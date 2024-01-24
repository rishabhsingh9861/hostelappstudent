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
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: DropdownButton<T>(
          elevation: 0,
          iconEnabledColor: const Color.fromARGB(255, 69, 122, 158),
          dropdownColor: Color.fromARGB(255, 198, 209, 228),
          value: dropdownValue,
          onChanged: onChanged,
          borderRadius: BorderRadius.circular(25),
          items: list.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              alignment: Alignment.center,
              child: Text(
                value.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        ),
      ),
    );
  }
}

const textsty = TextStyle(
  fontSize: 25,
  color: Colors.black,
);

const textstyy = TextStyle(
  fontSize: 21,
  color: Colors.black,
  fontFamily: "Nunito",
  fontWeight: FontWeight.bold,
);
const div = Padding(
  padding: EdgeInsets.only(left: 8.0, right: 8),
  child: Divider(
    color: Colors.black,
  ),
);

const stylVJTI = TextStyle(
  fontSize: 30,
  color: Colors.red,
  fontFamily: "Anton",
  fontWeight: FontWeight.bold,
);

const idStyle = TextStyle(
  fontSize: 19,
  color: Colors.black,
  fontFamily: "Nunito",
  fontWeight: FontWeight.bold,
);
