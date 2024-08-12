// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/main.dart';
import 'package:lead_app/models/user.dart';
import 'package:lead_app/screens/UserProductsPage.dart';
import 'package:lead_app/screens/checkoutPage.dart';
import 'package:lead_app/screens/settings.dart';
import 'package:lead_app/screens/updateprofileScreen.dart';
import 'package:lead_app/widgets/profile_update.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:craftful1/screens/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profile extends StatefulWidget {
  User user;
  profile({super.key, required this.user});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  late File _image;
  ImageProvider? _icon;

  @override
  void initState() {
    super.initState();
    intialize();
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usern = prefs.getString("username");
    return usern;
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userp = prefs.getString("education");
    return userp;
  }

  // void intialize() async {
  //   var username = await getUsername();
  //   var email = await getEmail();
  //   setState(() {
  //     widget.user.name = username ?? "Not Set";
  //     widget.user.email = email ?? "Not Set";
  //   });
  // }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _icon = FileImage(_image);

      // Save the image path in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', pickedFile.path);
    } else {
      print('No image selected.');
    }

    setState(() {});
  }

  void intialize() async {
    var username = await getUsername();
    var email = await getEmail();

    // Load the image from the saved path
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      _image = File(imagePath);
      _icon = FileImage(_image);
    }

    setState(() {
      widget.user.name = username ?? "Not Set";
      widget.user.email = email ?? "Not Set";
    });
  }

  @override
  Widget build(BuildContext context) {
    var isdark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile',
              style: Theme.of(context).textTheme.headlineMedium),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                    isdark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon)),
            IconButton(
                onPressed: () async {
                  intialize();
                },
                icon: const Icon(Icons.refresh)),
          ],
          backgroundColor: const Color.fromARGB(255, 176, 198, 209),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Stack(
            children: [
              SizedBox(
                height: 170,
                child: CircleAvatar(
                    radius:
                        85, // Adjusted to half the height to keep it circular
                    backgroundImage:
                        _icon ?? NetworkImage(API.images + widget.user.image)
                    // AssetImage('assets/images/default_profile.png'),
                    // child: IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(LineAwesomeIcons
                    //       .camera), // Replace with your desired icon
                    //   iconSize: 24, // Adjust the icon size as needed
                    //   color: Colors.white, // Adjust the icon color as needed
                    // ),
                    ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () async {
                    await getImage();
                    setState(() {});
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromARGB(255, 65, 47, 53)),
                    child: const Icon(
                      LineAwesomeIcons.camera,
                      color: Color.fromARGB(255, 234, 229, 229),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(" ${prefs.getString('name')} ",
              style: const TextStyle(fontSize: 20)),
          Text(" ${prefs.getString('email')} ",
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),

          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => Get.to(() => UpdateProfileScreen(
                  user: User(
                      name: prefs.getString('name') ?? '',
                      password: prefs.getString('password') ?? '',
                      email: prefs.getString('email') ?? '',
                      description: prefs.getString('description') ?? '',
                      phone: prefs.getString('phone') ?? '',
                      status: prefs.getString('status') ?? '',
                      id: prefs.getString('custID') ?? '',
                      image: prefs.getString('image') ?? '',
                      role: prefs.getString('role') ?? ''))),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  side: BorderSide.none,
                  shape: const StadiumBorder()),
              child: const Text("Edit Profile",
                  style: TextStyle(color: Colors.black)),
            ),
          ),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 10),

          /// -- MENU
          ProfileMenuWidget(
              title: "Settings",
              icon: LineAwesomeIcons.cog,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => settings(
                            user: widget.user,
                          )),
                );
              }),
          ProfileMenuWidget(
              title: "Billing Details",
              icon: LineAwesomeIcons.wallet,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                            totalPrice: 0,
                            totalQuantity: 0,
                          )),
                );
              }),
          ProfileMenuWidget(
              title: "User Products",
              icon: LineAwesomeIcons.user_check,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProductsPage(
                            userId: prefs.getString('custID') ?? '',
                          )),
                );
              }),
          const Divider(),
          const SizedBox(height: 10),

          ProfileMenuWidget(
              title: "Logout",
              icon: LineAwesomeIcons.alternate_sign_out,
              textColor: Colors.red,
              endIcon: false,
              onPress: () {
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
                        backgroundColor: Colors.redAccent,
                        side: BorderSide.none),
                    child: const Text("Yes"),
                  ),
                  cancel: OutlinedButton(
                      onPressed: () => Get.back(), child: const Text("No")),
                );
              }),
        ])));
  }
}
