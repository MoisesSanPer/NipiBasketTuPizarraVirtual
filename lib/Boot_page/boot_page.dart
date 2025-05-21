// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/pages/Home.dart';
import 'package:nipibasket_tupizarravirtual/services/EjerciciosServices.dart';
import 'package:nipibasket_tupizarravirtual/services/EntrenamietoService.dart';
import 'package:nipibasket_tupizarravirtual/services/JugadasServices.dart';
//Pagina ayudada de una de ejemplo que teniamos en clase , modifico  añadiendo los campos que necesito
class BootPage extends StatefulWidget {
    final UserCredential userCredential;
    final String username;
  const BootPage({super.key, required this.userCredential, required this.username});

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
    late final EntrenamientoService entrenamientoService;
    late final EjerciciosServices ejerciciosServices;
    late final JugadasServices jugadasServices;

   @override
  void initState() {
    super.initState();
        entrenamientoService = EntrenamientoService(widget.userCredential.user);
        ejerciciosServices = EjerciciosServices(widget.userCredential.user);
        jugadasServices = JugadasServices(widget.userCredential.user);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () { 
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Home(userCredential: widget.userCredential, entrenamientoService: entrenamientoService,ejerciciosServices: ejerciciosServices,jugadasServices: jugadasServices,)),
          );
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Cargando datos..."),
          ],
        ),
      ),
    );
  }
}