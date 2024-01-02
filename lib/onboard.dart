
import 'package:flutter/material.dart';
import 'package:vjtihostel/backgroundimage.dart';
import 'package:vjtihostel/button.dart';
import 'package:vjtihostel/student/vjtilogin.dart';

class Onboard extends StatelessWidget {
  const Onboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: BackgrounImage(
      assetimage: const AssetImage("assets/images/vjtihostel.jpg"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

         


              InkWell(
            onTap: () {
              Navigator.push(context,
             MaterialPageRoute(builder: (context) => const Vjtilogin()));
            },
            child: const Padding(
              padding: EdgeInsets.all(30.0),
              child: Button(
                
           txt: "NEXT",
           fontsize: 30.0,
           textcolor: Color(0xFFFFFFFF),
           leftcolor: Color(0xFF4B4C17),
           rightcolor: Color(0xFF0C1010),
           highlighcolor: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        
        ],
      ),
    )));
  }
}
