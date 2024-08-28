import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Your home page
import 'package:eventia/LoginPages/login.dart';
import 'package:eventia/navigator.dart';// Your sign-in screen

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the user is authenticated
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          // If user is authenticated, navigate to the home page
          if (user != null) {
            return const NavigatorWidget();
          }
          // If not authenticated, navigate to the sign-in screen
          return const LogIn();
        } else {
          // Show a loading indicator while checking the auth state
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
