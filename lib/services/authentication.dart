import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _getUser(user) {
    return user != null ? UserModel(userId: user.uid) : null;
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_getUser);
  }

  Future signInAnoumously() async {
    try {
      final authResult = await _auth.signInAnonymously();
      final User? user = authResult.user;
      return _getUser(user);
    } on FirebaseAuthException catch (err) {
      debugPrint(err.message.toString());
      return null;
    }
  }

  Future signOutUser() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (err) {
      debugPrint(err.message.toString());
      return null;
    }
  }

  Future signUpUser(String name, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (err) {
      debugPrint(err.message.toString());
      return null;
    }
  }
}
