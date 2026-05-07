import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData icon;
  final bool isNumber;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.hintText,
    this.isNumber = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // تسمية الحقل العلوي بستايل هادئ
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff64748B), // Slate 500
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          style: const TextStyle(fontSize: 15, color: Color(0xff1E293B)),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xffCBD5E1), fontSize: 14),
            prefixIcon: Icon(icon, size: 20, color: const Color(0xff94A3B8)),
            filled: true,
            fillColor: const Color(0xffF8FAFC), // خلفية خفيفة جداً للويب
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18, // زيادة الارتفاع قليلاً ليعطي شعور الـ Premium
            ),
            // الحدود الافتراضية
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffE2E8F0)),
            ),
            // الحدود عند عدم التفاعل
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffE2E8F0)),
            ),
            // الحدود عند التركيز (Focus)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.indigo, width: 2),
            ),
            // التفاعل عند تمرير الماوس (Hover)
            hoverColor: Colors.indigo.withOpacity(0.02),
          ),
        ),
      ],
    );
  }
}
