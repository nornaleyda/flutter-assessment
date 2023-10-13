import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_contact.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List data = [];

  @override
  void initState() {
    super.initState();
    fetchContact();
  }

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
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                fetchContact();
                setState(() {});
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index] as Map;
            return Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 10.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        item['avatar'],
                      ),
                    ),
                  ),
                  title: Text(
                    '${item['first_name']} ${item['last_name']}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(item['email']),
                  trailing: Icon(Icons.send),
                ));
          },
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

  Future<void> fetchContact() async {
    final url = 'https://reqres.in/api/users?page=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['data'] as List;
      setState(() {
        data = result;
      });
    } else {
      // Show error
    }
    ;
  }
}
