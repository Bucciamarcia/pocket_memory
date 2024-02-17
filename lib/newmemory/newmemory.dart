import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import "buttons.dart";

class NewMemoryScreen extends StatefulWidget {
  const NewMemoryScreen({super.key});

  @override
  State<NewMemoryScreen> createState() => _NewMemoryScreenState();
}

class _NewMemoryScreenState extends State<NewMemoryScreen> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  // Declare a TextEditingController
  final TextEditingController _textEditingController = TextEditingController();

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
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      // Update the controller's text instead of _lastWords
      _textEditingController.text = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Memory'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              // Update the TextField to use the controller
              child: TextField(
                controller: _textEditingController,
                onChanged: (String value) {
                  setState(() {});
                },
                minLines: 5,
                maxLines: 5,
                maxLength: 100,
                style: const TextStyle(
                  fontSize: 30,
                ),
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Memory',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                AddMemory(memoryText: _textEditingController.text),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(
                      color: Colors.lightBlue,
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _speechToText.isNotListening
                        ? _startListening
                        : _stopListening,
                    icon: FaIcon(_speechToText.isNotListening
                        ? FontAwesomeIcons.microphone
                        : FontAwesomeIcons.microphoneSlash),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}
