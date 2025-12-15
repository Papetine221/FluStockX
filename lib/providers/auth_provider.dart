import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      print('[AuthController] Attempting login for $email');
      await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password)
          .timeout(const Duration(seconds: 15)); // Add timeout
      print('[AuthController] Login successful');
      state = const AsyncData(null);
    } catch (e, st) {
      print('[AuthController] Login failed: $e');
      state = AsyncError(e, st);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String shopName,
  }) async {
    state = const AsyncLoading();
    try {
      print('[AuthController] Attempting register for $email');
      await ref
          .read(authRepositoryProvider)
          .signUp(
            email: email,
            password: password,
            name: name,
            phone: phone,
            shopName: shopName,
          )
          .timeout(const Duration(seconds: 15)); // Add timeout
      print('[AuthController] Register successful');
      state = const AsyncData(null);
    } catch (e, st) {
      print('[AuthController] Register failed: $e');
      if (e is TimeoutException) {
        state = AsyncError(
          'Le serveur ne répond pas (Timeout). Vérifiez votre connexion ou la configuration Firebase.',
          st,
        );
      } else {
        state = AsyncError(e, st);
      }
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);
