import 'package:flutter/material.dart';
import 'package:techstock/models/gestion_stock_model.dart';
import 'package:techstock/widgets/main_app_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techstock/providers/data_providers.dart';

class GestionStockScreen extends ConsumerStatefulWidget {
  const GestionStockScreen({super.key});

  static const routeName = '/stocks';

  @override
  ConsumerState<GestionStockScreen> createState() => _GestionStockScreenState();
}

class _GestionStockScreenState extends ConsumerState<GestionStockScreen> {
  // Mock data removed. We use 'ref.watch(productsProvider)' in build.

  String _searchTerm = '';

  Future<void> _showEditDialog({Product? product}) async {
    final isNew = product == null;
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final descCtrl = TextEditingController(text: product?.description ?? '');
    final qtyCtrl = TextEditingController(
      text: product != null ? product.quantity.toString() : '0',
    );
    final priceCtrl = TextEditingController(
      text: product != null ? product.price.toStringAsFixed(2) : '0.00',
    );

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
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
              ),
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),

              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Prix requis';
                  final n = double.tryParse(v.replaceAll(',', '.'));
                  if (n == null) return 'Prix invalide';
                  if (n < 0) return 'Prix >= 0';
                  return null;
                },
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
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final name = nameCtrl.text.trim();
                final desc = descCtrl.text.trim();
                final qty = int.parse(qtyCtrl.text.trim());
                final price = double.parse(
                  priceCtrl.text.replaceAll(',', '.').trim(),
                );

                // Async save
                final newProduct = Product(
                  id: isNew
                      ? 0
                      : product
                            .id, // 0 for new, ID for update (not used in add yet)
                  name: name,
                  description: desc,
                  quantity: qty,
                  price: price,
                  category: 'Divers', // Default for now
                );

                try {
                  if (isNew) {
                    await ref
                        .read(productRepositoryProvider)
                        .addProduct(newProduct);
                  } else {
                    // Update not implemented in repo yet, show snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Mise à jour pas encore connectée à l\'API pour les produits.',
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                    return;
                  }

                  // Refresh the list
                  ref.refresh(productsProvider);
                  Navigator.of(context).pop(true);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
                }
                // Removed setState/local update logic
              }
            },
            child: Text(isNew ? 'Ajouter' : 'Enregistrer'),
          ),
        ],
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isNew ? 'Produit ajouté' : 'Produit mis à jour'),
        ),
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
      // Delete unimplemented in UI yet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Suppression non implémentée (API)')),
      );
      // await ref.read(productRepositoryProvider).deleteProduct(p.id);
      // ref.refresh(productsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: const MainAppBar(),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur: $err')),
              data: (products) {
                final query = _searchTerm.trim().toLowerCase();
                final visibleProducts = query.isEmpty
                    ? products
                    : products
                          .where(
                            (p) =>
                                p.name.toLowerCase().contains(query) ||
                                p.description.toLowerCase().contains(query),
                          )
                          .toList();

                if (visibleProducts.isEmpty) {
                  return const Center(child: Text("Aucun produit trouvé"));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  itemCount: visibleProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = visibleProducts[i];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        title: Text(
                          p.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${p.description}\nPrix: ${p.price.toStringAsFixed(2)} €  |  Stocks: ${p.quantity}',
                          style: const TextStyle(height: 1.4),
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Modifier',
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
