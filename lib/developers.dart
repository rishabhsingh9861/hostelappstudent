import 'package:flutter/material.dart';

class Developers extends StatelessWidget {
  const Developers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                      ),
                      height: 250,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child:
                              Image.asset("assets/images/developers/app.png")),
                    ),
                  ),
                  const Text(
                    "DEVELOPER",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: "Anton",
                      fontSize: 25,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 180,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amber,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/developers/rishabh.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "RISHABH SINGH",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: "Nunito",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "GUIDE",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: "Anton",
                      fontSize: 25,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 180,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amber,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/developers/komal.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Ms.SHIVINI DHANANJAY SUPE",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: "Nunito",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "MAJOR CONTRIBUTERS",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 3,
                      fontFamily: "Anton",
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Contributers("Sahil Dongre", "sahil.png"),
                      Contributers("Komal Salunkhe", "komal.png"),
                      Contributers("Aditya Arakharao", "Aditya.png"),
                    ],
                  ),
                  Row(
                    children: [
                      Contributers("Ayush Gurav", "Ayush.png"),
                      Contributers("Mukund Gohil", "mukund.jpg"),
                      Contributers("Prathamesh Kothawade", "prathamesh.png"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget Contributers(String name, String image) {
    return Expanded(
      child: Container(
        height: 150,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset("assets/images/developers/${image}"),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Nunito",
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
