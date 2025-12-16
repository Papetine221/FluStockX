// Author: Papetine221
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techstock/config/api_config.dart';
import 'package:techstock/models/gestion_comptable_model.dart';
import 'package:techstock/repositories/base_repository.dart';

class TransactionRepository extends BaseRepository {
  Future<List<Transaction>> getTransactions() async {
    final uid = currentUserId;
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/get_transactions.php?user_id=$uid',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => Transaction.fromMap(json)).toList();
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    final uid = currentUserId;
    final uri = Uri.parse('${ApiConfig.baseUrl}/add_transaction.php');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({...transaction.toMap(), 'user_id': uid}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] != 'success') {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  Future<void> deleteTransaction(String id) async {
    final uid = currentUserId;
    final uri = Uri.parse(ApiConfig.deleteTransaction);

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'user_id': uid}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] != 'success') {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }
}
