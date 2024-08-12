import 'package:flutter/material.dart';
import 'package:lead_app/models/user.dart';
import 'package:lead_app/screens/admin_productList.dart';
import 'package:lead_app/screens/admin_userList.dart';

class AdminPage extends StatefulWidget {
  User user;
  AdminPage({super.key, required this.user});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ScreenOne(),
    const ScreenTwo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('login');
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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Screen One',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Screen Two',
          ),
        ],
      ),
    );
  }
}
