import 'package:flutter/material.dart';
import 'package:test_off/core/models/product.dart';
import 'package:test_off/core/models/order_model.dart';
import 'package:test_off/core/services/products_service.dart';
import 'package:test_off/core/services/orders_service.dart';
import 'package:test_off/core/services/auth_service.dart';

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
      SnackBar(content: Text('${product.name} added to cart'), duration: const Duration(seconds: 1)),
    );
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cart.remove(product);
    });
  }

  double get _cartTotal {
    return _cart.fold(0.0, (sum, item) => sum + item.price);
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
        status: 'pending',
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
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Your Cart'),
            content: SizedBox(
              width: double.maxFinite,
              child: _cart.isEmpty 
                  ? const Text('Cart is empty')
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _cart.length,
                      itemBuilder: (context, index) {
                        final item = _cart[index];
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text('\$${item.price}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              setDialogState(() {
                                _cart.removeAt(index);
                              });
                              setState(() {}); // Update background cart icon
                            },
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              Text('Total: \$${_cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: _cart.isEmpty ? null : () {
                  Navigator.pop(context);
                  _confirmOrder();
                },
                child: const Text('Confirm Order'),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showCartDialog,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_cart),
            if (_cart.isNotEmpty)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '${_cart.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () => _addToCart(product),
                ),
              );
            },
          ),
    );
  }
}
