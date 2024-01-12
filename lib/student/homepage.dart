// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vjtihostel/onboard.dart';
import 'package:vjtihostel/student/complaints.dart';
import 'package:vjtihostel/student/genrateid.dart';
import 'package:vjtihostel/student/pendingcomplaints.dart';
import 'package:vjtihostel/student/rectors.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
          centerTitle: true,
          title: const Text(
            'VJTI HOSTEL',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const GenerateId()));
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
            child: listtile("Request"),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: listtile("Facilities"),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 30, 10),
            child: listtile("Certificates"),
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
            child: listtile("Committee"),
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
