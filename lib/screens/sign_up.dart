// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/models/user.dart';
// import 'package:craftful1/models/products.dart';
import 'package:lead_app/screens/login.dart';
// import 'package:craftful1/widgets/color_hex.dart';
import 'package:lead_app/global/global.dart';
import 'package:http/http.dart' as http;
import 'package:lead_app/screens/verifyOTP.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  final User user;
  const signup({
    super.key,
    required this.user,
  });

  @override
  State<signup> createState() => _singUpState();
}

class _singUpState extends State<signup> {
  bool isLoading = false;
  GlobalKey<FormState> formstate = GlobalKey();
  // Crud _crud = Crud();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  // TextEditingController confirmPassword = TextEditingController();
  // late FocusNode _focusNode;

  Future<void> send_OTP() async {
    var response = await http.post(
      Uri.parse(API.send_otp),
      body: jsonEncode({
        'email': emailController.text.trim(),
        'username': nameController.text.trim(),
        'password': passwordController.text.trim(),
        'phone': phoneController.text.trim(),
      }),
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      Fluttertoast.showToast(msg: "OTP sent to email.");
      setState(() {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 700),
                pageBuilder: (_, __, ___) => OtpVerificationPage(
                      user: widget.user,
                    ),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                }));
      });
    } else {
      Fluttertoast.showToast(msg: "Error sending OTP.");
    }
  }

  signup() async {
    isLoading = true;
    try {
      if (nameController.text.trim().isEmpty) {
        Fluttertoast.showToast(msg: "Username is required.");
        return;
      }

      if (emailController.text.trim().isEmpty) {
        Fluttertoast.showToast(msg: "Email is required.");
        return;
      }
      if (emailController.text.trim().isEmail == false) {
        Fluttertoast.showToast(msg: "Please Enter a valid Email.");
        return;
      }

      if (passwordController.text.trim().isEmpty) {
        Fluttertoast.showToast(msg: "Password is required.");
        return;
      }
      if (passwordController.text.trim().length < 6) {
        Fluttertoast.showToast(msg: "Password must be at least 6 characters.");
        return;
      }
      if (phoneController.text.trim().isEmpty) {
        Fluttertoast.showToast(msg: "Phone number is required.");
        return;
      }
      if (phoneController.text.trim().length < 8) {
        Fluttertoast.showToast(
            msg: "Phone number must be at least 8 characters.");
        return;
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
    var checkEmailResponse = await http.post(
      Uri.parse(API.singUpUser),
      body: jsonEncode({
        'email': emailController.text,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (checkEmailResponse.statusCode == 200) {
      String responseBody = checkEmailResponse.body;
      if (responseBody.contains("exists")) {
        Fluttertoast.showToast(msg: "Email already exists.");
        return;
      }
    } else {
      Fluttertoast.showToast(msg: "Failed to check email existence.");
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', emailController.text);

    setState(() {
      isLoading = false;
      User newUser = User(
        id: '',
        description: '',
        image: '',
        status: '',
        role: '',
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        phone: phoneController.text,
      );
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) => OtpVerificationPage(
            user: newUser,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
    await send_OTP();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 225, 224, 241),
        body: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: ListView(children: [
                const SizedBox(
                  height: 150,
                  width: 150,
                ),
                const Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Padding(padding: EdgeInsets.all(16)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                Form(
                  key:
                      formstate, // GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter your username',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Global.customColor(),
                            ),
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(8)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter your email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Global.customColor(),
                            ),
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                          validator: (value) {
                            Pattern pattern =
                                r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
                            RegExp regex = RegExp(pattern.toString());
                            if (!regex.hasMatch(value!)) {
                              return 'Enter a valid email';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(8)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter your phone number',
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Global.customColor(),
                            ),
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                          // validator: (value) {
                          //   Pattern pattern =
                          //       r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
                          //   RegExp regex = new RegExp(pattern.toString());
                          //   if (!regex.hasMatch(value!))
                          //     return 'Enter a valid email';
                          //   else
                          //     return null;
                          // },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          validator: (value) {
                            Pattern pattern =
                                r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                            RegExp regex = RegExp(pattern.toString());
                            if (!regex.hasMatch(value!)) {
                              return 'Invalid password';
                            } else {
                              return null;
                            }
                          },
                          controller: passwordController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter your password',
                            prefixIcon: Icon(
                              Icons.password,
                              color: Global.customColor(),
                            ),
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                ))),
                      ]),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(300, 50)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Global.customColor()),
                            ),
                            onPressed: () async {
                              if (formstate.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Processing Data')),
                                );
                                await signup();
                              }
                            },
                            child: const Text('Sign Up',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 255, 255, 255))),
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 700),
                                    pageBuilder: (_, __, ___) => screenA(
                                      user: widget.user,
                                      // product: widget.product,
                                    ),
                                    transitionsBuilder:
                                        (_, animation, __, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                'Already have an account? Sign In',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ])));
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.name,
    required this.icon,
    required this.text,
    required this.validate,
  });

  final TextEditingController name;
  final IconData icon;
  final Text text;
  final String? Function(String?) validate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        // focusNode: _focusNode,
        controller: name,
        validator: validate,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          // labelText: text,
          label: text,
          prefixIcon: Icon(
            icon,
            color: Global.customColor(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }
}
