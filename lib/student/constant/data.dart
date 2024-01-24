import 'package:flutter/material.dart';

Widget writedata(
    String text, TextInputType keyboard, TextEditingController controller) {
  return TextFormField(
    keyboardType: keyboard,
    decoration: InputDecoration(
      labelText: text,
      labelStyle: const TextStyle(
          color: Colors.black,
          fontFamily: "Nunito",
          fontWeight: FontWeight.bold),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 69, 122, 158),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 61, 87, 109),
        ),
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please entere details';
      }
      // if (validPincode( ) == false) {
      //   return 'Please Provide valid pincode';
      // }
      return null;
    },
    controller: controller,
  );
}
