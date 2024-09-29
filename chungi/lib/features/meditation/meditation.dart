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
      extendBodyBehindAppBar: true, // Extend the body behind the AppBar
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/treeBackground.png', // Ensure the path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Optional Overlay for better readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3), // Adjust opacity as needed
            ),
          ),
          // Foreground Content
          SafeArea(
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
                    ),
                  ],
                ),
                // Add more widgets here as needed
              ],
            ),
          ),
        ],
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
