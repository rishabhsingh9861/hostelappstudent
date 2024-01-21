// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    'https://firebasestorage.googleapis.com/v0/b/vjti-hostel-f8c43.appspot.com/o/Icons%2Ficon.png?alt=media&token=2da3e303-790a-4b1e-aee2-cf974c14e386';

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
    return Material(
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
             
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    dropdownMenu(listyear, dropdownValueYear, (String? value) {
                  setState(() {
                    dropdownValueYear = value!;
                    setyear = dropdownValueYear;
                  });
                }),
              ),

              const SizedBox(
                height: 50,
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
                            refrenceroot.child('Passport Photo');
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
                          color: const Color.fromARGB(255, 185, 213, 226),
                          border: Border.all(
                              width: 3,
                              color: const Color.fromARGB(255, 69, 114, 148)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                'assets/images/galleryimage.png',
                                height: 40,
                                width: 40,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Select Passport Size Photo',
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
                    height: 50,
                    width: 50,
                    child: Image.network(imageUrl),
                  )
                ],
              ),

              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () async {
                  File? file = await pickFile();
                  uploadFile(file);
                  setState(() {
                    uniqueFilename;
                  });
                },
                child: Container(
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.green),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Text(
                    uniqueFilename,
                    style: textsty,
                  )),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
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
                    style: textsty,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
