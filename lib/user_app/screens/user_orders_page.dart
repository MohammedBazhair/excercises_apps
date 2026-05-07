import 'package:flutter/material.dart';
import 'package:test_off/admin_app/widgets/order_card.dart';
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
        return OrderCard(order: order,isAdmin: false);
      },
    );
  }

 
}
