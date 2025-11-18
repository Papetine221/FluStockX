// Fichier : lib/config/router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 1. Importez votre provider d'authentification.
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/fonctionnalites_screen.dart';
// 2. On change le Provider pour qu'il puisse lire d'autres providers.
// On lui passe 'ref' en paramètre.
final routerProvider = Provider<GoRouter>((ref) {
  // 3. On crée une clé pour écouter l'état d'authentification.
  final authState = ref.watch(authStateProvider);
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      // 'state.matchedLocation' est l'adresse où l'utilisateur VEUT aller.
      final requestedLocation = state.matchedLocation;

      // Est-ce que l'utilisateur est sur la page de connexion ?
      final isGoingToLogin = requestedLocation == '/login';
      // Si l'utilisateur n'est PAS connecté ET qu'il ne va PAS déjà vers la page de login,
      // alors on le redirige vers '/login'.
      if (!authState && !isGoingToLogin) {
        return '/login';
      }
      // Si l'utilisateur EST connecté ET qu'il essaie d'aller sur la page de login,
      // on le redirige vers sa page d'accueil.
      if (authState && isGoingToLogin) {
        return '/home';
      }
      // Dans tous les autres cas, on ne fait rien et on le laisse aller où il veut.
      return null; 
    },
    routes: [
      // ... vos routes ne changent pas
      GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', name: 'home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/fonctionnalites', name: 'fonctionnalites', builder: (context, state) => const FonctionnalitesScreen()),
    ],
  );
});
