import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteButton extends StatefulWidget {
  final String eventId;
  final bool isFavorited;

  FavoriteButton({required this.eventId, required this.isFavorited});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorited;

  // Get Firestore and FirebaseAuth instances
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.isFavorited;
  }

  void _toggleFavorite() async {
    setState(() {
      isFavorited = !isFavorited;
    });
    await _updateFavoriteInFirestore();
  }

  Future<void> _updateFavoriteInFirestore() async {
    final userDoc = firestore.collection('favourite').doc(auth.currentUser?.uid);

    try {
      if (isFavorited) {
        await userDoc.update({
          'events': FieldValue.arrayUnion([widget.eventId])
        });
      } else {
        await userDoc.update({
          'events': FieldValue.arrayRemove([widget.eventId])
        });
      }
    } catch (e) {
      // Revert the local change if there's an error
      setState(() {
        isFavorited = !isFavorited;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border,
        color: isFavorited ? Colors.red : Colors.grey,  // Updated color reference
      ),
      onPressed: _toggleFavorite,
    );
  }
}
