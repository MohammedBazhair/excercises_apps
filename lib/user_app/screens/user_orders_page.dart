import 'package:flutter/material.dart';
import 'package:test_off/core/models/order_model.dart';
import 'package:test_off/core/services/orders_service.dart';
import 'package:test_off/core/services/auth_service.dart';

class UserOrdersPage extends StatefulWidget {
  const UserOrdersPage({super.key});

  @override
  State<UserOrdersPage> createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  List<OrderModel> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    final user = await AuthService().getCurrentUser();
    if (user != null) {
      final orders = await OrdersService().fetchUserOrders(user.uid);
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_orders.isEmpty) return const Center(child: Text('You have no orders yet.'));

    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order on: ${order.createdAt.toLocal().toString().split('.')[0]}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Total Price: \$${order.totalPrice.toStringAsFixed(2)}'),
                Text('Status: ${order.status}', style: TextStyle(color: _getStatusColor(order.status), fontWeight: FontWeight.bold)),
                const Divider(),
                const Text('Products:'),
                ...order.products.map((p) => Text('- ${p.name} (\$${p.price})')),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'accepted') return Colors.green;
    if (status == 'rejected') return Colors.red;
    return Colors.orange;
  }
}
