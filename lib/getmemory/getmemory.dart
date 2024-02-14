import "package:flutter/material.dart";

class GetMemoryScreen extends StatelessWidget {
  const GetMemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retrieve Memory"),
      ),
      body: const Center(
        child: Text("Retrieve Memory"),
      ),
    );
  }
}