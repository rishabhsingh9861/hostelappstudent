import 'package:flutter/material.dart';
import 'package:vjtihostel/backgroundimage.dart';
import 'package:vjtihostel/student/vjtilogin.dart';

class Onboard extends StatelessWidget {
  const Onboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: BackgrounImage(
      assetimage: const AssetImage("assets/images/VJTIPG2.jpeg"),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(5),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color.fromARGB(255, 255, 255, 255))),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Vjtilogin()));
              },
              child: const Text(
                "NEXT",
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    )));
  }
}
