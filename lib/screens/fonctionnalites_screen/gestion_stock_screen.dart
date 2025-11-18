import 'package:flutter/material.dart';
import 'package:techstock/models/gestion_stock_model.dart';

class GestionStockScreen extends StatefulWidget {
  const GestionStockScreen({super.key});

  @override
  State<GestionStockScreen> createState() => _GestionStockScreenState();
}

class _GestionStockScreenState extends State<GestionStockScreen> {
  final List<Product> _products = [
    Product(id: 1, name: 'Clavier mécanique', description: 'Clavier RGB, switch brown', quantity: 12),
    Product(id: 2, name: 'Souris gaming', description: '16000 DPI, filaire', quantity: 8),
    Product(id: 3, name: 'SSD 1TB', description: 'NVMe M.2', quantity: 5),
  ];

  int _nextId = 4;
  String _searchTerm = '';

  List<Product> get _filteredProducts {
    final query = _searchTerm.trim().toLowerCase();
    if (query.isEmpty) return _products;
    return _products
        .where(
          (p) => p.name.toLowerCase().contains(query) || p.description.toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _showEditDialog({Product? product}) async {
    final isNew = product == null;
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final descCtrl = TextEditingController(text: product?.description ?? '');
    final qtyCtrl = TextEditingController(text: product != null ? product.quantity.toString() : '0');

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNew ? 'Ajouter un produit' : 'Modifier le produit'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
              ),
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: qtyCtrl,
                decoration: const InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Quantité requise';
                  final n = int.tryParse(v);
                  if (n == null) return 'Quantité invalide';
                  if (n < 0) return 'Quantité >= 0';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final name = nameCtrl.text.trim();
                final desc = descCtrl.text.trim();
                final qty = int.parse(qtyCtrl.text.trim());

                setState(() {
                  if (isNew) {
                    _products.add(Product(id: _nextId++, name: name, description: desc, quantity: qty));
                  } else {
                    product.name = name;
                    product.description = desc;
                    product.quantity = qty;
                  }
                });

                Navigator.of(context).pop(true);
              }
            },
            child: Text(isNew ? 'Ajouter' : 'Enregistrer'),
          ),
        ],
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isNew ? 'Produit ajouté' : 'Produit mis à jour')),
      );
    }
  }

  Future<void> _confirmDelete(Product p) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Supprimer "${p.name}" ? Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Annuler')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Supprimer')),
        ],
      ),
    );

    if (yes == true) {
      setState(() => _products.removeWhere((e) => e.id == p.id));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produit supprimé')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = _filteredProducts;
    final isQueryActive = _searchTerm.trim().isNotEmpty;
    final trimmedQuery = _searchTerm.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Stocks'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un produit'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              onChanged: (value) => setState(() => _searchTerm = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Rechercher un produit',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _products.isEmpty && !isQueryActive
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Aucun produit', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _showEditDialog(),
                          child: const Text('Ajouter le premier produit'),
                        ),
                      ],
                    ),
                  )
                : visibleProducts.isEmpty
                    ? Center(
                        child: Text(
                          "Aucun résultat pour \"$trimmedQuery\"",
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemCount: visibleProducts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final p = visibleProducts[i];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${p.description}\nQuantité: ${p.quantity}',
                                style: const TextStyle(height: 1.4),
                              ),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Modifier',
                                    icon: const Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () => _showEditDialog(product: p),
                                  ),
                                  IconButton(
                                    tooltip: 'Supprimer',
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDelete(p),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
