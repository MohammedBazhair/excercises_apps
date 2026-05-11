import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:test_off/admin_app/widgets/edit_product_dialog.dart';
import 'package:test_off/admin_app/widgets/products_action_bar.dart';
import 'package:test_off/core/models/product.dart';
import 'package:test_off/admin_app/widgets/import_info_card.dart';
import 'package:test_off/core/services/file_picker_service.dart';
import 'package:test_off/core/services/products_service.dart';
import 'package:test_off/core/widgets/custom_action_button.dart';
import 'package:test_off/core/widgets/product_card_tile.dart';
import 'package:test_off/admin_app/widgets/empty_products_state.dart';

class ExcelProductsPage extends StatefulWidget {
  const ExcelProductsPage({super.key});

  @override
  State<ExcelProductsPage> createState() => _ExcelProductsPageState();
}

class _ExcelProductsPageState extends State<ExcelProductsPage> {
  List<Product> _products = [];
  bool _isLoading = false;
  Source _source = Source.serverAndCache;

  @override
  void initState() {
    super.initState();
    _fetchFirebaseProducts();
  }

  Future<void> loadExcel() async {
    try {
      // اختيار ملف Excel من الجهاز
      final bytes = await FilePickerService.pickExcelFile();

      if (bytes == null) return;

      setState(() => _isLoading = true);

      // قراءة المنتجات من الملف
      final result = readProductsFromExcel(bytes);

      _products = result;
      _source = Source.cache;
    } catch (e) {
      // في المشاريع الحقيقية يفضل logging framework
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Product> readProductsFromExcel(Uint8List bytes) {
    try {
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

  Future<void> _fetchFirebaseProducts() async {
    setState(() {
      _isLoading = true;
    });
    final products = await ProductsService().fetchProducts();
    setState(() {
      _products = products;
      _source = Source.server;
      _isLoading = false;
    });
  }

  Future<void> updateProduct(Product updatedProduct) async {
    Navigator.pop(context);

    setState(() => _isLoading = true);
    await ProductsService().updateProduct(updatedProduct);

    final products = await ProductsService().fetchProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          'Products Inventory v2',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xff1E293B),
          ),
        ),
        centerTitle: false,
        actions: [
          CustomActionButton(
            icon: Icons.sync_rounded,
            tooltip: 'Sync All from Firebase',
            onPressed: _fetchFirebaseProducts,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ), // تحديد عرض المحتوى للويب
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const ImportInfoCard(
                message:
                    'Manage your inventory by importing Excel files or syncing directly with Firebase Cloud.',
              ),
              const SizedBox(height: 16),

              Text('Total Products: ${_products.length}'),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.indigo),
                      )
                    : _products.isEmpty
                    ? const EmptyProductsState()
                    : ListView.builder(
                        // استخدام ListView بسيط وفعال للويب
                        itemCount: _products.length,
                        padding: const EdgeInsets.only(bottom: 100),
                        itemBuilder: (context, index) {
                          return ProductCardTile(
                            product: _products[index],
                            index: index,
                            source: _source,
                            trailingIcon: Icons.edit_note_rounded,
                            onTrailingIconTapped: () => showEditDialog(
                              context: context,
                              product: _products[index],
                              onSave: updateProduct,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      // أزرار التحكم بشكل Floating Action Bar للويب
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ProductsActionBar(
        onImport: loadExcel, // الدالة الموجودة في صفحتك
        onSave: () async {
          setState(() => _isLoading = true);
          await ProductsService().addProducts(_products);
          setState(() => _isLoading = false);

          // لمسة إضافية: إظهار رسالة نجاح
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Products saved successfully!')),
          );
        },
      ),
    );
  }
}
