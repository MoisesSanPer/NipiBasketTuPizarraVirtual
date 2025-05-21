import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/models/Jugada.class.dart';
import 'package:nipibasket_tupizarravirtual/pages/VideoPlayer.dart';
import 'package:nipibasket_tupizarravirtual/services/JugadasServices.dart';

class Jugadas extends StatelessWidget {
  final UserCredential userCredential;
  final JugadasServices jugadasServices;
  const Jugadas({super.key, required this.userCredential, required this.jugadasServices});

  @override
  Widget build(BuildContext context)   {
    return Scaffold(
      body: StreamBuilder<List<Jugada>>(
        stream: jugadasServices.obtenerJugadasComoStream(),
        builder: (context, snapshot)  {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
       
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar datos'));
          }
          final jugadas = snapshot.data!;
          return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: jugadas.length,
          itemBuilder: (context, index) {
            final jugada = jugadas[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Encabezado con número y título
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                    ),
                    child: Row(
                      children: [
                        //Esto se refiere al número de la jugada en este caso el orden no influye pero es importante para el usuario
                        // que sepa que ejercicio es el que tiene que hacer
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[700],
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          // Número de la jugada el cual me he basado en el indice
                          child: Text(
                           (index + 1).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Título de la jugada
                        Expanded(
                          child: Text(
                            jugada.nombre,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Este container es el que se encarga de mostrar la imagen de la jugada
                 //Aqui se llamara al video de la jugada
                 Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: VideoPlayer(
                        videoURL: jugada.videoURL,
                        height: 200,
                      ),
                    ),
                  // Información de la jugada
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tipo de jugada con chip morado
                        Chip(
                          backgroundColor: Colors.deepPurple[100],
                          label: Text(
                            jugada.tipo.toString().split('.').last.toUpperCase(),
                            style: TextStyle(
                              color: Colors.deepPurple[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Descripción
                        Text(
                          jugada.descripcion,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
        },
      ),
    );
  }
}