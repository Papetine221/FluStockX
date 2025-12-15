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

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: int.tryParse(map['id'].toString()) ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }
}
