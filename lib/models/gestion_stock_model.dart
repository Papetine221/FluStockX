class Product {
  int id;
  String name;
  String description;
  int quantity;

  Product({required this.id, required this.name, this.description = '', this.quantity = 0});
}
