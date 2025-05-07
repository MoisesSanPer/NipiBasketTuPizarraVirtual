import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/models/Ejercicio.class.dart';
import 'package:nipibasket_tupizarravirtual/pages/VideoPlayer.dart';

class Ejercicios extends StatelessWidget {
  const Ejercicios({super.key});
Stream<List<Ejercicio>> obtenerEjerciciosComoStream() {
  return FirebaseFirestore.instance
      .collection('Ejercicio')
      .snapshots() // Obtiene un Stream<QuerySnapshot>
      .map((querySnapshot) {
        // Convierte cada documento en un Map y luego en String (JSON)
        final listaDeDatos = querySnapshot.docs
            .map((doc) => doc.data()).map((data) {
              // Convierte el Map a un objeto Ejercicio
              return Ejercicio.fromJson(data);
            }).toList();
        
        return listaDeDatos;
      });
}
  @override
  Widget build(BuildContext context)   {
    return Scaffold(
      body: StreamBuilder<List<Ejercicio>>(
        stream: obtenerEjerciciosComoStream(),
        builder: (context, snapshot)  {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
       
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar datos'));
          }
          final ejercicios = snapshot.data!;
          return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: ejercicios.length,
          itemBuilder: (context, index) {
            final ejercicio = ejercicios[index];
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
                        //Esto se refiere al número del ejercicio en este caso el orden no influye pero es importante para el usuario
                        // que sepa que ejercicio es el que tiene que hacer
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[700],
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          // Número del ejercicio el cual me he basado en el indice
                          child: Text(
                           (index + 1).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Título del ejercicio
                        Expanded(
                          child: Text(
                            ejercicio.nombre,
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
                  // Este container es el que se encarga de mostrar la imagen del ejercicio
                  // En este caso no tengo los videos implementados pero lo hare con la libreria de video_player
                 Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: VideoPlayer(
                        videoURL: ejercicio.videoURL,
                        height: 200,
                      ),
                    ),
                  // Información del ejercicio
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tipo de ejercicio con chip morado
                        Chip(
                          backgroundColor: Colors.deepPurple[100],
                          label: Text(
                            ejercicio.tipo.toString().split('.').last.toUpperCase(),
                            style: TextStyle(
                              color: Colors.deepPurple[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Descripción
                        Text(
                          ejercicio.descripcion,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 15,
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
