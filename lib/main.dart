import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techstock/screens/home_screen.dart';
import 'package:techstock/screens/login_screen.dart';
import 'package:techstock/screens/register_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen.dart';
import 'package:techstock/screens/about_screen.dart';
import 'package:techstock/screens/tarif_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/gestion_stock_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/gestion_client_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/dashboard_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/gestion_comptable_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/commande_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        FonctionnalitesScreen.routeName: (_) => const FonctionnalitesScreen(),
        AboutScreen.routeName: (_) => const AboutScreen(),
        TarifScreen.routeName: (_) => const TarifScreen(),
        GestionStockScreen.routeName: (_) => const GestionStockScreen(),
        GestionComptableScreen.routeName: (_) => const GestionComptableScreen(),
        GestionClientScreen.routeName: (_) => const GestionClientScreen(),
        DashboardScreen.routeName: (_) => const DashboardScreen(),
        CommandeScreen.routeName: (_) => const CommandeScreen(),
      },
    );
  }
}


//COMMANDES IMPORTANTES POUR FIREBASE
//npm install -g firebase-tools
//firebase login
//dart pub global activate flutterfire_cli
//flutterfire configure 