class Client {
  int id;
  String name;
  String email;
  String phone;

  Client({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
  });
}