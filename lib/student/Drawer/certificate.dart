import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:vjtihostel/student/Drawer/Forms/expenditure.dart';
import 'package:vjtihostel/student/Drawer/Forms/hostelAndMess.dart';


class Certificates extends StatelessWidget {
  const Certificates({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email.toString();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff90AAD6),
        title: const Text(
          "Certificate Section",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            fontFamily: "Nunito",
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[200],
                ),
                child: Center(

                  child: InkWell(
                    onTap: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HostelAndMess(email: email,),
                            ),
                          );
                    },
                    child: const ListTile(
                      leading: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image(
                            image: NetworkImage(
                                "https://tse4.mm.bing.net/th?id=OIP.GWNNI7nB26NNx3Cm23FLnQAAAA&pid=Api&P=0&h=180")),
                      ),
                      trailing:  Icon(CupertinoIcons.chevron_compact_right),
                      title:  Text(
                        "Hostel and Mess Certificate",
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold,
                  
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   height: 100,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: Colors.blueGrey[200],
              //   ),
              //   child: Center(
              //     child: ListTile(
              //       leading: const SizedBox(
              //         height: 100,
              //         width: 100,
              //         child: Image(
              //             image: NetworkImage(
              //                 "https://navi.com/blog/wp-content/uploads/2022/10/What-is-capital-expenditure.jpg")),
              //       ),
              //       trailing: GestureDetector(
              //           onTap: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(

              //                 builder: (context) => HostelAndMess(email:email),


              //               ),
              //             );
              //           },
              //           child:
              //           const Icon(CupertinoIcons.chevron_compact_right)),
              //       title: const Text(
              //         " Expenditure Certificate",
              //         style: TextStyle(
              //           fontFamily: "Nunito",
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
