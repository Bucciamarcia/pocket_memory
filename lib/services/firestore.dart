import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import "package:pocket_memory/services/auth.dart";
import "dart:developer";

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = AuthService().userId();

  Future<void> addUser() async {
    try {
      await _db.collection('users').doc(userId).set({
        'full_name': 'Full Name',
        'company': 'Company Name',
        'age': 42,
        'email': ''
      });
    } catch (e) {
      log('Error writing document: $e');
    }
  }
}

class CreateMemory {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = AuthService().userId();
  final List<double> embeddings;
  final String memoryText;

  CreateMemory({required this.embeddings, required this.memoryText});

  Future<double> addPermanent(
    
  ) async {
    try {
      _db.collection("users").doc(userId).collection("memories").add({
        "embeddings": embeddings,
        "memoryText": memoryText,
        "timestamp": FieldValue.serverTimestamp(),
      });
      return 200;
    } catch (e) {
      return 500;
    }
  }

}