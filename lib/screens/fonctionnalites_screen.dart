// Author: Papetine221
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
    final features = [
      {
        'title': 'Comptabilité',
        'subtitle': 'Factures, Paiements, Rapports',
        'icon': Icons.account_balance_wallet,
        'color': Colors.blue,
        'route': GestionComptableScreen.routeName,
      },
      {
        'title': 'Clients',
        'subtitle': 'Fiches, Historique, CRM',
        'icon': Icons.people_alt,
        'color': Colors.teal,
        'route': GestionClientScreen.routeName,
      },
      {
        'title': 'Stocks',
        'subtitle': 'Produits, Inventaire, Alertes',
        'icon': Icons.inventory_2,
        'color': Colors.purple,
        'route': GestionStockScreen.routeName,
      },
      {
        'title': 'Commandes',
        'subtitle': 'Ventes, Panier, Facturation',
        'icon': Icons.shopping_cart,
        'color': Colors.orange,
        'route': CommandeScreen.routeName,
      },
      {
        'title': 'Dashboard',
        'subtitle': 'KPIs, Graphiques, Analyses',
        'icon': Icons.dashboard,
        'color': Colors.indigo,
        'route': DashboardScreen.routeName,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const MainAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome / Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenue sur TechStock',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Que voulez-vous faire aujourd\'hui ?',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  // Use a slightly smaller aspect ratio (taller card) to prevent overflow
                  double childAspectRatio = constraints.maxWidth > 600
                      ? 1.1
                      : 0.95;

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: features.length,
                    itemBuilder: (context, index) {
                      final item = features[index];
                      return _buildFeatureCard(context, item);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, Map<String, dynamic> item) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (item['route'] != null) {
            Navigator.of(context).pushNamed(item['route']);
          }
        },
        // Reduced padding to prevent overflow
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Ensure it takes min space
            children: [
              Container(
                width: 48, // Slightly smaller
                height: 48,
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 26, // Slightly smaller
                ),
              ),
              const SizedBox(height: 12), // Reduced spacing
              Text(
                item['title'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                item['subtitle'] as String,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
