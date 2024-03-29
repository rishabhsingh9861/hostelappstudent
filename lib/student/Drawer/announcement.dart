import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vjtihostel/student/constant/const.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Announcements'),
      // ),
      appBar: appbars("ANNOUNCEMENTS"),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('notices').snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (ctx, index) {
                    final document = documents[index].data() as Map<String,
                        dynamic>?; // Cast to Map<String, dynamic>?
                    final userName = document?['userName'] as String?;
                    final message = document?['text'] as String?;
                    final imageUrl = document?['imageUrl'] as String?;
                    final pdfUrl = document?['pdfUrl'] as String?;
                    return MessageBubble(
                      sender: userName,
                      text: message,
                      image: imageUrl,
                      pdf: pdfUrl,
                      isMe: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.image,
    required this.pdf,
  });
  final String? text;
  final String? sender;
  final String? image;
  final String? pdf;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null || pdf != null)
            if (image != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 4, color: Color.fromARGB(255, 78, 78, 78)),
                  color: isMe
                      ? const Color.fromARGB(255, 78, 78, 78)
                      : Colors.grey,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                height: 300,
                width: 300,
                child: image != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        child: Image.network(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.picture_as_pdf), // Placeholder for PDF icon
              )
            else
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PdfViewer(pdfUrl: pdf!)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 5, color: Colors.black),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                    color: Colors.black12,
                  ),
                  height: 100,
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PDF',
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.picture_as_pdf)
                    ],
                  ),
                ),
              )
          // Container(
          //   height: 200,
          //   width: 300,
          //   decoration: BoxDecoration(
          //     color: isMe
          //         ? const Color.fromARGB(255, 78, 78, 78)
          //         : Colors.grey,
          //     borderRadius: isMe
          //         ? const BorderRadius.only(
          //             topLeft: Radius.circular(40),
          //             bottomLeft: Radius.circular(40),
          //             bottomRight: Radius.circular(40))
          //         : const BorderRadius.only(
          //             topRight: Radius.circular(40),
          //             bottomLeft: Radius.circular(40),
          //             bottomRight: Radius.circular(40),
          //           ),
          //   ),
          //   child: ClipRRect(
          //       borderRadius: isMe
          //           ? const BorderRadius.only(
          //               topLeft: Radius.circular(40),
          //               bottomLeft: Radius.circular(40),
          //               bottomRight: Radius.circular(40))
          //           : const BorderRadius.only(
          //               topRight: Radius.circular(40),
          //               bottomLeft: Radius.circular(40),
          //               bottomRight: Radius.circular(40),
          //             ),
          //       child: PdfViewer(pdfUrl: pdf!),),
          // )
          else
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade600, width: 3),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.grey[400],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$text ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          Text('$sender'),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.image,
    required this.pdf,
  });
  final String? text;
  final String? sender;
  final String? image;
  final String? pdf;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null || pdf != null)
            if (image != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 4, color: Color.fromARGB(255, 78, 78, 78)),
                  color: isMe
                      ? const Color.fromARGB(255, 78, 78, 78)
                      : Colors.grey,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                height: 200,
                width: 200,
                child: image != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        child: Image.network(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.picture_as_pdf), // Placeholder for PDF icon
              )
            else
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.black),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  color: Colors.black12,
                ),
                height: 200,
                width: 300,
                child: Center(child: Text("PDF Baki hai")),
              )
          // Container(
          //   height: 200,
          //   width: 300,
          //   decoration: BoxDecoration(
          //     color: isMe
          //         ? const Color.fromARGB(255, 78, 78, 78)
          //         : Colors.grey,
          //     borderRadius: isMe
          //         ? const BorderRadius.only(
          //             topLeft: Radius.circular(40),
          //             bottomLeft: Radius.circular(40),
          //             bottomRight: Radius.circular(40))
          //         : const BorderRadius.only(
          //             topRight: Radius.circular(40),
          //             bottomLeft: Radius.circular(40),
          //             bottomRight: Radius.circular(40),
          //           ),
          //   ),
          //   child: ClipRRect(
          //       borderRadius: isMe
          //           ? const BorderRadius.only(
          //               topLeft: Radius.circular(40),
          //               bottomLeft: Radius.circular(40),
          //               bottomRight: Radius.circular(40))
          //           : const BorderRadius.only(
          //               topRight: Radius.circular(40),
          //               bottomLeft: Radius.circular(40),
          //               bottomRight: Radius.circular(40),
          //             ),
          //       child: PdfViewer(pdfUrl: pdf!),),
          // )
          else
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade600, width: 3),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.grey[400],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$text ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          Text('$sender'),
        ],
      ),
    );
  }
}

class PdfViewer extends StatelessWidget {
  final String pdfUrl;

  PdfViewer({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // appBar: AppBar(
          //   title: const Text('PDF Viewer'),
          // ),
          body: SfPdfViewer.network(
        pdfUrl,
        // controller: _pdfViewerController,
        enableDocumentLinkAnnotation: false,
      )),
    );
  }
}
