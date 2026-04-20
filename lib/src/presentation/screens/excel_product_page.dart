import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:test_off/src/models/product.dart';
import 'package:test_off/src/presentation/widgets/import_info_card.dart';
import 'package:test_off/src/services/file_picker_service.dart';
import 'package:test_off/src/services/products_service.dart';
import '../widgets/product_card_tile.dart';
import '../widgets/empty_products_state.dart';

class ExcelProductsPage extends StatefulWidget {
  const ExcelProductsPage({super.key});

  @override
  State<ExcelProductsPage> createState() => _ExcelProductsPageState();
}

class _ExcelProductsPageState extends State<ExcelProductsPage> {
  List<Product> _products = [];
  bool _isLoading = false;
  Source _source = Source.serverAndCache;

  Future<void> loadExcel() async {
    try {
      // اختيار ملف Excel من الجهاز
      final filePath = await FilePickerService.pickExcelFile();

      if (filePath == null) return;

      setState(() => _isLoading = true);

      // قراءة المنتجات من الملف
      final result = readProductsFromExcel(filePath);

      _products = result;
      _source = Source.cache;
    } catch (e) {
      // في المشاريع الحقيقية يفضل logging framework
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Products Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'جلب المنتجات الذي سعرها على الاقل 300',
            onPressed: () async {
              final products = await ProductsService().fetchProductsWhere(300);
              setState(() {
                _products = products;
                _source = Source.server;
              });
            },
            icon: Icon(Icons.where_to_vote),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final products = await ProductsService().fetchProducts();
                  setState(() {
                    _products = products;
                    _source = Source.server;
                  });
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: ImportInfoCard(
                        message:
                            'Import Excel files or pull to fetch from Firebase!',
                      ),
                    ),

                    if (_isLoading)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_products.isEmpty)
                      const SliverFillRemaining(child: EmptyProductsState())
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return ProductCardTile(
                            product: _products[index],
                            index: index,
                            source: _source,
                          );
                        }, childCount: _products.length),
                      ),
                  ],
                ),
              ),
            ),

            // ⭐ الأزرار هنا خارج scroll
            Column(
              crossAxisAlignment: .stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: loadExcel,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Import Excel'),
                ),

                const SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    await ProductsService().addProducts(_products);

                    setState(() => _isLoading = false);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save to Firebase'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
