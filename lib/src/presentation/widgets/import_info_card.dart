import 'package:flutter/material.dart';

class ImportInfoCard extends StatelessWidget {
  const ImportInfoCard({
    super.key,
    this.icon = Icons.file_present_outlined,
    required this.message,
    this.backgroundColor = Colors.white,
    this.borderRadius = 16,
  });

  final IconData icon;
  final String message;
  final Color backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
