import 'package:chungi/common/api.dart';
import 'package:chungi/common/color_theme.cdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int _selectedIndex = 0;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () async {
              await makePostRequest();
            },
            child: const Text('Thera.ai')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            GestureDetector(
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
                        //AppTheme.kDarkGrey,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ...List.generate(
                            3,
                            (index) => Positioned.fill(
                              child: CustomPaint(
                                painter: WavePainter(
                                  animationValue:
                                      _waveAnimationController.value,
                                  waveIndex: index,
                                  color: _isListening
                                      ? Colors.red
                                      : AppTheme.kDarkGrey,
                                ),
                              ),
                            ),
                          ),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Voice Button
            InkWell(
              onTap: () => _onItemTapped(0),
              child: Container(
                padding: const EdgeInsets.all(
                    8), // Smaller padding for a smaller tap area
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.keyboard_voice,
                      color: _selectedIndex == 0 ? Colors.red : Colors.grey,
                    ),
                    Text(
                      'Voice',
                      style: TextStyle(
                        color: _selectedIndex == 0 ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Meditation Button
            InkWell(
              onTap: () => _onItemTapped(1),
              splashColor:
                  Colors.red.withOpacity(0.5), // Customize splash color
              child: Container(
                padding: const EdgeInsets.all(
                    8), // Smaller padding for a smaller tap area
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.self_improvement_sharp,
                      color: _selectedIndex == 1 ? Colors.red : Colors.grey,
                    ),
                    Text(
                      'Meditation',
                      style: TextStyle(
                        color: _selectedIndex == 1 ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
