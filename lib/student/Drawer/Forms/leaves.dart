// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:vjtihostel/student/constant/const.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({Key? key}) : super(key: key);

  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

List<String> listReasonLeave = <String>[
  'Type Of Leave',
  'Official leave  ',
  'Unofficial leave',
];
Timestamp time = Timestamp.now();

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String dropdownValueLeave = listReasonLeave.first;
  String setleave = "";
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/vjti-hostel-f8c43.appspot.com/o/Icons%2Ficon.png?alt=media&token=2da3e303-790a-4b1e-aee2-cf974c14e386';

  String name = "";
  int registration = 0;
  String photo = "";
  int contactno = 0;
  String roomno = "";
  int parentsno = 0;
 // String hostelid = "";
  String department = "";
  String address = "";
  String year = "";

  late User user; // Declare user variable
  late String email; // Declare email variable

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!; // Initialize user
    email = user.email.toString(); // Initialize email
    getuserdata(); // Fetch user data when the widget initializes
  }

  void getuserdata() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('HostelStudents')
        .doc(email)
        .collection('StudentIDCard')
        .doc('idcard')
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      setState(() {
        // Update state variables with fetched user data
        name = userData['Name'];
        contactno = userData['Student contact number'];
        photo = userData['Passport Photo'];
        registration = userData['Registration No'];
        roomno = userData['Room No'];
        parentsno = userData['Parent Contact Number'];
        // hostelid = userData['Hostel ID'];
        department = userData['Department'];
        address = userData['Adress'];
        year = userData['Year'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Leave Request and Approval'),
      // ),
      appBar: appbars("Leave Request and Approval"),
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
                    child: Image.asset("assets/images/leaverequest.png"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[350],
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xffE9E3D5),
                        value: dropdownValueLeave,
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValueLeave = value!;
                            setleave = dropdownValueLeave;
                          });
                        },
                        items: listReasonLeave
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _startDateController,
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: 'Start Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        )),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                        initialDatePickerMode: DatePickerMode.day,
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        _startDateController.text = formattedDate;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _endDateController,
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: 'End Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        )),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                        initialDatePickerMode: DatePickerMode.day,
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        _endDateController.text = formattedDate;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: 'Reason for Leave',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        )),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          padding: const EdgeInsets.only(left: 0),
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
                      const SizedBox(width: 10),
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
                      side: MaterialStateBorderSide.resolveWith((states) =>
                          const BorderSide(color: Colors.black, width: 2)),
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey,
                      ),
                    ),
                    onPressed: _submitLeaveRequest,
                    child: const Text(
                      'Submit Request',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitLeaveRequest() async {
    // Get the entered information
    String startDate = _startDateController.text;
    String endDate = _endDateController.text;
    String reason = _reasonController.text;

    // Validate if all fields are filled
    if (startDate.isEmpty ||
        endDate.isEmpty ||
        reason.isEmpty ||
        reason == 'Type Of Leave') {
      // Show an error message or handle accordingly
      return;
    }

    // Check if the start date is before the end date
    if (DateTime.parse(startDate).isAfter(DateTime.parse(endDate))) {
      // Show an error message indicating that the start date should be before the end date
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Start date must be before end date.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit the method if the condition is not met
    }

    try {
      // Create a map of the leave request data
      Map<String, dynamic> leaveRequestData = {
        'start_date': startDate,
        'end_date': endDate,
        'reason': reason,
        'Name': name,
        'Type': setleave,
        //'Hostelid': hostelid,
        'Registration No': registration,
        'Department': department,
        'Parents No': parentsno,
        'Student No': contactno,
        'Room No': roomno,
        'Addres': address,
        'Year': year,
        'Photo': photo,
        'Email': email,
        'Proof': imageUrl,
        'timestamp': time, // Include server timestamp
      };

      // Add the leave request data to the user's document in LeaveApproval collection
      await FirebaseFirestore.instance
          .collection('LeaveApproval')
          .doc('requests')
          .update({
        'leave_requests': FieldValue.arrayUnion([leaveRequestData])
      });

      // Show a success message or navigate to another screen
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text(
                'Leave request submitted successfully. Approval will be sent to your mail.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  int count = 1;
                  Navigator.of(context).popUntil((_) => count-- < 0);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      // Clear the form fields after submission
      // _startDateController.clear();
      // _endDateController.clear();
      // _reasonController.clear(); // Clear Reason for Leave
      // setState(() {
      //   dropdownValueLeave = listReasonLeave.first;

      //   imageUrl =
      //   'https://firebasestorage.googleapis.com/v0/b/vjti-hostel-f8c43.appspot.com/o/Icons%2Ficon.png?alt=media&token=2da3e303-790a-4b1e-aee2-cf974c14e386'; // Reset image URL
      // });
    } catch (error) {
      // Handle any errors that occur during the process
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to submit leave request.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
