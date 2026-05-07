import 'package:flutter/material.dart';
import 'package:test_off/core/models/order_model.dart';
import 'package:test_off/core/services/orders_service.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  List<OrderModel> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    final orders = await OrdersService().fetchAllOrders();
    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  void _updateStatus(String orderId, String status) async {
    await OrdersService().updateOrderStatus(orderId, status);
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_orders.isEmpty) return const Center(child: Text('No orders found'));

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
                Text('User ID: ${order.userId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Total Price: \$${order.totalPrice.toStringAsFixed(2)}'),
                Text('Status: ${order.status}', style: TextStyle(color: _getStatusColor(order.status))),
                const Divider(),
                const Text('Products:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...order.products.map((p) => Text('- ${p.name} (\$${p.price})')),
                const SizedBox(height: 10),
                if (order.status == 'pending') Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _updateStatus(order.id!, 'rejected'),
                      child: const Text('Reject', style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateStatus(order.id!, 'accepted'),
                      child: const Text('Accept'),
                    ),
                  ],
                ),
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
