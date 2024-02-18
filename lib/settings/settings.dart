import 'package:cloud_functions/cloud_functions.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton.icon(
              onPressed:()  {
                AuthService().signOut();
                Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
              },
              icon: const Icon(Icons.logout),
              label: const Text("Sign Out"),
            )
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed:() async {
                HttpsCallableResult<dynamic> result = await FirebaseFunctions.instance.httpsCallable("autoremove_guests").call(
                  {
                    "user": AuthService().userId(),
                  }
                );
                debugPrint("is anon: ${result.data}");
              },
              icon: const Icon(Icons.check_box_outline_blank_rounded),
              label: const Text("Check my anon status!"),
            )
          )
        ],
      ),
    );
  }
}