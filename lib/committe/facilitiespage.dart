// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FacilitiesPage extends StatefulWidget {
  const FacilitiesPage({super.key});

  @override
  _FacilitiesPageState createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage> {
  List<String> docIDs = [];

  Future<void> getDocId() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Facilities').get();

    docIDs = snapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff90AAD6),
        centerTitle: true,
        title: const Text(
          "Facilities",
          style: TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder(
                  future: getDocId(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: const Color.fromARGB(255, 196, 220, 240),
                            elevation: 8,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              trailing: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FacilitiesList(
                                        facilitiesID: docIDs[index],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  CupertinoIcons.chevron_forward,
                                ),
                              ),
                              title: Text(
                                docIDs[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: "Nunito",
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FacilitiesList extends StatelessWidget {
  final String facilitiesID;

  const FacilitiesList({super.key, required this.facilitiesID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(facilitiesID),
      //   backgroundColor: const Color.fromRGBO(
      //       255, 255, 255, 1), // Use a professional color for the app bar
      // ),
      appBar: AppBar(
        backgroundColor: const Color(0xff90AAD6),
        centerTitle: true,
        title: Text(
          facilitiesID,
          style: const TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: getFacilities(facilitiesID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Photo> photos = snapshot.data as List<Photo>;
              return ListView.builder(
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  Photo photo = photos[index];
                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255,
                            1), // Set the desired background color
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2), // Add a subtle shadow
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              photo.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black87,
                                  fontFamily: "Nunito" // Use a dark text color
                                  ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors
                                    .black, // Use a light background color
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  photo.photoUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              photo.description,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                // Use a subdued text color
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Photo>> getFacilities(String facilitiesID) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Facilities')
        .doc(facilitiesID)
        .collection('Photos')
        .orderBy('position')
        .get();

    List<Photo> photos = snapshot.docs
        .map((doc) => Photo.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return photos;
  }
}

class Photo {
  final String name;
  final String description;
  final String photoUrl;

  Photo({
    required this.name,
    required this.description,
    required this.photoUrl,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }
}
