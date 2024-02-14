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
        appBar: AppBar(
          title: const Text("PocketMemory")
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, "/newmemory"),
                  label: const Text("New Memory"),
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, "/getmemory"),
                  label: const Text("Retrieve Memory"),
                  icon: const Icon(Icons.list),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, "/settings"),
                  label: const Text("Settings"),
                  icon: const Icon(Icons.logout),
                ),
              ),
            ),
          ],
        ));
  }
}
