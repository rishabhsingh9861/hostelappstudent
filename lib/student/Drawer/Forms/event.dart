import 'package:flutter/material.dart';


import 'package:table_calendar/table_calendar.dart';
import 'package:vjtihostel/student/Drawer/Forms/past_year_photos.dart';

import 'event_collection.dart';



class EventsCalendar extends StatefulWidget {
  const EventsCalendar({super.key});

  @override
  State<EventsCalendar> createState() => _EventsCalendarState();
}

class _EventsCalendarState extends State<EventsCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  final TextEditingController _eventController = TextEditingController();

  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focussedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focussedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calendar",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Past Year Photos'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PastYearPhotosPage()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("Event Name"),
                  content: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _eventController,
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        events.addAll({
                          _selectedDay!: [Event(_eventController.text)]
                        });
                        Navigator.of(context).pop();
                        _selectedEvents.value = _getEventsForDay(_selectedDay!);
                      },
                      child: const Text(
                        "Submit",
                      ),
                    )
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            "Selected Day: ${_focusedDay.toString().split(" ")[0]}",
            style: const TextStyle(fontSize: 17, color: Colors.blueGrey),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            startingDayOfWeek: StartingDayOfWeek.monday,
            eventLoader: _getEventsForDay,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: () => print(""),
                              title: Text("${value[index]}"),
                            ));
                      });
                }),
          )
        ],
      ),
    );
  }
}
/*

return Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
        ),
        body: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(getAppointments()),
        ));

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(
    startTime: startTime,
    endTime: endTime,
    subject: "Conference",
    color: Colors.blue,
  ));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
*/




























































































































// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class EventRequest extends StatelessWidget {
//   const EventRequest({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: const Color(0xff90AAD6),
//         title: const Text(
//           "Event Request",
//           style: TextStyle(
//             fontFamily: "Nunito",
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 120,
//                   width: 150,
//                   // decoration: const BoxDecoration(
//                   //   color: Colors.white,
//                   // ),
//                   child: Image.asset("assets/images/Event.jpg"),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 leaveDetails(
//                   hinttext: "Enter Your Full Name ",
//                   labletext: "Name",
//                   icons: const Icon(CupertinoIcons.person),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 leaveDetails(
//                   hinttext: "Enter Your Hostel ID Number ",
//                   labletext: "ID Number",
//                   icons: const Icon(CupertinoIcons.number),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 leaveDetails(
//                   hinttext: "Enter Your Contack Number",
//                   labletext: "Contack Number",
//                   icons: const Icon(CupertinoIcons.phone),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 leaveDetails(
//                   hinttext: "Enter Your Email Address",
//                   labletext: "Email ID",
//                   icons: const Icon(CupertinoIcons.mail),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 leaveDetails(
//                   hinttext: "Enter Date Fron An Event",
//                   labletext: "Date",
//                   icons: const Icon(CupertinoIcons.calendar),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 leaveDetails(
//                   hinttext: "Duration of the Event",
//                   labletext: "Duration ",
//                   icons: const Icon(CupertinoIcons.time),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 leaveDetails(
//                   hinttext: "e.g., cultural, sports, educational",
//                   labletext: "Event Type",
//                   icons: const Icon(CupertinoIcons.doc_append),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 leaveDetails(
//                   hinttext: " ",
//                   labletext: "Purpose and Description of the Event:",
//                   icons: const Icon(CupertinoIcons.italic),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateColor.resolveWith(
//                       (states) => const Color(0xff90AAD6),
//                     ),
//                   ),
//                   onPressed: () {
//                   },
//                   child: const Text(
//                     "Submit",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // TextField leaveDetails({
// //   required String hinttext,
// //   required String labletext,
// //   required Icon icons,
// //   //required TextEditingController controller,
// // }) {
// //   return TextField(
// //     // controller: controller,
// //     decoration: InputDecoration(
// //       hintText: hinttext,
// //       labelText: labletext,
// //       labelStyle:
// //           const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
// //       icon: icons,
// //       border: const OutlineInputBorder(
// //         borderRadius: BorderRadius.all(
// //           Radius.circular(20),
// //         ),
// //       ),
// //       enabledBorder: const OutlineInputBorder(
// //         borderSide: BorderSide(color: Colors.black),
// //         borderRadius: BorderRadius.all(
// //           Radius.circular(20),
// //         ),
// //       ),
// //       focusedBorder: const OutlineInputBorder(
// //         borderSide: BorderSide(color: Colors.black, width: 2),
// //         borderRadius: BorderRadius.all(
// //           Radius.circular(20),
// //         ),
// //       ),
// //     ),
// //   );
// // }
