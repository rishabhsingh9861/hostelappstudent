import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

List<String> listDepartment = <String>[
  'Select Department',
  'Civil',
  'Computer Science',
  'Information Technology',
  'Electronics',
  'Electrical',
  'EXTC',
  'Mechanical',
  'Production',
  'Textile',
];

class _StudentDataState extends State<StudentData> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _middlenameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _registrationController = TextEditingController();
  final _parentnameController = TextEditingController();
  final _parentcontactnoController = TextEditingController();
  final _studentcontactnoController = TextEditingController();
  final _addresController = TextEditingController();
  final _hostelIdController = TextEditingController();

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
      String department,
      int hostelid,
      bool aprov) async {
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
      'Department': department,
      'Hostel Id': hostelid,
      'Approved': approv,
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
    _middlenameController.dispose();
    _surnameController.dispose();

    _hostelIdController.dispose();
    // _bloodgroupController.dispose();
    super.dispose();
  }

  String dropdownValueBlood = listbloodgroup.first;
  String dropdownValueCaste = listcastecategory.first;

  String dropdownValueDepartment = listDepartment.first;
  String setcaste = "";
  String setbloodgroup = "";

  String setdepartment = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appbars("Students Details"),
        body: SingleChildScrollView(
          reverse: false,
          child: Form(
            key: _formKey,
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: writedata(
                            "First Name", TextInputType.name, _nameController),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: writedata("Middle Name", TextInputType.name,
                            _middlenameController),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: writedata(
                            "Surname", TextInputType.name, _surnameController),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Registraion No.", TextInputType.number,
                      _registrationController),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dropdownMenu(listcastecategory, dropdownValueCaste,
                      (String? value) {
                    setState(() {
                      dropdownValueCaste = value!;
                      setcaste = dropdownValueCaste;
                    });
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dropdownMenu(listDepartment, dropdownValueDepartment,
                      (String? value) {
                    setState(() {
                      dropdownValueDepartment = value!;
                      setdepartment = dropdownValueDepartment;
                    });
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Enter Hostel Id", TextInputType.number,
                      _hostelIdController),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Parents Name", TextInputType.name,
                      _parentnameController),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Student Phone Number", TextInputType.number,
                      _studentcontactnoController),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Parents Phone Number", TextInputType.number,
                      _parentcontactnoController),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Permanent Address", TextInputType.name,
                      _addresController),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dropdownMenu(listbloodgroup, dropdownValueBlood,
                      (String? value) {
                    setState(() {
                      dropdownValueBlood = value!;
                      setbloodgroup = dropdownValueBlood;
                    });
                  }),
                ),
                const Text(
                  "Declaration clg Rules and Policy",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        onChanged: (value) {},
                        value: true,
                      ),
                      const Expanded(
                        child: Column(
                          children: [
                            Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 147, 182, 206),
                      ),
                    ),
                    onPressed: () {
                      // fetchUsernames();

                      if (_formKey.currentState!.validate()) {
                        addUserDetails(
                                "${_nameController.text} ${_middlenameController.text} ${_surnameController.text}"
                                    .trim(),
                                widget.email,
                                int.parse(_registrationController.text.trim()),
                                setcaste,
                                _parentnameController.text.trim(),
                                int.parse(
                                    _studentcontactnoController.text.trim()),
                                int.parse(
                                    _parentcontactnoController.text.trim()),
                                _addresController.text.trim(),
                                setbloodgroup,
                                setdepartment,
                                int.parse(_hostelIdController.text.trim()),
                                approv)
                            .then((value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomePage())));
                      }
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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

/*

InkWell(
                    onTap: () {
                      // fetchUsernames();

                      if (_formKey.currentState!.validate()) {
                        addUserDetails(
                                "${_nameController.text} ${_middlenameController.text} ${_surnameController.text}"
                                    .trim(),
                                widget.email,
                                int.parse(_registrationController.text.trim()),
                                setcaste,
                                _parentnameController.text.trim(),
                                int.parse(
                                    _studentcontactnoController.text.trim()),
                                int.parse(
                                    _parentcontactnoController.text.trim()),
                                _addresController.text.trim(),
                                setbloodgroup,
                                setblock + _roomnoController.text,
                                setdepartment,
                                int.parse(_hostelIdController.text.trim()),
                                approv)
                            .then((value) => Navigator.pushReplacement(
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
*/