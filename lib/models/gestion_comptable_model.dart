class Transaction {
  final String id;
  final String description;
  final double montant;
  final DateTime date;
  final String categorie;
  final String type; // 'revenu' ou 'depense'

  const Transaction({
    required this.id,
    required this.description,
    required this.montant,
    required this.date,
    required this.categorie,
    required this.type,
  });
}

class ResumeComptable {
  final double totalRevenus;
  final double totalDepenses;
  final double margeBrute;
  final double beneficeNet;

  const ResumeComptable({
    required this.totalRevenus,
    required this.totalDepenses,
    required this.margeBrute,
    required this.beneficeNet,
  });
}
