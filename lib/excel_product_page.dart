// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:excel/excel.dart' as e;
import 'package:flutter/material.dart';
import 'package:test_off/main.dart';

class ExcelProductsPage extends StatefulWidget {
  const ExcelProductsPage({super.key});

  @override
  State<ExcelProductsPage> createState() => _ExcelProductsPageState();
}

class _ExcelProductsPageState extends State<ExcelProductsPage> {
  List<Product> _products = [];

  Future<void> loadExcel() async {
    final file = await pickExcelFile();
    if (file == null) return;

    final result = await readProductsFromExcel(file);

    setState(() {
      _products = result;
    });
  }

  Future<List<Product>> readProductsFromExcel(File file) async {
    try {
      final bytes = await file.readAsBytes();

      final excel = e.Excel.decodeBytes(bytes);

      final sheet = excel.tables.values.first;
      final List<Product> products = [];

      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        final name = row[0]?.value.toString() ?? '';
        final price = double.tryParse(row[1]?.value.toString() ?? '0') ?? 0;

        final product = Product(name: name, price: price);
        products.add(product);
      }
      print(products);
      return products;
    } catch (e, st) {
      print(e);
      print(st);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Enterprise color palette
    const primaryNavy = Color(0xFF1A237E);
    const accentBlue = Color(0xFF3949AB);
    const backgroundGray = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: backgroundGray,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle:
            false, // Apps like Stripe/Amazon often use left-aligned titles
        title: const Text(
          'Inventory Dashboard',
          style: TextStyle(
            color: primaryNavy,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: primaryNavy),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Stats Section - Gives a professional "Enterprise" feel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  _buildQuickStat(
                    'Items',
                    _products.length.toString(),
                    Icons.inventory_2_outlined,
                  ),
                  const SizedBox(width: 40),
                  _buildQuickStat(
                    'Status',
                    _products.isEmpty ? 'Empty' : 'Syncing',
                    Icons.cloud_done_outlined,
                  ),
                ],
              ),
            ),

            Expanded(
              child: _products.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: accentBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  product.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: accentBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: primaryNavy,
                              ),
                            ),
                            subtitle: Text('${index + 1}'),
                            trailing: Text(
                              '\$${product.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Modern Action Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: loadExcel,
                  icon: const Icon(Icons.add_chart_rounded, size: 20),
                  label: const Text(
                    'IMPORT EXCEL DATA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Stats
  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  // Helper Widget for Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No data available',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            'Please upload your inventory file to begin.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
