// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vjtihostel/student/constant/const.dart';

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({super.key});

  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

List<String> listReasonLeave = <String>[
  'Type Of Leave',
  'Casual leave ',
  'Medical leave ',
  '1 day Leave ',
  '2 day Leave',
  '1 Week Leave',
  '2 Week Leave',
  '1 Month Leave',
  '2 Month Leave',
];

class _LeaveRequestState extends State<LeaveRequest> {
  String dropdownValueLeave = listReasonLeave.first;
  String setbleave = "";
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/vjti-hostel-f8c43.appspot.com/o/Icons%2Ficon.png?alt=media&token=2da3e303-790a-4b1e-aee2-cf974c14e386';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff90AAD6),
        centerTitle: true,
        title: const Text(
          "Leave Request",
          style: TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  width: 150,
                  // decoration: const BoxDecoration(
                  //   color: Colors.white,
                  // ),
                  child: Image.asset("assets/images/leaverequest.png"),
                ),
                const SizedBox(
                  height: 10,
                ),
                // leaveDetails(
                //   hinttext: "Enter Your Full Name ",
                //   labletext: "Name",
                //   icons: const Icon(CupertinoIcons.person),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // leaveDetails(
                //   hinttext: "Enter Your Hostel ID Number ",
                //   labletext: "ID Number",
                //   icons: const Icon(CupertinoIcons.number),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // leaveDetails(
                //   hinttext: "Enter Your Email Address",
                //   labletext: "Email ID",
                //   icons: const Icon(CupertinoIcons.mail),
                // ),
                // const SizedBox(
                //   height: 5,
                // ),
                // const Divider(),
                // const SizedBox(
                //   height: 5,
                // ),

                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: dropdownMenu(listReasonLeave, dropdownValueLeave,
                      (String? value) {
                    setState(() {
                      dropdownValueLeave = value!;
                      setbleave = dropdownValueLeave;
                    });
                  }),
                ),

                // leaveDetails(
                //   hinttext: " e.g., Casual, Medical, Vacation",
                //   labletext: "Enter Type Of Leave",
                //   icons: const Icon(CupertinoIcons.person),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: leaveDetails(
                        hinttext: " e.g. 01-01-2024",
                        labletext: "Start Date",
                        icons: const Icon(CupertinoIcons.doc_append),
                      ),
                    ),
                    Expanded(
                      child: leaveDetails(
                        hinttext: "e.g. 01-03-2024",
                        labletext: "End Date",
                        icons: const Icon(CupertinoIcons.doc_append),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: " ",
                  labletext: "Reason for Leave",
                  icons: const Icon(CupertinoIcons.italic),
                ),
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

                          Reference refrenceroot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImages =
                              refrenceroot.child('LeaveReasonImages');
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
                            Navigator.of(context).pop();
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Container(
                          height: 60,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(CupertinoIcons.photo),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Attach Proof',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 75,
                      width: 75,
                      child: Image.network(imageUrl),
                    )
                  ],
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
                  onPressed: () {},
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
  // required TextEditingController controller,
}) {
  return TextField(
    // controller: controller,
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
