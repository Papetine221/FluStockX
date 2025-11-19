import 'package:flutter_riverpod/legacy.dart';
import 'package:state_notifier/state_notifier.dart';

/// Contrôleur d'authentification très simple pour simuler une connexion.
class AuthController extends StateNotifier<bool> {
  AuthController() : super(false);

  void login() => state = true;

  void logout() => state = false;
}

/// Provider global permettant aux widgets d'écouter l'état de connexion.
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(),
);
