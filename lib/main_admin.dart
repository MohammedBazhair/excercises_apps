import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'admin_app/screens/admin_home_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const MaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      home: AdminHomePage(), 
    ),
  );
}
