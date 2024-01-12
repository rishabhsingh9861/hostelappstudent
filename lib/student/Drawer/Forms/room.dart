import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomChange extends StatefulWidget {
  RoomChange({super.key});

  @override
  State<RoomChange> createState() => _RoomChangeState();
}

class _RoomChangeState extends State<RoomChange> {
  bool? click = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff90AAD6),
        centerTitle: true,
        title: const Text(
          "Room Change Request",
          style: TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: 150,
                  // decoration: const BoxDecoration(
                  //   color: Colors.white,
                  // ),
                  child: Image.asset("assets/images/roomchange.png"),
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: "Enter Your Full Name ",
                  labletext: "Name",
                  icons: const Icon(CupertinoIcons.person),
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: "Enter Your Hostel ID Number ",
                  labletext: "ID Number",
                  icons: const Icon(CupertinoIcons.number),
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: "Enter Your Room Number ",
                  labletext: "Current Room Number",
                  icons: const Icon(CupertinoIcons.number),
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: "Enter Your Contact Number",
                  labletext: "Contact Number",
                  icons: const Icon(CupertinoIcons.phone),
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: "Enter Your Email Address",
                  labletext: "Email ID",
                  icons: const Icon(CupertinoIcons.mail),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                leaveDetails(
                  hinttext: " e.g. Branch wise",
                  labletext: "Roommate Preferences ",
                  icons: Icon(CupertinoIcons.person),
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: " ",
                  labletext: "Reason for Room Change",
                  icons: Icon(CupertinoIcons.italic),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: click,
                        activeColor: Colors.blueAccent,
                        onChanged: (newBool) {
                          setState(() {
                            click = newBool;
                          });
                        }),
                    const Expanded(
                      child: Text(
                        "Aware of and agree to the hostel's policies regarding room changes.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xff90AAD6),
                    ),
                  ),
                  onPressed: () {
                    print("Submit");
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
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

TextField leaveDetails({
  required String hinttext,
  required String labletext,
  required Icon icons,
  //required TextEditingController controller,
}) {
  return TextField(
    // controller: controller,
    decoration: InputDecoration(
      hintText: hinttext,
      labelText: labletext,
      labelStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      icon: icons,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
  );
}
