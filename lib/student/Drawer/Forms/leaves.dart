import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LeaveRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff90AAD6),
        centerTitle: true,
        title: const Text(
          "Leave Request",
          style: TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
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
                child: Image.asset("assets/images/leaverequest.png"),
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
                hinttext: "Enter Your Email Address",
                labletext: "Email ID",
                icons: const Icon(CupertinoIcons.mail),
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(),
              const SizedBox(
                height: 5,
              ),
              leaveDetails(
                hinttext: " e.g., Casual, Medical, Vacation",
                labletext: "Enter Type Of Leave",
                icons: const Icon(CupertinoIcons.person),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: leaveDetails(
                      hinttext: " e.g. 01-01-2024",
                      labletext: "Start Date",
                      icons: const Icon(CupertinoIcons.doc_append),
                    ),
                  ),
                  Expanded(
                    child: leaveDetails(
                      hinttext: "e.g. 01-03-2024",
                      labletext: "End Date",
                      icons: const Icon(CupertinoIcons.doc_append),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              leaveDetails(
                hinttext: " ",
                labletext: "Reason for Leave",
                icons: const Icon(CupertinoIcons.italic),
              ),
              const SizedBox(
                height: 10,
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
    );
  }
}

TextField leaveDetails({
  required String hinttext,
  required String labletext,
  required Icon icons,
  // required TextEditingController controller,
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
