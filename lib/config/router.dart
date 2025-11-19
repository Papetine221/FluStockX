// Fichier : lib/config/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/fonctionnalites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final requestedLocation = state.matchedLocation;
      final isGoingToLogin = requestedLocation == '/login';

      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }
      if (isLoggedIn && isGoingToLogin) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/fonctionnalites',
        name: 'fonctionnalites',
        builder: (context, state) => const FonctionnalitesScreen(),
      ),
    ],
  );
});

void navigateToFeatures(
  BuildContext context,
  WidgetRef ref, {
  bool replace = false,
}) {
  final isLoggedIn = ref.read(authControllerProvider);
  if (!isLoggedIn) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Veuillez vous connecter pour accéder aux fonctionnalités.',
        ),
      ),
    );
    if (ModalRoute.of(context)?.settings.name != LoginScreen.routeName) {
      Navigator.of(context).pushNamed(LoginScreen.routeName);
    }
    return;
  }

  if (replace) {
    Navigator.of(context).pushReplacementNamed(FonctionnalitesScreen.routeName);
  } else {
    Navigator.of(context).pushNamed(FonctionnalitesScreen.routeName);
  }
}
