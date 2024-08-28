import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:eventia/view/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

// Define your colors
const Color primaryColor = Color(0xFF282828);
const Color secondaryColor = Color(0xFFE9EEEA);
const Color accentColor = Color(0xFFD8E0E9);
const Color accentColor2 = Color(0xFFCFE2CC);
const Color accentColor3 = Color(0xffd0d6ce);
const Color blackColor = Color(0xFF010101);
const Color cardColor = Color(0xFFf4f4f4);
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
        primaryColor: primaryColor,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          onPrimary: secondaryColor,
          onSecondary: primaryColor,
          onSurface: primaryColor,
          onError: blackColor,
          error: blackColor,
        ),

        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),

          titleMedium: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),

          bodyMedium: TextStyle(
            color: primaryColor,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: secondaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: primaryColor),
          titleTextStyle: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor:primaryColor,
          unselectedItemColor: primaryColor.withOpacity(0.8),
          selectedLabelStyle: const TextStyle(color: primaryColor),
          unselectedLabelStyle: TextStyle(color:primaryColor.withOpacity(0.8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor, // Background color
            foregroundColor: primaryColor, // Text color
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: secondaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: primaryColor,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: primaryColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
      ),
      home:const SplashScreen()
    );
  }
}
