import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.text = "Please wait..."});

  final String text;

  // ✅ Helper function to log actions
  void logAction(String action) {
    print("[ACTION LOG] $action at ${DateTime.now()}");
  }

  @override
  Widget build(BuildContext context) {
    // Log when loading widget is built (displayed)
    logAction("LoadingWidget displayed with text: '$text'");

    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
