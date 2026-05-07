import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_off/core/models/order_model.dart';

class OrdersService {
  OrdersService._();
  static final OrdersService _instance = OrdersService._();
  factory OrdersService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _ordersCollection => _firestore.collection('orders');

  Future<void> createOrder(OrderModel order) async {
    try {
      await _ordersCollection.add(order.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<List<OrderModel>> fetchAllOrders() async {
    try {
      final snapshots = await _ordersCollection.orderBy('createdAt', descending: true).get();
      return snapshots.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<OrderModel>> fetchUserOrders(String userId) async {
    try {
      final snapshots = await _ordersCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshots.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _ordersCollection.doc(orderId).update({'status': status});
    } catch (e) {
      print(e);
    }
  }
}
