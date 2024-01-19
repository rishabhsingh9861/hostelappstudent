import 'package:flutter/material.dart';

PreferredSizeWidget appbars(String text) {
  return AppBar(
    backgroundColor: const Color(0xff90AAD6),
    // shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
    centerTitle: true,
    title: Text(
      text,
      style: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.bold),
    ),
  );
}

Widget dropdownMenu<T>(
    List<T> list, T? dropdownValue, ValueChanged<T?> onChanged) {
  return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(
              255, 97, 139, 163), // Set the color of the border
          width: 1.0, // Set the width of the border
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: DropdownButton<T>(
          iconEnabledColor: const Color.fromARGB(255, 93, 212, 228),
          dropdownColor: const Color(0xff90AAD6),
          value: dropdownValue,
          onChanged: onChanged,
          borderRadius: BorderRadius.circular(25),
          items: list.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
      ));
}

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    Key? key,
    required this.texts,
  }) : super(key: key);
  final String texts;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(
              width: 3, color: const Color.fromARGB(255, 76, 158, 175)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
            child: Text(
          texts,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        )));
  }
}

const textsty = TextStyle(
  fontSize: 25,
  color: Colors.black,
);
