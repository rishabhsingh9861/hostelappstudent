// ignore_for_file: empty_catches

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core

class PastYearPhotosPage extends StatefulWidget {
  const PastYearPhotosPage({Key? key}) : super(key: key);

  @override
  State<PastYearPhotosPage> createState() => _PastYearPhotosState();
}

class _PastYearPhotosState extends State<PastYearPhotosPage> {
  String imgURL = "";
  String imgURL1 = "";
  final storage = FirebaseStorage.instance;

  Future<void> getImageURL() async {
    try {
      final ref = storage.ref().child('Events/2023/holi.jpg');
      final ref1 = storage.ref().child('Events/2023/diwali.jpg');
      final url = await ref.getDownloadURL();
      final url1 = await ref1.getDownloadURL();

      setState(() {
        imgURL = url;
        imgURL1 = url1;
      });
    } catch (error) {
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize Firebase if not initialized yet
    if (Firebase.apps.isEmpty) {
      Firebase.initializeApp();
    }
    getImageURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Past Year Photos",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: "Nunito",
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 176, 189, 211),
      ),
      drawer: Drawer(
        child: ListView(
          children: _buildYearList(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 300,
            child: Image(
              image: NetworkImage(imgURL),
              fit: BoxFit.cover,
            ),
          ),
          Card(
            child: SizedBox(
              height: 300,
              child: Image(
                image: NetworkImage(imgURL1),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildYearList() {
    List<Widget> yearList = [];
    for (int year = (DateTime.now().year - 1);
        year >= (DateTime.now().year - 6);
        year--) {
      yearList.add(
        ListTile(
          title: Text(year.toString()),
          onTap: () {
            setState(() {
            });
            Navigator.pop(context);
          },
        ),
      );
    }
    return yearList;
  }
}
