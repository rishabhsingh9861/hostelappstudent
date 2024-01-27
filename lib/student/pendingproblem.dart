import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vjtihostel/student/constant/const.dart';

// new....
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
      appBar: AppBar(
        title: const Text('Pending Complaints'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: <Widget>[
                  for (String category in [
                    'Electrical',
                    'Carpentry',
                    'Plumbing',
                    'Structural',
                    'Cleaning',
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
            ],
          ),
        ),
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
    return Card(
      color: isSelected ? Colors.blue : null,
      child: ListTile(
        title: Text(category),
        onTap: onTap,
      ),
    );
  }
}

// final user = FirebaseAuth.instance.currentUser!;
// String email = user.email.toString();

class ComplaintCategory extends StatelessWidget {
  final String category;

  const ComplaintCategory({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Complaints'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(category)
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

          return ListView.builder(
            shrinkWrap: true,
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              var complaint = complaints[index];
              var complaintData = complaint.data() as Map<String, dynamic>;

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
                      child: ListTile(
                        title: Text('Problem: $problemDescription'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Room No: $roomNo'),
                            Text('Timestamp: $formattedDate'),
                            SizedBox(height: 10,),
                            Radio(
                              value: true,
                              groupValue: isComplete,
                              onChanged: (bool? value) async {
                                await FirebaseFirestore.instance
                                    .collection(category)
                                    .doc(complaint.id)
                                    .update({
                                  'Status': 'Solved',
                                  'SolvedTimestamp':
                                      FieldValue.serverTimestamp(),
                                });
                                complaintData['Status'] = 'Solved';
                                complaintData['SolvedTimestamp'] =
                                    FieldValue.serverTimestamp();
                                // Copy the document to 'Solved $category' collection
                                await FirebaseFirestore.instance
                                    .collection(
                                        'Solved $category') // Use the determined collection path
                                    .add(complaintData);

                                // Delete the document from '$category' collection
                                await FirebaseFirestore.instance
                                    .collection(
                                        category) // Use the determined collection path
                                    .doc(complaint.id)
                                    .delete();
                              },
                            ),
                            Text(
                              'Solved',
                              style: textsty,
                            )
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
                      ));
            },
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
            padding: EdgeInsets.all(16.0),
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }
}

class ComplaintCard extends StatelessWidget {
  final String name;
  final String problemDescription;
  final String problemCategory;
  final String emailId;
  final String roomNo;
  final int contactNumber;
  final String formattedDate;
  final String photoUrl;
  final VoidCallback onImageTap;

  const ComplaintCard({
    Key? key,
    required this.name,
    required this.problemDescription,
    required this.problemCategory,
    required this.emailId,
    required this.roomNo,
    required this.contactNumber,
    required this.formattedDate,
    required this.photoUrl,
    required this.onImageTap,
  }) : super(key: key);
//new
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('Name: $name'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Problem: $problemDescription'),
            Text('Category: $problemCategory'),
            Text('Email: $emailId'),
            Text('Room No: $roomNo'),
            Text('Contact Number: $contactNumber'),
            Text('Timestamp: $formattedDate'),
          ],
        ),
        leading: GestureDetector(
          onTap: onImageTap,
          child: CircleAvatar(
            backgroundImage: NetworkImage(photoUrl),
          ),
        ),
      ),
    );
  }
}

class ComplaintListItem extends StatelessWidget {
  final String title;
  final String value;

  const ComplaintListItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('$title: $value');
  }
}

bool isComplaintComplete(Map<String, dynamic> complaintData) {
  return complaintData['Status'] == 'Solved';
}
