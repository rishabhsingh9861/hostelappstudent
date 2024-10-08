// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vjtihostel/committe/committe_page.dart';
import 'package:vjtihostel/committe/facilitiespage.dart';
import 'package:vjtihostel/developers.dart';
import 'package:vjtihostel/onboard.dart';
import 'package:vjtihostel/student/Drawer/Forms/holiday_list.dart';
import 'package:vjtihostel/student/Drawer/Forms/hostelAndMess.dart';
import 'package:vjtihostel/student/Drawer/about.dart';
import 'package:vjtihostel/student/Drawer/announcement.dart';
import 'package:vjtihostel/student/complaints.dart';
import 'package:vjtihostel/student/constant/const.dart';
import 'package:vjtihostel/student/genrateid.dart';
import 'package:vjtihostel/student/pendingproblem.dart';
import 'package:vjtihostel/student/rectors.dart';
import 'package:vjtihostel/student/Drawer/request.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final user = FirebaseAuth.instance.currentUser!;
String email = user.email.toString();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('HostelStudents')
          .doc(email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          // User is not registered or data is missing, redirect to Onboard page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Onboard()),
            );
          });
          return const Scaffold(
            body: Center(
              child: Text('Redirecting to registration...'),
            ),
          );
        }

        // User is registered and data is present, proceed with HomePage
        return _buildHomePage(
            context, snapshot.data!.data() as Map<String, dynamic>?);
      },
    );
  }

  Widget _buildHomePage(BuildContext context, Map<String, dynamic>? userData) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffE9E3D5),
        centerTitle: true,
        title: const Text(
          "VJTI HOSTEL",
          style: TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GenerateId(),
                  ),
                );
              },
              child: Hero(
                tag: "ID",
                child: Image.asset(
                  'assets/images/idcard.png',
                  scale: 10,
                ),
              ),
            ),
          )
        ],
      ),
      drawer: const Drawers(),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('HostelStudents')
              .doc(email)
              .collection('StudentIDCard')
              .doc('idcard')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text(
                  'You have skipped the registration page please signout and login again',
                  style: textsty,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final reqData = snapshot.data?.data() as Map<String, dynamic>?;
            if (reqData == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Please Generate ID card',
                    style: textsty,
                  ),
                ),
              );
            }

            String name = reqData['Name'] ?? '';
            // String hostelid = reqData['Hostel ID'] ?? '';
            String roomo = reqData['Room No'] ?? '';
            int registration = reqData['Registration No'] ?? 0;
            String addres = reqData['Adress'] ?? '';
            String year = reqData['Year'] ?? '';
            String dept = reqData['Department'] ?? '';
            String bloodgrp = reqData['Blood Group'] as String? ?? '';
            String pphoto = reqData['Passport Photo'] as String? ?? '';
            int parentnumber = reqData['Parent Contact Number'] as int? ?? 0;
            int studentnumber = reqData['Student contact number'] as int? ?? 0;

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Hero(
                              tag: "vjtiLogo",
                              child: Image.asset("assets/images/vjtiLogo.png")),
                        ),
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Veermata Jijabai \n  Technological\n     Institute",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.red,
                                  fontFamily: "Anton",
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "( An Autonomous Institute of Government of Maharashtra )",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blueGrey,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    div,
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "V",
                                  style: stylVJTI,
                                ),
                                Text(
                                  "J",
                                  style: stylVJTI,
                                ),
                                Text(
                                  "T",
                                  style: stylVJTI,
                                ),
                                Text(
                                  "I",
                                  style: stylVJTI,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              height: 170,
                              width: 160,
                              child: Image(
                                image: NetworkImage(
                                  pphoto,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, top: 10, right: 5),
                          child: const Text(
                            "HOSTEL ID CARD",
                            style: TextStyle(
                              fontFamily: "Anton",
                              color: Colors.red,
                              fontSize: 21,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text(
                        //     'Hostel Id: $hostelid',
                        //     style: idStyle,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: $name',
                            style: idStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'ID No : $registration',
                            style: const TextStyle(
                              fontSize: 19,
                              color: Colors.black,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Department : $dept',
                            style: idStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Year : $year',
                            style: idStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Room  No. : $roomo',
                            style: idStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Address : $addres',
                            style: idStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Blood Group : $bloodgrp',
                            style: idStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Student Contact No : $studentnumber', //
                            style: idStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Call Parent',
                                style: idStyle,
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              InkWell(
                                onTap: () async {
                                  final call = 'tel:$parentnumber';
                                  if (!await launchUrlString(call)) {
                                    await canLaunchUrlString(call);
                                  }
                                },
                                child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset(
                                        'assets/images/phoneicon.png')),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Row(
                    //       children: [
                    //         const Padding(
                    //           padding: EdgeInsets.all(8.0),
                    //           child: Text(
                    //             'Call Parent: ',
                    //             style: textsty,
                    //           ),
                    //         ),
                    //         GestureDetector(
                    //           onTap: () async {
                    //             final call = 'tel:$parentnumber';
                    //             if (!await launchUrlString(call)) {
                    //               await canLaunchUrlString(call);
                    //             }
                    //           },
                    //           child: SizedBox(
                    //             height: 30,
                    //             width: 30,
                    //             child:
                    //                 Image.asset('assets/images/phoneicon.png'),
                    //           ),
                    //         ),
                    //       ],
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class Drawers extends StatefulWidget {
  const Drawers({super.key});

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  String url =
      'https://firebasestorage.googleapis.com/v0/b/vjti-hostel-f8c43.appspot.com/o/Icons%2Ffaceicon.jpg?alt=media&token=7e0a62d6-f43f-4e8d-ac34-d06ec750b482';

  void signUserOut() async {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Onboard()));
    });
  }

  Future<void> getuserdata() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('HostelStudents')
        .doc(email)
        .collection('StudentIDCard')
        .doc('idcard')
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      setState(() {
        url = userData['Passport Photo'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getuserdata();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(url),
              ),
              decoration: const BoxDecoration(color: Color(0xffE9E3D5)),
              accountName: Text(
                user.displayName!,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                user.email!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ChatScreen()));
              },
              child: listtile(
                "Announcements",
              ),
            ),
            div,
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Complaints(
                              email: email,
                            )));
              },
              child: listtile(
                "Complaints",
              ),
            ),
            div,
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PendingComplaints()));
              },
              child: listtile("Pending Complaints"),
            ),
            div,
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Request()));
              },
              child: listtile("Request"),
            ),
            div,
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FacilitiesPage()));
              },
              child: listtile("Facilities"),
            ),
            div,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HostelAndMess(email: email),
                  ),
                );
              },
              child: listtile("Certificates"),
            ),
            div,
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HolidayList()));
                },
                child: listtile("Holiday List")),
            div,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CommitteePage(),
                  ),
                );
              },
              child: listtile("Committee"),
            ),
            div,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Rectors(),
                  ),
                );
              },
              child: listtile("Rectors"),
            ),
            div,
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AboutUsPage()));
                },
                child: listtile("About VJTI")),
            div,
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => Developers()),
                    ),
                  );
                },
                child: listtile("Developer")),
            div,
            ElevatedButton(
              style: ButtonStyle(
                  side: MaterialStateBorderSide.resolveWith((states) =>
                      BorderSide(color: Colors.red.shade900, width: 2)),
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.red)),
              onPressed: () {
                signUserOut();
              },
              child: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

ListTile listtile(String title) {
  return ListTile(
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 21,
        color: Colors.black87,
        fontFamily: "Nunito",
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
