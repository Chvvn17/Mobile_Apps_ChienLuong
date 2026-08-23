import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Gibt die benutzerbezogene recipes-Collection zurück (users/{uid}/recipes).
CollectionReference<Map<String, dynamic>> recipesCollection() {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('recipes');
}
