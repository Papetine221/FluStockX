# TechStock

**TechStock** est une application mobile complète de gestion commerciale, conçue pour simplifier le pilotage de votre activité (stocks, clients, commandes, comptabilité).

## 🚀 Fonctionnalités

*   **📦 Gestion de Stock** : Suivi en temps réel, ajout/modification/suppression de produits.
*   **👥 Gestion Client** : Base de données clients, suivi des interactions.
*   **🛒 Gestion des Commandes** : Création et suivi des commandes clients.
*   **💰 Gestion Comptable** : Suivi des transactions (revenus/dépenses), calcul des soldes.
*   **📊 Dashboard Interactif** : Visualisation des performances (KPIs, graphiques).

## 🛠 Technologies

*   **Frontend** : Flutter (Dart)
*   **State Management** : Riverpod
*   **Graphiques** : FL Chart
*   **Navigation** : GoRouter
*   **Backend** :
    *   **Authentification** : Firebase Auth
    *   **Base de Données** : MySQL (via API PHP)
    *   **API** : PHP 

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir installé :
*   [Flutter SDK](https://docs.flutter.dev/get-started/install)
*   Un serveur local (Laragon, XAMPP, ou WAMP) pour PHP et MySQL.
*   Un projet Firebase configuré.

## ⚙️ Installation et Configuration

### 1. Configuration du Backend (API & Base de données)

1.  **Base de données MySQL** :
    *   Créez une base de données nommée `techstock_db` (ou autre, à adapter dans `db.php`).
    *   Importez le fichier `techstock_db.sql` situé dans le dossier de l'API  (`c:\laragon\www\API_techstock\techstock_db.sql`) pour créer les tables nécessaires.
2.  **API PHP** :
    *   Placez le dossier `API_techstock` dans la racine de votre serveur web (ex: `C:\laragon\www\API_techstock` ou `htdocs`).
    *   Vérifiez la configuration de la connexion BDD dans `API_techstock/db.php` (host, user, password).

### 2. Configuration de l'Application Mobile

1.  **Cloner le projet** :
    ```bash
    git clone https://github.com/Papetine221/FluStockX.git
    cd techstock
    ```
2.  **Dépendances** :
    Installez les paquets Flutter :
    ```bash
    flutter pub get
    ```
3.  **Firebase** :
    *   Assurez-vous que `firebase_options.dart` est présent dans `lib/`. Sinon, configurez-le via `flutterfire configure`.
4.  **Configuration API (IMPORTANT ⚠️)** :
    *   Ouvrez le fichier `lib/config/api_config.dart`.
    *   Modifiez la variable `baseUrl` avec l'adresse IP locale de votre ordinateur.
    *   *Note : Votre IP locale peut changer (DHCP). Vérifiez-la avec `ipconfig` si l'application n'arrive pas à se connecter.*
    ```dart
    // Exemple
    static const String baseUrl = 'http://192.168.1.15/API_techstock';
    ```

## ▶️ Lancement

Lancez l'application sur votre émulateur ou appareil physique :

```bash
flutter run
```

## 🧪 Test Rapide

Pour tester l'application rapidement, utilisez ces identifiants de test :
*   **Email** : `urm@rkir.jf`
*   **Mot de passe** : `111111`

## 📂 Structure du Projet

*   `lib/models/` : Modèles de données (Product, Client, Order...).
*   `lib/providers/` : Gestion d'état avec Riverpod.
*   `lib/repositories/` : Communication avec l'API PHP.
*   `lib/screens/` : Interfaces utilisateur (Vues).
*   `lib/widgets/` : Composants UI réutilisables.
*   `lib/config/` : Configuration globale (API endpoints, etc.).



