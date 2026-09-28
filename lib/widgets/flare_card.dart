import 'dart:math';
import 'package:flutter/material.dart';
import '../models/post.dart';
import 'post_card.dart';


// PostCard mise en valeur par un contour orange où une lumière fait le tour en boucle
class FlareCard extends StatefulWidget {
  final Post post;
  final Function(Post) onSparkToggled;
  final String? title; // optionnel : pas de titre si null (ex. GudBox)

  const FlareCard({super.key, required this.post, required this.onSparkToggled, this.title});

  @override
  State<FlareCard> createState() => _FlareCardState();
}

// SingleTickerProviderStateMixin fournit le "ticker" (un signal à chaque frame) à l'AnimationController
class _FlareCardState extends State<FlareCard> with SingleTickerProviderStateMixin {

  static const _orange = Color(0xFFFFC108);
  static const _lumiere = Color(0xFFFFF3C4); // la lumière claire qui tourne
  static const _fond = Color(0xFFF2EDE1);    // même fond que les posts classiques
  static const _epaisseur = 3.0;             // épaisseur du contour

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Valeur qui va de 0 à 1 en boucle (sans aller-retour) = un tour complet toutes les 4s
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    // Sans ça, l'animation continue de tourner en mémoire après la fermeture de l'écran
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          if (widget.title != null) ...[
            Text(widget.title!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
          ],

          // AnimatedBuilder ne reconstruit que le contour à chaque frame, pas la PostCard (passée en child)
          AnimatedBuilder(
            animation: _controller,
            child: PostCard(post: widget.post, onSparkToggled: widget.onSparkToggled),
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(_epaisseur),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  // Couche 1 : dégradé circulaire orange avec une zone claire, qu'on fait pivoter
                  gradient: SweepGradient(
                    colors: const [_orange, _orange, _lumiere, _orange, _orange],
                    stops: const [0.0, 0.40, 0.50, 0.60, 1.0],
                    transform: GradientRotation(_controller.value * 2 * pi),
                  ),
                  // Léger rayonnement autour du post (ne déborde pas dedans grâce au fond de la couche 2)
                  boxShadow: [
                    BoxShadow(
                      color: _orange.withValues(alpha: 0.30),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                // Couche 2 : fond opaque par-dessus → seule une bande de 3px du dégradé reste visible
                child: Container(
                  decoration: BoxDecoration(
                    color: _fond,
                    borderRadius: BorderRadius.circular(14 - _epaisseur),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14 - _epaisseur),
                        child: child,
                      ),
                      // Petites étoiles en haut à droite, dans la marge vide au-dessus du header de la PostCard.
                      // IgnorePointer : elles ne doivent pas bloquer les taps sur le post.
                      Positioned(
                        top: 2,
                        right: 10,
                        child: IgnorePointer(child: _etoiles()),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Chaque étoile : (position x, position y, taille, décalage de phase)
  // Le décalage de phase évite qu'elles clignotent toutes en même temps.
  static const _configEtoiles = [
    (x: 0.0,  y: 10.0, taille: 11.0, phase: 0.0),
    (x: 15.0, y: 0.0,  taille: 16.0, phase: 0.33),
    (x: 34.0, y: 11.0, taille: 10.0, phase: 0.66),
  ];

  // Appelée à chaque frame par l'AnimatedBuilder → réutilise le même controller que le contour
  Widget _etoiles() {
    return SizedBox(
      width: 48,
      height: 30,
      child: Stack(
        children: [
          for (final e in _configEtoiles) _etoile(e.x, e.y, e.taille, e.phase),
        ],
      ),
    );
  }

  Widget _etoile(double x, double y, double taille, double phase) {
    // angle qui fait un tour complet par cycle, décalé selon l'étoile
    final angle = 2 * pi * ((_controller.value + phase) % 1);
    // sin varie doucement entre -1 et 1 → ramené entre 0 et 1
    final t = 0.5 + 0.5 * sin(angle);
    return Positioned(
      left: x,
      top: y,
      child: Transform.translate(
        // petite dérive circulaire de 2px
        offset: Offset(2 * cos(angle), 2 * sin(angle)),
        child: Transform.scale(
          scale: 0.7 + 0.3 * t,
          child: Icon(
            Icons.star_rounded,
            size: taille,
            // clignotement : l'opacité varie entre 0.2 et 1
            color: _orange.withValues(alpha: 0.2 + 0.8 * t),
          ),
        ),
      ),
    );
  }
}
