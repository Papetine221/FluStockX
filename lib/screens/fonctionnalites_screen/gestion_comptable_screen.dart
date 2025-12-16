import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techstock/models/gestion_comptable_model.dart';
import 'package:techstock/providers/data_providers.dart';
import 'package:techstock/widgets/main_app_bar.dart';

class GestionComptableScreen extends ConsumerStatefulWidget {
  const GestionComptableScreen({super.key});

  static const routeName = '/accounting';

  @override
  ConsumerState<GestionComptableScreen> createState() =>
      _GestionComptableScreenState();
}

class _GestionComptableScreenState
    extends ConsumerState<GestionComptableScreen> {
  AccountingSummary _calculateSummary(List<Transaction> transactions) {
    double income = 0;
    double expense = 0;
    for (var t in transactions) {
      if (t.type == 'income') {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    double margin = income - expense;
    double net = margin > 0 ? margin * 0.8 : margin;

    return AccountingSummary(
      totalIncome: income,
      totalExpense: expense,
      grossMargin: margin,
      netProfit: net,
    );
  }

  void _showTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) => _TransactionDialog(
        onSave: (t) async {
          try {
            await ref.read(transactionRepositoryProvider).addTransaction(t);
            ref.refresh(transactionsProvider);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction ajoutée')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
            }
          }
        },
      ),
    );
  }

  Future<void> _deleteTransaction(String id) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Supprimer cette transaction ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (yes == true) {
      try {
        await ref.read(transactionRepositoryProvider).deleteTransaction(id);
        ref.refresh(transactionsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction supprimée')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTransactionDialog,
        icon: const Icon(Icons.add),
        label: const Text('Transaction'),
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (transactions) {
          final summary = _calculateSummary(transactions);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Revenus',
                        amount: summary.totalIncome,
                        color: Colors.green,
                        icon: Icons.arrow_upward,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Dépenses',
                        amount: summary.totalExpense,
                        color: Colors.red,
                        icon: Icons.arrow_downward,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Marge Brute',
                        amount: summary.grossMargin,
                        color: summary.grossMargin >= 0
                            ? Colors.blue
                            : Colors.orange,
                        icon: Icons.functions,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Bénéfice Net',
                        amount: summary.netProfit,
                        color: summary.netProfit >= 0
                            ? Colors.green
                            : Colors.red,
                        icon: Icons.account_balance_wallet,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Transactions Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Historique',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${transactions.length} entrées',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Transactions List
                transactions.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('Aucune transaction.'),
                        ),
                      )
                    : ListView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), // Scroll managed by SingleChildScrollView
                        shrinkWrap: true,
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final t = transactions[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: t.type == 'income'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                child: Icon(
                                  t.type == 'income'
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: t.type == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                t.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${t.category} • ${_formatDate(t.date)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${t.type == 'income' ? '+' : '-'} ${t.amount.toStringAsFixed(2)} FCFA',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: t.type == 'income'
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 15,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => _deleteTransaction(t.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${amount.toStringAsFixed(2)} FCFA',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionDialog extends StatefulWidget {
  final Function(Transaction) onSave;

  const _TransactionDialog({required this.onSave});

  @override
  State<_TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<_TransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  String _type = 'income'; // 'income' or 'expense'
  String _category = 'Ventes';

  final List<String> _incomeCats = ['Ventes', 'Investissements', 'Autres'];
  final List<String> _expenseCats = [
    'Salaires',
    'Loyer',
    'Fournitures',
    'Marketing',
    'Divers',
  ];

  @override
  void initState() {
    super.initState();
    // Set default category based on initial type
    _category = _incomeCats.first;
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final t = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: _descCtrl.text.trim(),
        amount: double.parse(_amountCtrl.text.replaceAll(',', '.')),
        date: DateTime.now(),
        category: _category,
        type: _type,
      );
      widget.onSave(t);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle Transaction'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Type Selector
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Revenu'),
                      value: 'income',
                      groupValue: _type,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() {
                        _type = val!;
                        _category = _incomeCats.first;
                      }),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Dépense'),
                      value: 'expense',
                      groupValue: _type,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() {
                        _type = val!;
                        _category = _expenseCats.first;
                      }),
                    ),
                  ),
                ],
              ),

              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: (_type == 'income' ? _incomeCats : _expenseCats)
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Ex: Vente X',
                ),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  suffixText: 'FCFA',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requis';
                  if (double.tryParse(v.replaceAll(',', '.')) == null)
                    return 'Invalide';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Enregistrer')),
      ],
    );
  }
}
