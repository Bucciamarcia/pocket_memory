import "package:flutter/material.dart";
import "buttons.dart";
import "../shared/listenbutton.dart";

class NewMemoryScreen extends StatefulWidget {
  const NewMemoryScreen({super.key});

  @override
  State<NewMemoryScreen> createState() => _NewMemoryScreenState();
}

class _NewMemoryScreenState extends State<NewMemoryScreen> {
  final TextEditingController _textEditingController = TextEditingController();

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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AddMemory(memoryText: _textEditingController.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                      ),
                      SpeechRecognitionWidget(
                        textEditingController: _textEditingController,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                    Row(
                      children: [
                        AddTempMemory(memoryText: _textEditingController.text),
                      ],
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
