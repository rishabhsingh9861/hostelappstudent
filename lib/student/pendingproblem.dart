import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class PendingComplaints extends StatefulWidget {
  const PendingComplaints({Key? key}) : super(key: key);

  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<PendingComplaints> {
  String selectedCategory = 'Electrical';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedCategory,
                items: <String>[
                  'Electrical',
                  'Carpentry',
                  'Plumbing',
                  'Structural',
                  'Cleaning',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Redirect to the corresponding file based on the selected category
                  switch (selectedCategory) {
                    case 'Electrical':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ElectricalComplaints()),
                      );
                      break;
                    case 'Carpentry':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CarpentryComplaints()),
                      );
                      break;
                    case 'Plumbing':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PlumbingComplaints()),
                      );
                      break;
                    case 'Structural':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StructuralComplaints()),
                      );
                      break;
                    case 'Cleaning':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CleaningComplaints()),
                      );
                      break;
                    default:
                    // Handle unknown category
                      break;
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ElectricalComplaints extends StatelessWidget {
  const ElectricalComplaints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electrical Complaints'),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Electical') // Use the determined collection path
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
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              var complaint = complaints[index];
              var complaintData = complaint.data() as Map<String, dynamic>;

              // Extracting fields with null checks
              String photoUrl = complaintData['Photo Url'] ?? '';
              String problemDescription = complaintData['Problem'] ?? '';
              String problemCategory = complaintData['Category'] ?? '';
              String emailId = complaintData['Email'] ?? '';
              String name = complaintData['Name'] ?? '';
              String roomNo = complaintData['Room Number'] ?? '';
              int contactNumber = complaintData['Contact Number'] ?? 0;
              Timestamp time = complaintData['Time'] ?? Timestamp.now();
              bool isComplete = complaintData['Status'] == 'Solved';
              String formattedDate = DateFormat.yMMMd().add_jms().format(time.toDate());

              // return Text('Formatted Timestamp: $formattedDate');

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
                      // Text('Problem: $problemDescription'),
                      // Text('Category: $problemCategory'),
                      // Text('Email: $emailId'),
                      Text('Room No: $roomNo'),
                      // Text('Contact Number: $contactNumber'),
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
                      Radio(
                        value: true,
                        groupValue: isComplete,
                        onChanged: (bool? value) async {
                          // Handle radio button change
                          // Update the complaint status in Firestore
                          await FirebaseFirestore.instance
                              .collection('Electical') // Use the determined collection path
                          // .doc(email)
                          // .collection('pending')
                              .doc(complaint.id)
                              .update({
                            'Status': 'Solved',
                            'SolvedTimestamp': FieldValue.serverTimestamp(),});
                          complaintData['Status'] = 'Solved';
                          complaintData['SolvedTimestamp'] = FieldValue.serverTimestamp();
                          // Copy the document to 'Solved Electrical' collection
                          await FirebaseFirestore.instance
                              .collection('Solved Electrical') // Use the determined collection path
                          // .doc(email)
                          // .collection('History')
                              .add(complaintData);

                          // Delete the document from 'Electical' collection
                          await FirebaseFirestore.instance
                              .collection('Electical') // Use the determined collection path
                          // .doc(email)
                          // .collection('pending')
                              .doc(complaint.id)
                              .delete();
                        },
                      ),
                      Text('Solved'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
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
class CarpentryComplaints extends StatelessWidget {
  const CarpentryComplaints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carpentry Complaints'),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Carpentry') // Use the determined collection path
        // .doc(email)
        // .collection('pending')
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
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              var complaint = complaints[index];
              var complaintData = complaint.data() as Map<String, dynamic>;

              // Extracting fields with null checks
              String photoUrl = complaintData['Photo Url'] ?? '';
              String problemDescription = complaintData['Problem'] ?? '';
              String problemCategory = complaintData['Category'] ?? '';
              String emailId = complaintData['Email'] ?? '';
              String name = complaintData['Name'] ?? '';
              String roomNo = complaintData['Room Number'] ?? '';
              int contactNumber = complaintData['Contact Number'] ?? 0;
              Timestamp time = complaintData['Time'] ?? Timestamp.now();
              bool isComplete = complaintData['Status'] == 'Solved';
              String formattedDate = DateFormat.yMMMd().add_jms().format(time.toDate());

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
                      // Text('Problem: $problemDescription'),
                      // Text('Category: $problemCategory'),
                      // Text('Email: $emailId'),
                      Text('Room No: $roomNo'),
                      // Text('Contact Number: $contactNumber'),
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
                      Radio(
                        value: true,
                        groupValue: isComplete,
                        onChanged: (bool? value) async {
                          // Handle radio button change
                          // Update the complaint status in Firestore
                          await FirebaseFirestore.instance
                              .collection('Carpentry') // Use the determined collection path
                          // .doc(email)
                          // .collection('pending')
                              .doc(complaint.id)
                              .update({
                            'Status': 'Solved',
                            'SolvedTimestamp': FieldValue.serverTimestamp(),});
                          complaintData['Status'] = 'Solved';
                          complaintData['SolvedTimestamp'] = FieldValue.serverTimestamp();
                          // Copy the document to 'Solved Electrical' collection
                          await FirebaseFirestore.instance
                              .collection('Solved Carpentry') // Use the determined collection path
                          // .doc(email)
                          // .collection('History')
                              .add(complaintData);

                          // Delete the document from 'Electical' collection
                          await FirebaseFirestore.instance
                              .collection('Carpentry') // Use the determined collection path
                          // .doc(email)
                          // .collection('pending')
                              .doc(complaint.id)
                              .delete();
                        },
                      ),
                      Text('Solved'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PlumbingComplaints extends StatelessWidget {
  const PlumbingComplaints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plumbing Complaints'),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Plumbing') // Use the determined collection path
        // .doc(email)
        // .collection('pending')
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
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              var complaint = complaints[index];
              var complaintData = complaint.data() as Map<String, dynamic>;

              // Extracting fields with null checks
              String photoUrl = complaintData['Photo Url'] ?? '';
              String problemDescription = complaintData['Problem'] ?? '';
              String problemCategory = complaintData['Category'] ?? '';
              String emailId = complaintData['Email'] ?? '';
              String name = complaintData['Name'] ?? '';
              String roomNo = complaintData['Room Number'] ?? '';
              int contactNumber = complaintData['Contact Number'] ?? 0;
              Timestamp time = complaintData['Time'] ?? Timestamp.now();
              bool isComplete = complaintData['Status'] == 'Solved';
              String formattedDate = DateFormat.yMMMd().add_jms().format(time.toDate());

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
                      // Text('Problem: $problemDescription'),
                      // Text('Category: $problemCategory'),
                      // Text('Email: $emailId'),
                      Text('Room No: $roomNo'),
                      // Text('Contact Number: $contactNumber'),
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
                      Radio(
                        value: true,
                        groupValue: isComplete,
                        onChanged: (bool? value) async {
                          // Handle radio button change
                          // Update the complaint status in Firestore
                          await FirebaseFirestore.instance
                              .collection('Plumbing') // Use the determined collection path
                          // .doc(email)
                          // .collection('pending')
                              .doc(complaint.id)
                              .update({
                            'Status': 'Solved',
                            'SolvedTimestamp': FieldValue.serverTimestamp(),});
                          complaintData['Status'] = 'Solved';
                          complaintData['SolvedTimestamp'] = FieldValue.serverTimestamp();
                          // Copy the document to 'Solved Electrical' collection
                          await FirebaseFirestore.instance
                              .collection('Solved Plumbing') // Use the determined collection path
                          // .doc(email)
                          // .collection('History')
                              .add(complaintData);

                          // Delete the document from 'Electical' collection
                          await FirebaseFirestore.instance
                              .collection('Plumbing') // Use the determined collection path
                          // .doc(email)
                          // .collection('pending')
                              .doc(complaint.id)
                              .delete();
                        },
                      ),
                      Text('Solved'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class StructuralComplaints extends StatelessWidget {
  const StructuralComplaints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Structural Complaints'),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Structural') // Use the determined collection path
        // .doc(email)
        // .collection('pending')
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
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              var complaint = complaints[index];
              var complaintData = complaint.data() as Map<String, dynamic>;

              // Extracting fields with null checks
              String photoUrl = complaintData['Photo Url'] ?? '';
              String problemDescription = complaintData['Problem'] ?? '';
              String problemCategory = complaintData['Category'] ?? '';
              String emailId = complaintData['Email'] ?? '';
              String name = complaintData['Name'] ?? '';
              String roomNo = complaintData['Room Number'] ?? '';
              int contactNumber = complaintData['Contact Number'] ?? 0;
              Timestamp time = complaintData['Time'] ?? Timestamp.now();
              bool isComplete = complaintData['Status'] == 'Solved';
              String formattedDate = DateFormat.yMMMd().add_jms().format(time.toDate());

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
                      // Text('Problem: $problemDescription'),
                      // Text('Category: $problemCategory'),
                      // Text('Email: $emailId'),
                      Text('Room No: $roomNo'),
                      // Text('Contact Number: $contactNumber'),
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
                      Radio(
                        value: true,
                        groupValue: isComplete,
                        onChanged: (bool? value) async {
                          // Handle radio button change
                          // Update the complaint status in Firestore
                          await FirebaseFirestore.instance
                              .collection('Structural') // Use the determined collection path
                          // .doc(email)
                          // .collection('pending')
                              .doc(complaint.id)
                              .update({
                            'Status': 'Solved',
                            'SolvedTimestamp': FieldValue.serverTimestamp(),});
                          complaintData['Status'] = 'Solved';
                          complaintData['SolvedTimestamp'] = FieldValue.serverTimestamp();
                          // Copy the document to 'Solved Electrical' collection
                          await FirebaseFirestore.instance
                              .collection('Solved Structural') // Use the determined collection path
                          // .doc(email)
                          // .collection('History')
                              .add(complaintData);

                          // Delete the document from 'Electical' collection
                          await FirebaseFirestore.instance
                              .collection('Structural') // Use the determined collection path
                          // .doc(email)
                          // .collection('pending')
                              .doc(complaint.id)
                              .delete();
                        },
                      ),
                      Text('Solved'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CleaningComplaints extends StatelessWidget {
  const CleaningComplaints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleaning Complaints'),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Cleaning') // Use the determined collection path
        // .doc(email)
        // .collection('pending')
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
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              var complaint = complaints[index];
              var complaintData = complaint.data() as Map<String, dynamic>;

              // Extracting fields with null checks
              String photoUrl = complaintData['Photo Url'] ?? '';
              String problemDescription = complaintData['Problem'] ?? '';
              String problemCategory = complaintData['Category'] ?? '';
              String emailId = complaintData['Email'] ?? '';
              String name = complaintData['Name'] ?? '';
              String roomNo = complaintData['Room Number'] ?? '';
              int contactNumber = complaintData['Contact Number'] ?? 0;
              Timestamp time = complaintData['Time'] ?? Timestamp.now();
              bool isComplete = complaintData['Status'] == 'Solved';
              String formattedDate = DateFormat.yMMMd().add_jms().format(time.toDate());

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
                      // Text('Problem: $problemDescription'),
                      // Text('Category: $problemCategory'),
                      // Text('Email: $emailId'),
                      Text('Room No: $roomNo'),
                      // Text('Contact Number: $contactNumber'),
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
                      Radio(
                        value: true,
                        groupValue: isComplete,
                        onChanged: (bool? value) async {
                          // Handle radio button change
                          // Update the complaint status in Firestore
                          await FirebaseFirestore.instance
                              .collection('Cleaning') // Use the determined collection path
                          // .doc(email)
                          // .collection('pending')
                              .doc(complaint.id)
                              .update({
                            'Status': 'Solved',
                            'SolvedTimestamp': FieldValue.serverTimestamp(),});
                          complaintData['Status'] = 'Solved';
                          complaintData['SolvedTimestamp'] = FieldValue.serverTimestamp();
                          // Copy the document to 'Solved Electrical' collection
                          await FirebaseFirestore.instance
                              .collection('Solved Cleaning') // Use the determined collection path
                          // .doc(email)
                          // .collection('History')
                              .add(complaintData);

                          // Delete the document from 'Electical' collection
                          await FirebaseFirestore.instance
                              .collection('Cleaning') // Use the determined collection path
                          // .doc(email)
                          // .collection('pending')
                              .doc(complaint.id)
                              .delete();
                        },
                      ),
                      Text('Solved'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
