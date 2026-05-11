import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_off/admin_app/screens/admin_home_page.dart';
import 'package:test_off/core/services/auth_service.dart';
import 'package:test_off/core/widgets/custom_text_field.dart';
import 'package:test_off/user_app/screens/user_home_page.dart';
import 'package:test_off/user_app/widgets/password_field.dart';
import 'package:test_off/user_app/widgets/profile_submit_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.isAdmin = false});
  final bool isAdmin;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Widget get _homePage =>
      widget.isAdmin ? const AdminHomePage() : const UserHomePage();

  // دالة التعامل مع الردود (Snackbar) بتنسيق Premium
  void _showCustomSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.redAccent : Colors.indigo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showCustomSnackBar('Please fill all fields', true);
      return;
    }

    setState(() => _isLoading = true);
    final user = await AuthService().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (user != null) {
      if (!mounted) return;
      await _saveLoginState();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => _homePage),
      );
    } else {
      if (!mounted) return;
      _showCustomSnackBar('Login Failed. Check credentials.', true);
    }
  }

  void _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showCustomSnackBar('Please fill all fields', true);
      return;
    }

    setState(() => _isLoading = true);
    final user = await AuthService().register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      'New User',
    );
    setState(() => _isLoading = false);

    if (user != null) {
      if (!mounted) return;
      await _saveLoginState();
      _showCustomSnackBar('Account created successfully!', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => _homePage),
      );
    } else {
      if (!mounted) return;
      _showCustomSnackBar('Registration Failed.', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // ترويسة الصفحة بتصميم بسيط
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Login to manage your orders and profile',
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),

              const SizedBox(height: 50),

              // استخدام Custom Widgets الموحدة
              CustomTextField(
                label: "Email Address",
                hintText: "example@mail.com",
                icon: Icons.email_outlined,
                controller: _emailController,
              ),

              const SizedBox(height: 25),

              // حقل كلمة المرور (يمكنك تطوير الـ Custom Widget لدعم obscureText لاحقاً)
              PasswordField(
                controller: _passwordController,
                hint: "••••••••",
                label: "Password",
              ),

              const SizedBox(height: 40),

              // زر تسجيل الدخول Premium
              ProfileSubmitButton(
                title: 'Login',
                isLoading: _isLoading,
                onPressed: _login,
              ),

              const SizedBox(height: 20),

              // خيار التسجيل بتصميم نظيف
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : _register,
                  style: TextButton.styleFrom(foregroundColor: Colors.indigo),
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Color(0xFF64748B)),
                      children: [
                        TextSpan(
                          text: "Register Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
