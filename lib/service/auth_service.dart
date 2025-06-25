import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ... (signIn and register methods remain the same) ...
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(String fullName, String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      
      if (user != null) {
        await user.updateDisplayName(fullName);
        await user.reload();
        user = _firebaseAuth.currentUser;
      }
      
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  // NEW METHOD for changing password
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return "No user is signed in.";
      }

      // Re-authenticate user
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(cred);

      // If re-authentication is successful, update the password
      await user.updatePassword(newPassword);

      return "Password updated successfully.";
    } on FirebaseAuthException catch (e) {
      // Handle errors
      if (e.code == 'wrong-password') {
        return 'The current password you entered is incorrect.';
      } else {
        return 'An error occurred. Please try again.';
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}