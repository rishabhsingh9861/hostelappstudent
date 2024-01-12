// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:vjtihostel/student/constant/const.dart';

class FeesReceiptViewer extends StatefulWidget {
  const FeesReceiptViewer({
    Key? key,
    required this.url,
    required this.name,
    required this.roomno,
    required this.hostelid,
    required this.year,
  }) : super(key: key);
  final String url;
  final String name;
  final String roomno;
  final String hostelid;
  final String year;

  @override
  State<FeesReceiptViewer> createState() => _FeesReceiptViewerState();
}

class _FeesReceiptViewerState extends State<FeesReceiptViewer> {
  String address = '';
  String bloodgroup = '';
  int parentsNumber = 0;
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
        String hostelidno,
        int registration,
        String roomno,
        String address,
        int studentcontactnumber,
        int parentcontactnumber,
        String url,
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
        'Student contact number': studentcontactnumber,
        'Parent Contact Number': parentcontactnumber,
        'Fess Recipt': url,
        'Emailid' : emailid ,
        'Time' : time,
        'Approved':approv
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
          studentnumber = userData['Student contact number'] as int;
          registrationnumber = userData['Registration No.'] as int;
          parentsNumber = userData['Parent Contact Number'] as int;
          bool approve = userData['Approved'] ;

          // Do something with the data
          return SafeArea(
            child: Scaffold(
              appBar: appbars('Preview'),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: ${widget.name}',
                                  style: textsty,
                                ),
                                Text(
                                  'Hostel ID: ${widget.hostelid}',
                                  style: textsty,
                                ),
                                Text(
                                  'Year: ${widget.year}',
                                  style: textsty,
                                ),
                                Text(
                                  'Room No. :${widget.roomno}',
                                  style: textsty,
                                ),
                                Text(
                                  'Addres :$address',
                                  style: textsty,
                                ),
                                Text(
                                  'Registration No. :$registrationnumber',
                                  style: textsty,
                                ),
                                Text(
                                  'Parent Contact No. :$parentsNumber',
                                  style: textsty,
                                ),
                                Text(
                                  'Student Number.:$studentnumber',
                                  style: textsty,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SfPdfViewer.network(widget.url,
                          controller: _pdfViewerController,
                          enableDocumentLinkAnnotation: false),
                    ),
                  )),
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
                      onPressed: () {
                        if (isChecked) {
                          addGeneratrIdDetails(
                                  widget.name,
                                  widget.year,
                                  widget.hostelid,
                                  registrationnumber,
                                  widget.roomno,
                                  address,
                                  studentnumber,
                                  parentsNumber,
                                  widget.url,
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
                      child: const Text('Generate Id Card')),
                ],
              ),
            ),
          ); // Replace YourWidget with the widget you want to build
        }
      }, 
    );
  }
}
