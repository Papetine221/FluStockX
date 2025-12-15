import 'package:flutter/material.dart';
import 'package:techstock/models/commande_model.dart';
import 'package:techstock/models/gestion_client_model.dart';
import 'package:techstock/models/gestion_stock_model.dart';
import 'package:techstock/widgets/main_app_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techstock/providers/data_providers.dart';

class CommandeScreen extends ConsumerStatefulWidget {
  const CommandeScreen({super.key});

  static const routeName = '/commandes';

  @override
  ConsumerState<CommandeScreen> createState() => _CommandeScreenState();
}

class _CommandeScreenState extends ConsumerState<CommandeScreen> {
  void _showAddOrderDialog() {
    final clientsAsync = ref.read(clientsProvider);
    final productsAsync = ref.read(productsProvider);

    showDialog(
      context: context,
      builder: (context) => _AddOrderDialog(
        clients: clientsAsync.value ?? [],
        products: productsAsync.value ?? [],
        onSave: (commande) async {
          try {
            // API Call
            await ref.read(orderRepositoryProvider).addOrder(commande);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Commande enregistrée !')),
            );
            // Refresh Orders
            ref.refresh(ordersProvider);
            // Also refresh products because stocks changed !
            ref.refresh(productsProvider);
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsProvider);
    final productsAsync = ref.watch(productsProvider);
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (clientsAsync.hasValue && productsAsync.hasValue)
            ? _showAddOrderDialog
            : null,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle Commande'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Historique des Commandes',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Show count only if loaded
                if (ordersAsync.hasValue)
                  Chip(label: Text('${ordersAsync.value!.length} commandes')),
              ],
            ),
          ),

          if (clientsAsync.isLoading ||
              productsAsync.isLoading ||
              ordersAsync.isLoading)
            const LinearProgressIndicator(),

          Expanded(
            child: ordersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur: $err')),
              data: (orders) {
                if (orders.isEmpty) {
                  return const Center(
                    child: Text('Aucune commande enregistrée.'),
                  );
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final commande = orders[index];
                    // Use Client List to find name
                    // Note: If client list is not fully loaded or pagination used later, this might fail.
                    // For now we assume fetch all clients is fast.
                    final clients = clientsAsync.value ?? [];
                    final clientIdx = clients.indexWhere(
                      (c) => c.id.toString() == commande.clientId,
                    );
                    final clientName = clientIdx != -1
                        ? clients[clientIdx].name
                        : 'Client ID: ${commande.clientId}';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          'Commande #${commande.id}', // ID from DB
                        ),
                        subtitle: Text(
                          '$clientName - ${commande.totalAmount.toStringAsFixed(2)} €\n${commande.date.day}/${commande.date.month}/${commande.date.year}',
                        ),
                        children: commande.items.map((item) {
                          return ListTile(
                            title: Text(
                              item.productName ??
                                  'Produit ID ${item.productId}',
                            ),
                            subtitle: Text('PU: ${item.unitPrice} €'),
                            trailing: Text(
                              'x${item.quantity} = ${item.total.toStringAsFixed(2)} €',
                            ),
                          );
                        }).toList(),
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

class _AddOrderDialog extends StatefulWidget {
  final List<Client> clients;
  final List<Product> products;
  final Function(Commande) onSave;

  const _AddOrderDialog({
    required this.clients,
    required this.products,
    required this.onSave,
  });

  @override
  State<_AddOrderDialog> createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<_AddOrderDialog> {
  Client? _selectedClient;
  final List<LigneCommande> _items = [];

  // Temporary selection variables
  Product? _tempProduct;
  int _tempQuantity = 1;

  void _addItem() {
    if (_tempProduct == null) return;

    setState(() {
      _items.add(
        LigneCommande(
          productId: _tempProduct!.id.toString(),
          productName: _tempProduct!.name,
          quantity: _tempQuantity,
          unitPrice: _tempProduct!.price,
        ),
      );
      // Reset temp selection
      _tempProduct = null;
      _tempQuantity = 1;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  double get _totalAmount => _items.fold(0, (sum, item) => sum + item.total);

  void _save() {
    if (_selectedClient == null || _items.isEmpty) return;

    final commande = Commande(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clientId: _selectedClient!.id.toString(),
      date: DateTime.now(),
      items: List.from(_items),
    );

    widget.onSave(commande);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          children: [
            const Text(
              'Nouvelle Commande',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Client Selection
            DropdownButtonFormField<Client>(
              value: _selectedClient,
              decoration: const InputDecoration(
                labelText: 'Client',
                border: OutlineInputBorder(),
              ),
              items: widget.clients
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedClient = val),
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Product Selection Area
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<Product>(
                    value: _tempProduct,
                    decoration: const InputDecoration(
                      labelText: 'Produit',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                    ),
                    items: widget.products
                        .map(
                          (p) => DropdownMenuItem(
                            value: p,
                            child: Text(
                              '${p.name} (${p.price}€)',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _tempProduct = val),
                    isExpanded: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Qté'),
                    onChanged: (val) {
                      final v = int.tryParse(val);
                      if (v != null && v > 0) _tempQuantity = v;
                    },
                  ),
                ),
                IconButton(
                  onPressed: _tempProduct != null ? _addItem : null,
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
              ],
            ),
            const Divider(),

            // List of Items
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    dense: true,
                    title: Text(item.productName),
                    subtitle: Text('${item.quantity} x ${item.unitPrice} €'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${item.total.toStringAsFixed(2)} €',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => _removeItem(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_totalAmount.toStringAsFixed(2)} €',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: (_selectedClient != null && _items.isNotEmpty)
                      ? _save
                      : null,
                  child: const Text('Valider la Commande'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
