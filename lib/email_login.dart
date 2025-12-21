import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendEmailLink(BuildContext context, String email) async {
  final actionCodeSettings = ActionCodeSettings(
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

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Login link sent to email")),
  );
}
