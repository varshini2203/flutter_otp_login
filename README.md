# Flutter OTP Login Application

A secure and user-friendly **Flutter authentication application** that enables users to log in using **OTP-based phone authentication**, **Google Sign-In**, and **Email login**. The application leverages **Firebase Authentication** to provide reliable and scalable user authentication.

---

## 📱 Project Overview

This project is designed to demonstrate the implementation of **multi-method authentication** in a Flutter mobile application. It allows users to log in securely using:

* One-Time Password (OTP) sent to their mobile number
* Google account authentication
* Email-based login

Firebase is used as the backend authentication service to ensure secure identity verification and session management.

---

## ✨ Features

* 📞 **Phone Number OTP Login** using Firebase Authentication
* 🔐 **Google Sign-In** integration
* 📧 **Email Login** support
* 🔄 Secure session handling
* ⏳ Loading indicators for better user experience
* 📱 Clean and responsive UI

---

## 🛠️ Technologies Used

* **Flutter** – Frontend mobile app development
* **Dart** – Programming language
* **Firebase Authentication** – Backend authentication service
* **Android Studio / VS Code** – Development environment

---

## 📂 Project Structure

```text
lib/
 ├── main.dart
 ├── login_page.dart
 ├── phone_login.dart
 ├── google_login.dart
 ├── email_login.dart
 ├── home_page.dart
 ├── profile_page.dart
 └── loading_widget.dart

assets/
 └── images/
```

---

## 🧪 How It Works

1. User selects a login method (Phone / Google / Email)
2. Firebase authenticates the user credentials
3. OTP is sent to the registered mobile number (for phone login)
4. On successful verification, the user is redirected to the home page

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK installed
* Firebase project configured
* Android emulator or physical device

### Run the Project

```bash
flutter pub get
flutter run
```

---

## 📌 Use Cases

* Secure user authentication in mobile apps
* Learning Firebase Authentication with Flutter
* OTP-based login system implementation

---

## 👩‍💻 Author

**Varshini**
B.E Computer Science Engineering Student
Flutter & Firebase Beginner Developer

---

⭐ If you find this project useful, feel free to star the repository and explore the code.
