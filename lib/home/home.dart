import "package:flutter/material.dart";
import "../services/auth.dart";
import "../login/login.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading bar
            print("Status waiting!");
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            return Scaffold(body: Text("ERROR! $error"));
          } else if (snapshot.hasData) {
            return const AppHome();
          } else {
            return const LoginScreen();
          }
        });
  }
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Center(child: Text("Welcome to PocketMemory!")),
            ElevatedButton.icon(
                icon: Icon(Icons.logout, color: Colors.grey[700]),
                onPressed: () => AuthService().signOut(),
                label: const Text("Log out"))
          ],
        ));
  }
}
