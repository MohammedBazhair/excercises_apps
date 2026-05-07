import 'package:flutter/material.dart';
import 'user_products_page.dart';
import 'user_orders_page.dart';
import 'profile_page.dart';
import 'package:test_off/core/services/auth_service.dart';
import 'login_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const UserProductsPage(),
    const UserOrdersPage(),
    const ProfilePage(),
  ];

  void _logout() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color(0xffF8FAFC),

        title: const Text('Customer App'),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      backgroundColor: const Color(0xffF8FAFC),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
      backgroundColor: const Color(0xFFFFFFFF),

        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'My Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
