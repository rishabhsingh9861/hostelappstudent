// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:vjtihostel/student/constant/const.dart';

class PendingComplaints extends StatefulWidget {
  const PendingComplaints({Key? key}) : super(key: key);

  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<PendingComplaints> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbars('Pending Complaints'),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                for (String category in [
                  'Electrical',
                  'Carpentry',
                  'Plumbing',
                  'Structural',
                  'Housekeeping',
                ])
                  ComplaintCategoryCard(
                    category: category,
                    isSelected: selectedCategory == category,
                    onTap: () {
                      // Navigate to the corresponding page directly
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ComplaintCategory(
                            category: category,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ComplaintCategoryCard extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const ComplaintCategoryCard({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.grey[400],
      ),
      child: ListTile(
        title: Text(category),
        onTap: onTap,
      ),
    );
  }
}

class ComplaintCategory extends StatefulWidget {
  final String category;

  const ComplaintCategory({Key? key, required this.category}) : super(key: key);

  @override
  _ComplaintCategoryState createState() => _ComplaintCategoryState();
}

class _ComplaintCategoryState extends State<ComplaintCategory> {
  late List<bool> isCompleteList;

  @override
  void initState() {
    super.initState();
    isCompleteList = List.filled(0, false);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('${widget.category} Complaints'),
      // ),
      appBar: appbars('${widget.category} Complaints'),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(widget.category)
            .where('Email', isEqualTo: email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Extracting data from the snapshot
          var complaints = snapshot.data!.docs;

          if (isCompleteList.length != complaints.length) {
            // Initialize isCompleteList based on the length of complaints
            isCompleteList = List.filled(complaints.length, false);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    var sortedComplaints = List.from(complaints);
                    sortedComplaints.sort((a, b) {
                      Timestamp timestampA = a['Time'];
                      Timestamp timestampB = b['Time'];
                      return timestampB
                          .compareTo(timestampA); // Descending order
                    });

                    var complaint = sortedComplaints[index];
                    var complaintData =
                        complaint.data() as Map<String, dynamic>;

                    // Extracting fields with null checks
                    String photoUrl = complaintData['Photo Url'] ?? '';
                    String problemDescription = complaintData['Problem'] ?? '';
                    String roomNo = complaintData['Room Number'] ?? '';
                    Timestamp time = complaintData['Time'] ?? Timestamp.now();
                    bool isComplete = complaintData['Status'] == 'Solved';
                    String formattedDate =
                        DateFormat.yMMMd().add_jms().format(time.toDate());

                    return isComplete
                        ? Container() // If status is complete, don't display the complaint
                        : Card(
                            elevation: 3.0,
                            margin: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text('Problem: $problemDescription'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Room No: $roomNo'),
                                      Text('Timestamp: $formattedDate'),
                                    ],
                                  ),
                                  leading: GestureDetector(
                                    onTap: () {
                                      _showFullImage(context, photoUrl);
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(photoUrl),
                                    ),
                                  ),
                                  trailing: Column(
                                    children: [
                                      Checkbox(
                                        value: isCompleteList[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isCompleteList[index] =
                                                value ?? false;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _submitComplaintStatus(
                                        context, widget.category, [complaint]);
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                          );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }

  void _submitComplaintStatus(BuildContext context, String category,
      List<QueryDocumentSnapshot> complaints) async {
    for (int i = 0; i < complaints.length; i++) {
      if (isCompleteList[i]) {
        var complaint = complaints[i];
        var complaintData = complaint.data() as Map<String, dynamic>;

        // Update the complaint status in Firestore
        await FirebaseFirestore.instance
            .collection(category)
            .doc(complaint.id)
            .update({
          'Status': 'Solved',
          'SolvedTimestamp': FieldValue.serverTimestamp(),
        });

        complaintData['Status'] = 'Solved';
        complaintData['SolvedTimestamp'] = FieldValue.serverTimestamp();

        // Copy the document to 'Solved $category' collection
        await FirebaseFirestore.instance
            .collection('Solved $category')
            .add(complaintData);

        // Delete the document from '$category' collection
        await FirebaseFirestore.instance
            .collection(category)
            .doc(complaint.id)
            .delete();
      }
    }
  }
}
