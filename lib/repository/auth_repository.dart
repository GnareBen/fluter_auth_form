import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_auth_form/common/auth_exception.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    if (e.code == 'invalid-email') {
      return 'L\'adresse email est invalide';
    } else if (e.code == 'user-disabled') {
      return 'Ce compte utilisateur a été désactivé';
    } else if (e.code == 'user-not-found') {
      return 'Aucun utilisateur trouvé avec cet email';
    } else if (e.code == 'too-many-requests') {
      return 'Trop de tentatives. Veuillez réessayer plus tard';
    } else if (e.code == 'network-request-failed') {
      return 'Erreur de connexion. Vérifiez votre accès internet';
    } else if (e.code == 'operation-not-allowed') {
      return 'La connexion par email/mot de passe n\'est pas activée';
    } else if (e.code == 'email-already-in-use') {
      return 'Cet email est déjà utilisé par un autre compte';
    } else if (e.code == 'weak-password') {
      return 'Le mot de passe est trop faible';
    } else if (e.code == 'invalid-verification-code') {
      return 'Code de vérification invalide';
    } else if (e.code == 'invalid-verification-id') {
      return 'ID de vérification invalide';
    } else if (e.code == 'missing-verification-code') {
      return 'Code de vérification manquant';
    } else {
      return e.message ?? 'Une erreur inattendue est survenue';
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, _getFirebaseAuthErrorMessage(e));
    } catch (e) {
      throw AuthException(
        'unknown-error',
        'Une erreur inattendue est survenue',
      );
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, _getFirebaseAuthErrorMessage(e));
    } catch (e) {
      throw AuthException(
        'unknown-error',
        'Une erreur inattendue est survenue',
      );
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, _getFirebaseAuthErrorMessage(e));
    } catch (e) {
      throw AuthException(
        'unknown-error',
        'Une erreur inattendue est survenue',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, _getFirebaseAuthErrorMessage(e));
    } catch (e) {
      throw AuthException(
        'unknown-error',
        'Une erreur inattendue est survenue',
      );
    }
  }

  // Sign in with Google
  // Future<UserCredential> signInWithGoogle() async {
  //   try {
  //     // Start the interactive sign-in process
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //     // User canceled the sign-in flow
  //     if (googleUser == null) {
  //       throw AuthException(
  //         code: 'user-cancelled',
  //         message: 'L\'utilisateur a annulé la connexion',
  //       );
  //     }

  //     // Obtain auth details from request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // Create a new credential for Firebase
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Sign in to Firebase with the Google credential
  //     return await _firebaseAuth.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     print(
  //       'FirebaseAuthException during Google sign-in: ${e.code} - ${e.message}',
  //     );
  //     throw AuthException(
  //       code: e.code,
  //       message: _getFirebaseAuthErrorMessage(e),
  //     );
  //   } catch (e) {
  //     print('Exception during Google sign-in: $e');
  //     throw AuthException(
  //       code: 'unknown-error',
  //       message:
  //           'Une erreur inattendue est survenue lors de la connexion Google',
  //     );
  //   }
  // }
}
