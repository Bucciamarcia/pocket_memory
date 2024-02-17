import 'package:flutter/material.dart';
import 'package:pocket_memory/services/auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed:()  {
            AuthService().signOut();
            Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
          },
          icon: const Icon(Icons.logout),
          label: const Text("Sign Out"),
        )
      ),
    );
  }
}