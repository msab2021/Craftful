import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:lead_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationPage extends StatefulWidget {
  User user;

  OtpVerificationPage({super.key, required this.user});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {

  String otp = '';
  // Future<void> send_OTP() async {
  //   var response = await http.post(
  //     Uri.parse(API.send_otp),
  //     body: jsonEncode({
  //       'email': widget.user.email,
  //       'username':widget.user.name,
  //       'password':widget.user.password,
  //       'phone':widget.user.phone,
  //     },
  //     ),
  //     headers: {"Content-Type": "application/json"},
  //   );

  //   var data = jsonDecode(response.body);

  //   if (data['status'] == 'success') {
  //     Fluttertoast.showToast(msg: "OTP verified successfully.");
  //     Navigator.pushNamed(context, 'login');
  //   } else {
  //     Fluttertoast.showToast(msg: "Invalid OTP.");
  //   }
  // }

   Future<void> verify_OTP() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    var response = await http.post(
      Uri.parse(API.otp_verification),
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      Fluttertoast.showToast(msg: "OTP verified successfully.");
      Navigator.pushNamed(context, 'login');
          await prefs.remove('email');

    } else {
      Fluttertoast.showToast(msg: "Invalid OTP.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OtpTextField(
              numberOfFields: 6,
              borderColor: Colors.black,
              showFieldAsBox: true,
              onSubmit: (pin) {
                setState(() {
                  otp = pin; // Update the otp variable
                });
              },
            ),
            ElevatedButton(
              onPressed: verify_OTP,
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}