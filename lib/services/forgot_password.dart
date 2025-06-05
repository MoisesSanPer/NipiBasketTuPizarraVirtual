// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/services/auth_services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final auth = AuthService();
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cambiar contraseña"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Introduzca su correo electrónico para enviarle un mensaje de restablecimiento de contraseña"),
            SizedBox(height: 20),
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'Introducir correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (email.text.isEmpty || !email.text.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Introduzca una dirección de correo electrónico válida"),
                    ),
                  );
                  return;
                }
                // Metodo enviar enlace de restablecimiento de contraseña
                await auth.sendPasswordResetLink(email.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Se ha enviado a su correo electrónico un mensaje para restablecer la contraseña",
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              child: Text("Enviar correo electrónico"),
            ),
          ],
        ),
      ),
    );
  }
}
