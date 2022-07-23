import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPR Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: const Text('SPR Project'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const TextToSpeechScreen()));
                },
                child: const Text('Text to Speech')),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const SpeechToTextScreen()));
                },
                child: const Text('Speech to Text')),
          ],
        ),
      ),
    );
  }
}

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({Key? key}) : super(key: key);

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final FlutterTts flutterTts = FlutterTts();
  var languageCode = "en-US";

  speak(String text) async {
    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);
  }

  String text = '';
  double rate = 0.5; // Range: 0-2
  double pitch = 1.0; // Range: 0-2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: const Text('Flutter TTS'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onFieldSubmitted: (value) {
                setState(() {
                  text = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
              textInputAction: TextInputAction.done,
              // style: textUtils.subtext1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 2, color: Colors.black)),
                fillColor: Colors.black,
                hintText: 'Start Typing...',
                // hintStyle: textUtils.textFieldHintStyle,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
                value: languageCode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(width: 2, color: Colors.black)),
                ),
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                    value: "it-IT",
                    child: Text('Italian'),
                  ),
                  DropdownMenuItem(
                    value: "en-US",
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: "fr-FR",
                    child: Text('French'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    languageCode = value.toString();
                  });
                }),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                const Text('Rate'),
                Expanded(
                  child: Slider(
                    value: rate,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: rate.toString(),
                    onChanged: (double value) {
                      setState(() {
                        rate = value;
                      });
                    },
                  ),
                ),
                Text('(${rate.toStringAsFixed(2)})'),
              ],
            ),
            Row(
              children: <Widget>[
                const Text('Pitch'),
                Expanded(
                  child: Slider(
                    value: pitch,
                    min: 0,
                    max: 2,
                    divisions: 10,
                    label: pitch.toString(),
                    onChanged: (double value) {
                      setState(() {
                        pitch = value;
                      });
                    },
                  ),
                ),
                Text('(${pitch.toStringAsFixed(2)})'),
              ],
            ),
            const SizedBox(height: 22),
            ElevatedButton(
                onPressed: () => speak(text),
                child: const Text('Click to Speak')),
          ],
        ),
      ),
    );
  }
}

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button to speak';

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => log('OnStatus: $status'),
        onError: (status) => log('OnStatus: $status'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) => setState(() {
            _text = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: const Text('Flutter SST'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: Center(
            child: Text(
              _text,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(seconds: 10),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          tooltip: 'Speak',
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
