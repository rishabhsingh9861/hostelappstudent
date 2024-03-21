// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vjtihostel/backgroundimage.dart';
import 'package:vjtihostel/button.dart';
import 'package:vjtihostel/student/homepage.dart';
import 'package:vjtihostel/student/studentdata.dart';

class Vjtilogin extends StatefulWidget {
  const Vjtilogin({super.key});

  @override
  State<Vjtilogin> createState() => _VjtiloginState();
}

class _VjtiloginState extends State<Vjtilogin> {
  voidCallbackAction() {}

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); // clear authentication cache
    setState(() {
      _isSigningIn = true;
    });

    try {
      final GoogleSignInAccount? guser = await googleSignIn.signIn();

      if (guser == null) {
        // User canceled the sign-in process
        //   print("Sign-in process canceled");
        return;
      }

      final String email = guser.email;
      // print("User email: $email");

      if (email.endsWith('vjti.ac.in')) {
        final GoogleSignInAuthentication gauth = await guser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: gauth.accessToken,
          idToken: gauth.idToken,
        );

        // Check if the user is still signed in before accessing the user data
        //   if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signInWithCredential(credential);

        await fetchUsernames();
        // print("Fetched usernames: $userList");

        // Wait for data to be fetched
        if (userList.any((user) => user['id'] == email)) {
          // User email found in the database, navigate to HomePage
          //   print("User email found in the database, navigating to HomePage");
          // ignore: use_build_context_synchronously
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        } else {
          // User email not found in the database, navigate to StudentData
          // print(   "User email not found in the database, navigating to StudentData");
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => StudentData(
                email: email,
              ),
            ),
          );
        }
        // }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Please Select Vjti email id"),
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.toString()),
          );
        },
      );
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  bool _isSigningIn = false;

  List userList = [];

  Future<void> fetchUsernames() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection("HostelStudents");

      QuerySnapshot querySnapshot = await users.get();

      setState(() {
        userList = querySnapshot.docs.map((DocumentSnapshot document) {
          return {'id': document.id};
        }).toList();
      });
    } catch (e) {
      //  print("Error fetching usernames: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BackgrounImage(
          assetimage: const AssetImage("assets/images/VjtiPG.jpg"),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: _isSigningIn
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Show circular progress indicator
                      : ElevatedButton(
                          style: ButtonStyle(
                              side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                      width: 3, color: Colors.black)),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => const Color.fromARGB(
                                      255, 114, 113, 113))),
                          onPressed: () {
                            signInWithGoogle();
                          },
                          child: const Text(
                            "Login With VJTI Email Id",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
