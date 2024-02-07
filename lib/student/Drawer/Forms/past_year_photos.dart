import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_application_1/main.dart';

class PastYearPhotosPage extends StatefulWidget {
  const PastYearPhotosPage({super.key});

  @override
  State<PastYearPhotosPage> createState() => _PastYearPhotosState();
}

class _PastYearPhotosState extends State<PastYearPhotosPage> {
  // ignore: unused_field
  int _selectedYear = DateTime.now().year;
  String imgURL = "";
  String imgURL1 = "";
  final storage = FirebaseStorage.instance;

  Future<void> getImageURL() async {
    // Get the reference to the image file in Firebase Storage
    try {
      final ref = storage.ref().child('Events/2023/holi.jpg');
      final ref1 = storage.ref().child('Events/2023/diwali.jpg');
      // Get the imageUrl to download URL
      final url = await ref.getDownloadURL();
      final url1 = await ref1.getDownloadURL();

      print(url);
      print(url1);
      setState(() {
        imgURL = url;
        imgURL1 = url1;
      });
    } catch (error) {
      print('Error fetching image URL: $error');
    }
  }


  @override
  void initState() {
    super.initState();

    // Retrieve the image from Firebase Storage
    getImageURL();
  }

  @override
  void dispose() {
    storage.ref().delete(); // Delete the reference, if necessary
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Year Photos",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: _buildYearList(),
        ),
      ),
      body: Column(
        children: [
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
              _selectedYear = year;
            });
            Navigator.pop(context); // Close the drawer
          },
        ),
      );
    }
    return yearList;
  }
}
