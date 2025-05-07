import 'package:flutter/material.dart';

class Entrenamiento extends StatelessWidget {
  const Entrenamiento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Entrenamiento',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.orange[700],
          ),
        ),
      ),
    );
  }
}