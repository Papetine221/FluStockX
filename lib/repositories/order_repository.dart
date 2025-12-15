import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techstock/config/api_config.dart';
import 'package:techstock/models/commande_model.dart';
import 'package:techstock/repositories/base_repository.dart';

class OrderRepository extends BaseRepository {
  Future<List<Commande>> getOrders() async {
    final uid = currentUserId;
    final uri = Uri.parse('${ApiConfig.baseUrl}/get_orders.php?user_id=$uid');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => Commande.fromMap(json)).toList();
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  Future<void> addOrder(Commande commande) async {
    final uid = currentUserId;
    final uri = Uri.parse('${ApiConfig.baseUrl}/add_order.php');

    // Create a simplified map for the API (as the model might have extra fields or different structure)
    // The PHP expects: user_id, client_id, total_amount, items: [{product_id, quantity, unit_price}]

    final body = {
      'user_id': uid,
      'client_id': commande.clientId,
      'total_amount': commande.totalAmount,
      'items': commande.items
          .map(
            (item) => {
              'product_id': item.productId,
              'quantity': item.quantity,
              'unit_price': item.unitPrice,
            },
          )
          .toList(),
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
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
