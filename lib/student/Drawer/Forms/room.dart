// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../constant/const.dart';

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

List<String> listvacant = <String>[
  'Select Reason',
  'First Year Completed',
  'Second Year Completed',
  'Third Year Completed',
  'Fourth Year Completed',
];
List<String> listbatch = [
  'Select Batch',
  '2024',
  '2025',
  '2026',
  '2027',
  '2028',
  '2029',
  '2030',
  '2031',
  '2032',
  '2033',
  '2034',
  '2035',
  '2036',
  '2037',
  '2038',
  '2039',
  '2040',
  '2041',
  '2042',
  '2043',
  '2044',
  '2045',
  '2046',
  '2047',
  '2048',
  '2049',
  '2050'
];

class _RoomChangeState extends State<RoomChange> {
  String uniqueFilename = 'Upload merged Fess Receipts till current year ';
  CollectionReference db =
      FirebaseFirestore.instance.collection('HostelStudents');
  CollectionReference db1 =
      FirebaseFirestore.instance.collection('RoomVacantReq');
  //TextEditingController preferences = TextEditingController();
  // TextEditingController reason = TextEditingController();
  bool? click;

  String dropdownValueVacant = listvacant.first;
  String setvacant = "";
  String dropdownValueBatch = listbatch.first;
  String setBatch = "";

  Future<File?> pickFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (pickedFile != null) {
      File file = File(pickedFile.files.single.path!);
      return file;
    }

    return null;
  }

  String downloadUrl = '';
  bool isChecked = false;

  Future<void> uploadFile(File? file) async {
    if (file == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('PDF not selected'),
          );
        },
      );
      return;
    }

    try {
      uniqueFilename = file.path.split('/').last;
      Reference referenceDirPdf =
          FirebaseStorage.instance.ref().child('FeesReceipt');
      Reference referencePdfToUpload = referenceDirPdf.child(uniqueFilename);

      showDialog(
        context: context,
        builder: (_) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Please wait Uploading',
                style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    color: Colors.green),
              ),
              CircularProgressIndicator(
                color: Colors.green,
              ),
            ],
          );
        },
      );

      // Set content type explicitly to 'application/pdf'
      await referencePdfToUpload.putFile(
        file,
        SettableMetadata(
          contentType: 'application/pdf',
        ),
      );

      downloadUrl = await referencePdfToUpload.getDownloadURL();

      setState(() {});
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('PDF not uploaded'),
          );
        },
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  // void dispose() {
  //   _nameController.dispose();
  //   _hostelid.dispose();
  //   _roomnoController.dispose();
  //   super.dispose();
  // }

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
            String photo = idCardData['Passport Photo'] ?? '';
            String reasonText = setvacant;
            String batch = setBatch;

            if (reasonText.isNotEmpty && batch.isNotEmpty) {
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
                    'Batch': batch,
                    'Email': emailid,
                    'Photo': photo,
                    'Fees Receipt' : downloadUrl  ,
                    'Timestamp': Timestamp.now(),
                  }
                ]),
              }, SetOptions(merge: true));

              // Data added successfully
              // const snackBar = SnackBar(
              //   backgroundColor: Colors.green,
              //   duration: Duration(seconds: 3),
              //   content: Text('Sent for verification!'),
              // );

              // ScaffoldMessenger.of(context).showSnackBar(snackBar);

              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    content: Text('Sent for verification!'),
                  );
                },
              ).then((value) => Navigator.pop(context));

              // Clear the text fields
              // preferences.clear();
              // reason.clear();
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
      // appBar: AppBar(
      //   backgroundColor: const Color(0xff90AAD6),
      //   centerTitle: true,
      //   title: const Text(
      //     "Vacant Room",
      //     style: TextStyle(
      //       fontFamily: "Nunito",
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      appBar: appbars('Vacant Room'),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dropdownMenu(listvacant, dropdownValueVacant,
                      (String? value) {
                    setState(() {
                      dropdownValueVacant = value!;
                      setvacant = dropdownValueVacant;
                    });
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dropdownMenu(listbatch, dropdownValueBatch,
                      (String? value) {
                    setState(() {
                      dropdownValueBatch = value!;
                      setBatch = dropdownValueBatch;
                    });
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () async {
                          File? file = await pickFile();
                          uploadFile(file);
                          setState(() {
                            uniqueFilename;
                          });
                        },
                        child: Container(
                          height: 58,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                uniqueFilename,
                                style: const TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Expanded(
                    //   child: SizedBox(
                    //     height: 44,
                    //     child: Image.network(
                    //         "http://cdn.onlinewebfonts.com/svg/img_215257.png"),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 20,
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
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    side: MaterialStateBorderSide.resolveWith((states) =>
                        const BorderSide(color: Colors.black, width: 2)),
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey,
                    ),
                  ),
                  onPressed: () {
                 
                      if (downloadUrl != '' ||
                          setvacant == 'Select Reason' ||
                          setBatch == 'Select Batch') {
                        validateFields();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text('Please fill the above details'),
                            );
                          },
                        );
                      }
                    
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.black, fontSize: 20),
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
