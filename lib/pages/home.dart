import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_contact.dart';
import 'package:flutter_application_1/pages/edit_contact.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool isLoading = true;
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
        body: RefreshIndicator(
          onRefresh: fetchContact,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index] as Map;
              final id = item['id'] as int;
              return Slidable(
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) {
                        //edit
                        navigateToEditPage(item);
                      }),
                      backgroundColor: const Color(0xFFEBF8F6),
                      icon: Icons.edit,
                      foregroundColor: const Color(0xFFF2C94C),
                    ),
                    SlidableAction(
                      onPressed: ((context) {
                        //delete
                        deleteById(id);
                      }),
                      backgroundColor: const Color(0xFFEBF8F6),
                      icon: Icons.delete,
                      foregroundColor: const Color(0xFFFA0F0F),
                    ),
                  ],
                ),
                child: Padding(
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
                      trailing: Icon(
                        Icons.send,
                        color: const Color(0xFF32BAA5),
                      ),
                    )),
              );
            },
          ),
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

  void navigateToEditPage(Map item) {
    final route = MaterialPageRoute(
      builder: (context) => EditContactPage(update: item),
    );
    Navigator.push(context, route);
    setState(() {
      // isLoading = true;
    });
    fetchContact();
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(builder: (context) => AddContactPage());
    Navigator.push(context, route);
  }

  Future<void> deleteById(int id) async {
    //Delete the item
    final url = 'https://reqres.in/api/users/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    print(response.statusCode);
    if (response.statusCode == 204) {
      //Remove item from the list
      final filtered = data.where((element) => element['id'] != id).toList();
      setState(() {
        data = filtered;
      });
    } else {
      showErrorMessage('Deletion Failed');
    }
  }

  Future<void> fetchContact() async {
    setState(() {
      isLoading = false;
    });

    final url = 'https://reqres.in/api/users?page=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['data'] as List;
      setState(() {
        data = result;
      });
    }
    // else {
    //   showErrorMessage('Unable to sync contact');
    // }
    setState(() {
      isLoading = false;
    });
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
