import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techstock/models/commande_model.dart';
import 'package:techstock/models/gestion_comptable_model.dart';
import 'package:techstock/providers/data_providers.dart';
import 'package:techstock/widgets/main_app_bar.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // Helper to safe-read provider data
  int _getCount<T>(AsyncValue<List<T>> asyncVal) =>
      asyncVal.hasValue ? asyncVal.value!.length : 0;

  double _getTotalIncome(
    AsyncValue<List<Commande>> orders,
    AsyncValue<List<Transaction>> transactions,
  ) {
    // Option A: Revenue based ONLY on Orders
    double orderRevenue = orders.hasValue
        ? orders.value!.fold(0.0, (sum, o) => sum + o.totalAmount)
        : 0;

    // Use Order Revenue for "Chiffre d'Affaires"
    return orderRevenue;
  }

  double _getNetProfit(AsyncValue<List<Transaction>> transactions) {
    if (!transactions.hasValue) return 0.0;
    double income = 0;
    double expense = 0;
    for (var t in transactions.value!) {
      if (t.type == 'income') income += t.amount;
      if (t.type == 'expense') expense += t.amount;
    }
    return income - expense;
  }

  @override
  Widget build(BuildContext context) {
    // Watch all providers
    final ordersAsync = ref.watch(ordersProvider);
    final productsAsync = ref.watch(productsProvider);
    final clientsAsync = ref.watch(clientsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);

    // Calculate Metrics
    final int productCount = _getCount(productsAsync);
    final int clientCount = _getCount(clientsAsync);
    final int orderCount = _getCount(ordersAsync);

    final double ca = _getTotalIncome(ordersAsync, transactionsAsync);
    final double profit = _getNetProfit(transactionsAsync);

    final bool isLoading =
        ordersAsync.isLoading ||
        productsAsync.isLoading ||
        clientsAsync.isLoading ||
        transactionsAsync.isLoading;

    return Scaffold(
      appBar: const MainAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(ordersProvider);
                  ref.refresh(productsProvider);
                  ref.refresh(clientsProvider);
                  ref.refresh(transactionsProvider);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Vue d\'ensemble',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          buildSummaryCard(
                            '${ca.toStringAsFixed(0)} FCFA',
                            'Chiffre d\'affaires',
                            Colors.blue.shade100,
                            Colors.blue,
                          ),
                          buildSummaryCard(
                            '${profit.toStringAsFixed(0)} FCFA',
                            'Bénéfice Net',
                            profit >= 0
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            profit >= 0 ? Colors.green : Colors.red,
                          ),
                          buildSummaryCard(
                            '$orderCount',
                            'Commandes',
                            Colors.orange.shade100,
                            Colors.orange.shade800,
                          ),
                          buildSummaryCard(
                            '$productCount',
                            'Produits en Stock',
                            Colors.purple.shade100,
                            Colors.purple,
                          ),
                          buildSummaryCard(
                            '$clientCount',
                            'Clients Actifs',
                            Colors.teal.shade100,
                            Colors.teal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Simple Bar Chart for counts
                      SizedBox(
                        height: 300,
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Statistiques',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY:
                                          (productCount > 0 ||
                                              clientCount > 0 ||
                                              orderCount > 0)
                                          ? [
                                                  double.parse('$productCount'),
                                                  double.parse('$clientCount'),
                                                  double.parse('$orderCount'),
                                                ].reduce(
                                                  (a, b) => a > b ? a : b,
                                                ) +
                                                5
                                          : 10,
                                      barTouchData: BarTouchData(
                                        enabled: false,
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (val, _) {
                                              switch (val.toInt()) {
                                                case 0:
                                                  return const Text('Produits');
                                                case 1:
                                                  return const Text('Clients');
                                                case 2:
                                                  return const Text(
                                                    'Commandes',
                                                  );
                                              }
                                              return const Text('');
                                            },
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30,
                                          ),
                                        ),
                                        topTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                      ),
                                      gridData: FlGridData(show: false),
                                      borderData: FlBorderData(show: false),
                                      barGroups: [
                                        BarChartGroupData(
                                          x: 0,
                                          barRods: [
                                            BarChartRodData(
                                              toY: productCount.toDouble(),
                                              color: Colors.purple,
                                              width: 20,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 1,
                                          barRods: [
                                            BarChartRodData(
                                              toY: clientCount.toDouble(),
                                              color: Colors.teal,
                                              width: 20,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 2,
                                          barRods: [
                                            BarChartRodData(
                                              toY: orderCount.toDouble(),
                                              color: Colors.orange,
                                              width: 20,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildSummaryCard(
    String value,
    String label,
    Color bg,
    Color textColor,
  ) {
    return Container(
      width: 150, // Fixed width for wrap
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
