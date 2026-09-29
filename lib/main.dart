import 'package:flutter/material.dart';
import 'package:gudnuz/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcomeScreen.dart';
import 'screens/feedScreen.dart';
import 'screens/userProfileScreen.dart';
import 'screens/createScreen.dart';
import 'screens/connexionScreen.dart';
import 'screens/inscriptionScreen.dart';
import 'screens/lockoutScreen.dart';
import 'package:gudnuz/services/auth_service.dart';
import 'package:gudnuz/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase n'est configuré que pour Android (firebase_options.dart) : sur iOS,
  // l'init échoue et on continue sans notifications plutôt que de bloquer l'app
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Firebase indisponible : $e');
  }

  final isLoggedIn = await AuthService().isLoggedIn();

  String initialRoute = '/welcome';

  if (isLoggedIn) {
    final prefs = await SharedPreferences.getInstance();
    final finDePauseMs = prefs.getInt('lockout_end_at');
    final lockoutActif = finDePauseMs != null &&
        DateTime.fromMillisecondsSinceEpoch(finDePauseMs).isAfter(DateTime.now());

    initialRoute = lockoutActif ? '/lockout' : '/main';
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute; // reçoit la route de départ depuis main()

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NotificationService.navigatorKey, // navigation depuis une notification
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Nohemi'),
      initialRoute: initialRoute, // utilise la valeur reçue
      routes: {
        '/welcome':    (context) => const WelcomeScreen(),
        '/connexion':  (context) => const ConnexionScreen(),
        '/inscription':(context) => const InscriptionScreen(),
        '/main':       (context) => const MainScreen(),
        '/lockout':    (context) => const LockoutScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialisé ici (et pas dans main) : l'utilisateur est connecté (JWT dispo pour charger le post)
    // et hors écran de pause — une notif ne contourne pas le verrouillage du scroll éthique
    NotificationService().init();
  }

  final List<Widget> _screens = [
    const FeedScreen(),
    const CreateScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: kYellow,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.home_outlined),
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.add_circle_outline),
            ),
            label: 'Poster',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.person_outline),
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}