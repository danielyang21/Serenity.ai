import 'dart:io';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:chungi/common/CustomBottomNavBar.dart';
import 'package:chungi/common/api.dart';
import 'package:chungi/common/color_theme.cdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'animation/math.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  late AnimationController _pulseAnimationController;
  late AnimationController _waveAnimationController;
  late Animation<double> _pulseAnimation;
  bool _isListening = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initAnimations();
  }

  @override
  void dispose() {
    _pulseAnimationController.dispose();
    _waveAnimationController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _initAnimations() {
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation =
        Tween<double>(begin: 1, end: 1.2).animate(_pulseAnimationController);

    _waveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _waveAnimationController.repeat();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _isListening = true;
    });
    _pulseAnimationController.repeat(reverse: true);
  }

  void _stopListening() async {
    await sendToOpenAI(_lastWords);
    setState(() {
      _lastWords = '';
      _isListening = false;
    });
    await _speechToText.stop();
    _pulseAnimationController.stop();
    _pulseAnimationController.reset();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  // Future<void> playAudio(String filePath) async {
  //   final audioPlayer = AssetsAudioPlayer.newPlayer();
  //   try {
  //     await audioPlayer.open(
  //       Audio.file(filePath),
  //       autoStart: true,
  //       showNotification: true,
  //     );
  //   } catch (error) {
  //     print("Error playing audio: $error");
  //     throw error; // Re-throw the error to be caught by the caller
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        try {
          final dir = await sendHelloWorld("Hello world");
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/$dir';

          print("Attempting to play audio file: $filePath");

          if (await File(filePath).exists()) {
            // await playAudio(filePath);
          } else {
            print("Audio file does not exist at path: $filePath");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Audio file not found")),
            );
          }
        } catch (e) {
          print("Error: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error playing audio: $e")),
          );
        }
      }),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () async {
            await makePostRequest();
          },
          child: const Text('Thera.ai'),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Your existing widgets
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Recognized words:',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              SizedBox(
                height: 400,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(_lastWords),
                ),
              ),
              const SizedBox(height: 30),
              _buildMicButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTapDown: (_) {
        if (!_isListening) {
          HapticFeedback.heavyImpact();
          _startListening();
        }
      },
      onTapUp: (_) {
        if (_isListening) {
          HapticFeedback.heavyImpact();
          _stopListening();
        }
      },
      onTapCancel: () {
        if (_isListening) {
          HapticFeedback.heavyImpact();
          _stopListening();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge(
            [_pulseAnimationController, _waveAnimationController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening ? Colors.red : Color(0xff97A870),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ..._buildWaves(),
                  Icon(
                    _isListening ? Icons.mic : Icons.mic_off,
                    color: Colors.white,
                    size: 50,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildWaves() {
    return List.generate(
      3,
      (index) => Positioned.fill(
        child: CustomPaint(
          painter: WavePainter(
            animationValue: _waveAnimationController.value,
            waveIndex: index,
            color: _isListening ? Colors.red : AppTheme.kDarkGrey,
          ),
        ),
      ),
    );
  }
}
