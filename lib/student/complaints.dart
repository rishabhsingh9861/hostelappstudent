// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vjtihostel/student/constant/const.dart';

class Complaints extends StatefulWidget {
  const Complaints({
    Key? key,
    required this.email,
  }) : super(key: key);
  final String email;

  @override
  State<Complaints> createState() => _ComplaintsState();
}

List<String> listproblemcategory = <String>[
  'Select Category',
  'Electical',
  'Carpentry',
  'Plumbing',
  'Structural',
  'Cleaning',
];

class _ComplaintsState extends State<Complaints> {
  final _formKey = GlobalKey<FormState>();
  final _problemController = TextEditingController();
  final _roomController = TextEditingController();
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/vjti-hostel-f8c43.appspot.com/o/Icons%2Ficon.png?alt=media&token=2da3e303-790a-4b1e-aee2-cf974c14e386';

  String dropdownValueProblem = listproblemcategory.first;
  String setproblem = "";
  Timestamp timestamp = Timestamp.now();

  @override
  void dispose() {
    _problemController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> sendProblemdata(
    String photourl,
    String problemDescription,
    String problemCategory,
    String emailid,
    String name,
    String roomNo,
    int contactNumber,
    Timestamp time,
  ) async {
    await FirebaseFirestore.instance
        .collection('HostelStudents')
        .doc(widget.email)
        .collection('Complaints')
        .doc()
        .set({
      'Photo Url': photourl,
      'Problem': problemDescription,
      'Category': problemCategory,
      'Email': emailid,
      'Name': name,
      'Room Number': roomNo,
      'Contact Number': contactNumber,
      'Time': time,
    });
  }

  Future<void> sendProblemtoemplyee(
    String photourl,
    String problemDescription,
    String problemCategory,
    String emailid,
    String name,
    String roomNo,
    int contactNumber,
    Timestamp time,
  ) async {
    await FirebaseFirestore.instance
        .collection('HostelStudents')
        .doc(widget.email)
        .collection('Complaints')
        .doc()
        .set({
      'Photo Url': photourl,
      'Problem': problemDescription,
      'Category': problemCategory,
      'Email': emailid,
      'Name': name,
      'Room Number': roomNo,
      'Contact Number': contactNumber,
      'Time': time,
    });
  }

  String name = '';
  String roomo = '';
  int contactNo = 0;

  void getuserdata() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('HostelStudents')
        .doc(widget.email)
        .collection('StudentIDCard')
        .doc('idcard')
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      name = userData['Name'];
      contactNo = userData['Student contact number'];
      roomo = userData['Room No'];
    }
  }

  @override
  void initState() {
    getuserdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbars(
        'Complain',
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: const Text(
                          'Problem Description',
                          style: TextStyle(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 88, 120, 146),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 88, 120, 146),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 1,
                      controller: _problemController,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              dropdownMenu(listproblemcategory, dropdownValueProblem, (value) {
                setState(() {
                  dropdownValueProblem = value!;
                  setproblem = dropdownValueProblem;
                });
              }),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);

                      if (file == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text('Image not selected'),
                            );
                          },
                        );
                      } else {
                        String uniqueFilename =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        Reference refrenceroot = FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            refrenceroot.child('Images');
                        Reference refrenceImageToUpload =
                            referenceDirImages.child(uniqueFilename);

                        try {
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
                                        color: Colors.green,
                                        fontSize: 20,
                                        decoration: TextDecoration.none),
                                  ),
                                  CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                ],
                              );
                            },
                          );

                          await refrenceImageToUpload.putFile(
                              File(file.path),
                              SettableMetadata(
                                contentType: "image/jpeg",
                              ));

                          imageUrl =
                              await refrenceImageToUpload.getDownloadURL();
                        } catch (error) {
                          // Print or log the error for debugging purposes

                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: Text('Image not uploaded'),
                              );
                            },
                          );
                        } finally {
                          Navigator.of(context)
                              .pop(); // Dismiss the "Please wait Uploading" dialog
                        }

                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text('Image uploaded successfully'),
                            );
                          },
                        );
                      }

                      setState(() {
                        imageUrl;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 122, 159, 187)),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(CupertinoIcons.photo),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Select Problem Image',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.network(imageUrl),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color(0xff90AAD6))),
                onPressed: () {
                  sendProblemdata(
                          imageUrl.toString(),
                          _problemController.text.trim(),
                          setproblem.toString(),
                          widget.email.toString(),
                          name.toString(),
                          roomo,
                          int.parse(contactNo.toString()),
                          timestamp)
                      .then((value) => showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text('Problem Sent Sucessfully'),
                                );
                              }).then((value) {
                            int count = 1;
                            Navigator.of(context).popUntil((_) => count-- < 0);
                          }));
                },
                child: const Text(
                  "Send Problem",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
