import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HostelAndMess extends StatefulWidget {

  const HostelAndMess({Key? key,
    required this.email,
  }) : super(key: key);
  final String email;


  @override
  State<HostelAndMess> createState() => _HostelAndMessState();
}

class _HostelAndMessState extends State<HostelAndMess> {
  CollectionReference db = FirebaseFirestore.instance.collection('HostelStudents');
  CollectionReference db1 = FirebaseFirestore.instance.collection('CertificateRequest');
  TextEditingController certificateType = new TextEditingController();

  void validateFields() async {
    try {
      // Use a single document for all requests
      DocumentReference certificateRequestDoc = db1.doc('requests');

      DocumentSnapshot idCardSnapshot =
      await db.doc(widget.email).collection('StudentIDCard').doc('idcard').get();

      if (idCardSnapshot.exists) {
        Map<String, dynamic>? idCardData = idCardSnapshot.data() as Map<String, dynamic>?;

        if (idCardData != null) {
          String name = idCardData['Name'] ?? '';
          String year = idCardData['Year'] ?? '';
          int regNo = idCardData['Registration No.'] ?? 0;
          String roomNo = idCardData['Room NO.'] ?? '';

          String certificate = certificateType.text.toString();

          if (certificate.isNotEmpty) {
            // Create a new request or update the existing one
            await certificateRequestDoc.set({
              'Certificates': FieldValue.arrayUnion([
                {
                  'Name': name,
                  'Year': year,
                  'RegNo': regNo,
                  'RoomNo': roomNo,
                  'CertificateType': certificate,
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
            certificateType.clear();
          } else {
            const snackBar = SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              content: Text('Fill All The Fields'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          // Handle the case where idCardData is null
        }
      } else {
        const snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text('First generate your ID card'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      // Handle errors
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        content: Text('Error fetching data: $e'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff90AAD6),
        title: const Text(
          "Certificate Request",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            fontFamily: "Nunito",
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: Image.network(
                      "https://icon-library.com/images/fill-out-form-icon/fill-out-form-icon-10.jpg"),
                ),
                const Text(
                  "Hostel and Mess ",
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.bold),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // hostelDetails(
                //     hinttext: "Enter Your Full Name",
                //     labletext: "Name",
                //     icons: const Icon(CupertinoIcons.person),
                //     controller: name),
                // const SizedBox(
                //   height: 10,
                // ),
                // hostelDetails(
                //     hinttext: "Enter the year you are studing in eg: 2nd Year",
                //     labletext: "Year",
                //     icons: const Icon(CupertinoIcons.tag),
                //     controller: year),
                // const SizedBox(
                //   height: 10,
                // ),
                // hostelDetails(
                //     hinttext: "Enter Your Branch",
                //     labletext: "Branch",
                //     icons: const Icon(CupertinoIcons.hammer),
                //     controller: brach),
                // const SizedBox(
                //   height: 10,
                // ),
                // hostelDetails(
                //   hinttext: "Enter Your Reg No",
                //   labletext: "Reg No",
                //   icons: const Icon(CupertinoIcons.number),
                //   controller: regNO,
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // hostelDetails(
                //   hinttext: "Enter Your Room No",
                //   labletext: "Room No",
                //   icons: const Icon(CupertinoIcons.home),
                //   controller: roomNo,
                // ),
                const SizedBox(
                  height: 10,
                ),
                hostelDetails(
                  hinttext: "Applying For i.e: Certificate type",
                  labletext: "Certificate Type",
                  icons: const Icon(CupertinoIcons.doc),
                  controller: certificateType,
                ),
                const SizedBox(
                  height: 10,
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
                    "SUBMIT",
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

TextField hostelDetails({
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
  );
}