// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/models/Usuarios.dart';
import 'package:nipibasket_tupizarravirtual/services/auth_services.dart';

class SettingsPage extends StatelessWidget {
  final UserCredential userCredential;

  const SettingsPage({super.key, required this.userCredential});

  // Método para obtener el usuario completo de Firestore
  Future<Usuarios?> userProfile() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        return Usuarios.fromJson(userDoc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error obteniendo datos de usuario: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajustes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple[900],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(24.0),
                  child: FutureBuilder<Usuarios?>(
                    future: userProfile(),
                    builder: (context, snapshot) {
                      final userData = snapshot.data;
                      final firebaseUser = userCredential.user;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                const AssetImage('lib/assets/icon/icono.png')
                                    as ImageProvider,
                            backgroundColor: Colors.deepPurple[100],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            userData?.username ?? 
                            'Usuario',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                             firebaseUser?.email ??
                            'Correo no disponible',
                            style: TextStyle(
                              fontSize: 16, 
                              color: Colors.grey[700]
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    shadowColor: Colors.red.withOpacity(0.4),
                  ),
                  onPressed: () => dialogoBorrar(context),
                  child: const Text(
                    'CERRAR SESIÓN',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Este método se encarga de mostrar un dialogo de confirmacion para cerrar sesion
  void dialogoBorrar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Cerrar sesión',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          '¿Estás seguro de que quieres salir de tu cuenta?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Aquí se llama al servicio de autenticación para cerrar sesión
              final AuthService auth = AuthService();
              Navigator.pop(context);
              await auth.signout(context: context);
            },
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}