import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventia/navigation.dart'; // Your home page
import 'package:eventia/LoginPages/login.dart'; // Your sign-in screen

class AuthCheck extends StatelessWidget {
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
            return PersistentNavBar(selectedIndex: 0,);
          }
          // If not authenticated, navigate to the sign-in screen
          return LogIn();
        } else {
          // Show a loading indicator while checking the auth state
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
