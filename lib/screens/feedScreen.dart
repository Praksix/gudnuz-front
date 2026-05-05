import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../models/post.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  String _categorie = "TOP";



  final List<Post> _tousPosts = [
    Post(
      titre: "Un accord climatique historique signé à Genève",
      auteur: "marie_info",
      contenu: "195 pays ont ratifié un accord inédit pour réduire les émissions de CO₂ de 60% d'ici 2035. Une avancée saluée par l'ensemble de la communauté scientifique.",
      categorie: "ACTU",
      sparks: 312,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(hours: 1)),
    ),
    Post(
      titre: "Ce chien qui attend son maître depuis 3 ans",
      auteur: "good_vibes_only",
      contenu: "Les habitants du village lui apportent à manger chaque jour. Finalement, son maître est rentré de l'hôpital hier. Les images sont bouleversantes.",
      categorie: "ACTU",
      sparks: 874,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(hours: 3)),
    ),
    Post(
      titre: "Un lycéen invente un système de filtration low-cost",
      auteur: "futur_now",
      contenu: "À 17 ans, Kofi Mensah a conçu un filtre à eau avec des matériaux recyclés qui alimente désormais son village entier au Ghana. Son invention est open-source.",
      categorie: "ACTU",
      sparks: 1203,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
    ),
    Post(
      titre: "Quand tu demandes à ChatGPT de faire ta compta",
      auteur: "lol_bruh",
      contenu: "Il m'a rendu un fichier Excel avec une colonne 'Dépenses existentielles'. Je lui ai demandé ce que c'était. Il m'a dit : 'votre abonnement Netflix'.",
      categorie: "HUMOUR",
      sparks: 2041,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(minutes: 45)),
    ),
    Post(
      titre: "Le stagiaire qui a mis en prod un vendredi",
      auteur: "dev_life",
      contenu: "Et le serveur a tenu. Toute la boîte l'a applaudi. Il a été embauché le lendemain. Morale : parfois les fous ont raison.",
      categorie: "HUMOUR",
      sparks: 567,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Post(
      titre: "Ce compilateur d'expressions intraduisibles",
      auteur: "linguist_fr",
      contenu: "En portugais, 'saudade' désigne une mélancolie douce pour quelque chose qu'on a aimé. En japonais, 'komorebi' décrit la lumière du soleil filtrée par les feuilles. On manque de mots en français.",
      categorie: "HUMOUR",
      sparks: 189,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(hours: 6)),
    ),
    Post(
      titre: "Stromae de retour avec un album surprise",
      auteur: "culture_radar",
      contenu: "Disponible dès ce soir à minuit, 'Nuit Noire' comprend 11 titres enregistrés à Bruxelles, Tokyo et Lagos. Les premières écoutes parlent d'un chef-d'œuvre.",
      categorie: "CULTURE",
      sparks: 3892,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(minutes: 20)),
    ),
    Post(
      titre: "Ce livre lu par 10 millions de personnes en un mois",
      auteur: "biblio_plus",
      contenu: "'Les Racines du ciel' de Romain Gary, republié avec une préface inédite, cartonne sur TikTok. Une nouvelle génération découvre un classique oublié.",
      categorie: "CULTURE",
      sparks: 445,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(hours: 4)),
    ),
    Post(
      titre: "Le street art qui transforme une ville entière",
      auteur: "art_in_streets",
      contenu: "La ville de Valparaíso au Chili est devenue un musée à ciel ouvert. 800 murales d'artistes du monde entier couvrent ses collines. Un projet communautaire sans subvention.",
      categorie: "CULTURE",
      sparks: 728,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(hours: 7)),
    ),
    Post(
      titre: "Un cinéaste de 19 ans remporte la Palme d'Or",
      auteur: "cine_actu",
      contenu: "Tourné avec un téléphone et un budget de 800€, 'Demain matin' a ému tout Cannes. Le réalisateur, Amine Bouali, dédie son prix à sa mère et à son quartier.",
      categorie: "CULTURE",
      sparks: 5610,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(hours: 9)),
    ),
  ];


  List<Post> get _postsFiltres {
    if (_categorie == "TOP") return _tousPosts;
    return _tousPosts.where((p) => p.categorie == _categorie).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2EDE1),
      appBar: AppBar(
        title: Text(_categorie, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFFF2EDE1),
        child: Column(
          children: [
            DrawerHeader(
              child: Text("GudNuz", style: TextStyle(fontSize: 62, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: Text("Top", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() { _categorie = "TOP"; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Actualités", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() { _categorie = "ACTU"; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Humour", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() { _categorie = "HUMOUR"; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Culture", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() { _categorie = "CULTURE"; });
                Navigator.pop(context);
              },
            ),
            Spacer(),
            Divider(color: Colors.grey, thickness: 1),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red,),
              title: Text("Déconnexion", style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _postsFiltres.length,
        itemBuilder: (context, index) {
          final post = _postsFiltres[index];
          return PostCard(post: post);
        },
      ),

    );
  }
}