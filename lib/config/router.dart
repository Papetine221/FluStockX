// Fichier : lib/config/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/fonctionnalites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/home', // Or check logic below
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = authState.isLoading;
      final requestedLocation = state.matchedLocation;
      final isGoingToLogin = requestedLocation == '/login';
      final isGoingToRegister = requestedLocation == '/register';

      // If state is loading, maybe don't redirect yet?
      // Or show a splash screen?
      // For now, let's assume if loading, we wait (or treat as not logged in).
      // But actually, StreamProvider emits null initially or loading.

      if (isLoggingIn) return null; // Do nothing while loading

      if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
        return '/login';
      }
      if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
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
        path: '/register',
        name: 'register',
        builder: (context, state) =>
            const RegisterScreen(), // Error in imports?
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
  final authState = ref.read(authStateChangesProvider);
  final isLoggedIn = authState.value != null;

  if (!isLoggedIn) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Veuillez vous connecter pour accéder aux fonctionnalités.',
        ),
      ),
    );
    // Note: Navigator.pushNamed might conflict with GoRouter if mixed.
    // But existing code used Navigator. checking if we should use context.goNamed
    // But keeping Navigator for now as 'router.dart' uses GoRouter but 'navigateToFeatures' uses Navigator?
    // Wait, the new 'routerProvider' creates a GoRouter, so we should arguably use GoRouter methods.
    // However, the existing 'navigateToFeatures' used Navigator calls.

    // I will stick to what was there but use context.push if possible OR
    // check if 'context' is from GoRouter.

    if (ModalRoute.of(context)?.settings.name != LoginScreen.routeName) {
      // If we are using GoRouter, routeName static constants might be useful identifiers but
      // Navigator.of(context).pushNamed expects a Map<String, WidgetBuilder> in MaterialApp(routes: ...)
      // BUT Main.dart defines routes: {...} map!
      // AND Main.dart uses initialRoute.
      // AND Main.dart DOES NOT use routerConfig: router.

      // WAIT. Main.dart uses `routes: {...}` map.
      // It DOES NOT use `GoRouter`.
      // The `router.dart` file defines a `routerProvider` that returns a `GoRouter`, BUT IT IS NOT USED IN MAIN.DART.

      // STOP. CHECK MAIN.DART AGAIN (File 6).
      // Main.dart:
      // routes: {
      //   HomeScreen.routeName: (_) => const HomeScreen(),
      //   ...
      // }

      // So the `router.dart` file implies there is INTENT to use GoRouter, but `main.dart` is currently using standard Navigator 1.0.
      // AND `navigateToFeatures` helper is using Navigator 1.0.

      // IF I change `router.dart`, I am changing an unused provider?
      // OR is `main.dart` supposed to be changed to use `GoRouter`?
      // The user task is "gere l'authentication via firebase". Not "migrate to GoRouter".

      // HOWEVER, `router.dart` was open.

      // If `main.dart` uses `routes`, then `navigateToFeatures` works with names.
      // `router.dart` seems to be an attempt or partial implementation of GoRouter.

      // BUT `router.dart` imports `../providers/auth_provider.dart` and uses `authControllerProvider`.
      // If I change `authControllerProvider`, I break `router.dart` compilation even if it's unused at runtime (assuming it's compiled).

      // So I MUST update `router.dart` to fix compilation errors, even if it's not used.
      // OR I should focus on `navigateToFeatures` which IS used.

      // Let's look at `navigateToFeatures` in `router.dart`.
      // It uses `ref.read(authControllerProvider)`. which was returning boolean.

      // My update to `authControllerProvider` now returns `AsyncValue<void>`.
      // So I must Fix `navigateToFeatures`.

      // Logic for `navigateToFeatures`:
      // `final isLoggedIn = ref.read(authStateChangesProvider).value != null;` (Check stream value)

      // And I should fix the unused `routerProvider` too just in case.

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
