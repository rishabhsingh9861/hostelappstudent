import 'package:flutter/material.dart';

PreferredSizeWidget appbars(String text) {
  return AppBar(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
    centerTitle: true,
    title:  Text(
      text,
    ),
  );
}


Widget dropdownMenu<T>(
      List<T> list, T? dropdownValue, ValueChanged<T?> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green, // Set the color of the border
              width: 1.0, // Set the width of the border
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: DropdownButton<T>(
              iconEnabledColor: const Color.fromARGB(255, 194, 136, 136),
              dropdownColor: const Color.fromARGB(255, 237, 233, 233),
              value: dropdownValue,
              onChanged: onChanged,
              items: list.map<DropdownMenuItem<T>>((T value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          )),
    );
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