import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_picker/country_picker.dart';

import 'home_page.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  String verificationId = "";
  bool otpSent = false;
  bool loading = false;

  Country selectedCountry = Country.worldWide;
  int timer = 60;
  Timer? _timer;

  // 🔹 SEND OTP
  Future<void> sendOTP() async {
    if (phoneController.text.trim().isEmpty) return;

    setState(() {
      loading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber:
      "+${selectedCountry.phoneCode}${phoneController.text.trim()}",
      timeout: const Duration(seconds: 60),

      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        goHome();
      },

      verificationFailed: (e) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Verification failed")),
        );
      },

      codeSent: (vid, token) {
        setState(() {
          verificationId = vid;
          otpSent = true;
          loading = false;
          startTimer();
        });
      },

      codeAutoRetrievalTimeout: (vid) {
        verificationId = vid;
      },
    );
  }

  // 🔹 VERIFY OTP
  Future<void> verifyOTP() async {
    try {
      setState(() => loading = true);

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text.trim(),
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      goHome();
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  // 🔹 TIMER
  void startTimer() {
    timer = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timer == 0) {
        t.cancel();
      } else {
        setState(() => timer--);
      }
    });
  }

  void goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A00E0),
              Color(0xFF8E2DE2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                const Text(
                  "Phone Verification",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Enter your mobile number to receive OTP",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 50),

                // 🔳 CARD
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      // 🌍 COUNTRY PICKER + PHONE
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                onSelect: (country) {
                                  setState(() {
                                    selectedCountry = country;
                                  });
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "+${selectedCountry.phoneCode}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: "Mobile Number",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // 🔢 OTP FIELD
                      if (otpSent)
                        TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Enter OTP",
                            border: OutlineInputBorder(),
                          ),
                        ),

                      const SizedBox(height: 25),

                      // ⏳ TIMER
                      if (otpSent && timer > 0)
                        Text(
                          "Resend OTP in $timer seconds",
                          style: const TextStyle(color: Colors.grey),
                        ),

                      if (otpSent && timer == 0)
                        TextButton(
                          onPressed: sendOTP,
                          child: const Text("Resend OTP"),
                        ),

                      const SizedBox(height: 20),

                      // 🔘 BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                          loading ? null : (otpSent ? verifyOTP : sendOTP),
                          child: loading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : Text(
                            otpSent ? "Verify OTP" : "Send OTP",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
