import 'package:flutter/material.dart';
import 'package:gudnuz/theme/colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/feed');
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/create');
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
        onTap(index);
      },
      backgroundColor: const Color(0xFF000000),
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
    );
  }
}