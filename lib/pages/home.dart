import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_contact.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool isLoading = true;
  bool showFavoritesOnly = false;

  List data = [];
  List filteredData = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchContact();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
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
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                fetchContact();
                setState(() {});
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Color(0xFFE5E5E5),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                    filterContacts(query);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '  Search Contact',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showFavoritesOnly = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: !showFavoritesOnly
                            ? Color(0xFF32BAA5)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    child: Text(
                      "All",
                      style: TextStyle(
                          color:
                              showFavoritesOnly ? Colors.grey : Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showFavoritesOnly = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: showFavoritesOnly
                            ? Color(0xFF32BAA5)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    child: Text(
                      "Favorite",
                      style: TextStyle(
                          color:
                              showFavoritesOnly ? Colors.white : Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: fetchContact,
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final item = filteredData[index] as Map;
                    final id = item['id'] as int;
                    return Column(
                      children: [
                        Slidable(
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: ((context) {
                                  //edit
                                  navigateToProfilePage(item);
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
                                trailing: IconButton(
                                  onPressed: () {
                                    provider.toggleFavorite(id);
                                  },
                                  icon: provider.isExist(id)
                                      ? Icon(Icons.star, color: Colors.yellow)
                                      : Icon(Icons.star_outline,
                                          color: const Color(0xFF32BAA5)),
                                ),
                              )),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
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

  void filterContacts(String query) {
    setState(() {
      final trimmedQuery = query.trim();
      if (trimmedQuery.isEmpty) {
        if (showFavoritesOnly) {
          // Show only favorite contacts
          filteredData = data.where((item) => item['isFavorite']).toList();
        } else {
          // Show all contacts
          filteredData = List.from(data);
        }
      } else {
        filteredData = data
            .where((item) => [
                  item['first_name'],
                  item['last_name'],
                  '${item['first_name']} ${item['last_name']}',
                ].any((name) =>
                    name.toLowerCase().contains(trimmedQuery.toLowerCase())))
            .toList();
        if (showFavoritesOnly) {
          filteredData =
              filteredData.where((item) => item['isFavorite']).toList();
        }
      }
    });
  }

  void navigateToProfilePage(Map item) {
    searchController.clear();

    final route = MaterialPageRoute(
      builder: (context) => ProfilePage(update: item),
    );
    Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchContact();
  }

  void navigateToAddPage() {
    searchController.clear();

    final route = MaterialPageRoute(builder: (context) => AddContactPage());
    Navigator.push(context, route);
  }

  Future<void> deleteById(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Are you sure you want to delete this contact?',
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Colors.white, width: 2.0),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // Delete the contact
                    final url = 'https://reqres.in/api/users/$id';
                    final uri = Uri.parse(url);
                    final response = await http.delete(uri);
                    print(response.statusCode);
                    print(id);
                    if (response.statusCode == 204) {
                      final filtered =
                          data.where((element) => element['id'] != id).toList();
                      setState(() {
                        filteredData = filtered;
                      });
                    } else {
                      showErrorMessage('Deletion Failed');
                    }
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Color(0xFF32BAA5)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchContact() async {
    setState(() {
      isLoading = true;
    });

    final url = 'https://reqres.in/api/users?page=1';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['data'] as List;
      setState(() {
        data = result;
        filteredData = result; // Initialize filteredData with the same data
      });
    } else {
      showErrorMessage('Unable to sync contact');
    }
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
