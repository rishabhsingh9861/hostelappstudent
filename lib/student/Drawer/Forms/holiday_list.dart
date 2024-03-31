// ignore_for_file: use_key_in_widget_constructors

// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:vjtihostel/student/constant/const.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Holiday Events',
//       showSemanticsDebugger: false,
//       home: HolidayList(),
//     );
//   }
// }

class HolidayList extends StatelessWidget {
  const HolidayList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     '2024 Holiday List',
      //     style: TextStyle(
      //         color: Colors.black,
      //         fontSize: 20,
      //         fontFamily: "Nunito",
      //         fontWeight: FontWeight.bold),
      //   ),
      //   backgroundColor: const Color.fromARGB(255, 176, 189, 211),
      //   elevation: 50,
      // ),
      appBar: appbars("Holiday List"),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       ListTile(
      //         title: const Text('Calendar'),
      //         onTap: () {
      //           Navigator.pop(context); // Close the drawer
      //         },
      //       ),
      //       InkWell(
      //         onTap: () {
      //           // print('hello');
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => const PastYearPhotosPage()),
      //           );
      //         },
      //         child: Container(
      //           child: ListTile(
      //             title: const Text('Past Year Photos'),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Events')
            .orderBy('eventDate')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // Check if the data is null before accessing it
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No data available'),
            );
          }

          List<DocumentSnapshot<Map<String, dynamic>>> documents =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              String eventName = documents[index]['eventName'];
              Timestamp eventDate = documents[index]['eventDate'];
                  DateTime dateTime = eventDate.toDate();
                String formattedTime = DateFormat.yMd().format(dateTime);

              // Convert timestamp to DateTime
              // DateTime date = eventDate.toDate();

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[100],
                ),
                margin: const EdgeInsets.all(5),
                child: ListTile(
                  title: Text(eventName),
                  subtitle: Text('Date: $formattedTime'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
