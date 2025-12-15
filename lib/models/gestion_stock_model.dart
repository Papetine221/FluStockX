class Product {
  int id;
  String name;
  String description;
  String category;
  int quantity;
  double price;
  int minThreshold;

  Product({
    required this.id,
    required this.name,
    this.description = '',
    this.category = 'Divers',
    this.quantity = 0,
    this.price = 0.0,
    this.minThreshold = 5,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: int.tryParse(map['id'].toString()) ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Divers',
      quantity: int.tryParse(map['stockQuantity'].toString()) ?? 0,
      price: double.tryParse(map['sellingPrice'].toString()) ?? 0.0,
      minThreshold: int.tryParse(map['minThreshold'].toString()) ?? 5,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'stockQuantity': quantity,
      'sellingPrice': price,
      'minThreshold': minThreshold,
    };
  }
}
