import 'package:flutter/material.dart';
import 'package:test_off/core/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isAdmin; 
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const OrderCard({
    super.key,
    required this.order,
    this.isAdmin = true, 
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    // تجميع المنتجات وحساب الكميات
    final Map<String, int> productCounts = {};
    for (var p in order.products) {
      productCounts[p.name] = (productCounts[p.name] ?? 0) + 1;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // الهيدر: معلومات الطلب/المستخدم والحالة
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xffF8FAFC),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.indigo.withOpacity(0.1),
                        child: Icon(
                          isAdmin
                              ? Icons.person_outline
                              : Icons.shopping_bag_outlined,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAdmin
                                ? 'User ID: ${order.userId.substring(0, 8)}...'
                                : 'My Order',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1E293B),
                            ),
                          ),
                          Text(
                            'Order #${order.id?.substring(0, 5) ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),
            ),

            // المنتجات
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Items Summary',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff94A3B8),
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...productCounts.entries.map((entry) {
                    final product = order.products.firstWhere(
                      (p) => p.name == entry.key,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'x${entry.value}',
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                color: Color(0xff475569),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '\$${(product.price * entry.value).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }),

                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${order.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),

                  // عرض الأزرار فقط إذا كان المستخدم أدمن والطلب في حالة انتظار
                  if (isAdmin && order.status == OrderStatus.pending) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onReject,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Color(0xffFEE2E2)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onAccept,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Accept Order'),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // ملاحظة إضافية للعميل (اختياري)
                  if (!isAdmin) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Placed on: ${order.createdAt.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color color;
    String text;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case OrderStatus.accepted:
        color = Colors.green;
        text = 'Accepted';
        break;
      case OrderStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
