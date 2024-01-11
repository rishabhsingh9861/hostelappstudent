import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventRequest extends StatelessWidget {
  const EventRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff90AAD6),
        title: const Text(
          "Event Request",
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
                  child: Image.asset("assets/images/Event.jpg"),
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
                  hinttext: "Enter Your Contack Number",
                  labletext: "Contack Number",
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
                const SizedBox(
                  height: 5,
                ),
                leaveDetails(
                  hinttext: "Enter Date Fron An Event",
                  labletext: "Date",
                  icons: const Icon(CupertinoIcons.calendar),
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: "Duration of the Event",
                  labletext: "Duration ",
                  icons: const Icon(CupertinoIcons.time),
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: "e.g., cultural, sports, educational",
                  labletext: "Event Type",
                  icons: const Icon(CupertinoIcons.doc_append),
                ),
                const SizedBox(
                  height: 10,
                ),
                leaveDetails(
                  hinttext: " ",
                  labletext: "Purpose and Description of the Event:",
                  icons: const Icon(CupertinoIcons.italic),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xff90AAD6),
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
