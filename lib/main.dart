import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lead_app/components/cart_provider.dart';
import 'package:lead_app/components/favorite_provider.dart';
import 'package:lead_app/models/user.dart';
import 'package:lead_app/screens/AboutUs.dart';
import 'package:lead_app/screens/cart_page.dart';
import 'package:lead_app/screens/login.dart';
import 'package:lead_app/screens/result.dart';
import 'package:lead_app/screens/admin_page.dart'; // Import your admin page
import 'package:lead_app/screens/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  String role = prefs.getString("role").toString();

   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider<Favorite>(
          create: (context) => Favorite(),
        ),
      ],
      child: MyApp(role: role),
    ),
  );
}


class MyApp extends StatelessWidget {
  final String role;

  const MyApp({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: GetMaterialApp(
        theme: ThemeData.light(), // Light theme
        darkTheme: ThemeData.dark(), // Dark theme
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        title: "Flutter App",
        initialRoute: prefs.getString("custID") == null
            ? "login"
            : (role == "admin" ? "admin" : "home"),
        routes: {
          "login": (context) => screenA(
                user: User(
                    email: prefs.getString('email') ?? '',
                    name: prefs.getString('name') ?? '',
                    password: prefs.getString('password') ?? '',
                    description: prefs.getString('description') ?? '',
                    phone: prefs.getString('phone') ?? '',
                    status: prefs.getString('status') ?? '',
                    id: prefs.getString('custID') ?? '',
                    image: prefs.getString('image') ?? '',
                    role: prefs.getString('role') ?? ''),
              ), // Replace with your login page
          "home": (context) => result(
              user: User(
                  email: prefs.getString('email') ?? '',
                  name: prefs.getString('name') ?? '',
                  password: prefs.getString('password') ?? '',
                  status: prefs.getString('status') ?? '',
                  description: prefs.getString('description') ?? '',
                  phone: prefs.getString('phone') ?? '',
                  id: prefs.getString('custID') ?? '',
                  image: prefs.getString('image') ?? '',
                  role: prefs.getString('role') ?? '')),
          "admin": (context) => AdminPage(
              user: User(
                  // Replace with your admin page
                  email: prefs.getString('email') ?? '',
                  name: prefs.getString('name') ?? '',
                  password: prefs.getString('password') ?? '',
                  description: prefs.getString('description') ?? '',
                  phone: prefs.getString('phone') ?? '',
                  status: prefs.getString('status') ?? '',
                  id: prefs.getString('custID') ?? '',
                  image: prefs.getString('image') ?? '',
                  role: prefs.getString('role') ?? '')),
                  "settings": (context) => settings(user: User(
                  // Replace with your admin page
                  email: prefs.getString('email') ?? '',
                  name: prefs.getString('name') ?? '',
                  password: prefs.getString('password') ?? '',
                  description: prefs.getString('description') ?? '',
                  phone: prefs.getString('phone') ?? '',
                  status: prefs.getString('status') ?? '',
                  id: prefs.getString('custID') ?? '',
                  image: prefs.getString('image') ?? '',
                  role: prefs.getString('role') ?? '')),
                  "cart": (context) => const CartPage(),
                  "about": (context) => const AboutUsPage(),
        },
      ),
    );
  }
}
