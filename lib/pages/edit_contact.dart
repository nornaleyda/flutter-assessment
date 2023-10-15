import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditContactPage extends StatefulWidget {
  final Map? update;
  const EditContactPage({Key? key, this.update});

  @override
  State<EditContactPage> createState() => _EditContactPage();
}

class _EditContactPage extends State<EditContactPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  late String avatarUrl;

  @override
  void initState() {
    super.initState();
    final update = widget.update;
    final firstName = update!['first_name'];
    final lastName = update['last_name'];
    final email = update['email'];
    avatarUrl = update['avatar'];
    firstNameController.text = firstName;
    lastNameController.text = lastName;
    emailController.text = email;
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
          SizedBox(
            height: 40,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF32BAA5),
                  width: 5.0,
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
            height: 40,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: 50,
              child: TextField(
                controller: firstNameController,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: '  First Name',
                  labelStyle: const TextStyle(color: Color(0xFF32BAA5)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF32BAA5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF32BAA5)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: 50,
              child: TextField(
                controller: lastNameController,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: '  Last Name',
                  labelStyle: const TextStyle(color: Color(0xFF32BAA5)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF32BAA5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF32BAA5)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: 50,
              child: TextField(
                controller: emailController,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: '  Email',
                  labelStyle: const TextStyle(color: Color(0xFF32BAA5)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF32BAA5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFF32BAA5)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: 50,
              child: ElevatedButton(
                onPressed: updateContact,
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
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateContact() async {
    // Get the data from the form
    final update = widget.update;

    final id = update!['id'];
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;

    final body = {
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
    };

    // Submit data to the server
    final url = 'https://reqres.in/api/users/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri, body: jsonEncode(body));

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);

      showSuccessMessage('Contact updated');
    } else {
      print(response.statusCode);
      print(response.body);

      showErrorMessage('Contact failed to update');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
