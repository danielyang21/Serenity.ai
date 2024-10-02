import 'package:flutter/material.dart';

import '../features/home/home.dart';
import '../features/meditation/meditation.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomAppBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.keyboard_voice),
          label: 'Voice',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.self_improvement_sharp),
          label: 'Meditation',
        ),
      ],
      //urrentIndex: selectedIndex,
      // selectedItemColor: Colors.red,
      onTap: (index) {
        onItemTapped(index);
        _navigateToPage(context, index);
      },
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Meditation()),
        );
        break;
    }
  }
}
