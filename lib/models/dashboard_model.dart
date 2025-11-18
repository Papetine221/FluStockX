class DashboardModel {
  final double chiffreAffaires;
  final int commandes;
  final int ventes;
  final int produits;
  final double revenuTotal;
  final int cibles;

  DashboardModel({
    required this.chiffreAffaires,
    required this.commandes,
    required this.ventes,
    required this.produits,
    required this.revenuTotal,
    required this.cibles,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      chiffreAffaires: (json['chiffre_affaires'] ?? 0).toDouble(),
      commandes: json['commandes'] ?? 0,
      ventes: json['ventes'] ?? 0,
      produits: json['produits'] ?? 0,
      revenuTotal: (json['revenu_total'] ?? 0).toDouble(),
      cibles: json['cibles'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chiffre_affaires": chiffreAffaires,
      "commandes": commandes,
      "ventes": ventes,
      "produits": produits,
      "revenu_total": revenuTotal,
      "cibles": cibles,
    };
  }
}
