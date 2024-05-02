// ignore_for_file: non_constant_identifier_names, file_names, use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vjtihostel/student/constant/const.dart';

class HostelAndMess extends StatefulWidget {
  const HostelAndMess({
    Key? key,
    required this.email,
  }) : super(key: key);
  final String email;

  @override
  State<HostelAndMess> createState() => _HostelAndMessState();
}

List<String> listCertificate = <String>[
  'Certificate Type',
  'Hostel and Mess Certificate',
  'Expenditure Certificate',
  'Passport Verification Certificate'
];

String uniqueFilename = 'Upload Fees Receipt';

class _HostelAndMessState extends State<HostelAndMess> {
  CollectionReference db =
      FirebaseFirestore.instance.collection('HostelStudents');
  CollectionReference db1 =
      FirebaseFirestore.instance.collection('CertificateRequest');

  String dropdownValueCertificate = listCertificate.first;
  String certificate = "";
  String downloadUrl = '';

  Future<File?> pickFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (pickedFile != null) {
      File file = File(pickedFile.files.single.path!);
      return file;
    }

    return null;
  }

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
                    color: Colors.green,
                    decoration: TextDecoration.none),
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

  void validateFields() async {
    try {
      DocumentReference certificateRequestDoc = db1.doc('requests');

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
          int regNo = idCardData['Registration No'] ?? 0;
          String roomNo = idCardData['Room No'] ?? '';

          if (certificate.isNotEmpty) {
            await certificateRequestDoc.set({
              'Certificates': FieldValue.arrayUnion([
                {
                  'Name': name,
                  'Year': year,
                  'Registration No': regNo,
                  'Room No': roomNo,
                  'Certificate Type': certificate,
                  'Timestamp': Timestamp.now(),
                  'FeesReceiptUrl': downloadUrl,
                  'photo': idCardData['Passport Photo'],
                  'Email': idCardData['Emailid']
                }
              ]),
            }, SetOptions(merge: true)).then((value) {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    title: Text('Success'),
                    content: Text(
                        'Your request is submitted successfully. Approval will be sent to your mail.Please collect it after 2 days from office after approval'),
                  );
                },
              ).then((value) {
                setState(() {
                  // Clear selected certificate and file name
                  certificate = '';
                  uniqueFilename = 'Upload Fees Receipt';
                });
                Navigator.pop(context);
              });
            });

            // const snackBar = SnackBar(
            //   backgroundColor: Colors.green,
            //   duration: Duration(seconds: 3),
            //   content: Text('Sent for verification!'),
            // );

            // ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // Clear the selected certificate and filename
            // certificate = '';
            // uniqueFilename = 'Upload Fees Receipt';
          } else {
            const snackBar = SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              content: Text('Select a Certificate Type'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          const snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            content: Text('Select a Certificate Type'),
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
    } catch (e) {
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffE9E3D5),
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
        child: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.network(
                        "https://icon-library.com/images/fill-out-form-icon/fill-out-form-icon-10.jpg"),
                  ),
                  const Text(
                    "Apply for Certificate ",
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: dropdownMenu(
                      listCertificate,
                      dropdownValueCertificate,
                      (String? value) {
                        setState(() {
                          dropdownValueCertificate = value!;
                          certificate = dropdownValueCertificate;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      File? file = await pickFile();
                      uploadFile(file);
                    },
                    child: Container(
                      height:
                          58, // Specify a fixed height or use another appropriate constraint
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
                  const SizedBox(
                    height: 25,
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
                      validateFields();
                    },
                    child: const Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
