class LigneCommande {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  const LigneCommande({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory LigneCommande.fromMap(Map<String, dynamic> map) {
    return LigneCommande(
      productId:
          map['product_id']?.toString() ?? map['productId']?.toString() ?? '0',
      productName: map['product_name'] ?? map['productName'] ?? 'Unknown',
      quantity: int.tryParse(map['quantity'].toString()) ?? 0,
      unitPrice:
          double.tryParse(
            map['price']?.toString() ?? map['unitPrice']?.toString() ?? '0.0',
          ) ??
          0.0,
    );
  }
}

class Commande {
  final String id;
  final String clientId;
  final DateTime date;
  final List<LigneCommande> items;
  final double totalAmount; // Added field to map

  const Commande({
    required this.id,
    required this.clientId,
    required this.date,
    required this.items,
    this.totalAmount = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'date': date.toIso8601String(),
      'items': items.map((x) => x.toMap()).toList(),
      'totalAmount': totalAmount,
    };
  }

  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
      id: map['id']?.toString() ?? '',
      clientId:
          map['client_id']?.toString() ?? map['clientId']?.toString() ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      totalAmount:
          double.tryParse(
            map['total_amount']?.toString() ??
                map['totalAmount']?.toString() ??
                '0.0',
          ) ??
          0.0,
      items:
          (map['items'] as List<dynamic>?)
              ?.map((x) => LigneCommande.fromMap(x))
              .toList() ??
          [],
    );
  }
}
