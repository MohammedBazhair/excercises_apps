import 'package:flutter/material.dart';

class ProductsActionBar extends StatelessWidget {
  final VoidCallback onImport;
  final VoidCallback onSave;

  const ProductsActionBar({
    super.key,
    required this.onImport,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر الاستيراد من Excel
          ElevatedButton.icon(
            onPressed: onImport,
            style:
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  elevation: 0, // ليتماشى مع ستايل الويب الحديث
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ).copyWith(
                  // إضافة تأثير عند تمرير الماوس
                  overlayColor: WidgetStateProperty.all(
                    Colors.white.withOpacity(0.1),
                  ),
                ),
            icon: const Icon(Icons.upload_file_rounded),
            label: const Text(
              'Import Excel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 12),

          // زر الحفظ في Firebase
          OutlinedButton.icon(
            onPressed: onSave,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              side: const BorderSide(color: Colors.indigo, width: 1.5),
            ),
            icon: const Icon(Icons.cloud_upload_rounded, color: Colors.indigo),
            label: const Text(
              'Save to Firebase',
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
