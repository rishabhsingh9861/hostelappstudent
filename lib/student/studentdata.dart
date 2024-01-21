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
List<String> listBlock = <String>[
  'Select Block',
  'A',
  'B',
  'C',
  'D',
  'E',
  'T',
];
List<String> listDepartment = <String>[
  'Select Department',
  'Civil',
  'Computer Science',
  'information Technology',
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
  final _roomnoController = TextEditingController();
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
      String roomNumber,
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
      'Room No.': roomNumber,
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
    _roomnoController.dispose();
    _hostelIdController.dispose();
    // _bloodgroupController.dispose();
    super.dispose();
  }

  String dropdownValueBlood = listbloodgroup.first;
  String dropdownValueCaste = listcastecategory.first;
  String dropdownValueBlock = listBlock.first;
  String dropdownValueDepartment = listDepartment.first;
  String setcaste = "";
  String setbloodgroup = "";
  String setblock = "";
  String setdepartment = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: false,
          child: Form(
            key: _formKey,
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata(
                      "First Name", TextInputType.name, _nameController),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata(
                      "Middle Name", TextInputType.name, _middlenameController),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata(
                      "Surname", TextInputType.name, _surnameController),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Registraion No.", TextInputType.number,
                      _registrationController),
                ),
                const SizedBox(
                  height: 25,
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
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dropdownMenu(listBlock, dropdownValueBlock,
                      (String? value) {
                    setState(() {
                      dropdownValueBlock = value!;
                      setblock = dropdownValueBlock;
                    });
                  }),
                ),
                const SizedBox(
                  height: 25,
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
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Enter Room Number", TextInputType.number,
                      _roomnoController),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Enter Hostel Id", TextInputType.number,
                      _hostelIdController),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Parents Name", TextInputType.name,
                      _parentnameController),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Student Phone Number", TextInputType.number,
                      _studentcontactnoController),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata("Parents Phone Number", TextInputType.number,
                      _parentcontactnoController),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: writedata(
                      "Native Place", TextInputType.name, _addresController),
                ),
                const SizedBox(
                  height: 25,
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
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: InkWell(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
