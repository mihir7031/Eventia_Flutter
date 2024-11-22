import 'package:eventia/LoginPages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventia/LoginPages/auth.dart';
import 'package:eventia/navigator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eventia/LoginPages/database.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  String email = "", password = "", name = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _visible = false;
  double _height = 0.0;
  bool _isInitialAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    // Trigger the animation visibility
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _visible = true;
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
  registration() async {
    if (passwordController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        mailController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        Map<String, dynamic> userInfoMap = {
          "id": userCredential.user!.uid,
          "name": nameController.text,
          "email": mailController.text,
          "imgUrl": " ",
        };

        await DatabaseMethods().addUser(userCredential.user!.uid, userInfoMap);

        var existingProfile = await DatabaseMethods()
            .getUserProfileInfo(userCredential.user!.uid);

        if (existingProfile == null) {
          Map<String, dynamic> userProfileMap = {
            "id": userCredential.user!.uid,
            "birthdate": "",
            "profession": "",
            "city": "",
            "state": "",
            "about_me": "",
            "language": "",
            "social_media": "",
          };

          await DatabaseMethods()
              .addUserProfile(userCredential.user!.uid, userProfileMap);
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            )));

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NavigatorWidget()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double fixedHeight = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent screen resizing
      body: Stack(
        children: [
          // Background Image
          AnimatedPositioned(
            top: 0,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 500), // Animation duration
            height: _isInitialAnimationComplete ? fixedHeight : _height, // Use fixed height after animation
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_background.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Form Container
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500), // Adjust the duration for slower animation
            curve: Curves.easeInOut,
            bottom: _visible ? 0 : -MediaQuery.of(context).size.height * 0.75,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
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
                  // Adjust content to avoid keyboard overlap
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField('Name', nameController),
                            const SizedBox(height: 20),
                            _buildTextField('Email', mailController),
                            const SizedBox(height: 20),
                            _buildTextField('Password', passwordController, isPassword: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = mailController.text;
                              name = nameController.text;
                              password = passwordController.text;
                            });
                            registration();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'or Sign up with',
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
                          const Text("Already have an account?", style: TextStyle(color: Colors.black54)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LogIn()),
                              );
                            },
                            child: const Text(
                              'Log In',
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


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
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
          fillColor: Colors.transparent,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, VoidCallback onPressed) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: color,
      child: IconButton(
        icon: FaIcon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
