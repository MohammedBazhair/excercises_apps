/// Model (Entity) يمثل المنتج
/// يستخدم لاحقًا لعرض البيانات في الواجهة
class Product {
  final String? id;
  final String name;
  final double price;

  Product({this.id, required this.name, required this.price});

  /// مفيد أثناء الـ debugging
  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_name': name,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, {String? id}) {
    return Product(
      id: id,
      name: map['product_name'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }

}
