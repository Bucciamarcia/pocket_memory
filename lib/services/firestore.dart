import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import "package:pocket_memory/services/auth.dart";


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = AuthService().userId();

  Future<void> addUser() async {
  try {
    await _db.collection('users').doc(userId).set({
      'full_name': 'Full Name',
      'company': 'Company Name',
      'age': 42,
      'email': ''});
    print('User added/updated successfully!');
  } catch (e) {
    print('Error writing document: $e');
  }
}
}