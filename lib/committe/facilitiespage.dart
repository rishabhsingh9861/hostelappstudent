// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FacilitiesPage extends StatefulWidget {
  const FacilitiesPage({Key? key}) : super(key: key);

  @override
  _FacilitiesPageState createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage> {
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
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('Facilities').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final List<DocumentSnapshot> docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final String facilitiesName = doc['name'] as String;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FacilitiesList(
                              facilitiesID: doc.id,
                              facilitiesname: facilitiesName,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: const Color.fromARGB(255, 196, 220, 240),
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          trailing: const Icon(
                            CupertinoIcons.chevron_forward,
                          ),
                          title: Text(
                            facilitiesName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: "Nunito",
                            ),
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
      ),
    );
  }
}

class FacilitiesList extends StatelessWidget {
  final String facilitiesID;
  final String facilitiesname;

  const FacilitiesList({
    Key? key,
    required this.facilitiesID,
    required this.facilitiesname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff90AAD6),
        centerTitle: true,
        title: Text(
          facilitiesname,
          style: const TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('Facilities')
              .doc(facilitiesID)
              .collection('Photos')
              .orderBy('position')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final List<DocumentSnapshot> docs = snapshot.data!.docs;
              final List<Photo> photos = docs.map((doc) => Photo.fromMap(doc.data() as Map<String, dynamic>)).toList();

              return ListView.builder(
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
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
                                fontFamily: "Nunito",
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.black,
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
