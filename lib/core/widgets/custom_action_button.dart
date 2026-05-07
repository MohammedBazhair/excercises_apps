import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? backgroundColor;

  const CustomActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        // استخدام اللون المرر أو اللون الافتراضي (Slate 100)
        color: backgroundColor ?? const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        tooltip: tooltip,
        // استخدام لون الأيقونة المرر أو اللون الافتراضي (Slate 600)
        icon: Icon(
          icon,
          color: iconColor ?? const Color(0xff475569),
          size: 20, // حجم مناسب لأزرار العمليات في الجداول
        ),
        onPressed: onPressed,
        splashRadius: 24, // لجعل تأثير الضغطة متناسق مع حجم الزر
        hoverColor: (iconColor ?? Colors.indigo).withOpacity(0.05),
      ),
    );
  }
}
