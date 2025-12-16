// Author: Papetine221
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

  Future<void> updateProduct(Product product) async {
    try {
      final uid = currentUserId;
      final uri = Uri.parse(ApiConfig.updateProduct);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': product.id,
          'user_id': uid,
          'name': product.name,
          'category': product.category,
          'stockQuantity': product.quantity,
          'minThreshold': product.minThreshold,
          'formattedPrice': '${product.price.toStringAsFixed(0)} FCFA',
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
      throw Exception('Erreur modification produit: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final uid = currentUserId;
      final uri = Uri.parse(ApiConfig.deleteProduct);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'user_id': uid}),
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
      throw Exception('Erreur suppression produit: $e');
    }
  }
}
