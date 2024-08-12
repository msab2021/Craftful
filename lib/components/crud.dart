import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lead_app/models/user.dart';

class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error with status code ${response.statusCode}");
      }
    } catch (e) {
      print("Error with message $e");
    }
  }

  Future<User?> postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        if (responsebody['status'] == 'success') {
          var user = responsebody['user'];
          if (user is Map<String, dynamic>) {
            var id = user['custID'];
            var name = user['name'];
            var email = user['email'];
            var description = user['description'];
            var phone = user['phone'];
            var password = user['password'];
            var status = responsebody['status'];
            var role = user['role'];
            var image = user['image'];

            if (name == null ||email == null ||password == null ||status == null ||role == null ||id == null) {
              print('Error: One or more fields are null');
              return null;
            }

            return User(
              name: name,
              email: email,
              password: password,
              description: description,
              phone: phone,
              status: status, 
              id: id,
              image: image,
              role: role,

            );
          } else {
            print("Error: user is not a Map");
            return null;
          }
        } else {
          print("Error: ${responsebody['status']}");
          return null;
        }
      } else {
        print("Error with status code ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error with message $e");
      return null;
    }
  }

  postRequest2(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);

        return responsebody;
      } else {
        print("Error with status code ${response.statusCode}");
      return null;}
      
    } catch (e) {
      print("Error with message $e");
      return null;
    }
  }
}
