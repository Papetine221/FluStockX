import 'package:flutter/material.dart';
import 'package:techstock/models/gestion_comptable_model.dart';
import 'package:techstock/widgets/main_app_bar.dart';

class GestionComptableScreen extends StatefulWidget {
  const GestionComptableScreen({super.key});

  static const routeName = '/accounting';

  @override
  State<GestionComptableScreen> createState() => _GestionComptableScreenState();
}

class _GestionComptableScreenState extends State<GestionComptableScreen> {
  final _service = _AccountingService();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: _currentIndex == 0 ? _buildDashboard() : _buildTransactions(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTransactionForm,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => setState(() => _currentIndex = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Transactions',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    final resume = _service.getResume();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Résumé comptable',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow(
                    'Revenus',
                    resume.totalRevenus,
                    Colors.green,
                  ),
                  _buildSummaryRow(
                    'Dépenses',
                    resume.totalDepenses,
                    Colors.red,
                  ),
                  _buildSummaryRow(
                    'Marge brute',
                    resume.margeBrute,
                    resume.margeBrute >= 0 ? Colors.blue : Colors.orange,
                  ),
                  _buildSummaryRow(
                    'Bénéfice net',
                    resume.beneficeNet,
                    resume.beneficeNet >= 0 ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildFlowChart(resume),
          const SizedBox(height: 20),
          _buildLatestTransactions(),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            _formatCurrency(value),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowChart(ResumeComptable resume) {
    final total = resume.totalRevenus + resume.totalDepenses;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Répartition des flux',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (total > 0) ...[
              _buildBar('Revenus', resume.totalRevenus, total, Colors.green),
              const SizedBox(height: 10),
              _buildBar('Dépenses', resume.totalDepenses, total, Colors.red),
            ] else
              const Text(
                'Aucune donnée disponible',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, double value, double total, Color color) {
    final ratio = total > 0 ? value / total : 0.0;
    final percent = total > 0 ? ratio * 100 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${_formatCurrency(value)} (${percent.toStringAsFixed(1)}%)'),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: ratio,
          minHeight: 8,
          backgroundColor: Colors.grey.shade200,
          color: color,
        ),
      ],
    );
  }

