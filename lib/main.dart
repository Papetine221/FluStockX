import 'package:flutter/material.dart';
import 'package:techstock/screens/home_screen.dart';
import 'package:techstock/screens/login_screen.dart';
import 'package:techstock/screens/register_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen.dart';
import 'package:techstock/screens/about_screen.dart';
import 'package:techstock/screens/tarif_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/gestion_stock_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/gestion_client_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
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
        GestionClientScreen.routeName: (_) => const GestionClientScreen(),
        DashboardScreen.routeName: (_) => const DashboardScreen(),

      },
    );
  }
}

