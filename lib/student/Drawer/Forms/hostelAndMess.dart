import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HostelAndMess extends StatefulWidget {

  const HostelAndMess({super.key});


  @override
  State<HostelAndMess> createState() => _HostelAndMessState();
}

class _HostelAndMessState extends State<HostelAndMess> {
  CollectionReference db = FirebaseFirestore.instance.collection('Certificates');
  TextEditingController name = new TextEditingController();
  TextEditingController year = new TextEditingController();
  TextEditingController brach = new TextEditingController();
  TextEditingController regNO = new TextEditingController();
  TextEditingController roomNo = new TextEditingController();
  TextEditingController certificateType = new TextEditingController();

  void validateFields() async {
    String Name = name.text.toString();
    String Year = year.text.toString();
    String branch = brach.text.toString();
    String RegNo = regNO.text.toString();
    String roomno = roomNo.text.toString();
    String certificate = certificateType.text.toString();

    if (Name != "" && Year != "" && branch != "" && RegNo != "" && roomno != "" && certificate != "") {
      if (int.tryParse(RegNo) == null || int.tryParse(roomno) == null) {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text('Reg No field and Room No field should be numeric.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      try {
        await db.add({
          'Name': Name,
          'Year': Year,
          'Branch': branch,
          'RegNo': RegNo,
          'RoomNo': roomno,
          'CertificateType': certificate,
        });

        // Data added successfully
        const snackBar = SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          content: Text('Data added successfully!'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Clear the text fields
        name.clear();
        year.clear();
        brach.clear();
        regNO.clear();
        roomNo.clear();
        certificateType.clear();
      } catch (e) {
        // Handle errors
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text('Error adding data: $e'),
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
                const SizedBox(
                  height: 10,
                ),
                hostelDetails(
                    hinttext: "Enter Your Full Name",
                    labletext: "Name",
                    icons: const Icon(CupertinoIcons.person),
                    controller: name),
                const SizedBox(
                  height: 10,
                ),
                hostelDetails(
                    hinttext: "Enter the year you are studing in eg: 2nd Year",
                    labletext: "Year",
                    icons: const Icon(CupertinoIcons.tag),
                    controller: year),
                const SizedBox(
                  height: 10,
                ),
                hostelDetails(
                    hinttext: "Enter Your Branch",
                    labletext: "Branch",
                    icons: const Icon(CupertinoIcons.hammer),
                    controller: brach),
                const SizedBox(
                  height: 10,
                ),
                hostelDetails(
                  hinttext: "Enter Your Reg No",
                  labletext: "Reg No",
                  icons: const Icon(CupertinoIcons.number),
                  controller: regNO,
                ),
                const SizedBox(
                  height: 10,
                ),
                hostelDetails(
                  hinttext: "Enter Your Room No",
                  labletext: "Room No",
                  icons: const Icon(CupertinoIcons.home),
                  controller: roomNo,
                ),
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