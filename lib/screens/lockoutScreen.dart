import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockoutScreen extends StatefulWidget {
  const LockoutScreen({super.key});

  @override
  State<LockoutScreen> createState() => _LockoutScreenState();
}

class _LockoutScreenState extends State<LockoutScreen> {

  // La durée restante — démarre à 4h, sera recalculée depuis le vrai timestamp
  Duration _remaining = const Duration(hours: 4);

  // Le timer qui va "ticker" chaque seconde
  // Le "?" signifie qu'il peut être null (il l'est avant qu'on le crée)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // initState ne peut pas être async, donc on délègue à une méthode séparée
    // On NE MET PAS "await" ici — on lance _initLockout et on continue
    _initLockout();
  }

  // Cette méthode est async : elle peut "attendre" des opérations longues
  Future<void> _initLockout() async {

    // SharedPreferences = stockage clé/valeur persistant sur le téléphone
    // C'est comme un mini dictionnaire qui survit aux redémarrages de l'app
    final prefs = await SharedPreferences.getInstance();

    // On lit la clé 'lockout_end_at' — null si elle n'existe pas encore
    final finDePauseMs = prefs.getInt('lockout_end_at');

    if (finDePauseMs == null) {
      // Première fois qu'on arrive ici : on calcule et on sauvegarde la fin
      // DateTime.now() = maintenant, .add() ajoute une durée
      final fin = DateTime.now().add(const Duration(minutes: 2));
      // On convertit en millisecondes pour pouvoir le stocker (SharedPreferences
      // ne sait pas stocker un DateTime directement, seulement des int/String/bool)
      await prefs.setInt('lockout_end_at', fin.millisecondsSinceEpoch);
    }

    // Que ce soit la première fois ou non, on relit le timestamp sauvegardé
    // Le "!" à la fin dit à Dart "je garantis que ce n'est pas null"
    // (on vient de le sauvegarder juste au-dessus si c'était null)
    final fin = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('lockout_end_at')!);

    // On calcule la durée restante = fin - maintenant
    final restant = fin.difference(DateTime.now());

    // setState() dit à Flutter "reconstruis le widget avec ces nouvelles valeurs"
    setState(() => _remaining = restant);

    // On démarre le timer : il appelle la fonction toutes les secondes
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _remaining -= const Duration(seconds: 1));
      if (_remaining.inSeconds <= 0) {
        _deverrouiller();
      }
    });
  }

  Future<void> _deverrouiller() async {
    _timer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lockout_end_at');
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  void dispose() {
    // IMPORTANT : toujours annuler le timer quand le widget est détruit
    // Sinon il continue de tourner en arrière-plan et cause des bugs
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text("GUDNUZ", style: TextStyle(fontSize: 62, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            Text("Fin du scroll", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            Text("Vas toucher de l'herbe", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(height: 50),
            Image.asset('assets/images/black-spark.png'),
            const SizedBox(height: 50),
            Text("Reviens dans", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            Text(
              "${_remaining.inHours}h ${_remaining.inMinutes % 60}min ${_remaining.inSeconds % 60}s",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 90),
            TextButton(
              onPressed: _deverrouiller,
              child: Text("Débloquer (debug)"),
            ),
          ],
        ),
      ),
    );
  }
}