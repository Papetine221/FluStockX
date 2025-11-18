import 'package:flutter/material.dart';
import 'package:techstock/screens/about_screen.dart';
import 'package:techstock/screens/fonctionnalites_screen.dart';
import 'package:techstock/screens/home_screen.dart';
import 'package:techstock/screens/login_screen.dart';
import 'package:techstock/screens/tarif_screen.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory_2,
              color: Color.fromARGB(255, 122, 92, 205),
              size: 20,
            ),
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: PopupMenuButton<int>(
            child: Container(
              width: 48,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromARGB(255, 122, 92, 205), width: 2),
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
            itemBuilder: (context) => const [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.home, color: Colors.black54),
                    SizedBox(width: 12),
                    Text('Accueil'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.featured_play_list, color: Colors.black54),
                    SizedBox(width: 12),
                    Text('Fonctionnalités'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.black54),
                    SizedBox(width: 12),
                    Text('Tarif'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.black54),
                    SizedBox(width: 12),
                    Text('A propos'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
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
    );
  }
}
