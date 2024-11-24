import 'package:flutter/material.dart';
import 'package:homework3/modules/home_screen/components/footer.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/break_point.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: appHeight(percent: 0.6),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bg_aboutus.jfif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black12,
                  ),
                ),
                const Text(
                  "About Us",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              constraints: const BoxConstraints(maxWidth: BreakPoint.md),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Welcome to SS5 Reads',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "At Book Haven, we believe in the magic of stories. Founded in 2024, our mission is to bring readers closer to their favorite books and introduce them to new worlds. Whether you're a fan of thrillers, romance, fantasy, or self-help, we have something for everyone.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Our Values',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text('Community'),
                    subtitle: Text('Bringing book lovers together.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.public),
                    title: Text('Diversity'),
                    subtitle:
                        Text('Celebrating stories from around the world.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Quality'),
                    subtitle:
                        Text('Offering only the best reading experiences.'),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Our Vision',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "To be more than a bookstore—a sanctuary for every reader. Whether you're looking to escape into a story, learn something new, or connect with fellow book lovers, Book Haven is here for you.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
