import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(
//     home: ChatScreen(),
//   ));
// }

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _pickedImage;
  File? _pickedPdf;
  String? userName;

  Future<void> _sendMessage(
      String? message, String? imageUrl, String? pdfUrl) async {
    // Add message to Firestore
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null ||
        (message != null && message.isNotEmpty) ||
        imageUrl != null ||
        pdfUrl != null) {
      // Get user's name from 'Rectors' collection
      String? userName;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Rectors')
          .where('Rector Email', isEqualTo: user?.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic>? userData =
            snapshot.docs[0].data() as Map<String, dynamic>;
        userName = userData['Rector Name'];
      }

      await FirebaseFirestore.instance.collection('notices').add({
        'userName': userName,
        'userEmail': user?.email, // Include user email in the document
        'text': message,
        'imageUrl': imageUrl,
        'pdfUrl': pdfUrl,
        'createdAt': Timestamp.now(),
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _pickedPdf = null; // Clear picked PDF when picking image
      });
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? pickedPdfFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (pickedPdfFile != null) {
      setState(() {
        _pickedPdf = File(pickedPdfFile.files.single.path!);
        _pickedImage = null; // Clear picked image when picking PDF
      });
    }
  }

  Future<void> _uploadImageAndSendMessage() async {
    if (_pickedImage != null) {
      // Upload image to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      UploadTask uploadTask = ref.putFile(_pickedImage!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Add message to Firestore with the image URL
      _sendMessage('', imageUrl, null);

      // Clear picked image and text field
      setState(() {
        _pickedImage = null;
        _controller.clear();
      });
    } else if (_pickedPdf != null) {
      // Upload PDF to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('pdfs/${DateTime.now().toString()}');
      UploadTask uploadTask = ref.putFile(_pickedPdf!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String pdfUrl = await snapshot.ref.getDownloadURL();

      // Add message to Firestore with the PDF URL
      _sendMessage('', null, pdfUrl);

      // Clear picked PDF
      setState(() {
        _pickedPdf = null;
        _controller.clear(); // Clear the text field after sending the message
      });
    }
  }

  Future<void> getuserdata(String emailid) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Rectors')
        .where('Rector Email', isEqualTo: emailid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic>? userData =
          snapshot.docs[0].data() as Map<String, dynamic>;
      ;
      setState(() {
        userName = userData['Rector Name'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      getuserdata(user.email!); // Fetch user data on screen initialization
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
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
                    final imageUrl = document?['imageUrl'] as String?;
                    final pdfUrl = document?['pdfUrl'] as String?;
                    return ListTile(
                      title: Text(document?['text'] ?? ''),
                      subtitle: userName != null ? Text(userName) : null,
                      leading: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              // height: 450, 
                              // width: 250, 
                              // fit: BoxFit
                              //     .cover, // Adjust the image fit as needed
                            )
                          : null,
                      trailing: pdfUrl != null
                          ? IconButton(
                              icon: Icon(Icons.picture_as_pdf),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PdfViewer(pdfUrl: pdfUrl),
                                  ),
                                );
                              },
                            )
                          : null,
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

class ImagePreviewWidget extends StatelessWidget {
  final File imageFile;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  ImagePreviewWidget({
    required this.imageFile,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageFile.path.isNotEmpty) Image.file(imageFile),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onConfirm,
              child: const Text('Confirm'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onCancel,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}

class PdfViewer extends StatelessWidget {
  final String pdfUrl;

  PdfViewer({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: SfPdfViewer.network(pdfUrl, enableDocumentLinkAnnotation: false),
    );
  }
}
