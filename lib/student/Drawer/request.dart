// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vjtihostel/student/Drawer/Forms/leaves.dart';
import 'package:vjtihostel/student/Drawer/Forms/room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vjtihostel/student/constant/const.dart';

class Request extends StatelessWidget {
  const Request({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color(0xff90AAD6),
      //   title: const Text("Request"),
      //   centerTitle: true,
      //   foregroundColor: Colors.black,
      // ),
      appBar: appbars("Request"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Requestcontainer(
                    Requestname: "Leave Request",
                    image: "leaverequest.png",
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaveRequestPage(),
                        ),
                      );
                    },
                  ),
                  Requestcontainer(
                    Requestname: "Room Vacant",
                    image: "roomchange.png",
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomChange(email: email),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container Requestcontainer(
      {required String Requestname,
      required String image,
      required VoidCallback? function}) {
    return Container(
      // margin: const EdgeInsets.all(5),
      height: 280,
      width: 180,
      decoration: BoxDecoration(
        color: const Color.fromARGB(95, 189, 185, 185),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(top: 10),
            height: 150,
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset("assets/images/$image"),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            Requestname,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            style: ButtonStyle(
                side: MaterialStateBorderSide.resolveWith(
                    (states) => const BorderSide(color: Colors.black, width: 2)),
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.grey)),
            onPressed: function,
            child: const Text(
              "SEND",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
