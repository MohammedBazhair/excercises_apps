import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_off/user_app/screens/login_page.dart';
import 'firebase_options.dart';
import 'admin_app/screens/admin_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? AdminHomePage() : const LoginPage(isAdmin: true),
    ),
  );
}
