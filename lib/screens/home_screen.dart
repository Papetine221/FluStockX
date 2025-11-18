import 'package:flutter/material.dart';
import 'package:techstock/screens/about_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen.dart';
import 'package:techstock/screens/login_screen.dart';
import 'package:techstock/screens/tarif_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    // Use a soft gradient background and place a transparent Scaffold on top
    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.white,
              ],
            ),
          ),
        ),
        // Main scaffold with transparent background so gradient is visible
        Scaffold(
          backgroundColor: Colors.transparent,
          // 1. La barre de titre (la "porte d'entrée").
          appBar: AppBar(
            // Empêche l'affichage automatique du burger (à gauche)
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                // petit logo/icône à gauche
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.inventory_2, color: Color.fromARGB(255, 122, 92, 205), size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'FlustockX',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 92, 205),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            // Bouton burger stylisé en haut à droite (affiche un popup menu)
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: PopupMenuButton<int>(
                  // Affiche un bouton personnalisé comme déclencheur
                  child: Container(
                    width: 48,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color.fromARGB(255, 122, 92, 205), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.menu,
                        color: Color.fromARGB(255, 122, 92, 205),
                        size: 26,
                      ),
                    ),
                  ),
                  onSelected: (value) {
                    // 0: Accueil, 1: Carte, 2: Profil
                    switch (value) {
                      case 0:
                        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                        break;
                      case 1:
                        Navigator.of(context).pushNamed(FonctionnalitesScreen.routeName);
                        break;
                      case 2:
                        Navigator.of(context).pushNamed(TarifScreen.routeName);

                        break;
                      case 3:
                        Navigator.of(context).pushNamed(AboutScreen.routeName);
                      break;

                      case 4:
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                      break;

                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          Icon(Icons.home, color: Colors.black54),
                          SizedBox(width: 12),
                          Text('Accueil'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.featured_play_list, color: Colors.black54),
                          SizedBox(width: 12),
                          Text('Fonctionnalités'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.black54),
                          SizedBox(width: 12),
                          Text('Tarif'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 3,
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.black54),
                          SizedBox(width: 12),
                          Text('A propos'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 4,
                      child: Row(
                        children: [
                          Icon(Icons.login, color: Colors.black54),
                          SizedBox(width: 12),
                          Text('Connexion'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
// 2. Le corps de la page.
          body: Center(
            child: ConstrainedBox(
            
              constraints: const BoxConstraints(maxHeight: 600 ),
              child: Card(
                elevation: 6,
            
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
                  child: Column(
                     children: [
                      // Decorative icon
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.storefront, color: Color.fromARGB(255, 122, 92, 205), size: 36),
                      ),
                      const SizedBox(height: 18),
                     
                     Column(
                      children: [
                         const Text(
                        'La Gestion de Stock et des Commandes  ',
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                       ),
                      const Text(
                        'devient Plus Simple',
                        style: TextStyle(fontSize: 34, color: Color.fromARGB(255, 122, 92, 205), fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      ],
                     ),
                      const SizedBox(height: 12),
                      const Text(
                        'Suivez vos stocks et commandes en temps réel, sans effort. Solution complète pour commerçants, où que vous soyez.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Démarrer appuyé')),
                              );
                            },
                            icon: const Icon(Icons.play_arrow , color: Colors.white,),
                            label: const Text('Démarrer',style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 29, 14, 203),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                          const SizedBox(width: 14),
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Demo appuyé')),
                              );
                            },
                            icon: const Icon(Icons.visibility, color: Colors.blueAccent),
                            label: const Text('Demo', style: TextStyle(color: Colors.blueAccent)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blueAccent),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

