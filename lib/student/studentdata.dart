import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vjtihostel/button.dart';
import 'package:vjtihostel/student/constant/const.dart';
import 'package:vjtihostel/student/constant/data.dart';
import 'package:vjtihostel/student/homepage.dart';

class StudentData extends StatefulWidget {
  const StudentData({
    Key? key,
    required this.email,
  }) : super(key: key);
  final String email;

  @override
  State<StudentData> createState() => _StudentDataState();
}

List<String> listbloodgroup = <String>[
  'Select Blood group',
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
  'Not Sure'
];
List<String> listcastecategory = <String>[
  'Select Category',
  'Open',
  'OBC',
  'VJ/NT',
  'SC',
  'ST',
];

class _StudentDataState extends State<StudentData> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _registrationController = TextEditingController();
  final _parentnameController = TextEditingController();
  final _parentcontactnoController = TextEditingController();
  final _studentcontactnoController = TextEditingController();
  final _addresController = TextEditingController();

  bool approv = false;
  Future addUserDetails(
      String name,
      String email,
      int registration,
      String caste,
      String parentname,
      int studentcontactnumber,
      int parentcontactnumber,
      String address,
      String bloodgroup,
      bool aprov
      ) async {
    await FirebaseFirestore.instance
        .collection('HostelStudents')
        .doc(widget.email)
        .set({
      'Name': name,
      'Email': email,
      'Registration No.': registration,
      'Caste': caste,
      'Parent Name': parentname,
      'Student contact number': studentcontactnumber,
      'Parent Contact Number': parentcontactnumber,
      'Address': address,
      'Blood Group': bloodgroup,
      'Approved' : approv,
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _registrationController.dispose();
    // _categoryController.dispose();
    _parentnameController.dispose();
    _studentcontactnoController.dispose();
    _parentcontactnoController.dispose();
    _addresController.dispose();
    // _bloodgroupController.dispose();
    super.dispose();
  }

  String dropdownValueBlood = listbloodgroup.first;
  String dropdownValueCaste = listcastecategory.first;
  String setcaste = "";
  String setbloodgroup = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: _formKey,
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                writedata("Name", TextInputType.name, _nameController),
                const SizedBox(
                  height: 50,
                ),
                writedata("Registraion No.", TextInputType.number,
                    _registrationController),
                const SizedBox(
                  height: 25,
                ),
                dropdownMenu(listcastecategory, dropdownValueCaste,
                    (String? value) {
                  setState(() {
                    dropdownValueCaste = value!;
                    setcaste = dropdownValueCaste;
                  });
                }),
                const SizedBox(
                  height: 25,
                ),
                writedata(
                    "Parents Name", TextInputType.name, _parentnameController),
                const SizedBox(
                  height: 50,
                ),
                writedata("Student Phone Number", TextInputType.number,
                    _studentcontactnoController),
                const SizedBox(
                  height: 50,
                ),
                writedata("Parents Phone Number", TextInputType.number,
                    _parentcontactnoController),
                const SizedBox(
                  height: 50,
                ),
                writedata(
                    "Native Place", TextInputType.name, _addresController),
                const SizedBox(
                  height: 25,
                ),
                dropdownMenu(listbloodgroup, dropdownValueBlood,
                    (String? value) {
                  setState(() {
                    dropdownValueBlood = value!;
                    setbloodgroup = dropdownValueBlood;
                  });
                }),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: InkWell(
                    onTap: () {
                      // fetchUsernames();

                      if (_formKey.currentState!.validate()) {
                        addUserDetails(
                          _nameController.text.trim(),
                          widget.email,
                          int.parse(_registrationController.text.trim()),
                          setcaste,
                          _parentnameController.text.trim(),
                          int.parse(_studentcontactnoController.text.trim()),
                          int.parse(_parentcontactnoController.text.trim()),
                          _addresController.text.trim(),
                          setbloodgroup,
                          approv
                        ).then((value) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomePage())));
                      }
                    },
                    child: const Button(
                        txt: "Submit",
                        textcolor: Color(0xFF111111),
                        leftcolor: Color(0xFFa7a7a7),
                        rightcolor: Color(0xFFE7E7E7),
                        highlighcolor: Color(0xFFE7E7E7),
                        fontsize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
