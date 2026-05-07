import 'package:flutter/material.dart';
import 'package:test_off/core/models/user_model.dart';
import 'package:test_off/core/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
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
        const SnackBar(content: Text('Profile updated successfully')));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: TextEditingController(text: _user?.email),
            decoration: const InputDecoration(labelText: 'Email (Read Only)'),
            readOnly: true,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateProfile,
            child: const Text('Update Profile'),
          ),
        ],
      ),
    );
  }
}
