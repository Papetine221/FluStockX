import 'package:firebase_auth/firebase_auth.dart';

/// Base class for repositories to access the current authenticated user's ID.
class BaseRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }
    return user.uid;
  }
}

// Provider to check connectivity or other global API concerns could go here.
