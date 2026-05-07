import 'package:flutter/material.dart';
import 'package:test_off/core/models/product.dart';

class CartDialog extends StatefulWidget {
  final List<Product> cart;
  final VoidCallback onOrderConfirmed;
  final VoidCallback onCartChanged;

  const CartDialog({
    super.key,
    required this.cart,
    required this.onOrderConfirmed,
    required this.onCartChanged,
  });

  @override
  State<CartDialog> createState() => _CartDialogState();
}

class _CartDialogState extends State<CartDialog> {
  // حساب الإجمالي
  double get total => widget.cart.fold(0, (sum, item) => sum + item.price);

  // تجميع المنتجات المتكررة للعرض فقط
  Map<String, int> get groupedItems {
    final Map<String, int> counts = {};
    for (var item in widget.cart) {
      counts[item.name] = (counts[item.name] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Row(
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Colors.indigo),
                const SizedBox(width: 12),
                const Text(
                  'Your Cart',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 32),

            // محتوى السلة
            Flexible(
              child: widget.cart.isEmpty
                  ? _buildEmptyCart()
                  : ListView(
                      shrinkWrap: true,
                      children: groupedItems.entries.map((entry) {
                        final product = widget.cart.firstWhere((p) => p.name == entry.key);
                        return _buildCartItem(entry.key, entry.value, product.price);
                      }).toList(),
                    ),
            ),

            const Divider(height: 32),

            // المجموع وأزرار التحكم
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount', style: TextStyle(color: Colors.grey)),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.cart.isEmpty ? null : widget.onOrderConfirmed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Confirm Order', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(String name, int quantity, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
            child: Text('x$quantity', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text('\$${(price * quantity).toStringAsFixed(2)}'),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
            onPressed: () {
              setState(() {
                final index = widget.cart.indexWhere((p) => p.name == name);
                if (index != -1) widget.cart.removeAt(index);
              });
              widget.onCartChanged(); // لتحديث الـ Badge في الخلفية
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Column(
      children: [
        Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey[200]),
        const SizedBox(height: 16),
        const Text('Your cart is empty', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}