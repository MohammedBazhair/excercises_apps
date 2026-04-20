import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_off/src/models/product.dart';

class ProductsService {
  ProductsService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference<Map<String, dynamic>> _productsCollection =
      _firestore.collection('products');

  static final ProductsService _instance = ProductsService._();

  factory ProductsService() => _instance;

  Future<void> addProduct(Product product) async {
    try {
      await _productsCollection.add(product.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProducts(List<Product> products) async {
    try {
      final batch = _firestore.batch();

      for (final product in products) {
        final docRef = _productsCollection.doc();
        batch.set(docRef, product.toMap());
      }

      await batch.commit();
      print('Saved to Firebase');
    } catch (e) {
      print(e);
    }
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final snapshots = await _productsCollection.get();

      return snapshots.docs.map((doc) => Product.fromMap(doc.data())).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Product>> fetchProductsWhere(double smallerPrice) async {
    try {
      final snapshots = await _productsCollection
          .where('price', isGreaterThanOrEqualTo: smallerPrice)
          .get();

      return snapshots.docs.map((doc) => Product.fromMap(doc.data())).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
