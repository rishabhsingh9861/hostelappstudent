// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.txt,
    required this.textcolor,
    required this.leftcolor,
    required this.rightcolor,
    required this.highlighcolor,
    required this.fontsize,
  }) : super(key: key);
  final String txt;
  final Color textcolor;
  final Color leftcolor;
  final Color rightcolor;
  final Color highlighcolor;
  final double fontsize;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          alignment: Alignment.center,
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              gradient: LinearGradient(colors: [
                leftcolor,
                rightcolor,
                // Color(0xFF4B4C17),
                // Color(0xFF0C1010),
                // Color(0xFFFA0F80),
                // Color(0xFFFFB80D),
              ]),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 0),
                  color: leftcolor,
                  blurRadius: 16.0,
                ),
                BoxShadow(
                  offset: const Offset(0, 0),
                  color: rightcolor,
                  blurRadius: 16.0,
                ),
                BoxShadow(
                  offset: const Offset(0, 0),
                  color: highlighcolor,
                  blurRadius: 16.0,
                ),
                // BoxShadow(
                //   offset: Offset(0, 0),
                //   color: Color(0xFFFFB80D),
                //   blurRadius: 16.0,
                // ),
              ]),
          child: Text(txt,
              style:  TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.w900,
                  fontSize: fontsize),),)
    );
  }
}