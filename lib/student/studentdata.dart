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
  'EWS',
  'SBC',
  'OBC',
  'VJ/NT',
  'SC',
  'ST',
  'PH',
  'Others'
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
 // final _hostelIdController = TextEditingController();
  bool isChecked = false;

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
      // int hostelid,
      bool aprov) async {
    await FirebaseFirestore.instance
        .collection('HostelStudents')
        .doc(widget.email)
        .set({
      'Name': name,
      'Email': email,
      'Registration No': registration,
      'Caste': caste,
      'Parent Name': parentname,
      'Student contact number': studentcontactnumber,
      'Parent Contact Number': parentcontactnumber,
      'Address': address,
      'Blood Group': bloodgroup,
      'Department': department,
      // 'Hostel Id': hostelid,
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

   // _hostelIdController.dispose();
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: writedata("Enter Hostel Id", TextInputType.number,
                //       _hostelIdController),
                // ),
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
                  "Declaration Hostel Rules and Policy",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                          "VJTI BOYS' HOSTEL - Rules, Regulations, and Guidelines\n\n"
                          "A. ENTRY/EXIT Restrictions (Hostel and Campus-wide)\n"
                          "1. Last Entry at Night: 11:30 pm.\n"
                          "2. Earlier EXIT/ENTRY in the Morning: 6 am onward.\n"
                          "3. With prior permission from Rector, anytime for going to home/coming from home.\n\n"
                          "B. Mess Related Rules and Guidelines\n"
                          "1. Do not waste food, water, and electricity. Keep the dining area and mess area clean and hygienic.\n"
                          "2. Mess Timings:\n"
                          "   - Breakfast:\n"
                          "     - Weekdays: 7:30 am to 9:00 am\n"
                          "     - Weekends and Holidays: 8:00 am to 10:00 am\n"
                          "   - Lunch: 12:30 pm to 2:00 pm\n"
                          "   - Dinner: 7:30 pm to 9:00 pm\n"
                          "3. For leave, inform the mess manager one day in advance.\n"
                          "4. Adhere strictly to rules and regulations laid down by the Joint Managing Committee (JMC) of the students' Messes.\n\n"
                          "C. TV Room Related\n"
                          "1. Timing:\n"
                          "   - Weekdays: 5:30 pm to 11:30 pm\n"
                          "   - Weekends: from Breakfast till 11:30 pm\n"
                          "2. Discussion/private talks and food usage are discouraged in the TV room.\n"
                          "3. Do not mark, spoil, or damage furniture and fittings.\n\n"
                          "D. Meeting Parents and Visitors\n"
                          "1. Visitor/Parents meeting to be done in Hostel Office.\n"
                          "2. With prior permission, parents can avail the facility of a guest room for one day stay.\n"
                          "3. In case of emergency or health-related issues of students, the stay of parents in the guest room may be extended.\n"
                          "4. No outsiders including relatives and day scholar students shall be allowed in the room at any time.\n\n"
                          "E. Ragging and Other Prohibitions\n"
                          "1. Ragging is strictly prohibited as per Maharashtra Prohibition of Ragging Act and MHRD guidelines.\n"
                          "2. Smoking, alcohol, and drugs are strictly prohibited.\n"
                          "3. Writing, painting, sticking posters, and spitting on any walls are strictly prohibited.\n\n"
                          "F. Admission Related\n"
                          "1. Admission offered is valid for only one academic year.\n"
                          "2. Students who discontinue Institute admission and are involved in violation of regulations will not be admitted to the hostel in the next academic year.\n"
                          "3. Students who secure minimum credits for admission into the next academic year will only be considered for hostel admission.\n\n"
                          "H. Going to Outside/Relative/Home Town\n"
                          "1. Students going/staying outside of the hostel during the night for any work shall apply in writing to the Rector and submit the application to the hostel office before leaving. Make a note of it in the register available with their block watchman.\n\n"
                          "Hostel and Institute Authorities have the absolute right to enter and inspect the room at any time.\n\n"),
                      div,
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                          "VJTI GIRLS' HOSTEL Rules, Regulations, and Guidelines\n\n"
                          "A. ENTRY/EXIT Restrictions (Girls' Hostel and Campus-wide)\n"
                          "1. Last Entry at Night:\n"
                          "   - Weekdays: 10:00 PM\n"
                          "   - Weekends and Holidays: 11:00 PM\n"
                          "2. Earlier EXIT/Entry in the Morning: 6 AM onward with prior permission (any time for going to home or coming from Home)\n"
                          "3. Both A and E blocks are treated as a single Hostel.\n\n"
                          "B. Mess Related Rules and Guidelines\n"
                          "1. Do not waste food, water, and electricity. Keep the dining area and mess area clean and hygienic.\n"
                          "2. Mess timings (Food will not be served beyond these timings):\n"
                          "   - Breakfast:\n"
                          "     - Weekdays: 7:30 AM to 9:00 AM\n"
                          "     - Weekends and Holidays: 8:00 AM to 10:00 AM\n"
                          "   - Lunch: 12:30 PM to 2:00 PM\n"
                          "   - Dinner: 7:30 PM to 9:00 PM\n"
                          "3. In case of early or late class, inform the mess contractor for late food/packet food provision.\n"
                          "4. For leave, inform the mess contractor one day in advance.\n\n"
                          "C. Reading Room Timings\n"
                          "1. 24 x 7 open (please switch off lights and fans when no one is inside).\n"
                          "2. Discussions/Private talks and food usage are discouraged in the reading room.\n"
                          "3. Do not mark, spoil, or damage furniture and fittings.\n\n"
                          "D. TV Room Related\n"
                          "1. TV is currently in the Mess area (Weekdays: 5:30 PM to 10:00 PM, Weekends from Breakfast till Dinner time). TV should be shifted to a separate open space.\n\n"
                          "E. Meeting Parents and Visitors\n"
                          "1. Visitor meeting has to be done in the meeting area.\n"
                          "2. Parents can visit the room with the company of lady staff.\n"
                          "3. Mother/Sister can stay in the room if required in case of an emergency or health-related issue (in a separate room earmarked for this purpose).\n\n"
                          "F. Lift Related and General Safety\n"
                          "1. Lift maintenance can be called directly on toll-free numbers with equipment number as a reference.\n"
                          "2. Be vigilant and inform security in case of any inappropriate incidence noticed.\n\n"
                          "G. Ragging and Other Prohibitions\n"
                          "1. Ragging is strictly prohibited as per Maharashtra Ragging Prohibition of Ragging Act and MHRD guidelines.\n"
                          "2. Smoking, alcohol, and drugs are strictly prohibited and subject to expulsion from the hostel.\n"
                          "3. Writing, painting, sticking posters, and spitting on any walls are strictly prohibited and liable to penalty.\n\n"
                          "I. Admission Related\n"
                          "1. Admission offered is valid for only one academic year.\n"
                          "2. Students who discontinue Institute admission and/or are involved in violation of regulations will not be admitted to the hostel in the next academic year.\n"
                          "3. Students who secure minimum credits for admission into the next academic year will only be considered for hostel admission."),
                      Checkbox(
                        checkColor: Colors.white,
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black,
                      ),
                    ),
                    onPressed: () {
                      // fetchUsernames();

                      if (_formKey.currentState!.validate() && isChecked) {
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
                               // int.parse(_hostelIdController.text.trim()),
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
                        fontSize: 20,
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