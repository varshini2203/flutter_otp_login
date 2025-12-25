import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailLogin {
  // ✅ Helper function to log actions
  static void logAction(String action) {
    print("[ACTION LOG] $action at ${DateTime.now()}");
  }

  static Future<void> sendLoginLink(
      BuildContext context, String email) async {
    try {
      logAction("Attempting to send login link to email: $email");

      await FirebaseAuth.instance.signOut();
      logAction("Signed out any existing user");

      final ActionCodeSettings actionCodeSettings = ActionCodeSettings(
        url: 'https://flutterotplogin.page.link/login',
        handleCodeInApp: true,
        androidPackageName: 'com.example.flutter_otp_login',
        androidInstallApp: true,
        androidMinimumVersion: '21',
      );

      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      logAction("Login link sent successfully to: $email");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login link sent to email"),
        ),
      );
    } catch (e) {
      logAction("Error sending login link: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  static Future<User?> signInWithEmailLink(
      String email, String link) async {
    try {
      logAction("Attempting sign in with email link for: $email");

      if (FirebaseAuth.instance.isSignInWithEmailLink(link)) {
        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailLink(
          email: email,
          emailLink: link,
        );

        logAction("Sign in successful for user: ${userCredential.user?.email}");
        return userCredential.user;
      } else {
        logAction("Invalid email link for sign in: $link");
      }
      return null;
    } catch (e) {
      logAction("Error signing in with email link: $e");
      return null;
    }
  }

  static Future<void> signOut() async {
    logAction("Signing out user");
    await FirebaseAuth.instance.signOut();
    logAction("User signed out successfully");
  }
}
