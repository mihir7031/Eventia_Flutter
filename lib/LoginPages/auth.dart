import 'package:eventia/LoginPages/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:eventia/navigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn();
      if (googleSignInAccount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google sign-in cancelled by user")),
        );
        return;
      }

      final GoogleSignInAuthentication? googleSignInAuthentication =
      await googleSignInAccount.authentication;

      if (googleSignInAuthentication == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to authenticate with Google")),
        );
        return;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result = await firebaseAuth.signInWithCredential(
          credential);
      User? userDetails = result.user;

      if (userDetails != null) {
        // Check if user information already exists in the database
        Map<String, dynamic>? existingUserInfo = await DatabaseMethods()
            .getUserInfo(userDetails.uid);

        // Prepare the userInfoMap with the existing or new data
        Map<String, dynamic> userInfoMap = {
          "email": userDetails.email,
          "name": existingUserInfo?["name"] ?? userDetails.displayName,
          "imgUrl": existingUserInfo?["imgUrl"] ?? userDetails.photoURL,
          "id": userDetails.uid
        };

        // Add or update user info in the User collection
        await DatabaseMethods().addUser(userDetails.uid, userInfoMap);

        // Fetch the existing User_profile document
        DocumentSnapshot userProfileDoc = await FirebaseFirestore.instance
            .collection("User_profile")
            .doc(userDetails.uid)
            .get();

        // Retain existing data if the document exists
        Map<String, dynamic>? existingProfileData = userProfileDoc.exists
            ? userProfileDoc.data() as Map<String, dynamic>?
            : {};

        // Create or update the userProfileMap, preserving existing data
        Map<String, dynamic> userProfileMap = {
          "birthdate": existingProfileData?["birthdate"] ?? null,
          "profession": existingProfileData?["profession"] ?? null,
          "city": existingProfileData?["city"] ?? null,
          "state": existingProfileData?["state"] ?? null,
          "about me": existingProfileData?["about me"] ?? null,
          "language": existingProfileData?["language"] ?? null,
          "social media": existingProfileData?["social media"] ?? null,
          "uid": userDetails.uid,
        };

        // Add or update user profile in the User_profile collection
        await FirebaseFirestore.instance
            .collection("User_profile")
            .doc(userDetails.uid)
            .set(userProfileMap, SetOptions(
            merge: true)); // Use merge to avoid overwriting existing data

        // Navigate to the next page after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigatorWidget()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to sign in with Google")),
        );
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthException(e, context);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Platform Exception: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred: $e")),
      );
    }
  }


// Handle Firebase authentication exceptions
  void handleFirebaseAuthException(FirebaseAuthException e,
      BuildContext context) {
    String errorMessage;
    switch (e.code) {
      case 'account-exists-with-different-credential':
        errorMessage = "Account already exists with a different credential.";
        break;
      case 'invalid-credential':
        errorMessage = "Invalid credentials. Please try again.";
        break;
      case 'user-disabled':
        errorMessage = "This user has been disabled. Please contact support.";
        break;
      case 'operation-not-allowed':
        errorMessage =
        "Operation not allowed. Please enable Google Sign-In in Firebase.";
        break;
      case 'invalid-verification-code':
        errorMessage = "Invalid verification code. Please try again.";
        break;
      case 'invalid-verification-id':
        errorMessage = "Invalid verification ID. Please try again.";
        break;
      default:
        errorMessage = "An unknown error occurred. Please try again.";
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }


  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential = result.credential!;
        final oAuthCredential = OAuthProvider('apple.com');
        final credential = oAuthCredential.credential(
            idToken: String.fromCharCodes(AppleIdCredential.identityToken!));
        final UserCredential = await auth.signInWithCredential(credential);
        final firebaseUser = UserCredential.user!;

        if (scopes.contains(Scope.fullName)) {
          final fullName = AppleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }

        // Fetch the existing User_profile document
        DocumentSnapshot userProfileDoc = await FirebaseFirestore.instance
            .collection("User_profile")
            .doc(firebaseUser.uid)
            .get();

        // Retain existing data if the document exists
        Map<String, dynamic>? existingProfileData = userProfileDoc.exists
            ? userProfileDoc.data() as Map<String, dynamic>?
            : {};

        // Create or update the userProfileMap, preserving existing data
        Map<String, dynamic> userProfileMap = {
          "birthdate": existingProfileData?["birthdate"] ?? null,
          "profession": existingProfileData?["profession"] ?? null,
          "city": existingProfileData?["city"] ?? null,
          "state": existingProfileData?["state"] ?? null,
          "about me": existingProfileData?["about me"] ?? null,
          "language": existingProfileData?["language"] ?? null,
          "social media": existingProfileData?["social media"] ?? null,
          "uid": firebaseUser.uid,
        };

        // Add or update user profile in the User_profile collection
        await FirebaseFirestore.instance
            .collection("User_profile")
            .doc(firebaseUser.uid)
            .set(userProfileMap, SetOptions(
            merge: true)); // Use merge to avoid overwriting existing data

        return firebaseUser;

      case AuthorizationStatus.error:
        throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString());

      case AuthorizationStatus.cancelled:
        throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
      default:
        throw UnimplementedError();
    }
  }
}
