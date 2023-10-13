import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_contact.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Contacts',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF32BAA5),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF32BAA5),
          onPressed: navigateToAddPage,
          label: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(builder: (context) => AddContactPage());
    Navigator.push(context, route);
  }
}
