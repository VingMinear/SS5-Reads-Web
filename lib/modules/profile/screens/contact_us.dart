import 'package:bootstrap_grid/bootstrap_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/utils/break_point.dart';
import 'package:homework3/utils/style.dart';
import 'package:homework3/widgets/primary_button.dart';

import '../../../utils/Utilty.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // // Stream method to get a single "Contact Us" document from Firestore
  // Stream<ContactUs> _getContactUs() {
  //   return _firestore
  //       .collection('contact_us')
  //       .doc('contactInfo') // Assuming you have a single document with this ID
  //       .snapshots()
  //       .map((docSnapshot) {
  //     // Convert the Firestore document into a ContactUs object
  //     return ContactUs.fromFirestore(docSnapshot.data()!);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_contactus.jfif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(25),
              constraints: const BoxConstraints(maxWidth: BreakPoint.md),
              child: Column(
                children: [
                  const Text(
                    "Contact Us",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "If you have any questions, concerns, or feedback, we're here to help. Feel free to get in touch with us through the following methods:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  BootstrapRow(
                    children: const [
                      BootstrapCol(
                        sm: 12,
                        md: 6,
                        child: Column(
                          children: [
                            ContactCard(
                              icon: Icons.phone,
                              title: 'Phone',
                              content: '+1 555 123 4567',
                              subtitle: 'Available: 9AM - 6PM',
                            ),
                            ContactCard(
                              icon: Icons.email,
                              title: 'Email',
                              content: 'support@ss5reads.com',
                              subtitle: 'We respond within 24 hours',
                            ),
                            ContactCard(
                              icon: Icons.location_on,
                              title: 'Location',
                              content:
                                  'No. T01, National Road 2, Sangkat Chak Angrae Leu,Khan Mean Chey, Phnom Penh 120601, Cambodia.',
                              subtitle: 'Visit us for an in-store experience',
                            ),
                          ],
                        ),
                      ),
                      BootstrapCol(
                        sm: 12,
                        md: 6,
                        child: ContactForm(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactUs {
  final String telephone;
  final String telegram;
  final String location;
  ContactUs({
    required this.location,
    required this.telephone,
    required this.telegram,
  });

  // A method to convert Firestore data into a ContactUs object
  factory ContactUs.fromFirestore(Map<String, dynamic> data) {
    return ContactUs(
      telephone: data['telephone'] ?? '',
      telegram: data['telegram'] ?? '',
      location: data['location'] ?? '',
    );
  }
}

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final String subtitle;

  const ContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: Icon(icon, size: 30, color: Colors.black),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(content,
                    style: const TextStyle(fontSize: 15, color: Colors.white)),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      showTaost('Message sent successfully !');
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(6),
    );
    return Container(
      decoration: BoxDecoration(
        boxShadow: shadow,
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              "Send Message",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: border,
                enabledBorder: border,
                labelStyle: hintStyle(),
                errorBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.red)),
                focusedErrorBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.red)),
                focusedBorder: border,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Your Email',
                border: border,
                enabledBorder: border,
                errorBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.red)),
                focusedErrorBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.red)),
                labelStyle: hintStyle(),
                focusedBorder: border,
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Your Message',
                border: border,
                enabledBorder: border,
                labelStyle: hintStyle(),
                errorBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.red)),
                focusedErrorBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.red)),
                focusedBorder: border,
              ),
              maxLines: 5,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter your message' : null,
            ),
            const SizedBox(height: 16),
            CustomPrimaryButton(
              onPressed: _submitForm,
              textColor: Colors.white,
              textValue: 'Send Message',
            )
          ],
        ),
      ),
    );
  }
}
