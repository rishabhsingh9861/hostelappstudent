// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommitteePage extends StatefulWidget {
  const CommitteePage({Key? key}) : super(key: key);

  @override
  _CommitteePageState createState() => _CommitteePageState();
}

class _CommitteePageState extends State<CommitteePage> {
  List<String> docIDs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Committee'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder(
                  future:
                      FirebaseFirestore.instance.collection('Committee').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          String reqId = snapshot.data!.docs[index].id;
                          docIDs.add(reqId);

                          final reqData = snapshot.data!.docs[index].data();

                          String committename = reqData['Name'] as String;

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                committename,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {
                                // Handle the tap event
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MembersPage(
                                      committeeId: docIDs[index],
                                      committeename: committename,
                                    ),
                                  ),
                                );
                              },
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

class MembersPage extends StatelessWidget {
  final String committeeId;
  final String committeename;

  const MembersPage({
    Key? key,
    required this.committeeId,
    required this.committeename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(committeename),
      ),
      body: Center(
        child: FutureBuilder(
          future: getMembers(committeeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Member> members = snapshot.data as List<Member>;
              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  Member member = members[index];
                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align content to the start
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(member.photoUrl, scale: 1),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    member.designation,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 350,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            final email = member.email;
                                            final gmail = 'mailto:$email';
                                            if (await launchUrlString(gmail)) {
                                              await canLaunchUrlString(gmail);
                                            }
                                          },
                                          child: Image.asset(
                                              'assets/images/gmailicon.png'),
                                        ),
                                        const SizedBox(
                                          width: 100,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            final phoneNumber =
                                                member.phoneNumber;
                                            final call = 'tel:$phoneNumber';
                                            if (!await launchUrlString(call)) {
                                              await canLaunchUrlString(call);
                                            }
                                          },
                                          child: Image.asset(
                                              'assets/images/phoneicon.png'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.all(16),
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

  Future<List<Member>> getMembers(String committeeId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Committee')
        .doc(committeeId)
        .collection('Members')
        .orderBy('Position')
        .get();

    List<Member> members = snapshot.docs
        .map((doc) => Member.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return members;
  }
}

class Member {
  final String name;
  final String designation;
  final String phoneNumber;
  final String photoUrl;
  final String email;

  Member({
    required this.name,
    required this.designation,
    required this.phoneNumber,
    required this.photoUrl,
    required this.email,
  });

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      name: map['Name'] ?? '',
      designation: map['Designation'] ?? '',
      phoneNumber: map['Phone Number'] ?? '',
      photoUrl: map['Photo Url'] ?? '',
      email: map['Email'] ?? '',
    );
  }
}
