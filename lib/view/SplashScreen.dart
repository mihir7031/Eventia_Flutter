import 'package:flutter/material.dart';
import 'package:eventia/LoginPages/auth_check.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController with a duration of 3 seconds
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Start the animation for a smooth progress bar fill
    _animationController.forward();

    // Navigate to the main screen when the animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthCheck()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Splash screen image as background, loaded immediately
          Image.asset(
            'assets/images/splash_screen.jpeg',
            fit: BoxFit.cover,
          ),
          // Centered loading bar with a gradual fill
          Positioned(
            bottom: 80, // Position the loading bar near the bottom
            left: MediaQuery.of(context).size.width * 0.1, // Center the bar with padding on each side
            right: MediaQuery.of(context).size.width * 0.1,
            child: SizedBox(
              height: 10, // Thicker loading bar
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _animationController.value, // Link the progress to the animation
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    color: Colors.blue, // Customize the color as needed
                  );
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent, // Make sure background is transparent
    );
  }
}