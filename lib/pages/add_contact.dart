import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPage();
}

class _AddContactPage extends State<AddContactPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Contact',
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
            height: 10,
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
                  labelText: 'First Name',
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
            height: 10,
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
                  labelText: 'Last Name',
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
            height: 10,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: 50,
              child: ElevatedButton(
                onPressed: submitContact,
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
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitContact() async {
    //Get the data from form
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final body = {
      "name": firstName,
      "firstname": lastName,
    };
    //submit data to the server
    final url = 'https://reqres.in/api/users';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: jsonEncode(body));

    if (response.statusCode == 201) {
      firstNameController.text = '';
      lastNameController.text = '';

      showSuccessMessage('Contact created');
    } else {
      showErrorMessage('Contact failed');
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
