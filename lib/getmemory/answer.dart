import 'package:flutter/material.dart';

class AnswerScreen extends StatelessWidget {
  final String answer;
  const AnswerScreen({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Retrieved'),
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SelectableText(
              answer,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
      ),
    );
  }
}