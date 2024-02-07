// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomChange extends StatefulWidget {
  const RoomChange({
    Key? key,
    required this.email,
  }) : super(key: key);
  final String email;

  @override
  State<RoomChange> createState() => _RoomChangeState();
}

final user = FirebaseAuth.instance.currentUser!;
String emailid = user.email.toString();

class _RoomChangeState extends State<RoomChange> {
  CollectionReference db =
      FirebaseFirestore.instance.collection('HostelStudents');
  CollectionReference db1 =
      FirebaseFirestore.instance.collection('RoomChangeReq');
  //TextEditingController preferences = TextEditingController();
  TextEditingController reason = TextEditingController();
  bool? click;

  void validateFields() async {
    try {
      if (click ?? false) {
        // Checkbox is checked
        // Use a single document for all requests
        DocumentReference roomChangeRequestDoc = db1.doc('requests');

        DocumentSnapshot idCardSnapshot = await db
            .doc(widget.email)
            .collection('StudentIDCard')
            .doc('idcard')
            .get();

        if (idCardSnapshot.exists) {
          Map<String, dynamic>? idCardData =
              idCardSnapshot.data() as Map<String, dynamic>?;

          if (idCardData != null) {
            String name = idCardData['Name'] ?? '';
            String year = idCardData['Year'] ?? '';
            int regNo = idCardData['Registration No.'] ?? 0;
            String roomNo = idCardData['Room No'] ?? '';
            String emailid = idCardData['Emailid'] ?? '';
            //String prefer = preferences.text.toString();
            String reasonText = reason.text.toString();

            if (reasonText.isNotEmpty) {
              // Create a new request or update the existing one
              await roomChangeRequestDoc.set({
                'Requests': FieldValue.arrayUnion([
                  {
                    'Name': name,
                    'Year': year,
                    'RegNo': regNo,
                    'RoomNo': roomNo,
                   // 'Preferences': prefer,
                    'Reason': reasonText,
                    'Email': emailid,
                    'Timestamp': Timestamp.now(),
                  }
                ]),
              }, SetOptions(merge: true));

              // Data added successfully
              const snackBar = SnackBar(
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
                content: Text('Sent for verification!'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              // Clear the text fields
              // preferences.clear();
              reason.clear();
            } else {
              const snackBar = SnackBar(
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
                content: Text('Fill All The Fields'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else {
            const snackBar = SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              content: Text('Fill All The Fields'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          const snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            content: Text('First generate your ID card'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        // Checkbox is not checked, show a message or take appropriate action
        const snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text('Please agree to the hostel\'s policies.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      // Handle errors
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        content: Text('Error fetching data: $e'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff90AAD6),
        centerTitle: true,
        title: const Text(
          "Vacant Room",
          style: TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  width: 150,
                  // decoration: const BoxDecoration(
                  //   color: Colors.white,
                  // ),
                  child: Image.asset("assets/images/roomchange.png"),
                ),
                const SizedBox(
                  height: 10,
                ),

                // leaveDetails(
                //   hinttext: " e.g. Branch wise",
                //   labletext: "Roommate Preferences ",
                //   icons: const Icon(CupertinoIcons.person),
                //   controller: preferences,

                // ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'If Academics year completed , write only "Academics Year Completed" else specify your problem ',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: " ",
                  labletext: "Reason for Room Change",
                  icons: const Icon(CupertinoIcons.italic),
                  controller: reason,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: click ?? false,
                        activeColor: Colors.blueAccent,
                        onChanged: (newBool) {
                          setState(() {
                            click = newBool;
                          });
                        }),
                    const Expanded(
                      child: Text(
                        "Aware of and agree to the hostel's policies regarding room changes.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xff90AAD6),
                    ),
                  ),
                  onPressed: () {
                    validateFields();
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

TextField leaveDetails({
  required String hinttext,
  required String labletext,
  required Icon icons,
  required TextEditingController controller,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hinttext,
      labelText: labletext,
      labelStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      icon: icons,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
    keyboardType: TextInputType.multiline,
    maxLines: null,
    minLines: 1,
  );
}
