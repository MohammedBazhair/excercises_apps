import 'package:flutter/material.dart';
import 'package:test_off/core/models/product.dart';
import 'package:test_off/core/widgets/custom_text_field.dart';

void showEditDialog({
  required BuildContext context,
  required Product product,
  required void Function(Product updatedProduct) onSave,
}) {
  showDialog(
    context: context,
    builder: (context) => EditProductDialog(
      product: product,
      onSave: onSave,
    ),
  );
}

class EditProductDialog extends StatefulWidget {
  final Product product;
  final Function(Product) onSave;

  const EditProductDialog({
    super.key,
    required this.product,
    required this.onSave,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الهيدر
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Edit Product',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // الحقول (باستخدام الـ Custom Widget الخاص بك)
            CustomTextField(
              controller: _nameController,
              label: 'Product Name',
              icon: Icons.inventory_2_outlined,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _priceController,
              label: 'Price',
              icon: Icons.attach_money_rounded,
              isNumber: true,
            ),
            const SizedBox(height: 40),

            // الأزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    foregroundColor: const Color(0xff64748B),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final updatedProduct = Product(
                      id: widget.product.id,
                      name: _nameController.text.trim(),
                      price:
                          double.tryParse(_priceController.text.trim()) ??
                          widget.product.price,
                    );
                    widget.onSave(updatedProduct);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
