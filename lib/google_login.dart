import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin {
  // ✅ Helper function to log actions
  static void logAction(String action) {
    print("[ACTION LOG] $action at ${DateTime.now()}");
  }

  static Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      logAction("Starting Google sign-in process");

      final GoogleSignIn googleSignIn = GoogleSignIn();

      // 🔴 Clear previous sessions
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
      logAction("Signed out any existing Firebase and Google sessions");

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        logAction("Google sign-in cancelled by user");
        return null; // user cancelled
      }

      logAction("Google account selected: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      logAction("Firebase sign-in successful for user: ${userCredential.user?.email}");

      return userCredential.user;
    } catch (e) {
      logAction("Google login failed: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google login failed: $e")),
      );
      return null;
    }
  }

  static Future<void> signOut() async {
    logAction("Signing out Google and Firebase user");
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    logAction("Google and Firebase user signed out successfully");
  }
}
