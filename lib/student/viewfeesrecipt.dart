// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:vjtihostel/student/constant/const.dart';
import 'package:vjtihostel/student/genrateid.dart';

class FeesReceiptViewer extends StatefulWidget {
  const FeesReceiptViewer({
    Key? key,
    required this.url,
    required this.imgurl,
    required this.roomnumber,
    required this.year,
  }) : super(key: key);
  final String url;
  final String imgurl;
  final String roomnumber;

  final String year;

  @override
  State<FeesReceiptViewer> createState() => _FeesReceiptViewerState();
}

class _FeesReceiptViewerState extends State<FeesReceiptViewer> {
  String address = '';
  String bloodgroup = '';
  String roomno = '';
  String name = '';
  int parentsNumber = 0;
  int hostelid = 0;
  int registrationnumber = 0;
  int studentnumber = 0;
  PdfViewerController? _pdfViewerController;
  bool isChecked = false;
  Timestamp timenow = Timestamp.now();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String emailids = user.email.toString();

    Future addGeneratrIdDetails(
        String name,
        String year,
        int hostelidno,
        int registration,
        String roomno,
        String address,
        String bloodgrp,
        String department,
        int studentcontactnumber,
        int parentcontactnumber,
        String url,
        String imgurl,
        String emailid,
        Timestamp time,
        bool approv) async {
      await FirebaseFirestore.instance
          .collection('GenerateIdRequest')
          .doc()
          .set({
        'Name': name,
        'Year': year,
        'Hostel ID': hostelidno,
        'Registration No.': registration,
        'Room NO.': roomno,
        'Adress': address,
        'Blood Group': bloodgrp,
        'Department': department,
        'Student contact number': studentcontactnumber,
        'Parent Contact Number': parentcontactnumber,
        'Fess Recipt': url,
        'Passport Photo': imgurl,
        'Emailid': emailid,
        'Time': time,
        'Approved': approv
      });
    }

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('HostelStudents')
          .doc(emailids)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        } else {
          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;

          address = userData['Address'] as String;
          bloodgroup = userData['Blood Group'] as String;
          name = userData['Name'] as String;
          hostelid = userData['Hostel Id'] as int;
          String dept = userData['Department'] as String;
          studentnumber = userData['Student contact number'] as int;
          registrationnumber = userData['Registration No.'] as int;
          parentsNumber = userData['Parent Contact Number'] as int;
          bool approve = userData['Approved'];

          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: appbars('Preview'),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 80,
                      backgroundImage: NetworkImage(
                        imageUrl,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: $name',
                                style: textstyy,
                              ),
                              Text(
                                'Hostel ID: $hostelid',
                                style: textstyy,
                              ),
                              Text(
                                'Year: ${widget.year}',
                                style: textstyy,
                              ),
                              Text(
                                'Year: $dept',
                                style: textstyy,
                              ),
                              Text(
                                'Room No.:${widget.roomnumber}',
                                style: textstyy,
                              ),
                              Text(
                                'Addres: $address',
                                style: textstyy,
                              ),
                              Text(
                                'Registration No.: $registrationnumber',
                                style: textstyy,
                              ),
                              Text(
                                'Parent Contact No.: $parentsNumber',
                                style: textstyy,
                              ),
                              Text(
                                'Student Number.: $studentnumber',
                                style: textstyy,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: SfPdfViewer.network(widget.url,
                            controller: _pdfViewerController,
                            enableDocumentLinkAnnotation: false),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Material(
                          child: Checkbox(
                            checkColor: Colors.white,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                        ),
                        const Column(
                          children: [
                            Text(
                              'All Correct',
                            ),
                          ],
                        )
                      ],
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) =>
                                  const Color.fromARGB(255, 124, 162, 192))),
                      onPressed: () {
                        if (isChecked) {
                          addGeneratrIdDetails(
                                  name,
                                  widget.year,
                                  hostelid,
                                  registrationnumber,
                                  widget.roomnumber,
                                  address,
                                  bloodgroup,
                                  dept,
                                  studentnumber,
                                  parentsNumber,
                                  widget.url,
                                  imageUrl,
                                  emailids,
                                  timenow,
                                  approve)
                              .then((value) => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text(
                                              'Send For Verification Process'),
                                        );
                                      }).then((value) {
                                    int count = 1;
                                    Navigator.of(context)
                                        .popUntil((_) => count-- < 0);
                                  }));
                        }
                      },
                      child: const Text(
                        'Generate Id Card',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ); // Replace YourWidget with the widget you want to build
        }
      },
    );
  }
}
