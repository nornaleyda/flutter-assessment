import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_contact.dart';
import 'package:flutter_application_1/pages/edit_contact.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final Map? update;
  const ProfilePage({Key? key, this.update});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late String avatarUrl;
  late String firstName;
  late String lastName;
  late String email;

  @override
  void initState() {
    super.initState();
    final update = widget.update;
    firstName = update!['first_name'];
    lastName = update['last_name'];
    email = update['email'];
    avatarUrl = update['avatar'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF32BAA5),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    if (widget.update != null) {
                      navigateToEditPage(widget.update!);
                    } else {
                      // Handle the case where widget.update is null, e.g., show an error message.
                    }
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: const Color(0xFF32BAA5)),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF32BAA5),
                  width: 5.0, // Border width
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: NetworkImage(avatarUrl),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${firstName} ${lastName}'),
                SizedBox(width: 10),
                Icon(
                  Icons.star_outline,
                  // color: Colors.yellow,
                  size: 30,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            color: Color(0xFFF1F1F1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center horizontally
              children: [
                Icon(
                  Icons.mail_outlined,
                  color: Colors.grey,
                  size: 40,
                ),
                SizedBox(
                    height: 10), // Add some spacing between the icon and text
                Text(
                  email,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // final Uri emailLaunchUri = Uri(
                  //   scheme: 'mailto',
                  //   path: 'smith@example.com',
                  //   query: encodeQueryParameters(<String, String>{
                  //     'subject': 'Example Subject & Symbols are allowed!',
                  //   }),
                  // );

                  // launchUrl(emailLaunchUri);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF32BAA5)),
                ),
                child: const Text(
                  'Send Email',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigateToEditPage(Map item) {
    final route = MaterialPageRoute(
      builder: (context) => EditContactPage(update: item),
    );
    Navigator.push(context, route);
  }
}
