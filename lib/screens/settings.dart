import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lead_app/main.dart';
import 'package:lead_app/models/user.dart';
import 'package:lead_app/screens/updateprofileScreen.dart';
import 'package:lead_app/widgets/dark_mode.dart';

class settings extends StatefulWidget {
  User user;
  settings({super.key, required this.user});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          ListTile(
            leading: const Icon(Icons.person_2_outlined),
            title: const Text('Go to Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProfileScreen(user: widget.user),
                ),
              );
            },
          ),
          Obx(
            () => Container(
              color: themeController.isDarkMode.value
                  ? Colors.black
                  : Colors.white,
              child: ListTile(
                leading: const Icon(Icons.brightness_4),
                title: const Text('Dark Mode'),
                onTap: themeController.changeTheme,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Get.defaultDialog(
                title: "LOGOUT",
                titleStyle: const TextStyle(fontSize: 20),
                content: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text("Are you sure, you want to Logout?"),
                ),
                confirm: ElevatedButton(
                  onPressed: () {
                    prefs.clear();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("login", (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, side: BorderSide.none),
                  child: const Text("Yes"),
                ),
                cancel: OutlinedButton(
                    onPressed: () => Get.back(), child: const Text("No")),
              );
            },
          ),
        ]));
  }
}
