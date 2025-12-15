import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techstock/models/gestion_client_model.dart';
import 'package:techstock/models/gestion_stock_model.dart';
import 'package:techstock/repositories/client_repository.dart';
import 'package:techstock/repositories/product_repository.dart';
import 'package:techstock/models/commande_model.dart';
import 'package:techstock/repositories/order_repository.dart';
import 'package:techstock/models/gestion_comptable_model.dart';
import 'package:techstock/repositories/transaction_repository.dart';

// --- Repositories Providers ---
final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  return ClientRepository();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

// --- Data Providers (Async) ---

// Clients List
final clientsProvider = FutureProvider.autoDispose<List<Client>>((ref) async {
  final repository = ref.watch(clientRepositoryProvider);
  return repository.getClients();
});

// Products List
final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

// Orders List
final ordersProvider = FutureProvider.autoDispose<List<Commande>>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getOrders();
});

// Transactions List
final transactionsProvider = FutureProvider.autoDispose<List<Transaction>>((
  ref,
) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTransactions();
});
