import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eventia/view/screenmain.dart';
import 'package:eventia/view/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool showSplash = true;
  showSplashScreen(){
    Future.delayed(Duration(seconds: 5),(){
      setState(() {
        showSplash = false;
      });
    });
  }
  @override
  void initState() {
    showSplashScreen();
    super.initState();
  }
  Widget build(BuildContext context) {
    return MaterialApp(

   theme: ThemeData(
    textTheme: GoogleFonts.latoTextTheme(
      Theme.of(context).textTheme,
    ),

    ),
      title: "Flutter demo",
home:showSplash?SplashScreen():screenmain(),
    );
  }
}
