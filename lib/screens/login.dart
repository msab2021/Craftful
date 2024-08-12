import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/components/crud.dart';
import 'package:lead_app/main.dart';
import 'package:lead_app/screens/admin_page.dart';
// import 'package:craftful1/models/products.dart';
import 'package:lead_app/screens/sign_up.dart';
import 'package:lead_app/global/global.dart';
import 'package:lead_app/models/user.dart';
import 'package:lead_app/widgets/show_in.dart';
import 'package:lead_app/screens/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types, must_be_immutable
class screenA extends StatefulWidget {
  User user;

  // products product;
  screenA({
    super.key,
    required this.user,
  });

  @override
  State<screenA> createState() => _screenAState();
}

// ignore: camel_case_types
class _screenAState extends State<screenA> {
  GlobalKey<FormState> formState = GlobalKey();
  Crud crud = Crud();
  bool isLoading = false;
  // bool loggedIn = false;

  login() async {
    isLoading = true;
    setState(() {});
    var response = await crud.postRequest2(
        API.loginUser, {"email": email.text, "password": password.text});
    isLoading = false;
    setState(() {});
    if (response['status'] == "success") {
      var data = response['data'][0];
      User user = User(
        id: data['custID'].toString(),
        name: data['username'],
        email: data['email'],
        description: data['description'],
        phone: data['phone'].toString(),
        password: data['password'],
        status: response['status'],
        image: data['image'],
        role: data['role'],
      );

      prefs.setString("custID", data['custID'].toString());
      prefs.setString("name", data['username']);
      prefs.setString("email", data['email']);
      prefs.setString("description", data['description']);
      prefs.setString("phone", data['phone'].toString());
      prefs.setString("password", data['password']);
      prefs.setString("status", response['status']);
      prefs.setString("image", data['image']);
      prefs.setString("role", data['role']);

      // loggedIn = true;

      if (user.role == "user") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => result(
                  user: user, // Pass the User instance to the result page
                )));
      } else if (user.role == "admin") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AdminPage(user: user,
                // Pass the User instance to the admin page
                )));
      }

      Fluttertoast.showToast(msg: "Welcome.");
    } else {
      Fluttertoast.showToast(msg: "Email or password are incorrect.");
    }
  }

  get p => null;

  Future<void> setUsername(String name) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    var usern = p.setString("username", name);
  }

  Future<void> setPassword(int pass) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    var userp = p.setInt("password", pass);
  }

  Future<String?> getUsername() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    var usern = p.getString("username");
    return usern;
  }

  Future<int?> getPassword() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    var userp = p.getInt("password");
    return userp;
  }

  // Future<void> setEducation(String education) async {
  //   SharedPreferences p = await SharedPreferences.getInstance();
  //   var userp = p.setString("education", education);
  // }

  Future<String?> getEducation() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    var userp = p.getString("education");
    return userp;
  }

  bool isObscure = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isEyeActive = false;

  @override
  Widget build(BuildContext context) {
    // List<Map<String, dynamic>> userss = [
    //   {'username': 'taleb', 'pass': 12345, 'id': 1},
    //   {'username': 'nour', 'pass': 12345, 'id': 2},
    //   {'username': 'Amal', 'pass': 12345, 'id': 3},
    //   {'username': 'Mohamd', 'pass': 12345, 'id': 4},
    //   {'username': 'Ahamad', 'pass': 12345, 'id': 5},
    // ];

    //   User(
    //     id: 124,
    //     username: "Amina",
    //     password: "amina",
    //     education: "MIS",
    //     isActive: false,
    //     image: const AssetImage(
    //       "assets/images/hhhh.jpg",
    //     ),
    //   ),
    //   User(
    //       id: 125,
    //       username: "Rayan",
    //       password: "rayan",
    //       education: "CS",
    //       isActive: true,
    //       image: const AssetImage(
    //         "assets/images/hhhh.jpg",
    //       )),
    // ];

    return isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 225, 224, 241),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title:
                  const Text("Welcome", style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .15,
                  ),
                  SizedBox(
                    child: Image.asset(
                      "assets/images/craftful2 (2).png",
                      height: MediaQuery.of(context).size.height * .3,
                      // repeat: ImageRepeat.repeatY,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 0, top: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Welcome to our app",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: AutofillHints.language,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    width: double.infinity,
                    child: const Text("Create your new account",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 176, 157, 157))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: email,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter your username',
                        // suffixIcon: Icon(
                        //   Icons.person,
                        //   color: Global.customColor(),
                        // ),
                        border: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          isEyeActive = value.isNotEmpty;
                        });
                      },
                      controller: password,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Enter your Password',
                        suffixIcon: isEyeActive
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                icon: isObscure
                                    ? const Icon(Icons.remove_red_eye)
                                    : const Icon(Icons.visibility_off_sharp))
                            : null,
                      ),
                      obscureText: isObscure,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(250, 50),
                        backgroundColor: Global.customColor(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        if (email.text.isEmpty || password.text.isEmpty) {
                          showinDialog(
                              context, "Error", "You have to fill the fields");
                          return;
                        } // print(name.text);
                        // loggedIn = false;
                        await login();
                        // for (User u in users) {
                        //   if (u.username.toLowerCase() == name.text.toLowerCase() &&
                        //       u.password == password.text) {
                        //     if (u.isActive) {
                        //       setUsername(u.username);
                        //       setPassword(u.password.hashCode);
                        //       loggedIn = true;
                        //       Navigator.pushReplacement(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: ((context) => result(
                        //                     user: u,
                        //                     // product: widget.product,
                        //                   ))));
                        //       break;
                        //     } else {
                        //       showinDialog(
                        //           context, "Activate", "Activate your account");
                        //       return;
                        //     }
                        //   }
                        // }
                        //   if (!loggedIn) {
                        //     showinDialog(context, "Login Failed",
                        //         "username or password are incorrect");
                        //   }
                      },
                      child: const Text("login",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      autofocus: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 700),
                            pageBuilder: (_, __, ___) => signup(
                              user: widget.user,
                              // product: widget.product,
                            ),
                            transitionsBuilder: (_, animation, __, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        "You don't have an account? Sign up now!",
                        style: TextStyle(color: Global.customColor()),
                      )),

                  // Image.network("https://i.pravatar.cc/200")
                ],
              ),
            ),
          );
  }
}
