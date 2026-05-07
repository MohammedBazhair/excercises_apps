import 'package:flutter/material.dart';
import 'package:test_off/core/models/user_model.dart';

class ProfileAvatar extends StatelessWidget {
  final UserModel? userModel;
  const ProfileAvatar({super.key,required this.userModel});

  @override
  Widget build(BuildContext context) {
    if(userModel==null) return const Center(child: Text('User not found'));
    return Center(
      child: Column(
        spacing: 15,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.indigo.withOpacity(0.1),
                  child: Text(
                    userModel!.name.substring(0,2).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(userModel!.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(userModel!.email, style: const TextStyle(fontSize: 13, color: Colors.indigo)),
        ],
      ),
    );
  }
}
