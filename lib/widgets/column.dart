import 'package:flutter/material.dart';
import 'package:lead_app/global/global.dart';
import 'package:lead_app/models/user.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Global.customColor(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text("welcome ${widget.user.email}",
                        style: Global.setStyle(Colors.black)),
                  ),
                  Center(child: Text("id ${widget.user.name}"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
