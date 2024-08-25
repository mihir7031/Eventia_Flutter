import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eventia/view/screenmain.dart'; // Make sure this is correct
import 'package:eventia/view/SplashScreen.dart'; // Make sure this is correct
import 'package:firebase_core/firebase_core.dart';
import 'package:eventia/navigation.dart';
import 'package:eventia/LoginPages/login.dart';
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
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: accentColor,
          background: secondaryColor,
          onPrimary: secondaryColor,
          onSecondary: primaryColor,
          onSurface: primaryColor,
          onBackground: primaryColor,
          onError: blackColor,
          error: blackColor,
        ),
        scaffoldBackgroundColor: secondaryColor,
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
          iconTheme: IconThemeData(color: primaryColor),
          titleTextStyle: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: secondaryColor,
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.grey,
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
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
      ),
      home:SplashScreen()
    );
  }
}
