import 'package:flutter/material.dart';

Widget writedata(
    String text, TextInputType keyboard, TextEditingController controller) {
  return TextFormField(
    keyboardType: keyboard,
    decoration: InputDecoration(
        labelText: text,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 77, 117, 143))),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 77, 113, 143)),
            borderRadius: BorderRadius.circular(12))),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please entere name';
      }
      // if (validPincode( ) == false) {
      //   return 'Please Provide valid pincode';
      // }
      return null;
    },
    controller: controller,
  );
}
