import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Rectors extends StatefulWidget {
  const Rectors({super.key,});

  @override
  State<Rectors> createState() => _RectorsState();
}

class _RectorsState extends State<Rectors> {
  List<String> requiredId = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Rectors')
            .orderBy('Rank', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String reqId = snapshot.data!.docs[index].id;
                requiredId.add(reqId);
                final reqData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String rectorName = reqData['Cheif Rector Name'] as String;
                String rectorImage = reqData['Cheif rector Image'] as String;
                String rectorEmail = reqData['Cheif Rector email'] as String;
                String position = reqData['Position1'] as String;
                int rectorNumber = reqData['Cheif Rector Number'] as int;

                return material(rectorNumber, rectorEmail, rectorImage,
                    rectorName, position);
              },
            );
          } else {
            // Handle the case when there is no data or it's still loading
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget material(int phoneno, String emailto, String assetimage,
      String nametext, String positiontext) {
    int phoneNumber = phoneno;
    String email = emailto;
    return Material(
    //  color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          height: 400,
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(
                  width: 3, color: const Color.fromARGB(255, 0, 0, 0)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(assetimage),
                  radius: 70,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 150,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nametext,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 30),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        positiontext,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        final gmail = 'mailto:$email';
                        if (await launchUrlString(gmail)) {
                          await canLaunchUrlString(gmail);
                        }
                      },
                      child: Image.asset('assets/images/gmailicon.png'),
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                    InkWell(
                      onTap: () async {
                        final call = 'tel:$phoneNumber';
                        if (!await launchUrlString(call)) {
                          await canLaunchUrlString(call);
                        }
                      },
                      child: Image.asset('assets/images/phoneicon.png'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
