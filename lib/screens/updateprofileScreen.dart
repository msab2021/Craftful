import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/global/global.dart';
import 'package:lead_app/main.dart';
import 'package:lead_app/models/user.dart';
import 'package:lead_app/screens/sign_up.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatefulWidget {
  final User user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formkey = GlobalKey<FormState>();

  Future<bool> updateProfileWithImage() async {
    String name = nameController.text;
    String email = emailController.text;
    String description = descriptionController.text;
    String phone = phoneController.text;
    String password = passwordController.text;

    // Convert the image to base64
    List<int> imageBytes = await _imageFile!.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    // Send a POST request to the PHP server with the updated data.
    var response = await http.post(
      Uri.parse(API.update_user), // replace with your actual URL
      body: {
        'id': widget.user.id.toString(),
        'name': name,
        'email': email,
        'description': description,
        'phone': phone,
        'password': password,
        'image': base64Image,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        // Update the user data in the app
        widget.user.name = name;
        widget.user.email = email;
        widget.user.password = password;
        widget.user.description = description;
        widget.user.phone = phone;

        widget.user.image = jsonResponse['image'];

        return true;
      }
    }
    return false;
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      // Save the image path in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', selectedImage.path);
    }
    setState(() {
      _imageFile = selectedImage;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    // Load the image from the saved path
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      _imageFile = XFile(imagePath);
    }
    setState(() {});
  }

  TextEditingController nameController =
      TextEditingController(text: prefs.getString('name'));
  TextEditingController emailController =
      TextEditingController(text: prefs.getString('email'));
  TextEditingController passwordController =
      TextEditingController(text: prefs.getString('password'));
  TextEditingController descriptionController =
      TextEditingController(text: prefs.getString('description'));
  TextEditingController phoneController =
      TextEditingController(text: prefs.getString('phone'));
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile",
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path)) as ImageProvider
                        : NetworkImage(API.images + widget.user.image)
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color.fromARGB(255, 94, 47, 47)),
                      child: IconButton(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        onPressed: _pickImage,
                        icon: const Icon(
                          LineAwesomeIcons.camera,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Form(
                child: Column(
                  children: [
                    NewWidget(
                      name: nameController,
                      icon: Icons.person,
                      text: const Text(
                        "Username",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      validate: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        } else if (value.length < 3) {
                          return 'Username must be at least 3 characters long';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 40 - 20),
                    NewWidget(
                      name: emailController,
                      icon: Icons.email,
                      text: const Text(
                        "Email",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      validate: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40 - 20),
                    NewWidget(
                      name: phoneController,
                      icon: Icons.phone,
                      text: const Text(
                        "Your phone number",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      validate: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40 - 20),
                    NewWidget(
                      name: descriptionController,
                      icon: Icons.description_outlined,
                      text: const Text(
                        "Your profile description here...",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      validate: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 40 - 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 35, right: 35),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        controller: nameController,
                        obscureText: _obscureText, // Add this line
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          label: const Text('Password'),
                          prefixIcon: Icon(
                            Icons.fingerprint,
                            color: Global.customColor(),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                              .hasMatch(value)) {
                            // Show an error message
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 40),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formkey.currentState!.validate()) {
                            bool success = await updateProfileWithImage();
                            if (success) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(
                                  "custID", widget.user.id.toString());
                              prefs.setString("name", widget.user.name);
                              prefs.setString("email", widget.user.email);
                              prefs.setString("phone", widget.user.phone);
                              prefs.setString(
                                  "description", widget.user.description);

                              prefs.setString("password", widget.user.password);
                              setState(() {});
                              Fluttertoast.showToast(
                                  msg:
                                      'User information was successfully updated');
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'An error occurred while updating your profile.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Edit Profile",
                            style: TextStyle(color: Colors.black87)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// const SizedBox(height: 40 - 20),
                    // NewWidget(
                    //   name: phone,
                    //   icon: Icons.phone,
                    //   text: const Text(
                    //     "Phone Number",
                    //     style: TextStyle(color: Colors.black),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),