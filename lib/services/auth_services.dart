// ignore_for_file: use_build_context_synchronously


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nipibasket_tupizarravirtual/Boot_page/boot_page.dart';
import 'package:nipibasket_tupizarravirtual/extensions/extensions.dart';
import 'package:nipibasket_tupizarravirtual/pages/login.dart';

class AuthService {
   final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
    required String username,
  }) async {
    
    try {

     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password.sha256Hash,
    );
      if (userCredential.user == null || userCredential.user?.uid == null) {
      throw Exception('No se pudo obtener el UID del usuario recién creado');
  }

       await _firestore.collection('Users').doc(userCredential.user?.uid).set({
        'email': email,
        'uuid': userCredential.user?.uid,
        'username': username,
      });
      
      WidgetsBinding.instance.addPostFrameCallback((_) {   //Añadido mediante la IA  solo esta linea ya que me estaba dando errores
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BootPage())
        );
      });
      
    
    } on FirebaseAuthException catch(e) {
      String message = _handleAuthError(e);
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password.sha256Hash
      );    
         WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BootPage())
        );
      });
      
    } on FirebaseAuthException catch(e) {
      String message = _handleAuthError(e);
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
  }
  }

  Future<void> signout ({
    required BuildContext context
  }) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>LoginScreen()
        )
      );
  }
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}