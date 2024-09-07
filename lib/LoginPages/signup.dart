import 'package:eventia/LoginPages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventia/LoginPages/auth.dart';
import 'package:eventia/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eventia/navigator.dart';
import 'package:eventia/LoginPages/database.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (passwordcontroller.text.isNotEmpty &&
        namecontroller.text.isNotEmpty &&
        mailcontroller.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Create a map to store user details in the User collection
        Map<String, dynamic> userInfoMap = {
          "id": userCredential.user!.uid,
          "name": namecontroller.text,
          "email": mailcontroller.text,
          "imgUrl": " ",
        };

        // Add user details to Firestore User collection
        await DatabaseMethods().addUser(userCredential.user!.uid, userInfoMap);

        // Check if the User_profile document already exists
        var existingProfile = await DatabaseMethods()
            .getUserProfileInfo(userCredential.user!.uid);

        if (existingProfile == null) {
          // Create a map for the User_profile collection with additional fields
          Map<String, dynamic> userProfileMap = {
            "id": userCredential.user!.uid,
            "birthdate": "", // You can update this with the actual input later
            "profession": "",
            "city": "",
            "state": "",
            "about_me": "",
            "language": "",
            "social_media": "",
          };

          // Add the user profile to the User_profile collection if it doesn't exist
          await DatabaseMethods()
              .addUserProfile(userCredential.user!.uid, userProfileMap);
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            )));

        // Navigate to another page after successful registration
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Text(
                'Eventia',
                style: TextStyle(
                  fontFamily: 'Blacksword',
                  color: primaryColor,
                  fontSize: 50, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Create your Account",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: namecontroller,
                      hint: "Name",
                      validatorMessage: "Please Enter Name",
                    ),
                    const SizedBox(height: 30.0),
                    _buildTextField(
                      controller: mailcontroller,
                      hint: "Email",
                      validatorMessage: "Please Enter Email",
                    ),
                    const SizedBox(height: 30.0),
                    _buildTextField(
                      controller: passwordcontroller,
                      hint: "Password",
                      validatorMessage: "Please Enter Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 30.0),
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = mailcontroller.text;
                            name = namecontroller.text;
                            password = passwordcontroller.text;
                          });
                          registration();
                        }
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500),
                              ))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "or Sign Up with",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30.0),
              _buildSocialLoginButtons(),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?",
                      style: TextStyle(
                          color: Color(0xFF8c8e98),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LogIn()));
                    },
                    child: const Text(
                      "LogIn",
                      style: TextStyle(
                          color: Color(0xFF273671),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
        required String hint,
        required String validatorMessage,
        bool obscureText = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFd9d9d9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          fillColor: Colors.transparent,
          focusedBorder: InputBorder.none,
          hintStyle: const TextStyle(color: Color(0xFF8c8c8c), fontSize: 18.0),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: primaryColor,
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const FaIcon(FontAwesomeIcons.google, color: primaryColor),
          label: const Text('google'),
          onPressed: () {
            AuthMethods().signInWithGoogle(context);
          },
        ),
        const SizedBox(width: 30.0),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: primaryColor,
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const FaIcon(FontAwesomeIcons.apple, color: primaryColor),
          label: const Text('apple'),
          onPressed: () {
            AuthMethods().signInWithApple();
          },
        ),
      ],
    );
  }
}
