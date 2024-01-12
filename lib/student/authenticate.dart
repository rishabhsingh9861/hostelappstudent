
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vjtihostel/onboard.dart';
import 'package:vjtihostel/student/homepage.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
 
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    String email = '';
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final User? user = snapshot.data;
          if (user != null) {
            email = user.email.toString();
          }

          return  HomePage( );
        } else {
          return const Onboard();
        }
      },
    ));
  }
}