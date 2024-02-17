import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechRecognitionWidget extends StatefulWidget {
  final TextEditingController textEditingController;

  const SpeechRecognitionWidget({Key? key, required this.textEditingController})
      : super(key: key);

  @override
  State<SpeechRecognitionWidget> createState() =>
      _SpeechRecognitionWidgetState();
}

class _SpeechRecognitionWidgetState extends State<SpeechRecognitionWidget> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

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
      widget.textEditingController.text = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(
          color: Colors.lightBlue,
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed:
            _speechToText.isNotListening ? _startListening : _stopListening,
        icon: FaIcon(_speechToText.isNotListening
            ? FontAwesomeIcons.microphone
            : FontAwesomeIcons.microphoneSlash),
        color: Colors.blue,
      ),
    );
  }
}
