class ApiConfig {
  // ---------------------------------------------------------------------------
  // URL de base de l'API (À MODIFIER selon votre configuration locale)
  // ---------------------------------------------------------------------------
  // Pour émulateur Android : 'http://10.0.2.2/API_techstock'
  // Pour appareil physique (WIFI) : 'http://192.168.1.X/API_techstock' (Remplacez X par votre IP)
  // Pour iOS simulateur : 'http://127.0.0.1/API_techstock'

  // static const String baseUrl = 'http://10.0.2.2/API_techstock';
  static const String baseUrl = 'http://192.168.137.1/API_techstock';

  // ---------------------------------------------------------------------------
  // Endpoints (Points d'entrée)
  // ---------------------------------------------------------------------------

  // --- Clients ---
  static const String getClients = '$baseUrl/get_clients.php';
  static const String addClient = '$baseUrl/add_client.php';

  // --- Produits ---
  static const String getProducts = '$baseUrl/get_products.php';
  static const String addProduct = '$baseUrl/add_product.php';
  static const String updateProduct = '$baseUrl/update_product.php';

  // --- Commandes ---
  static const String getOrders = '$baseUrl/get_orders.php';
  static const String addOrder = '$baseUrl/add_order.php';

  // --- Comptabilité ---
  static const String getTransactions = '$baseUrl/get_transactions.php';
  static const String addTransaction = '$baseUrl/add_transaction.php';
}
