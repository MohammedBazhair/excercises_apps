import 'package:flutter/material.dart';
import '../../models/user.dart';

class DisplayPage extends StatelessWidget {
  final User user;
  const DisplayPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 20),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE0E7FF),
                child: Icon(Icons.person, size: 50, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(height: 20),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 40),
              _buildInfoRow(Icons.email, "البريد", user.email),
              const SizedBox(height: 15),
              _buildInfoRow(Icons.phone, "الهاتف", user.phone),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 15),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }
}
