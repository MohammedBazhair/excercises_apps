import 'package:flutter/material.dart';

class EmptyProductsState extends StatelessWidget {
  const EmptyProductsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No products found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
