class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String category;
  final String type; // 'income' or 'expense'
  final String? referenceId; // Linked Order ID (optional)

  const Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.referenceId,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id']?.toString() ?? '',
      description: map['description'] ?? '',
      amount: double.tryParse(map['amount']?.toString() ?? '0.0') ?? 0.0,
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      category: map['category'] ?? 'Divers',
      type: map['type'] ?? 'income',
      referenceId:
          map['order_id']?.toString() ??
          map['referenceId']?.toString(), // Handle DB column 'order_id'
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'type': type,
      'order_id': referenceId, // Send as order_id for API
    };
  }
}

class AccountingSummary {
  final double totalIncome;
  final double totalExpense;
  final double grossMargin;
  final double netProfit;

  const AccountingSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.grossMargin,
    required this.netProfit,
  });
}
