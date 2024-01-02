 import 'package:flutter/material.dart';

Widget writedata(String text , TextInputType keyboard , TextEditingController controller ) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        keyboardType: keyboard,
        decoration: InputDecoration(
            labelText: text,
          
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.green)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.greenAccent),
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
      ),
    );
}