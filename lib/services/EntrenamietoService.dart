// entrenamiento_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nipibasket_tupizarravirtual/models/Entrenamientos.class.dart';
//Creo este servcio para poder obtener los entrenamientos de la base de datos
//Y no tienes problemas en que si necesito llamarlo en otro page  sea mas sencillo llamo la clase servicio y le paso el  usuario 
//Con esto me resulta sencillo y consigo asi llamarlo desde cualquier parte de la aplicacion
//Y no tengo que estar llamando a la base de datos cada vez que lo necesite
class EntrenamientoService {
  final User? user;

  EntrenamientoService(this.user);

  Stream<List<Entrenamientos>> obtenerEntrenamientosComoStream() {
    return FirebaseFirestore.instance
        .collection('Entrenamientos')
        .where('idUsuario', whereIn: ['', user?.uid])
        .snapshots()
        .asyncMap((querySnapshot) async {
          final entrenamientos = <Entrenamientos>[];
          for (final doc in querySnapshot.docs) {
            final entrenamiento = Entrenamientos.fromJson(doc.data());
            final ejercicios = await Entrenamientos.cargarEjercicios(
              doc.data()['ejercicios'],
            );
            entrenamiento.ejercicios.addAll(ejercicios);
            entrenamientos.add(entrenamiento);
          }
          return entrenamientos;
        });
  }
}