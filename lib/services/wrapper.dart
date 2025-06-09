import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/pages/Home.dart';
import 'package:nipibasket_tupizarravirtual/pages/login.dart';
import 'package:nipibasket_tupizarravirtual/services/EjerciciosServices.dart';
import 'package:nipibasket_tupizarravirtual/services/EntrenamietoService.dart';
import 'package:nipibasket_tupizarravirtual/services/JugadasServices.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else {
            if (snapshot.data == null) {
              return const LoginScreen();
            } else {
              // Inicializar servicios solo cuando hay usuario
              final user = snapshot.data!;
              final entrenamientoService = EntrenamientoService(user);
              final ejerciciosServices = EjerciciosServices(user);
              final jugadasServices = JugadasServices(user);
              return Home(
                entrenamientoService: entrenamientoService,
                ejerciciosServices: ejerciciosServices,
                jugadasServices: jugadasServices,
              );
            }
          }
        },
      ),
    );
  }
}