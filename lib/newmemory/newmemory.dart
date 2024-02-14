import "package:flutter/material.dart";

class NewMemoryScreen extends StatelessWidget {
  const NewMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Memory"),
      ),
      body: const Center(
        child: Text("New Memory"),
      ),
    );
  }
}