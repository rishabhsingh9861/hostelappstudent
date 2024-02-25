// // ignore_for_file: use_build_context_synchronously

// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vjtihostel/student/Drawer/Forms/amenities.dart';
import 'package:vjtihostel/student/constant/const.dart';
import 'package:intl/intl.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

List<String> listReasonLeave = <String>[
  'Type Of Leave',
  'Official leave  ',
  'Unofficial leave',
];

final user = FirebaseAuth.instance.currentUser!;
String email = user.email.toString();

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String dropdownValueLeave = listReasonLeave.first;
  String setbleave = "";
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/vjti-hostel-f8c43.appspot.com/o/Icons%2Ficon.png?alt=media&token=2da3e303-790a-4b1e-aee2-cf974c14e386';

  String name = "";
  String registration = "";
  String photo = "";
  String contactno = "";
  String roomno = "";
  int parentsno = 0;
  int hostelid = 0;
  String department = "";
  String address = "";
  String year = "";

  void getuserdata() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('HostelStudents')
        .doc(email)
        .collection('StudentIDCard')
        .doc('idcard')
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      name = userData['Name'];
      contactno = userData['Student contact number'];
      photo = userData['Passport Photo'];
      registration = userData['Registration No.'];
      roomno = userData['Room No'];
      parentsno = userData['Parent Contact Number'];
      hostelid = userData['Hostel ID'];
      department = userData['Department'];
      address = userData['Adress'];
      year = userData['Year'];
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
      appBar: appbars('Leave Request and Approval'),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Events').snapshots(),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    TextField(
                        controller: _startDateController,
                        decoration:
                            const InputDecoration(labelText: 'Start Date'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                            initialDatePickerMode: DatePickerMode.day,
                          );

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('yyyy-MM-dd')
                                .format(pickedDate); // Format the picked date
                            _startDateController.text = formattedDate;
                          }
                        }),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _endDateController,
                      decoration: const InputDecoration(labelText: 'End Date'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                          initialDatePickerMode: DatePickerMode.day,
                        );

                        if (pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd')
                              .format(pickedDate); // Format the picked date
                          _endDateController.text = formattedDate;
                        }
                      },
                    ),
                    // const SizedBox(height: 16),
                    // TextField(
                    //   controller: _reasonController,
                    //   decoration: const InputDecoration(labelText: 'Reason'),
                    // ),

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
                              String uniqueFilename = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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

                                imageUrl = await refrenceImageToUpload
                                    .getDownloadURL();
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
                                    content:
                                        Text('Image uploaded successfully'),
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
                                border:
                                    Border.all(width: 1, color: Colors.black),
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

                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xff90AAD6),
                        ),
                      ),
                      onPressed: () {
                        _submitLeaveRequest();
                      },
                      child: const Text('Submit Request'),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _submitLeaveRequest() async {
    // Get the entered information
    String startDate = _startDateController.text;
    String endDate = _endDateController.text;
    String reason = _reasonController.text;

    // Validate if all fields are filled
    if (startDate.isEmpty || endDate.isEmpty || reason.isEmpty) {
      // Show an error message or handle accordingly
      return;
    }

    // Create a map of the leave request data
    Map<String, dynamic> leaveRequestData = {
      'start_date': startDate, 
      'end_date': endDate,
      'reason': reason,
      'Name': name,
      'Hostelid': hostelid,
      'Registration No': registration,
      'Department': department,
      'Parents No': parentsno,
      'Student No': contactno,
      'Room No': roomno,
      'Addres': address,
      'Year': year,
      'Photo': photo,

    
    };

    // Add the leave request data to Firestore
    await FirebaseFirestore.instance
        .collection('LeaveApproval')
        .add(leaveRequestData);

    // Show a success message or navigate to another screen
    // You can customize this part based on your application flow
  }
}















// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:vjtihostel/student/constant/const.dart';

// class LeaveRequest extends StatefulWidget {
//   const LeaveRequest({super.key});

//   @override
//   State<LeaveRequest> createState() => _LeaveRequestState();
// }



// class _LeaveRequestState extends State<LeaveRequest> {
//   String dropdownValueLeave = listReasonLeave.first;
//   String setbleave = "";
//   String imageUrl =
//       'https://firebasestorage.googleapis.com/v0/b/vjti-hostel-f8c43.appspot.com/o/Icons%2Ficon.png?alt=media&token=2da3e303-790a-4b1e-aee2-cf974c14e386';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xff90AAD6),
//         centerTitle: true,
//         title: const Text(
//           "Leave Request",
//           style: TextStyle(
//             fontFamily: "Nunito",
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//           
//                 // leaveDetails(
//                 //   hinttext: "Enter Your Full Name ",
//                 //   labletext: "Name",
//                 //   icons: const Icon(CupertinoIcons.person),
//                 // ),
//                 // const SizedBox(
//                 //   height: 10,
//                 // ),
//                 // leaveDetails(
//                 //   hinttext: "Enter Your Hostel ID Number ",
//                 //   labletext: "ID Number",
//                 //   icons: const Icon(CupertinoIcons.number),
//                 // ),
//                 // const SizedBox(
//                 //   height: 10,
//                 // ),
//                 // leaveDetails(
//                 //   hinttext: "Enter Your Email Address",
//                 //   labletext: "Email ID",
//                 //   icons: const Icon(CupertinoIcons.mail),
//                 // ),
//                 // const SizedBox(
//                 //   height: 5,
//                 // ),
//                 // const Divider(),
//                 // const SizedBox(
//                 //   height: 5,
//                 // ),

//                 Padding(
//                   padding: const EdgeInsets.only(left: 40),
//                   child: dropdownMenu(listReasonLeave, dropdownValueLeave,
//                       (String? value) {
//                     setState(() {
//                       dropdownValueLeave = value!;
//                       setbleave = dropdownValueLeave;
//                     });
//                   }),
//                 ),

//                 // leaveDetails(
//                 //   hinttext: " e.g., Casual, Medical, Vacation",
//                 //   labletext: "Enter Type Of Leave",
//                 //   icons: const Icon(CupertinoIcons.person),
//                 // ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateColor.resolveWith(
//                       (states) => const Color(0xff90AAD6),
//                     ),
//                   ),
//                   onPressed: () {},
//                   child: const Text(
//                     "Submit",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// TextField leaveDetails({
//   required String hinttext,
//   required String labletext,
//   required Icon icons,
//   // required TextEditingController controller,
// }) {
//   return TextField(
//     // controller: controller,
//     decoration: InputDecoration(
//       hintText: hinttext,
//       labelText: labletext,
//       labelStyle:
//           const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//       icon: icons,
//       border: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(20),
//         ),
//       ),
//       enabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.black),
//         borderRadius: BorderRadius.all(
//           Radius.circular(20),
//         ),
//       ),
//       focusedBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.black, width: 2),
//         borderRadius: BorderRadius.all(
//           Radius.circular(20),
//         ),
//       ),
//     ),
//   );
// }
