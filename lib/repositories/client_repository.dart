// Author: Papetine221
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techstock/config/api_config.dart';
import 'package:techstock/models/gestion_client_model.dart';
import 'package:techstock/repositories/base_repository.dart';

class ClientRepository extends BaseRepository {
  Future<List<Client>> getClients() async {
    try {
      final uid = currentUserId;
      final uri = Uri.parse('${ApiConfig.getClients}?user_id=$uid');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Client.fromMap(json)).toList();
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Impossible de charger les clients: $e');
    }
  }

  Future<void> addClient(Client client) async {
    try {
      final uid = currentUserId;
      final uri = Uri.parse(ApiConfig.addClient);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': uid,
          'name': client.name,
          'email': client.email,
          'phone': client.phone,
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
      throw Exception('Erreur lors de l\'ajout: $e');
    }
  }

  Future<void> updateClient(Client client) async {
    try {
      final uid = currentUserId;
      final uri = Uri.parse(ApiConfig.updateClient);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': client.id,
          'user_id': uid,
          'name': client.name,
          'email': client.email,
          'phone': client.phone,
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
      throw Exception('Erreur lors de la modification: $e');
    }
  }

  Future<void> deleteClient(String id) async {
    try {
      final uid = currentUserId;
      final uri = Uri.parse(ApiConfig.deleteClient);

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
      throw Exception('Erreur lors de la suppression: $e');
    }
  }
}
