import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:chungi/common/color_theme.cdart.dart';

import '../../common/api.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await postToOpenAI(_lastWords);
    setState(() {
      _lastWords = '';
    });
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
      appBar: AppBar(
        title: const Text('Thera.ai'),
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
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                if (_speechToText.isNotListening) {
                  HapticFeedback.heavyImpact();
                  _startListening();
                } else {
                  HapticFeedback.heavyImpact();
                  _stopListening();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppTheme.kDarkGrey),
                child: _speechToText.isNotListening
                    ? const Icon(
                        Icons.mic_off,
                        color: Colors.white,
                        size: 50,
                      )
                    : const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 50,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
