/// Model (Entity) يمثل المنتج
/// يستخدم لاحقًا لعرض البيانات في الواجهة
class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});

  /// مفيد أثناء الـ debugging
  @override
  String toString() => 'Product(name: $name, price: $price)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_name': name,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['product_name'] as String,
      price: map['price'] as double,
    );
  }

}
