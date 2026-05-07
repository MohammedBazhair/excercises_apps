import 'package:flutter/material.dart';
import 'package:test_off/admin_app/widgets/order_card.dart';
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
    setState(() => _isLoading = true);
    final orders = await OrdersService().fetchAllOrders();
    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  void _handleUpdate(String orderId, String status) async {
    // إظهار Loading خفيف أثناء التحديث
    await OrdersService().updateOrderStatus(orderId, status);
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xffF1F5F9,
      ), // خلفية رمادية فاتحة جداً تبرز البطاقات البيضاء
      appBar: AppBar(
        title: const Text(
          'Order Management',
          style: TextStyle(
            color: Color(0xff1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadOrders,
            icon: const Icon(Icons.refresh_rounded, color: Colors.indigo),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                return OrderCard(
                  order: _orders[index],
                  onAccept: () => _handleUpdate(_orders[index].id!, 'accepted'),
                  onReject: () => _handleUpdate(_orders[index].id!, 'rejected'),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No orders found',
            style: TextStyle(color: Color(0xff64748B), fontSize: 18),
          ),
        ],
      ),
    );
  }
}
