// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vjtihostel/student/constant/const.dart';
import 'package:vjtihostel/student/viewfeesrecipt.dart';

class GenerateId extends StatefulWidget {
  const GenerateId({Key? key}) : super(key: key);

  @override
  State<GenerateId> createState() => _GenerateIdState();
}

String imageUrl =
    'https://tse3.mm.bing.net/th?id=OIP.PZpRGo0S1iGYMx8z82P-WAHaHJ&pid=Api&P=0&h=180';

List<String> listyear = <String>[
  'Select Year',
  'First Year',
  'Second Year',
  'Third Year',
  'Final Year',
];

class _GenerateIdState extends State<GenerateId> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomnumber = TextEditingController();
  final _hostelid = TextEditingController();

  String dropdownValueYear = listyear.first;
  String setyear = "";
  String uniqueFilename = 'Upload Fess Receipt';

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
                style: TextStyle(fontSize: 20, decoration: TextDecoration.none),
              ),
              CircularProgressIndicator(),
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

  @override
  void dispose() {
    _nameController.dispose();
    _hostelid.dispose();
    _roomnumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbars("Identification Details"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 280,
                  child: Image.asset('assets/images/idcard.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dropdownMenu(listyear, dropdownValueYear,
                      (String? value) {
                    setState(() {
                      dropdownValueYear = value!;
                      setyear = dropdownValueYear;
                    });
                  }),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: InkWell(
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
                            String uniqueFilename = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();

                            Reference refrenceroot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                refrenceroot.child('Passport Photo');
                            Reference refrenceImageToUpload =
                                referenceDirImages.child(uniqueFilename);

                            try {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Please wait Uploading',
                                        style: TextStyle(
                                            fontSize: 20,
                                            decoration: TextDecoration.none),
                                      ),
                                      CircularProgressIndicator(),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 280,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 1,
                                color: const Color.fromARGB(255, 97, 139, 163),
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(CupertinoIcons.photo)),
                                Text(
                                  'Select Passport Size Photo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.network(
                          imageUrl,
                        ),
                      ),
                    )
                  ],
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
                              color: const Color.fromARGB(255, 97, 139, 163),
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
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
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: Image.network(
                            "http://cdn.onlinewebfonts.com/svg/img_215257.png"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => const Color.fromARGB(255, 108, 159, 201),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (downloadUrl != '') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FeesReceiptViewer(
                                      url: downloadUrl,
                                      year: setyear,
                                      imgurl: imageUrl,
                                    )));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text('please upload fees receipt'),
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Review',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Nunito",
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
