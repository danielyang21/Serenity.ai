import 'package:chungi/common/CustomBottomNavBar.dart';
import 'package:flutter/material.dart';

import 'MeditationPlay.dart';

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
      extendBodyBehindAppBar: true, // Extend the body behind the AppBar

      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/treeBackground3.png', // Ensure the path is correct
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.1), // Adjust opacity as needed
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 30, left: 50),
            child: Text(
              'Guided Meditation',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),

          // Foreground Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers vertically
                children: [
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      // Navigate to MeditationPlay with parameters
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeditationPlay(
                            imagePath: 'assets/meditationPic3.png',
                            title: 'Mindfulness',
                            audioPath: 'mindfulness.mp3',
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Image.asset(
                        'assets/meditationPic3.png',
                        width: 360,
                      ),
                    ),
                  ),

                  Center(
                    child: Text(
                      'Mindfulness',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  GestureDetector(
                    onTap: () {
                      // Navigate to MeditationPlay with parameters
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeditationPlay(
                            imagePath: 'assets/meditationPic1.png',
                            title: 'Anxiety',
                            audioPath: 'anxiety.mp3',
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Image.asset(
                        'assets/meditationPic1.png',
                        width: 360,
                      ),
                    ),
                  ),

                  Center(
                    child: Text(
                      'Anxiety',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  GestureDetector(
                    onTap: () {
                      // Navigate to MeditationPlay with parameters
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeditationPlay(
                            imagePath: 'assets/meditationPic2.png',
                            title: 'Positivity',
                            audioPath: 'positive.mp3',
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Image.asset(
                        'assets/meditationPic2.png',
                        width: 360,
                      ),
                    ),
                  ),

                  Center(
                    child: Text(
                      'Positivity',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Add more widgets here as needed
                ],
              ),
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
