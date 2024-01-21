// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vjtihostel/committe/committe_page.dart';
import 'package:vjtihostel/committe/facilitiespage.dart';
import 'package:vjtihostel/onboard.dart';
import 'package:vjtihostel/student/Drawer/certificate.dart';
import 'package:vjtihostel/student/complaints.dart';
import 'package:vjtihostel/student/constant/const.dart';
import 'package:vjtihostel/student/genrateid.dart';
import 'package:vjtihostel/student/pendingComplaints.dart';
import 'package:vjtihostel/student/rectors.dart';
import 'package:vjtihostel/student/Drawer/request.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final user = FirebaseAuth.instance.currentUser!;
String email = user.email.toString();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 208, 208, 206),
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
          centerTitle: true,
          title: const Text('VJTI HOSTEL'),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GenerateId()),
                  );
                },
                child: Image.asset(
                  'assets/images/id-card.png',
                  scale: 10,
                ),
              ),
            )
          ],
        ),
        drawer: const Drawers(),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('HostelStudents')
              .doc(email)
              .collection('StudentIDCard')
              .doc('idcard')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                    child: Text(
                  'You have skipped the registration page pls contact hostel office',
                  style: textsty,
                ));
              }

              final reqData = snapshot.data?.data() as Map<String, dynamic>?;
              if (reqData == null) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Please Generate Id card',
                    style: textsty,
                  ),
                ));
              }

              String name = reqData['Name'] ?? '';
              String hostelid = reqData['Hostel ID'] ?? '';
              String roomo = reqData['Room NO.'] ?? '';
              int registration = reqData['Registration No.'] ?? 0;
              String addres = reqData['Adress'] ?? '';
              String bloodgrp = reqData['Blood Group'] as String? ?? '';
              String pphoto = reqData['Passport Photo'] as String? ?? '';
              int parentnumber = reqData['Parent Contact Number'] as int? ?? 0;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueGrey,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Hostel Id: $hostelid',
                                style: textsty,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Room  No. : $roomo',
                                style: textsty,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(pphoto),
                              radius: 70,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Name: $name',
                          style: textsty,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Registration No. : $registration',
                          style: textsty,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Address : $addres',
                          style: textsty,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Blood Group : $bloodgrp',
                          style: textsty,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Call Parent: ',
                              style: textsty,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final call = 'tel:$parentnumber';
                              if (!await launchUrlString(call)) {
                                await canLaunchUrlString(call);
                              }
                            },
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset('assets/images/phoneicon.png'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class Drawers extends StatelessWidget {
  const Drawers({super.key});

  @override
  Widget build(BuildContext context) {
    void signUserOut() async {
      FirebaseAuth.instance.signOut().then((value) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Onboard()));
      });
    }

    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();
    return Drawer(
        child: SingleChildScrollView(


      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            // currentAccountPictureSize: const Size.square(72),
            // otherAccountsPicturesSize: const Size.square(20.0),
            // margin: EdgeInsets.zero,

            accountName: Text(
              user.displayName!,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            accountEmail: Text(
              user.email!,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Complaints(
                                email: email,
                              )));
                },
                child: listtile("Complaints")),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PendingComplaints()));
                },
                child: listtile("Pending Complaints")),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Request()));
                },
                child: listtile("Request")),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                      MaterialPageRoute(builder: (_) => FacilitiesPage()));
              },
              child: listtile("Facilities")),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Certificates()));
              },
              child: listtile("Certificates"),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: listtile("Events"),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CommitteePage()));
                },
                child: listtile("Committee")),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Rectors()));
                },
                child: listtile("Rectors")),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: listtile("Developer"),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: InkWell(
                onTap: () {
                  signUserOut();
                },
                child: listtile("SignOut")),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ));
  }
}

ListTile listtile(String title) {
  return ListTile(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    ),
  );
}