import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});


  void logAction(String action) {
    print("[ACTION LOG] $action at ${DateTime.now()}");
  }

  Future<void> _logout(BuildContext context) async {
    logAction("Logout button tapped");
    await FirebaseAuth.instance.signOut();
    logAction("User signed out successfully");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
    logAction("Navigated to LoginPage after logout");
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    logAction("ProfilePage built for user: ${user?.email ?? user?.phoneNumber ?? 'Unknown'}");

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF833AB4),
              Color(0xFFFD1D1D),
              Color(0xFFFCAF45),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 🔙 BACK BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      logAction("Back button tapped, navigated back");
                    },
                  ),
                ),

                const SizedBox(height: 20),


                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF833AB4),
                        Color(0xFFFD1D1D),
                        Color(0xFFFCAF45),
                      ],
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 👋 NAME / TITLE
                const Text(
                  "My Profile",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Firebase Authenticated User",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 40),

                // 🔳 INFO CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      // 📧 EMAIL
                      _infoTile(
                        icon: Icons.email,
                        label: "Email",
                        value: user?.email ?? "Not Available",
                      ),

                      const Divider(),

                      // 📱 PHONE
                      _infoTile(
                        icon: Icons.phone,
                        label: "Phone",
                        value: user?.phoneNumber ?? "Not Available",
                      ),

                      const Divider(),

                      // 🆔 UID
                      _infoTile(
                        icon: Icons.verified_user,
                        label: "User ID",
                        value: user?.uid ?? "",
                        small: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 🔴 LOGOUT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      "Logout",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _logout(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 INFO TILE WIDGET
  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    bool small = false,
  }) {
    logAction("Displaying info tile: $label = $value");
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: small ? 12 : 14,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
