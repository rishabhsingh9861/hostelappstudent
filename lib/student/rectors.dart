import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vjtihostel/student/constant/const.dart';

class Rectors extends StatefulWidget {
  const Rectors({super.key});

  @override
  State<Rectors> createState() => _RectorsState();
}

class _RectorsState extends State<Rectors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbars("Rectors"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            material(
                '7231957066',
                'rtSingh_b21@ci.vjti.ac.in',
                'assets/images/try.png',
                'Dr. Abhay Bambole ',
                'Cheif Rector Hostel'),
            material(
                '7231957066',
                'rtSingh_b21@ci.vjti.ac.in',
                'assets/images/try.png',
                'Dr. Abhay Bambole ',
                'Cheif Rector Hostel'),
            material(
                '7231957066',
                'rtSingh_b21@ci.vjti.ac.in',
                'assets/images/try.png',
                'Dr. Abhay Bambole ',
                'Cheif Rector Hostel'),
          ],
        ),
      ),
    );
  }
}

Widget material(String phoneno, String emailto, String assetimage,
    String nametext, String positiontext) {
  String phoneNumber = phoneno;
  String email = emailto;
  return Material(
    // color: Colors.blueGrey,
    child: SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            height: 380,
            width: 350,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 3, color: const Color.fromARGB(255, 0, 0, 0)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(assetimage),
                    radius: 70,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 120,
                  width: 350,
                  decoration: BoxDecoration(
                      //color: const Color.fromARGB(255, 218, 227, 246),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nametext,
                          style: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          positiontext,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () async {
                            final gmail = 'mailto:$email';
                            if (await launchUrlString(gmail)) {
                              await canLaunchUrlString(gmail);
                            }
                          },
                          child: Image.asset('assets/images/gmailicon.png')),
                      const SizedBox(
                        width: 100,
                      ),
                      InkWell(
                          onTap: () async {
                            final call = 'tel:$phoneNumber';
                            if (!await launchUrlString(call)) {
                              await canLaunchUrlString(call);
                            }
                          },
                          child: Image.asset('assets/images/phoneicon.png')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
