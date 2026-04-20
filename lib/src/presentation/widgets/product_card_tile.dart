import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_off/src/models/product.dart';

class ProductCardTile extends StatelessWidget {
  final Product product;
  final int index;
  final Source source;
  
  const ProductCardTile({
    super.key,
    required this.product,
    required this.index,
    required this.source,
  });

  String get subtitleSource {
    return switch (source) {
      Source.server => 'From Firbase',
      Source.cache => 'From Excel',
      Source.serverAndCache => 'From Firbase and Excel',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            color: Color(0x11000000),
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitleSource),
        trailing: Text(
          '\$${product.price}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
