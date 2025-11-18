import 'package:flutter/material.dart';
import 'package:techstock/models/dashboard_model.dart';

import 'package:fl_chart/fl_chart.dart';


class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardModel? dashboard;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStaticData();
  }

  void loadStaticData() {
    setState(() {
      dashboard = DashboardModel.fromJson({
        "chiffre_affaires": 290000,
        "commandes": 5,
        "ventes": 3,
        "produits": 8,
        "revenu_total": 14500,
        "cibles": 2,
      });

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        title: const Text(
          'Tableau de Bord',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) {
              switch (value) {
                case 'Accueil':
                  Navigator.pushNamed(context, '/accueil');
                  break;
                case 'Articles':
                  Navigator.pushNamed(context, '/articles');
                  break;
                case 'Commande':
                  Navigator.pushNamed(context, '/commande');
                  break;
                case 'Paramètres':
                  Navigator.pushNamed(context, '/parametres');
                  break;
                case 'À Propos':
                  Navigator.pushNamed(context, '/apropos');
                  break;
                case 'Déconnexion':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Déconnecté')),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Accueil',
                  child: ListTile(
                    leading: Icon(Icons.home, color: Colors.blue),
                    title: Text('Accueil'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Articles',
                  child: ListTile(
                    leading: Icon(Icons.article, color: Colors.green),
                    title: Text('Articles'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Commande',
                  child: ListTile(
                    leading: Icon(Icons.shopping_cart, color: Colors.orange),
                    title: Text('Commande'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Paramètres',
                  child: ListTile(
                    leading: Icon(Icons.settings, color: Colors.grey),
                    title: Text('Paramètres'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'À Propos',
                  child: ListTile(
                    leading: Icon(Icons.info, color: Colors.indigo),
                    title: Text('À Propos'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Déconnexion',
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Déconnexion'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),

      body: isLoading || dashboard == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                buildSummaryCard('${dashboard!.chiffreAffaires} XOF', 'Chiffre d\'affaires'),
                buildSummaryCard('${dashboard!.commandes}', 'Commandes'),
                buildSummaryCard('${dashboard!.ventes}', 'Ventes'),
                buildSummaryCard('${dashboard!.produits}', 'Produits'),
                buildSummaryCard('${dashboard!.revenuTotal} XOF', 'Revenu Total'),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Row(
                children: [
                  Expanded(child: buildPieChart()),
                  const SizedBox(width: 20),
                  Expanded(child: buildBarChart()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSummaryCard(String value, String label) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget buildPieChart() {
    return Column(
      children: [
        const Text('Répartition des Revenus', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: dashboard!.revenuTotal,
                  color: Colors.green,
                  title: 'Revenu Total',
                ),
                PieChartSectionData(
                  value: dashboard!.ventes.toDouble(),
                  color: Colors.red,
                  title: 'Ventes',
                ),
                PieChartSectionData(
                  value: dashboard!.cibles.toDouble(),
                  color: Colors.grey,
                  title: 'Cibles',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBarChart() {
    double produits = dashboard!.produits.toDouble();
    double ventes = dashboard!.ventes.toDouble();
    double commandes = dashboard!.commandes.toDouble();

    double maxY = [produits, ventes, commandes].reduce((a, b) => a > b ? a : b) + 1;

    return Column(
      children: [
        const Text('Performance des Ventes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [BarChartRodData(toY: produits, color: Colors.blue, width: 16)],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [BarChartRodData(toY: ventes, color: Colors.green, width: 16)],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [BarChartRodData(toY: commandes, color: Colors.orange, width: 16)],
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      switch (v.toInt()) {
                        case 0: return const Text('Produits');
                        case 1: return const Text('Ventes');
                        case 2: return const Text('Commandes');
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
