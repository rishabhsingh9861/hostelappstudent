// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vjtihostel/student/constant/const.dart';
import 'package:vjtihostel/student/constant/data.dart';
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

List<String> listBlock = <String>[
  'Select Block',
  'A',
  'B',
  'C',
  'D',
  'E',
  'T',
  'Flat',
];

class _GenerateIdState extends State<GenerateId> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  //final _hostelid = TextEditingController();
  final _roomnoController = TextEditingController();

  String dropdownValueYear = listyear.first;
  String setyear = "";
  String dropdownValueBlock = listBlock.first;
  String setblock = "";
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

  @override
  void dispose() {
    _nameController.dispose();
    //_hostelid.dispose();
    _roomnoController.dispose();
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 5, top: 5),
                              height: 100,
                              child: Hero(
                                  tag: "vjtiLogo",
                                  child: Image.asset(
                                      "assets/images/vjtiLogo.png")),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8),
                              child: Text(
                                "Veermata Jijabai \n  Technological\n     Institute",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontFamily: "Anton",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Hero(
                          tag: "ID",
                          child: Image.asset('assets/images/idcard.png')),
                    ),
                  ],
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dropdownMenu(listBlock, dropdownValueBlock,
                      (String? value) {
                    setState(() {
                      dropdownValueBlock = value!;
                      setblock = dropdownValueBlock;
                    });
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Enter Room Number", TextInputType.number,
                      _roomnoController),
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

                              List<int> compressedImage =
                                  (await FlutterImageCompress.compressWithFile(
                                file.path,
                                quality: 20,
                              )) as List<int>;

                              await refrenceImageToUpload.putData(
                                Uint8List.fromList(compressedImage),
                                SettableMetadata(
                                  contentType: "image/jpeg",
                                ),
                              );

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
                                color: Colors.black,
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
                ElevatedButton(
                  style: ButtonStyle(
                    side: MaterialStateBorderSide.resolveWith(
                      (states) =>
                          const BorderSide(color: Colors.black, width: 1),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.grey,
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
                                      roomnumber:
                                          setblock + _roomnoController.text,
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
