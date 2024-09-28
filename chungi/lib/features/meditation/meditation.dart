import 'package:chungi/common/CustomBottomNavBar.dart';
import 'package:flutter/material.dart';

class Meditation extends StatefulWidget {
  const Meditation({super.key});

  @override
  State<Meditation> createState() => _MeditationState();
}

class _MeditationState extends State<Meditation> {
  int _selectedIndex = 0; // Moved inside the state class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Guided Meditation'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Card(
                    color: Colors.grey,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Add navigation logic here if needed
        },
      ),
    );
  }
}
