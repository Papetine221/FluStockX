import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String shopName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Skipped Firestore write since we are moving to MySQL
        // await _firestore.collection('users').doc(user.uid).set({...});

        // Also update display name in Auth for convenience
        await user.updateDisplayName(name);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Erreur d\'inscription: ${e.message}');
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Keeping the helper for better error messages on login,
  // though duplicate of what reference project did inline.
  Exception _mapFirebaseAuthException(FirebaseAuthException e) {
    if (e.code == 'user-not-found') {
      return Exception('Aucun utilisateur trouvé pour cet email.');
    } else if (e.code == 'wrong-password') {
      return Exception('Mot de passe incorrect.');
    }
    return Exception(e.message ?? 'Une erreur inconnue est survenue.');
  }
}
