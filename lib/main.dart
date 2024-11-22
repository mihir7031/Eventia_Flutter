import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:eventia/view/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

// Define your updated colors
const Color primaryColor = Color(0xFFFF6F61);// Deep Blue
const Color textColor = Color(0xFF666666); // Medium gray for a lighter feel
const Color secondaryColor = Color(0xFFFFFFFF); // White
const Color accentColor =Color(0xFF3498DB); // Coral
const Color accentColor2 = Color(0xFF1ABC9C); // Mint Green
const Color accentColor3 = Color(0xFFF1C40F); // Golden Yellow
const Color blackColor = Color(0xFF010101); // Black for text
const Color cardColor = Color(0xFFF2F2F2); // Light Gray for cards
const Color inactiveColor = Color(0xFF7F8C8D);
const Color iconColor = Color(0xFF666666);// Cool Slate Gray for inactive elements

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
              color: textColor,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            titleMedium: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            bodyMedium: TextStyle(
              color: textColor,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          appBarTheme: AppBarTheme(
            color: secondaryColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: iconColor),
            titleTextStyle: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: primaryColor,
            unselectedItemColor: inactiveColor,
            selectedLabelStyle: const TextStyle(color: primaryColor),
            unselectedLabelStyle: const TextStyle(color: inactiveColor),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style:
            ElevatedButton.styleFrom(
              backgroundColor: primaryColor, // Coral for button background
              foregroundColor: iconColor,

              // White for text color
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: cardColor, // Light gray for input background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: primaryColor, // Deep Blue for focus state
              ),
            ),
          ),
          iconTheme: IconThemeData(
            color: iconColor,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: accentColor2, // Mint Green for FAB
          ),
        ),
        home: const SplashScreen());
  }
}
