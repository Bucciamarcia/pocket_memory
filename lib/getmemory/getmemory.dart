import "package:flutter/material.dart";
import "buttons.dart";
import "../shared/listenbutton.dart";

class GetMemoryScreen extends StatefulWidget {
  const GetMemoryScreen({super.key});

  @override
  State<GetMemoryScreen> createState() => _GetMemoryScreenState();
}

class _GetMemoryScreenState extends State<GetMemoryScreen> {
  // Declare a TextEditingController
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Memory'),
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
                GetMemory(memoryText: _textEditingController.text),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                ),
                SpeechRecognitionWidget(textEditingController: _textEditingController,)
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}
