
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:cloud_functions/cloud_functions.dart";

class GetMemory extends StatelessWidget {
  final String memoryText;
  const GetMemory({super.key, required this.memoryText});

  @override
  Widget build(BuildContext context) {
    String answer;
    return Expanded(
      child: ElevatedButton.icon(
          label: const Text("Retrieve Memory"),
          icon: const FaIcon(FontAwesomeIcons.plus),
          style: ElevatedButtonTheme.of(context).style?.copyWith(
                backgroundColor: memoryText == ""
                    ? MaterialStateProperty.all(Colors.grey)
                    : null, // MaterialStateProperty.all(Colors.lightBlue),
                foregroundColor: memoryText == ""
                    ? MaterialStateProperty.all(Colors.grey[800])
                    : null,
                shape: memoryText == ""
                    ? MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                        side: const BorderSide(
                          color: Colors.grey,
                        )))
                    : null /* MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                      side: const BorderSide(
                        color: Colors.lightBlue,
                      ),
                    )) */
                ,
                padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                textStyle: MaterialStateProperty.all(const TextStyle(
                  fontSize: 18,
                )),
                iconSize: const MaterialStatePropertyAll(18),
                iconColor: memoryText == ""
                    ? MaterialStateProperty.all(Colors.grey[800])
                    : null,
              ),
          onPressed: () async {
            try {


              HttpsCallableResult<dynamic> result = await FirebaseFunctions
                  .instance
                  .httpsCallable('retrieve_memory')
                  .call(
                {
                  "memoryText": memoryText,
                  "user": FirebaseAuth.instance.currentUser!.uid,
                },
              );
              answer = result.data["answer"] as String;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Memory Retrieved"),
                    content: Text(answer),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              );
            } catch (e) {
              debugPrint("ERROR CAUGHT");
              debugPrint(e.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("ERROR: Can't retrieve Memory!"),
                  backgroundColor: Colors.red,
                ),
              );
              // Stop the function if an error is caught
              return;
            }
          },
          ),
    );
  }
}
