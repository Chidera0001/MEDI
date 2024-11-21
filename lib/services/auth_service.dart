import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Call Firestore service to store user data
        await FirestoreService().addUserData(user);
      }
    } catch (e) {
      print("Error registering user: $e");
    }
  }
}

// ignore: non_constant_identifier_names
FirestoreService() {
}