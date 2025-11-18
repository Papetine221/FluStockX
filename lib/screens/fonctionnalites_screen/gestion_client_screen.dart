import 'package:flutter/material.dart';
import 'package:techstock/models/gestion_client_model.dart';
import 'package:techstock/widgets/main_app_bar.dart';

class GestionClientScreen extends StatefulWidget { 
  const GestionClientScreen({Key? key}) : super(key: key);

  static const routeName = '/clients';

  @override
  State<GestionClientScreen> createState() => _GestionClientScreenState();
}

class _GestionClientScreenState extends State<GestionClientScreen> {
  final List<Client> _clients = [
    Client(id: 1, name: 'Mamadou Ndiaye', email: 'mamadou@gmail.com', phone: '77 123 45 67'),
    Client(id: 2, name: 'Awa Diop', email: 'awa.diop@gmail.com', phone: '76 998 11 22'),
    Client(id: 3, name: 'Ousmane Sarr', email: 'sarr.ousmane@gmail.com', phone: '78 221 44 55'),
  ];

  int _nextId = 4;
  String _searchTerm = '';

  List<Client> get _filteredClients {
    final query = _searchTerm.trim().toLowerCase();
    if (query.isEmpty) return _clients;
    return _clients
        .where(
          (c) =>
              c.name.toLowerCase().contains(query) ||
              c.email.toLowerCase().contains(query) ||
              c.phone.toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _showEditDialog({Client? client}) async {
    final isNew = client == null;

    final nameCtrl = TextEditingController(text: client?.name ?? '');
    final emailCtrl = TextEditingController(text: client?.email ?? '');
    final phoneCtrl = TextEditingController(text: client?.phone ?? '');

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNew ? 'Ajouter un client' : 'Modifier le client'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nom du client'),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
              ),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Téléphone'),
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
                final email = emailCtrl.text.trim();
                final phone = phoneCtrl.text.trim();

                setState(() {
                  if (isNew) {
                    _clients.add(
                      Client(id: _nextId++, name: name, email: email, phone: phone),
                    );
                  } else {
                    client.name = name;
                    client.email = email;
                    client.phone = phone;
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
        SnackBar(content: Text(isNew ? 'Client ajouté' : 'Client mis à jour')),
      );
    }
  }

  Future<void> _confirmDelete(Client c) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Supprimer "${c.name}" ? Cette action est irréversible.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler')),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Supprimer')),
        ],
      ),
    );

    if (yes == true) {
      setState(() => _clients.removeWhere((e) => e.id == c.id));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Client supprimé')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleClients = _filteredClients;
    final trimmedQuery = _searchTerm.trim();
    final isQueryActive = trimmedQuery.isNotEmpty;

    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un client'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              onChanged: (value) => setState(() => _searchTerm = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Rechercher un client',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _clients.isEmpty && !isQueryActive
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Aucun client', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _showEditDialog(),
                          child: const Text('Ajouter le premier client'),
                        ),
                      ],
                    ),
                  )
                : visibleClients.isEmpty
                    ? Center(
                        child: Text(
                          "Aucun résultat pour \"$trimmedQuery\"",
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemCount: visibleClients.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final c = visibleClients[i];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                'Email : ${c.email}\nTéléphone : ${c.phone}',
                                style: const TextStyle(height: 1.4),
                              ),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Modifier',
                                    icon: const Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () => _showEditDialog(client: c),
                                  ),
                                  IconButton(
                                    tooltip: 'Supprimer',
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDelete(c),
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
