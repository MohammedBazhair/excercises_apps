import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_off/core/models/product.dart';
import 'package:test_off/core/models/order_model.dart';
import 'package:test_off/core/services/products_service.dart';
import 'package:test_off/core/services/orders_service.dart';
import 'package:test_off/core/services/auth_service.dart';
import 'package:test_off/core/widgets/product_card_tile.dart';
import 'package:test_off/user_app/widgets/cart_dialog.dart';
import 'package:test_off/user_app/widgets/cart_fab.dart';

class UserProductsPage extends StatefulWidget {
  const UserProductsPage({super.key});

  @override
  State<UserProductsPage> createState() => _UserProductsPageState();
}

class _UserProductsPageState extends State<UserProductsPage> {
  List<Product> _products = [];
  final List<Product> _cart = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final products = await ProductsService().fetchProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  double get _cartTotal {
    return _cart.fold(0.0, (total, item) => total + item.price);
  }

  void _confirmOrder() async {
    if (_cart.isEmpty) return;

    setState(() => _isLoading = true);
    final user = await AuthService().getCurrentUser();
    if (user != null) {
      final order = OrderModel(
        userId: user.uid,
        products: List.from(_cart),
        totalPrice: _cartTotal,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );
      await OrdersService().createOrder(order);
      setState(() {
        _cart.clear();
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
    }
  }

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (context) => CartDialog(
        cart: _cart,
        onCartChanged: () => setState(() {}), // تحديث الـ Badge الخارجي
        onOrderConfirmed: () {
          Navigator.pop(context);
          _confirmOrder();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      floatingActionButton: CartFAB(
        cartItemCount: _cart.length,
        onPressed: _showCartDialog,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(24),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ProductCardTile(
                  product: product,
                  index: index,
                  source: Source.server,
                  onTrailingIconTapped: () => _addToCart(product),
                  trailingIcon: Icons.add_shopping_cart_rounded,
                );
              },
            ),
    );
  }
}
