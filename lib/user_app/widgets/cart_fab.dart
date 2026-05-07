import 'package:flutter/material.dart';

class CartFAB extends StatelessWidget {
  final int cartItemCount;
  final VoidCallback onPressed;

  const CartFAB({
    super.key,
    required this.cartItemCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      elevation: 4,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // زوايا منحنية عصرية
      ),
      child: Stack(
        clipBehavior: Clip.none, // للسماح للـ Badge بالخروج قليلاً عن حدود الزر
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 26,
          ), // أيقونة أرق وأكثر احترافية
          if (cartItemCount > 0)
            Positioned(
              right: -8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xffEF4444), // أحمر حيوي (Vivid Red)
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ), // إطار أبيض يفصل الـ Badge عن الزر
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Center(
                  child: Text(
                    '$cartItemCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
