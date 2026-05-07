import 'package:test_off/core/models/product.dart';

class OrderModel {
  final String? id;
  final String userId;
  final List<Product> products;
  final double totalPrice;
  final String status;
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
      'status': status,
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
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }
}
