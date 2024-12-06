import 'package:flutter/material.dart';



class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liên hệ'), // Set the app bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Information with Icons
            ListTile(
              leading: Icon(Icons.phone), // Phone icon
              title: Text('+1234567890'), // Phone number
            ),
            ListTile(
              leading: Icon(Icons.email), // Email icon
              title: Text('example@example.com'), // Email address
            ),
            ListTile(
              leading: Icon(Icons.location_on), // Location icon
              title: Text('123 Street, City, Country'), // Address
            ),
            // Add more ListTile widgets for additional contact information
          ],
        ),
      ),
    );
  }
}
