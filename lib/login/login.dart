import "package:flutter/material.dart";
import "loginblock.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Center(
              child: Image(
                image: AssetImage("assets/logo.png"),
                width: 170,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: const Text(
                "Welcome to PocketMemory!",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: const Text(
                "In order to use PocketMemory. You need to log in.\n\nBefore making an account, you can try it out as guest."
              )
            ),
            const LoginBlock()
          ],
        ),
      ),
    );
  }
}
