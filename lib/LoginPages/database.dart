import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Add user to User collection
  Future<void> addUser(String userId, Map<String, dynamic> userInfoMap) async {
    try {
      await firestore.collection("User").doc(userId).set(userInfoMap);
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  // Get user info from User collection
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await firestore.collection("User").doc(userId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error getting user info: $e");
    }
    return null;
  }

  // Add user profile to User_profile collection
  Future<void> addUserProfile(String userId, Map<String, dynamic> userProfileMap) async {
    try {
      await firestore.collection("User_profile").doc(userId).set(userProfileMap);
    } catch (e) {
      print("Error adding user profile: $e");
    }
  }

  // Get user profile info from User_profile collection
  Future<Map<String, dynamic>?> getUserProfileInfo(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await firestore.collection("User_profile").doc(userId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error getting user profile info: $e");
    }
    return null;
  }
}
