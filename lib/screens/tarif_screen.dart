// Author: Papetine221
import 'package:flutter/material.dart';
import 'package:techstock/widgets/main_app_bar.dart';

class TarifScreen extends StatelessWidget {
  const TarifScreen({super.key});

  static const routeName = '/tarifs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MainAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.blue.shade200),
            ),
            elevation: 5,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Étiquette en haut
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    /*child: Text(
                      "Le plus choisi",
                      style: TextStyle(color: Colors.white),
                    ),*/
                  ),
                  SizedBox(height: 16),

                  // Titre du plan
                  Text(
                    "Essentiel",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Prix
                  Text(
                    "5.000 FCFA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 4),

                  // Mention sous prix
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "par mois",
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  ),

                  SizedBox(height: 8),
                  Text(
                    "Paiement intégral à chaque mois",
                    style: TextStyle(
                      color: Colors.green,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Liste des fonctionnalités
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      featureItemGreen("Compte activé"),
                      featureItemGreen("Gestion avancée des stocks"),
                      featureItemGreen("Factures illimitées"),
                      featureItemGreen("Relevé de vente"),
                      featureItemGreen("Mises à jour produits"),
                      featureItemRed("Notifications stock épuisé"),
                      featureItemRed("Gestion des comptes employés"),
                      featureItemRed(
                        "Business Manager (Noter dépenses et entrées)",
                      ),
                      featureItemRed("Messages marketing"),
                      featureItemRed("Site web (page produits)"),
                      featureItemRed("Support prioritaire"),
                      featureItemRed("Rapports avancés"),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Bouton
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {},
                    child: Text("Acheter maintenant"),
                  ),
                ],
              ),
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.blue.shade200),
            ),
            elevation: 5,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Étiquette en haut
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    /*child: Text(
                      "Le plus choisi",
                      style: TextStyle(color: Colors.white),
                    ),*/
                  ),
                  SizedBox(height: 16),

                  // Titre du plan
                  Text(
                    "Avancé",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Prix
                  Text(
                    "30.000 FCFA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 4),

                  // Mention sous prix
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "par an",
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  ),

                  SizedBox(height: 8),
                  Text(
                    "Renouvellement à 50% ou moins",
                    style: TextStyle(
                      color: Colors.green,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Liste des fonctionnalités
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      featureItemGreen("Compte activé"),
                      featureItemGreen("Gestion avancée des stocks"),
                      featureItemGreen("Factures illimitées"),
                      featureItemGreen("Relevé de vente"),
                      featureItemGreen("Mises à jour produits"),
                      featureItemGreen("Notifications stock épuisé"),
                      featureItemRed("Gestion des comptes employés"),
                      featureItemRed(
                        "Business Manager (Noter dépenses et entrées)",
                      ),
                      featureItemRed("Messages marketing"),
                      featureItemRed("Site web (page produits)"),
                      featureItemRed("Support prioritaire"),
                      featureItemRed("Rapports avancés"),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Bouton
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {},
                    child: Text("Acheter maintenant"),
                  ),
                ],
              ),
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.blue.shade200),
            ),
            elevation: 5,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Étiquette en haut
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Le plus choisi",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Titre du plan
                  Text(
                    "Pro",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Prix
                  Text(
                    "80.000 FCFA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 4),

                  // Mention sous prix
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "par an",
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  ),

                  SizedBox(height: 8),
                  Text(
                    "Renouvellement à 75% ou moins",
                    style: TextStyle(
                      color: Colors.green,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Liste des fonctionnalités
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      featureItemGreen("Compte activé"),
                      featureItemGreen("Gestion avancée des stocks"),
                      featureItemGreen("Factures illimitées"),
                      featureItemGreen("Relevé de vente"),
                      featureItemGreen("Mises à jour produits"),
                      featureItemGreen("Notifications stock épuisé"),
                      featureItemGreen("Gestion des comptes employés"),
                      featureItemGreen(
                        "Business Manager (Noter dépenses et entrées)",
                      ),
                      featureItemGreen("Messages marketing"),
                      featureItemGreen("Site web (page produits)"),
                      featureItemGreen("Support prioritaire"),
                      featureItemGreen("Rapports avancés"),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Bouton
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {},
                    child: Text("Acheter maintenant"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget featureItemGreen(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      children: [
        Icon(Icons.check, color: Colors.green, size: 20),
        SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

Widget featureItemRed(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      children: [
        Icon(Icons.close, color: Colors.red, size: 20),
        SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
