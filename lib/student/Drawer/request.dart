import 'package:flutter/material.dart';
import 'package:vjtihostel/student/Drawer/Forms/amenities.dart';
import 'package:vjtihostel/student/Drawer/Forms/event.dart';
import 'package:vjtihostel/student/Drawer/Forms/leaves.dart';
import 'package:vjtihostel/student/Drawer/Forms/room.dart';

class Request extends StatelessWidget {
  const Request({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff90AAD6),
        title: const Text("Request"),
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Requestcontainer(
                    Requestname: "Leave Request",
                    image: "leaverequest.png",
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaveRequest(),
                        ),
                      );
                    },
                  ),
                  Requestcontainer(
                    Requestname: "Room Change",
                    image: "roomchange.png",
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomChange(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Requestcontainer(
                    Requestname: "Complaints ",
                    image: "Complaint.png",
                    function: () {},
                  ),
                  Requestcontainer(
                    Requestname: "Amenities",
                    image: "Amenities1.jpg",
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Amenities(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Requestcontainer(
                    Requestname: "Event Request",
                    image: "Event.jpg",
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventRequest(),
                        ),
                      );
                    },
                  ),
                  Requestcontainer(
                    Requestname: "Status Tracking",
                    image: "Status.webp",
                    function: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container Requestcontainer(
      {required String Requestname,
      required String image,
      required VoidCallback? function}) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 280,
      width: 180,
      decoration: BoxDecoration(
        color: const Color.fromARGB(95, 189, 185, 185),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(top: 10),
            height: 150,
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset("assets/images/${image}"),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            Requestname,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: function,
            child: const Text(
              "VIEW",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
