import 'package:flutter/material.dart';
import 'package:test_off/core/models/user_model.dart';
import 'package:test_off/core/services/auth_service.dart';
import 'package:test_off/core/widgets/custom_text_field.dart';
import 'package:test_off/user_app/widgets/profile_avatar.dart';
import 'package:test_off/user_app/widgets/profile_submit_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController(); // فصلناه لتنظيم أفضل
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final user = await AuthService().getCurrentUser();
    if (user != null) {
      setState(() {
        _user = user;
        _nameController.text = user.name;
        _addressController.text = user.address;
        _emailController.text = user.email;
        _isLoading = false;
      });
    }
  }

  void _updateProfile() async {
    if (_user == null) return;
    setState(() => _isLoading = true);

    final updatedUser = UserModel(
      uid: _user!.uid,
      name: _nameController.text.trim(),
      email: _user!.email,
      address: _addressController.text.trim(),
    );

    await AuthService().updateUser(updatedUser);

    setState(() {
      _user = updatedUser;
      _isLoading = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
              child: Column(
                children: [
                  ProfileAvatar(userModel: _user),
                  const SizedBox(height: 40),

                  CustomTextField(
                    label: "Full Name",
                    hintText: "Enter your name",
                    icon: Icons.person_outline_rounded,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: "Delivery Address",
                    controller: _addressController,
                    icon: Icons.location_on_outlined,

                    hintText: "Enter your full address",
                  ),

                  const SizedBox(height: 30),

                  ProfileSubmitButton(
                    isLoading: _isLoading,
                    onPressed: _updateProfile,
                  ),
                ],
              ),
            ),
    );
  }
}
