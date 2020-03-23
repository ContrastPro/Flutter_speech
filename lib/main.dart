import 'package:flutter/material.dart';
import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasSpeech = true;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String totalString = "";
  final SpeechToText speech = SpeechToText();
  bool _record = false;

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(onError: errorListener, onStatus: statusListener );

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Speech to Text'),
          elevation: 0.0,
        ),
        body: _hasSpeech
            ? SingleChildScrollView(
                child: Container(
                  child: SelectableText(
                    lastWords,
                    style: TextStyle(fontSize: 16),
                  ),
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                ),
              )
            : Center(
                child: Text('Speech recognition unavailable',
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold))),
        floatingActionButton: FloatingActionButton(
          child: speech.isListening ? Icon(Icons.stop) : Icon(Icons.mic),
          backgroundColor: speech.isListening ? Colors.redAccent : Colors.blue,
          onPressed: () {
            if (_record == false) {
              startListening();
              _record = true;
            } else {
              speech.stop();
              _record = false;
            }
          },
        ),
      ),
    );
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(onResult: resultListener);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {});
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }
}
