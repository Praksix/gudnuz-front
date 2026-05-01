import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../widgets/app_bottom_nav_bar.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2EDE1),
      appBar: AppBar(
        title: const Text('Actus', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
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
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text("Actualités", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text("Humour", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text("Culture", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pop(context),
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
      body: ListView(
        children: const [
          PostCard(),
          PostCard(),
          PostCard(),
          PostCard(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}