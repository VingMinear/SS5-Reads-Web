import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../../../utils/Utilty.dart';
import '../../../widgets/CardContact.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream method to get a single "Contact Us" document from Firestore
  Stream<ContactUs> _getContactUs() {
    return _firestore
        .collection('contact_us')
        .doc('contactInfo') // Assuming you have a single document with this ID
        .snapshots()
        .map((docSnapshot) {
      // Convert the Firestore document into a ContactUs object
      return ContactUs.fromFirestore(docSnapshot.data()!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(
        title: 'Contact Us',
        showNotification: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<ContactUs>(
        stream:
            _getContactUs(), // Using StreamBuilder to listen to Firestore updates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No contact data available.'));
          } else {
            final contactUs = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    child: Image.asset(
                      'assets/icons/contactus.jpg',
                      width: 250,
                    ),
                  ),
                  Text(
                    '''If you have any questions, concerns, or feedback, we're here to help. Feel free to get in touch with us through the following methods:''',
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '''1. Phone: Our friendly customer support team is available to assist you over the phone.''',
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '''2. Telegram: For non-urgent inquiries, you can reach out to us via telegram account.''',
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      cardContact(
                        onTap: () {
                          callLaunchUrl(
                            url: 'tel:${contactUs.telephone}',
                          );
                        },
                        title: 'Telephone',
                        icon: 'assets/icons/ic_ph.svg',
                      ),
                      const SizedBox(width: 16),
                      cardContact(
                        onTap: () {
                          callLaunchUrl(
                            url: 'https://t.me/${contactUs.telegram}',
                          );
                        },
                        title: 'Telegram',
                        icon: 'assets/icons/ic_telegram.svg',
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ContactUs {
  final String telephone;
  final String telegram;

  ContactUs({
    required this.telephone,
    required this.telegram,
  });

  // A method to convert Firestore data into a ContactUs object
  factory ContactUs.fromFirestore(Map<String, dynamic> data) {
    return ContactUs(
      telephone: data['telephone'] ?? '',
      telegram: data['telegram'] ?? '',
    );
  }
}
