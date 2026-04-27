import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/premium_button.dart';
import 'display_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  void goToDisplayPage() {
    if (nameController.text.isEmpty) return; // إضافة تحقق بسيط
    final user = User(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DisplayPage(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "مرحباً بك،",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Text(
                  "يرجى إدخال البيانات المطلوبة للمتابعة",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: nameController,
                  label: 'الاسم الكامل',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: emailController,
                  label: 'البريد الإلكتروني',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: phoneController,
                  label: 'رقم الهاتف',
                  icon: Icons.phone_android_outlined,
                ),
                const SizedBox(height: 40),
                PremiumButton(
                  onPressed: goToDisplayPage,
                  text: 'حفظ وعرض البيانات',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
