import 'package:eventia/LoginPages/forgot_password.dart';
import 'package:eventia/LoginPages/auth.dart';
import 'package:eventia/LoginPages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventia/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eventia/navigator.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = "", password = "";
  bool _showForm = false;
  double _height=0.0;
  bool _isInitialAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    // Delay to start the animation when page loads
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _showForm = true;
      });
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize height based on MediaQuery after dependencies are ready
    _height = MediaQuery.of(context).size.height; // Start at full height
    Future.delayed(Duration.zero, () {
      setState(() {
        _height = MediaQuery.of(context).size.height * 0.4;
        _isInitialAnimationComplete = true;// Animate to 40% height
      });
    });
  }



  Future<void> userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigatorWidget()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided.";
      } else {
        errorMessage = "An error occurred. Please try again.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          errorMessage,
          style: const TextStyle(fontSize: 18.0),
        ),
      ));
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final double fixedHeight = MediaQuery.of(context).size.height * 0.4;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          resizeToAvoidBottomInset: false, // Prevent resizing on keyboard pop
          body: Stack(
            children: [
              // Background Image
              AnimatedPositioned(
                top: 0,
                left: 0,
                right: 0,
                duration: const Duration(milliseconds: 500), // Animation duration
                height:_isInitialAnimationComplete ? fixedHeight : _height, // Use calculated height
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login_background.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Form Container with animation
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500), // Adjust the duration for slower animation
                curve: Curves.easeInOut,
                bottom: _showForm ? 0 : -constraints.maxHeight * 0.75,
                left: 0,
                right: 0,
                child: Container(
                  height: constraints.maxHeight * 0.75,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Email Field
                                _buildTextField('Email', emailController),
                                const SizedBox(height: 20),
                                // Password Field
                                _buildTextField('Password', passwordController, isPassword: true),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text;
                                  password = passwordController.text;
                                });
                                userLogin();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ForgotPassword()),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'or Sign in with',
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialIcon(FontAwesomeIcons.google, Colors.red, () {
                                AuthMethods().signInWithGoogle(context);
                              }),
                              const SizedBox(width: 20),
                              _buildSocialIcon(FontAwesomeIcons.apple, Colors.black, () {
                                AuthMethods().signInWithApple();
                              }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?", style: TextStyle(color: Colors.black54)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUp()),
                                  );
                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const NavigatorWidget()),
                              );
                            },
                            child: const Text(
                              "Skip for now",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w300,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // Custom Text Field Builder
  Widget _buildTextField(String hint, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hint';
          }
          if (hint == 'Email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
          fillColor: Colors.transparent,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  // Social Icon Builder
  Widget _buildSocialIcon(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: color,
        child: FaIcon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}