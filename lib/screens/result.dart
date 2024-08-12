// ignore_for_file: must_be_immutable, camel_case_types

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lead_app/screens/cart_page.dart';
import 'package:lead_app/screens/fav_page.dart';
// import 'package:craftful1/models/products.dart';
// import 'package:craftful1/screens/news.dart';
// import 'package:craftful1/screens/pro_screen.dart';
import 'package:lead_app/screens/profile.dart';
import 'package:lead_app/screens/service.dart';
import 'package:lead_app/models/user.dart';

class result extends StatefulWidget {
  User user;
  // products product;
  result({
    super.key,
    required this.user,
  });

  @override
  State<result> createState() => _resultState();
}

class _resultState extends State<result> {
  int value = 0;

  void onValueChanged(int newValue) {
    setState(() {
      value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      // const postData(),

      // proscreen(),

      service(
        user: widget.user,
      ),
      // settings(),
      const CartPage(),
      const FavoritesPage(),
      profile(user: widget.user),
    ];

    return Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: const Text("Home:", style: TextStyle(color: Colors.white)),
        //   backgroundColor: Global.customColor(),
        //   centerTitle: true,

        body: screens[value],
        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          height: 50.0,
          items: const <Widget>[
            Icon(
              Icons.home,
              size: 30,
              color: Colors.blue,
            ),
            Icon(
              Icons.shopping_cart,
              size: 30,
              color: Color.fromARGB(255, 208, 134, 24),
            ),
            Icon(
              Icons.favorite,
              size: 30,
              color: Color.fromARGB(255, 187, 10, 33),
            ),
            Icon(
              Icons.person,
              size: 30,
              color: Color.fromRGBO(213, 239, 16, 1),
            ),
          ],
          color: const Color.fromARGB(255, 245, 243, 243),
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          animationCurve: Curves.linear,
          animationDuration: const Duration(milliseconds: 500),
          onTap: onValueChanged,
        ));
  }
}
