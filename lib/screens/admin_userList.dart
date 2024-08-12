// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:lead_app/screens/User_detils_Page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  List<User>? users;
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse(API.get_users));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'success') {
        List<dynamic> userData = jsonResponse['data'];
        setState(() {
          users = userData
              .map((item) => User.fromJson(item))
              .where((user) => user.role != 'admin')
              .toList();
        });
      } else {
        throw Exception(
            'Failed to load users from server: ${jsonResponse['error']}');
      }
    } else {
      throw Exception('Failed to load users from server.');
    }
  }

  Future<void> handleDelete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      throw Exception('No users selected');
    }

    var response = await http.post(
      Uri.parse(API.delete_user),
      body: {
        'user_id': userId,
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // Fluttertoast.showToast(
      //   msg: jsonResponse['status'],
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
      await prefs.remove('user_id');
      setState(() {
        print('Status: ${jsonResponse['status']}');
      });
    } else {
      throw Exception('Failed to delete users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchUsers,
      child: ListView.builder(
        itemCount: users?.length ?? 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailPage(user: users![index]),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(users![index].name),
                subtitle: Text(users![index].email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString(
                            'user_id', users![index].id.toString());
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // Store the BuildContext in a separate variable
                            final BuildContext dialogContext = context;

                            return AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text(
                                  'Are you sure you want to delete this user?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () async {
                                    await handleDelete();
                                    Navigator.of(dialogContext).pop();
                                    setState(() {
                                      Fluttertoast.showToast(
                                        msg: 'User deleted successfully',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
