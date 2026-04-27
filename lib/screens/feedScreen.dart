import 'package:flutter/material.dart';
import 'package:gudbuz/theme/colors.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2EDE1),
      appBar: AppBar(
        title: const Text('Actus', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, )),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: DrawerHeader(child: Text("GUDNUZ")),




      body: ListView(
        children: const [
          PostCard(),
          PostCard(),
          PostCard(),
          PostCard(),
        ],
      ),





      bottomNavigationBar:
      BottomNavigationBar(
        backgroundColor: Color(0xFF000000),
        selectedItemColor: kYellow,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top:10),
              child: Icon(Icons.home_outlined),
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top:10),
              child: Icon(Icons.add_circle_outline),
            ),
            label: 'Poster',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top:10),
              child: Icon(Icons.person_outline),
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
}}