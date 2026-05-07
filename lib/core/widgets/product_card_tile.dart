import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_off/core/models/product.dart';
class ProductCardTile extends StatelessWidget {
  final Product product;
  final int index;
  final Source source;
  final VoidCallback? onEdit;

  const ProductCardTile({
    super.key,
    required this.product,
    required this.index,
    required this.source,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xffF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff64748B),
              ),
            ),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xff1E293B),
          ),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            source == Source.server
                ? 'Synced with Firebase'
                : 'Local Excel Data',
            style: TextStyle(
              color: source == Source.server ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(
                Icons.edit_note_rounded,
                color: Color(0xff94A3B8),
              ),
              onPressed: onEdit,
              hoverColor: Colors.indigo.withOpacity(0.05),
            ),
          ],
        ),
      ),
    );
  }
}
