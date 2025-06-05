// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_nullable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nipibasket_tupizarravirtual/Boot_page/boot_page.dart';
import 'package:nipibasket_tupizarravirtual/pages/login.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
    required String username,
  }) async {
    try {
      UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.updateDisplayName(username);
      //Verifica si el usuario se creó correctamente
      if (userCredential.user == null || userCredential.user?.uid == null) {
        throw Exception('No se pudo obtener el UID del usuario recién creado');
      }
      await firestore.collection('Users').doc(userCredential.user?.uid).set({
        'email': email,
        'uuid': userCredential.user?.uid,
        'username': username,
        'photoURL': userCredential.user?.photoURL ?? '',
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BootPage(username: username)),
      );
    } on FirebaseAuthException catch (e) {
      String message = _handleAuthError(e);
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.black,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  BootPage(username: userCredential.user?.displayName ?? ''),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = _handleAuthError(e);
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.black,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Cierra sesión previa para permitir elegir otra cuenta
      await googleSignIn.signOut();

      // Inicia el flujo de autenticación
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Inicio de sesión cancelado.");
        return null;
      }

      // Obtiene los detalles de autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crea las credenciales
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión con Firebase
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Agrega o actualiza el usuario en Firestore
      final user = userCredential.user;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid);
        await userDoc.set({
          'uuid': user.uid,
          'username': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
        }, SetOptions(merge: true));
        Fluttertoast.showToast(
          msg: "Inicio de sesión exitoso.",
          backgroundColor: Colors.green,
        );
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  BootPage(username: userCredential.user?.displayName ?? ''),
        ),
      );
    } on FirebaseAuthException catch (e) {
      final String message = _handleAuthError(e);
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.black,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ocurrió un error inesperado: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.black,
        fontSize: 14.0,
      );
    }
    return null;
  }

  Future<void> signout({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
    );
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña proporcionada es demasiado débil.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con ese correo electrónico.';
      case 'invalid-email':
        return 'La dirección de correo electrónico no es válida.';
      case 'user-not-found':
        return 'No se ha encontrado ningún usuario con este correo electrónico.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'user-disabled':
        return 'Esta cuenta ha sido desactivada.';
      case 'too-many-requests':
        return 'Demasiados intentos. Vuelva a intentarlo más tarde.';
      case 'operation-not-allowed':
        return 'Las cuentas de correo electrónico/contraseña no están habilitadas.';
      default:
        return 'Autenticación fallida. Por favor, inténtelo de nuevo.';
    }
  }
}
