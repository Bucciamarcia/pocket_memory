import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:cloud_functions/cloud_functions.dart";
import "../services/auth.dart";

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
          showLoadingDialog(context);
          try {
            String userId = await AuthService().userId();
            await FirebaseFunctions.instance.httpsCallable('add_memory').call(
              {
                "memoryText": memoryText,
                "isTemporary": false,
                "user": userId,
                "expiration": ""
              },
            );
          } catch (e) {
            Navigator.of(context, rootNavigator: true).pop();
            debugPrint("ERROR CAUGHT");
            debugPrint(e.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("ERROR: Memory not added!"),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Memory added!"),
              backgroundColor: Colors.green[800],
            ),
          );
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        },
      ),
    );
  }
}

class AddTempMemory extends StatelessWidget {
  final String memoryText;
  const AddTempMemory({super.key, required this.memoryText});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        label: const Text("Add Temporary Memory"),
        icon: const FaIcon(FontAwesomeIcons.plus),
        style: ElevatedButtonTheme.of(context).style?.copyWith(
              backgroundColor: memoryText == ""
                  ? MaterialStateProperty.all(Colors.grey)
                  : MaterialStateProperty.all(
                      const Color.fromARGB(255, 110, 156, 224)),
              foregroundColor: memoryText == ""
                  ? MaterialStateProperty.all(Colors.grey[800])
                  : null,
              shape: memoryText == ""
                  ? MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 13, 83, 189),
                        ),
                      ),
                    ),
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final TextEditingController tempController =
                  TextEditingController();
              return AlertDialog(
                title: const Text('Set expiration'),
                content: Column(
                  children: [
                    const Text(
                        'Set an expiration, in number of days (max 365) for the memory.'),
                    TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Days',
                      ),
                      controller: tempController,
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      int expirationDays = int.parse(tempController.text);

                      showLoadingDialog(context);
                      try {
                        String userId = await AuthService().userId();
                        await FirebaseFunctions.instance
                            .httpsCallable('add_memory')
                            .call(
                          {
                            "memoryText": memoryText,
                            "isTemporary": false,
                            "user": userId,
                            "expiration": expirationDays
                          },
                        );
                        Navigator.of(context, rootNavigator: true).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Memory added!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/", (route) => false);
                      } catch (e) {
                        Navigator.of(context, rootNavigator: true).pop();
                        debugPrint("ERROR CAUGHT");
                        debugPrint(e.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("ERROR: Memory not added!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                    },
                    child: const Text('Add Temporary Memory'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> showLoadingDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Adding Memory..."),
            ],
          ),
        ),
      );
    },
  );
}
