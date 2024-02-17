
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:cloud_functions/cloud_functions.dart";
import 'package:pocket_memory/services/firestore.dart';

class AddMemory extends StatelessWidget {
  final String memoryText;
  const AddMemory({super.key, required this.memoryText});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
          label: const Text("Add Memory"),
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
            List<double> embeddings = [];
            try {


              HttpsCallableResult<dynamic> result = await FirebaseFunctions
                  .instance
                  .httpsCallable('get_embeddings')
                  .call(
                {
                  "memoryText": memoryText,
                },
              );
              embeddings = (result.data["embeddings"] as List<dynamic>).map((e) => e as double).toList();
              debugPrint("EMBEDDINGS: $embeddings");
            } catch (e) {
              debugPrint("ERROR CAUGHT");
              debugPrint(e.toString());
            }
            CreateMemory(
              embeddings: embeddings,
              memoryText: memoryText,
            ).addPermanent();
          },
          ),
    );
  }
}
