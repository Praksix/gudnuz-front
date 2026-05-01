import 'package:flutter/material.dart';
import 'screens/welcomeScreen.dart';
import 'screens/feedScreen.dart';
import 'screens/detailsScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nohemi',
      ),
      //home: const WelcomeScreen(),
      home: const FeedScreen(),
    );
  }
}