import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eventia/view/screenmain.dart'; // Make sure this is correct
import 'package:eventia/view/SplashScreen.dart'; // Make sure this is correct
import 'package:firebase_core/firebase_core.dart';


void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Run your app
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showSplash = true;

  void showSplashScreen() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showSplash = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    showSplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventia',
      theme: ThemeData(
        primaryColor: Colors.lightBlue[400],
        colorScheme: ColorScheme.light(
          primary: Colors.lightBlue[400]!,
          secondary: Colors.lightBlue[100]!,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.lightBlue[400],
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: SplashScreen(),
    );
  }
}