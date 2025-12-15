import 'package:flutter/material.dart';
import 'package:techstock/widgets/main_app_bar.dart';
import 'package:techstock/screens/fonctionnalites_screen/gestion_stock_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/gestion_client_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/dashboard_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/gestion_comptable_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/commande_screen.dart';

class FonctionnalitesScreen extends StatelessWidget {
  const FonctionnalitesScreen({super.key});

  static const routeName = '/features';

  static const Color primary = Color.fromARGB(255, 122, 92, 205);

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Gestion des Stocks',
        'bullets': [
          'Liste des produits',
          'Alertes de stock faible',
          'Mouvements & entrées',
        ],
      },
      {
        'title': 'Gestion Comptable',
        'bullets': ['Factures', 'Paiements', 'Rapports financiers'],
      },
      {
        'title': 'Gestion Client',
        'bullets': ['Fiches clients', 'Historique d\'achat', 'Segmentation'],
      },
      {
        'title': 'Commandes',
        'bullets': ['Nouvelle commande', 'Historique', 'Facturation'],
      },
      {
        'title': 'Dashboard',
        'bullets': ['KPI en temps réel', 'Graphiques', 'Export CSV/PDF'],
      },
    ];

    return Scaffold(
      appBar: const MainAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use ListView for narrow screens (mobile) to avoid aspect ratio overflows
          if (constraints.maxWidth < 600) {
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _buildFeatureCard(
                context,
                items[index],
                index,
                isGrid: false,
              ),
            );
          }

          // Use GridView for larger screens
          final crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1, // Adjusted ratio
              ),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  _buildFeatureCard(context, items[index], index, isGrid: true),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    Map<String, dynamic> entry,
    int index, {
    required bool isGrid,
  }) {
    final title = entry['title'] as String;
    final bullets = (entry['bullets'] as List<dynamic>).cast<String>();

    final cardContent = SizedBox(
      height: isGrid
          ? null
          : 180, // Fixed height for ListView items to look consistent, or null for auto
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Important for ListView
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_iconForIndex(index), color: primary, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Bullets
            Expanded(
              child: SingleChildScrollView(
                // Allow scrolling if bullets overflow in Grid
                child: Column(
                  children: [
                    for (var b in bullets)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Icon(
                                Icons.circle,
                                size: 8,
                                color: Colors.black45,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                b,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => _navigateToFeature(context, index),
                child: const Text('Ouvrir'),
              ),
            ),
          ],
        ),
      ),
    );

    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToFeature(context, index),
        child: cardContent,
      ),
    );
  }

  IconData _iconForIndex(int i) {
    switch (i) {
      case 0:
        return Icons.inventory_2;
      case 1:
        return Icons.account_balance;
      case 2:
        return Icons.person;
      case 3:
        return Icons.shopping_cart;
      case 4:
      default:
        return Icons.dashboard;
    }
  }

  void _navigateToFeature(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(GestionStockScreen.routeName);
        break;
      case 1:
        Navigator.of(context).pushNamed(GestionComptableScreen.routeName);
        break;
      case 2:
        Navigator.of(context).pushNamed(GestionClientScreen.routeName);
        break;
      case 3:
        Navigator.of(context).pushNamed(CommandeScreen.routeName);
        break;
      case 4:
        Navigator.of(context).pushNamed(DashboardScreen.routeName);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fonctionnalité en cours de développement.'),
          ),
        );
    }
  }
}
