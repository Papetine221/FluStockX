import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techstock/config/api_config.dart';
import 'package:techstock/models/gestion_stock_model.dart';
import 'package:techstock/repositories/base_repository.dart';

class ProductRepository extends BaseRepository {
  Future<List<Product>> getProducts() async {
    try {
      final uid = currentUserId;
      final uri = Uri.parse('${ApiConfig.getProducts}?user_id=$uid');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Product.fromMap(json)).toList();
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Impossible de charger les produits: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final uid = currentUserId;
      final uri = Uri.parse(ApiConfig.addProduct);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': uid,
          'name': product.name,
          'category': product.category,
          'stockQuantity': product.quantity,
          'minThreshold': product.minThreshold,
          'formattedPrice':
              '${product.price.toStringAsFixed(0)} FCFA', // Simple formatting
          'sellingPrice': product.price,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] != 'success') {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur ajout produit: $e');
    }
  }
}
