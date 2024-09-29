import 'package:chungi/common/CustomBottomNavBar.dart';
import 'package:flutter/material.dart';

class Meditation extends StatefulWidget {
  const Meditation({super.key});

  @override
  State<Meditation> createState() => _MeditationState();
}

class _MeditationState extends State<Meditation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              '../images/gradientGreen.png', // Path to your background image
              fit: BoxFit.cover, // Makes the image cover the entire background
            ),
          ),
          // Page content
          SafeArea(
            child: Column(
              children: [
                const Text('Guided Meditation'),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 150,
                          child: Card(
                            color: Colors.white.withOpacity(0.8),
                            // Optional: make card background transparent
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Space between the two cards
                      Expanded(
                        child: SizedBox(
                          height: 150,
                          child: Card(
                            color: Colors.white.withOpacity(0.8),
                            // Optional: make card background transparent
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