  Widget _buildLatestTransactions() {
    final transactions = _service.transactions;
    final lastTransactions = transactions.length > 3
        ? transactions.sublist(transactions.length - 3)
        : transactions;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dernières transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => setState(() => _currentIndex = 1),
                  child: const Text('Voir tout'),
                ),
              ],
            ),
            if (lastTransactions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Aucune transaction pour le moment. Cliquez sur + pour ajouter.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...lastTransactions.reversed.map(_buildTransactionTile),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactions() {
    final transactions = _service.transactions;
    final reversedTransactions = transactions.reversed.toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Toutes les transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Chip(
                label: Text('${transactions.length} entrées'),
                backgroundColor: Colors.grey.shade200,
              ),
            ],
          ),
        ),
        Expanded(
          child: transactions.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Aucune transaction enregistrée',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ajoutez-en via le bouton +',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: reversedTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = reversedTransactions[index];
                    return _buildTransactionCard(transaction);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(Transaction transaction) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: transaction.type == 'revenu'
            ? Colors.green
            : Colors.red,
        child: Icon(
          transaction.type == 'revenu'
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          color: Colors.white,
          size: 18,
        ),
      ),
      title: Text(
        transaction.description,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${_formatDate(transaction.date)} · ${transaction.categorie}',
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: Text(
        _formatCurrency(transaction.montant),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: transaction.type == 'revenu' ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.type == 'revenu'
              ? Colors.green
              : Colors.red,
          child: Icon(
            transaction.type == 'revenu'
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.categorie),
            Text(
              _formatDate(transaction.date),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(transaction.montant),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: transaction.type == 'revenu'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                Text(
                  transaction.type == 'revenu' ? 'Revenu' : 'Dépense',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  _showTransactionForm(existing: transaction);
                } else if (value == 'delete') {
                  _confirmDelete(transaction.id);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Modifier')),
                PopupMenuItem(value: 'delete', child: Text('Supprimer')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la transaction'),
        content: const Text(
          'Cette action est irréversible. Voulez-vous continuer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _service.deleteTransaction(id);
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showTransactionForm({Transaction? existing}) {
    showDialog<void>(
      context: context,
      builder: (context) => _TransactionForm(
        initial: existing,
        onSave: (transaction) {
          if (existing == null) {
            _service.addTransaction(transaction);
          } else {
            _service.updateTransaction(existing.id, transaction);
          }
          Navigator.of(context).pop();
          setState(() {});
        },
      ),
    );
  }

  String _formatCurrency(double value) => '${value.toStringAsFixed(2)} €';

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _TransactionForm extends StatefulWidget {
  const _TransactionForm({required this.onSave, this.initial});

  final void Function(Transaction) onSave;
  final Transaction? initial;

  @override
  State<_TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<_TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _amountCtrl;
  late DateTime _selectedDate;
  String _selectedType = 'revenu';
  String _selectedCategory = 'Ventes';

  final List<String> _incomeCategories = [
    'Ventes',
    'Investissements',
    'Subventions',
    'Autres revenus',
  ];
  final List<String> _expenseCategories = [
    'Salaires',
    'Loyer',
    'Fournitures',
    'Marketing',
    'Transport',
    'Autres dépenses',
  ];

  @override
  void initState() {
    super.initState();
    _descriptionCtrl = TextEditingController(
      text: widget.initial?.description ?? '',
    );
    _amountCtrl = TextEditingController(
      text: widget.initial != null
          ? widget.initial!.montant.toStringAsFixed(2)
          : '',
    );
    _selectedType = widget.initial?.type ?? 'revenu';
    _selectedCategory = widget.initial?.categorie ?? _incomeCategories.first;
    _selectedDate = widget.initial?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _selectedType == 'revenu'
        ? _incomeCategories
        : _expenseCategories;

    return AlertDialog(
      title: Text(
        widget.initial == null
            ? 'Nouvelle transaction'
            : 'Modifier la transaction',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'revenu', child: Text('Revenu')),
                  DropdownMenuItem(value: 'depense', child: Text('Dépense')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedType = value;
                    final defaultList = value == 'revenu'
                        ? _incomeCategories
                        : _expenseCategories;
                    _selectedCategory = defaultList.first;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: categories.contains(_selectedCategory)
                    ? _selectedCategory
                    : categories.first,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(
                  () => _selectedCategory = value ?? categories.first,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Vente produit X',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Description requise'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 150.00',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Montant requis';
                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) return 'Montant invalide';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
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

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amount = double.parse(_amountCtrl.text.replaceAll(',', '.'));
    final transaction = Transaction(
      id:
          widget.initial?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      description: _descriptionCtrl.text.trim(),
      montant: amount,
      date: _selectedDate,
      categorie: _selectedCategory,
      type: _selectedType,
    );

    widget.onSave(transaction);
  }
}

class _AccountingService {
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      description: 'Vente PC Gamer',
      montant: 1899.99,
      date: DateTime.now().subtract(const Duration(days: 3)),
      categorie: 'Ventes',
      type: 'revenu',
    ),
    Transaction(
      id: '2',
      description: 'Achat stock périphériques',
      montant: 540.25,
      date: DateTime.now().subtract(const Duration(days: 2)),
      categorie: 'Fournitures',
      type: 'depense',
    ),
    Transaction(
      id: '3',
      description: 'Campagne publicitaire',
      montant: 320.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      categorie: 'Marketing',
      type: 'depense',
    ),
  ];

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  void addTransaction(Transaction transaction) =>
      _transactions.add(transaction);

  void updateTransaction(String id, Transaction updated) {
    final index = _transactions.indexWhere(
      (transaction) => transaction.id == id,
    );
    if (index != -1) {
      _transactions[index] = updated;
    }
  }

  void deleteTransaction(String id) =>
      _transactions.removeWhere((transaction) => transaction.id == id);

  ResumeComptable getResume() {
    final totalRevenue = _transactions
        .where((transaction) => transaction.type == 'revenu')
        .fold<double>(0, (sum, transaction) => sum + transaction.montant);
    final totalExpense = _transactions
        .where((transaction) => transaction.type == 'depense')
        .fold<double>(0, (sum, transaction) => sum + transaction.montant);
    final margin = totalRevenue - totalExpense;
    final net = margin > 0 ? margin * 0.8 : margin;

    return ResumeComptable(
      totalRevenus: totalRevenue,
      totalDepenses: totalExpense,
      margeBrute: margin,
      beneficeNet: net,
    );
  }
}
