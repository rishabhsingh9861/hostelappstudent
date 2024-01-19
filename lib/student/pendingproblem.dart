// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vjtihostel/button.dart';
import 'package:vjtihostel/student/constant/const.dart';

class PendingComplaints extends StatefulWidget {
  const PendingComplaints({super.key});

  @override
  State<PendingComplaints> createState() => _PendingComplaintsState();
}

class _PendingComplaintsState extends State<PendingComplaints> {
  Set<String> selectedComplaints = {};
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
   
    List problemids = [];
    String problemCategory = '';
    String roomNo = '';
    String issue = '';
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();

    Future<void> deletesolvedProblem(String probid) async {
      FirebaseFirestore.instance
          .collection('HostelStudents')
          .doc(email)
          .collection('Complaints')
          .doc(probid)
          .delete();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('HostelStudents')
          .doc(email)
          .collection('Complaints')
          .orderBy('Time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: appbars('Pending Complaints'),
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String probid = snapshot.data!.docs[index].id;
                problemids.add(probid);
                final problem =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                problemCategory = '${problem['Category']}';
                roomNo = '${problem['Room No.']}';
                issue = '${problem['Problem']}';

                Timestamp timestamp = problem['Time'];
                DateTime dateTime = timestamp.toDate();
                String formattedTime = DateFormat.yMd().format(dateTime);

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    height: 350,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: const Color.fromARGB(255, 76, 158, 175),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Category:   $problemCategory",
                          style: textsty,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Date: $formattedTime",
                          style: textsty,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Room No. : $roomNo",
                          style: textsty,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Problem : $issue",
                          style: textsty,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              value: selectedComplaints
                                  .contains(problemids[index]),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value!) {
                                    selectedComplaints.add(problemids[index]);
                                  } else {
                                    selectedComplaints
                                        .remove(problemids[index]);
                                  }
                                });
                              },
                            ),
                            const Text(
                              'Submit when only this complaint is resolved',
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            if (selectedComplaints
                                .contains(problemids[index])) {
                              deletesolvedProblem(problemids[index]).then(
                                (value) => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: Text('Complaint Solved'),
                                    );
                                  },
                                ).then((value) => {Navigator.pop(context)}),
                              );
                            } else {
                              // Display a message that no complaint is selected
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Select a complaint first.'),
                                  );
                                },
                              );
                            }
                          },
                          child: const Button(
                            txt: 'Solved',
                            textcolor: Colors.black,
                            leftcolor: Color(0xFFafcdfb),
                            rightcolor: Color(0xFFa4c6fb),
                            highlighcolor: Color(0xFF91bafb),
                            fontsize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
