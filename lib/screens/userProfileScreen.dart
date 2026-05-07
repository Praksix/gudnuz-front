import 'dart:ffi';

import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';
import 'package:gudnuz/theme/colors.dart';


class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {

  final String _auteur = "Tom";

  final List<Post> _tousPosts = [
    Post(
      titre: "Un accord climatique historique signé à Genève",
      auteur: "Tom",
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
      auteur: "Tom",
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
      auteur: "Tom",
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
      auteur: "Tom",
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
      auteur: "Tom",
      contenu: "Tourné avec un téléphone et un budget de 800€, 'Demain matin' a ému tout Cannes. Le réalisateur, Amine Bouali, dédie son prix à sa mère et à son quartier.",
      categorie: "CULTURE",
      sparks: 5610,
      image: "assets/images/party.jpg",
      createdAt: DateTime.now().subtract(Duration(hours: 9)),
    ),
  ];



  List<Post> get _postsFiltres {
    return _tousPosts.where((p) => p.auteur == _auteur).toList();
  }

  String get _nuzCount => _postsFiltres.length.toString();

  String get _sparksCount {
    int total = _postsFiltres.fold(0, (somme, post) => somme + post.sparks);
    return total.toString();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2EDE1),
        appBar: AppBar(
          title: const Text('Profil', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(

          ),
          child: SingleChildScrollView(
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(

                   // height: 400,
                    decoration: BoxDecoration(
                      color: kYellow,
                      border: Border(
                        top: BorderSide(color: Colors.black, width: 1),
                        bottom: BorderSide(color: Colors.black, width: 1),
                      ),

                    ),


                    child: Padding(
                      padding: const EdgeInsets.only(top:15, left:15, bottom: 15),

                      child: Row(

                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                image: AssetImage('assets/images/pp.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(_auteur, style: TextStyle(fontSize: 24, height: 1.1, fontWeight: FontWeight.w700)),
                              Text("Dealer de Good Vibes", style: TextStyle(fontSize: 17, height: 1.1, fontWeight: FontWeight.w600, color: Colors.white)),


                              Row(
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.all(12),
                                   child: Column(
                                     children: [
                                       Text(_nuzCount, style: TextStyle(fontSize: 22, height: 1.3, fontWeight: FontWeight.w800, color: Colors.black)),
                                       Text("Nuz", style: TextStyle(fontSize: 16, height: 1.3, fontWeight: FontWeight.w600, color: Colors.black)),
                                     ],
                                   ),
                                 ),


                                 Padding(
                                   padding: const EdgeInsets.all(12),
                                   child: Column(
                                     children: [
                                       Text(_sparksCount, style: TextStyle(fontSize: 22, height: 1.3, fontWeight: FontWeight.w800, color: Colors.black)),
                                       Text("Sparks", style: TextStyle(fontSize: 16, height: 1.3, fontWeight: FontWeight.w600, color: Colors.black)),
                                     ],
                                   ),
                                 ),


                                 Padding(
                                   padding: const EdgeInsets.all(12),
                                   child: Column(
                                     children: [
                                       Text("5", style: TextStyle(fontSize: 22, height: 1.3, fontWeight: FontWeight.w800, color: Colors.black)),
                                       Text("Flares", style: TextStyle(fontSize: 16, height: 1.3, fontWeight: FontWeight.w600, color: Colors.black)),
                                     ],


                                   ),

                                 ),



                               ],


                             )





                              //Text("Dealer de Good Vibes", style: TextStyle(fontSize: 22, height: 1.3, fontWeight: FontWeight.w600, color: Colors.white)),

                            ],
                          ),


                        ],


                      ),


                    ),




                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _postsFiltres.length,
                    itemBuilder: (context, index) {
                      final post = _postsFiltres[index];
                      return PostCard(post: post);
                    },
                  ),

                      //PostCard(),





        ]),
      ),
    ),

  );
  }
}