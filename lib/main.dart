import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:test_off/excel_product_page.dart';

/// يسمح للمستخدم باختيار ملف Excel من الجهاز
/// يعيد مسار الملف (path) أو null في حال الإلغاء
Future<String?> pickExcelFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'], // السماح فقط بملفات Excel
  );

  if (result == null) return null; // المستخدم ألغى الاختيار

  return result.files.single.path;
}

/// يفتح نافذة اختيار مجلد لحفظ الملف الناتج
/// يعيد مسار المجلد أو null
Future<String?> pickOutputFolder() async {
  final result = await FilePicker.platform.getDirectoryPath();
  return result;
}

void main() {
  /// نقطة تشغيل التطبيق
  /// MaterialApp بدون Debug Banner
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: ExcelProductsPage()),
  );
}

/// Model (Entity) يمثل المنتج
/// يستخدم لاحقًا لعرض البيانات في الواجهة
class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});

  /// مفيد أثناء الـ debugging
  @override
  String toString() => 'Product(name: $name, price: $price)';
}
