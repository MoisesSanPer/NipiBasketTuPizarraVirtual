import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nipibasket_tupizarravirtual/models/Ejercicio.class.dart';

class EjerciciosServices {
  final User? user;

  EjerciciosServices(this.user);
  //Metodo que obtiene los ejercicios de la base de datos
  Stream<List<Ejercicio>> obtenerEjerciciosComoStream() {
    return FirebaseFirestore.instance
        .collection('Ejercicio')
        .where('idUsuario', whereIn: ['', user?.uid])
        .snapshots() // Obtiene un Stream<QuerySnapshot>
        .map((querySnapshot) {
          // Convierte cada documento en un Map y luego en String (JSON)
          final listaDeDatos =
              querySnapshot.docs.map((doc) => doc.data()).map((data) {
                // Convierte el Map a un objeto Ejercicio
                return Ejercicio.fromJson(data);
              }).toList();

          return listaDeDatos;
        });
  }

  Future<void> agrgarEjercicio(Ejercicio ejercicio) async {
    // Guardar el ejercicio en Firestore
    await FirebaseFirestore.instance
        .collection('Ejercicio')
        .doc(ejercicio.id)
        .set({
          'id': ejercicio.id,
          'nombre': ejercicio.nombre,
          'descripcion': ejercicio.descripcion,
          'tipo': ejercicio.tipo.toString().split('.').last,
          'videoURL': ejercicio.videoURL,
          'idUsuario': user?.uid,
        });
  }
}
