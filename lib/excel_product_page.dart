import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_off/main.dart';

/// صفحة عرض المنتجات المقروءة من Excel
class ExcelProductsPage extends StatefulWidget {
  const ExcelProductsPage({super.key});

  @override
  State<ExcelProductsPage> createState() => _ExcelProductsPageState();
}

class _ExcelProductsPageState extends State<ExcelProductsPage> {
  /// القائمة النهائية للمنتجات
  List<Product> _products = [];

  /// مؤشر تحميل بسيط للواجهة
  bool _isLoading = false;

  /// تحميل ملف Excel وقراءته
  Future<void> loadExcel() async {
    try {
      // اختيار ملف Excel من الجهاز
      final filePath = await pickExcelFile();
      if (filePath == null) return;

      setState(() {
        _isLoading = true;
      });

      // قراءة المنتجات من الملف
      final result = readProductsFromExcel(filePath);

      _products = result;
    } catch (e) {
      // في المشاريع الحقيقية يفضل logging framework
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// إنشاء ملف Excel جديد وحفظه في مجلد يختاره المستخدم
  Future<void> saveExcel() async {
    // إنشاء ملف Excel فارغ
    final Excel excel = Excel.createExcel();

    // الحصول على أول Sheet (يتم إنشاؤه تلقائيًا)
    final sheet = excel.sheets.values.first;

    // دعم الاتجاه من اليمين لليسار (للعربية)
    sheet.isRTL = true;

    // الصفوف (Headers + Data)
    final row0 = [TextCellValue('Product Name'), TextCellValue('Price')];

    final row1 = [TextCellValue('Laptop Dell'), DoubleCellValue(1500)];

    final row2 = [TextCellValue('Mouse'), DoubleCellValue(50)];

    // إضافة الصفوف إلى الشيت
    excel.appendRow(sheet.sheetName, row0);
    excel.appendRow(sheet.sheetName, row1);
    excel.appendRow(sheet.sheetName, row2);

    // تحويل ملف Excel إلى bytes
    final fileBytes = excel.save(fileName: 'FlutterExcel.xlsx');
    if (fileBytes == null) return;

    // اختيار مجلد الحفظ
    final path = await pickOutputFolder();
    if (path == null) return;

    // المسار النهائي للملف
    final pathFile = '$path/test.xlsx';

    // كتابة الملف فعليًا على القرص
    final file = File(pathFile);
    await file.writeAsBytes(fileBytes);
  }

  /// قراءة المنتجات من ملف Excel وتحويلها إلى List<Product>
  List<Product> readProductsFromExcel(String path) {
    try {
      // قراءة الملف كـ bytes
      final File file = File(path);
      final Uint8List bytes = file.readAsBytesSync();

      // فك ترميز ملف Excel
      final Excel excel = Excel.decodeBytes(bytes);

      // افتراض أن أول Sheet يحتوي على البيانات
      final Sheet productsSheet = excel.tables.values.first;

      final List<Product> products = [];

      // بدء القراءة من الصف الثاني (تجاوز العناوين)
      for (int i = 1; i < productsSheet.rows.length; i++) {
        final row = productsSheet.rows[i];

        final name = row[0]?.value.toString() ?? 'without name';

        final price = double.tryParse(row[1]?.value.toString() ?? '0') ?? 0;

        products.add(Product(name: name, price: price));

        // لأغراض التتبع أثناء التطوير
        print(i);
      }

      return products;
    } catch (e, st) {
      print(e);
      print(st);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          // مؤشر تحميل بسيط في شريط التطبيق
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),

      // عرض رسالة في حال عدم وجود بيانات
      body: _products.isEmpty
          ? const Center(
              child: Text(
                'No data loaded',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];

                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 18,
                    child: Text(
                      product.name.isNotEmpty
                          ? product.name[0].toUpperCase()
                          : '?',
                    ),
                  ),
                  title: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('Item ${index + 1}'),
                  trailing: Text(
                    '\$${product.price}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),

      // زر حفظ ملف Excel
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await saveExcel(),
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}
