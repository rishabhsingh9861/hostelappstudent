// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vjtihostel/student/constant/const.dart';
import 'package:vjtihostel/student/constant/data.dart';
import 'package:vjtihostel/student/viewfeesrecipt.dart';

class GenerateId extends StatefulWidget {
  const GenerateId({Key? key}) : super(key: key);

  @override
  State<GenerateId> createState() => _GenerateIdState();
}

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
      String uniqueFilename = file.path.split('/').last;
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
            children: [
              const SizedBox(
                height: 30,
              ),
              writedata('Enter Full Name', TextInputType.name, _nameController),
              const SizedBox(
                height: 50,
              ),
              writedata('Enter Room Number', TextInputType.name, _roomnumber),
              const SizedBox(
                height: 50,
              ),
              writedata('Enter Hostel ID', TextInputType.number, _hostelid),
              const SizedBox(
                height: 50,
              ),
              dropdownMenu(listyear, dropdownValueYear, (String? value) {
                setState(() {
                  dropdownValueYear = value!;
                  setyear = dropdownValueYear;
                });
              }),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () async {
                  File? file = await pickFile();
                  uploadFile(file);
                },
                child: Container(
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.green),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                      child: Text(
                    'Upload Fess Receipt',
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
                                      name: _nameController.text.toString(),
                                      roomno: _roomnumber.text.toString(),
                                      hostelid: _hostelid.text.toString(),
                                      year: setyear,
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
