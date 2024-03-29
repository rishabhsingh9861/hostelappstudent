import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff90AAD6),
        title: const Text('VJTI'),
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.5,
                child: Hero(
                  tag: 'college_image',
                  child: Image.asset(
                    'assets/images/college_image.jpg', // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Welcome to VJTI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'VJTI Mumbai (estd. in 1887 as Victoria Jubilee Technical Institute) has pioneered India’s Engineering education, research and training ecosystem. Pre-independence, VJTI had been instrumental in driving industrial growth throughout united India. Post-independence, VJTI played a pivotal role in setting up IITs and RECs of India and strengthened technology excellence of country.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'In 1997, VJTI changed its name to Veermata Jijabai Technological Institute to honor mother of Chhatrapati Shivaji Maharaj.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Located in South Mumbai, VJTI is an autonomous institution owned by Maharashtra State Government. The institute offers programs in engineering and technology at the diploma, degree, post-graduate and doctoral levels.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                double avatarSize = constraints.maxWidth * 0.3;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CircleAvatar(
                    radius: avatarSize,
                    backgroundImage: AssetImage(
                        'assets/images/director.jpg'), // Replace with your image path
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Dr. Sachin D. Kore',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Director, VJTI Mumbai',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
