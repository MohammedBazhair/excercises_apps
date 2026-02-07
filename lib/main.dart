// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:test_off/excel_product_page.dart';

Future<File?> pickExcelFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  if (result == null) return null;

  return File(result.files.single.path!);
}




void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: ExcelProductsPage()));
}

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});

  @override
  String toString() => 'Product(name: $name, price: $price)';
}

