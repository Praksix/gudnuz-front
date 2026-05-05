import 'dart:ui';

class Post {
  final String titre;
  final String image;
  final DateTime createdAt;
  final String auteur;
  final String contenu;
  final String categorie; // "ACTU", "HUMOUR", "CULTURE"
  final int sparks;

  Post({
    required this.auteur,
    required this.contenu,
    required this.categorie,
    required this.sparks,
    required this.titre,
    required this.image,
    required this.createdAt,
  });
}
