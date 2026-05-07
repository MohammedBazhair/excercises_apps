import 'package:test_off/core/models/product.dart';

enum OrderStatus {
  pending,
  accepted,
  rejected,
}

class OrderModel {
  final String? id;
  final String userId;
  final List<Product> products;
  final double totalPrice;
  final OrderStatus status;
  final DateTime createdAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.products,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'products': products.map((p) => p.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      products: (map['products'] as List<dynamic>? ?? [])
          .map((p) => Product.fromMap(p as Map<String, dynamic>))
          .toList(),
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.byName(map['status'] ?? 'pending'),
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }
}
