import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditationPlay extends StatefulWidget {
  final String imagePath;
  final String title;
  final String audioPath;
  const MeditationPlay({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.audioPath,
  }) : super(key: key);
  @override
  _MeditationPlayState createState() => _MeditationPlayState();
}

class _MeditationPlayState extends State<MeditationPlay> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    // Play the audio when the widget is loaded
    playAudio();
    // Listen to audio events
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Release the resources
    super.dispose();
  }

  void playAudio() async {
    await _audioPlayer.play(AssetSource(widget.audioPath));
  }

  void pauseAudio() async {
    await _audioPlayer.pause();
  }

  void seekAudio(Duration newPosition) {
    _audioPlayer.seek(newPosition);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the progress percentage
    double progress =
        duration.inSeconds > 0 ? position.inSeconds / duration.inSeconds : 0.0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 13, left: 20),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                _audioPlayer.stop(); // Stop audio playback
                Navigator.pop(context); // Navigate back
              },
            ),
          )),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/treeBackground3.png', // Replace with your background image asset
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.yellow.withOpacity(0.1),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                // Title Text
                Text(
                  widget.title, // Use the passed title
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20),
                // Meditation Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Row(
                      children: [
                        SizedBox(width: 65),
                        Image.asset(
                          widget.imagePath, // Use the passed image path
                          width: 330,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                // Audio Controls (Progress and Buttons)
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      // Progress bar
                      Slider(
                        value: position.inSeconds.toDouble(),
                        min: 0.0,
                        max: duration.inSeconds.toDouble(),
                        onChanged: (double value) {
                          seekAudio(Duration(seconds: value.toInt()));
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.white54,
                      ),
                      // Display current position and duration
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDuration(position),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            formatDuration(duration),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Playback buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: Colors.white,
                              size: 64,
                            ),
                            onPressed: () {
                              if (isPlaying) {
                                pauseAudio();
                              } else {
                                playAudio();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
