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
//Metodo que obtiene los entrenamientos de la base de datos
//Lo que hace es obtener los entrenamientos de la base de datos y los convierte en un stream
  Stream<List<Entrenamientos>> obtenerEntrenamientosComoStream() {
    return FirebaseFirestore.instance
        .collection('Entrenamientos')
        //filtras por el id del usuario
        .where('idUsuario', whereIn: ['', user?.uid])
        .snapshots()
        .asyncMap((querySnapshot) async {
          final entrenamientos = <Entrenamientos>[];
          //Recorres los documentos de la base de datos
          for (final doc in querySnapshot.docs) {
            //Conviertes el documento en un mapa y lo pasas al fromJson
            final entrenamiento = Entrenamientos.fromJson(doc.data());
            //Cargas los ejercicios de firebase basados en los documentos y el campo ejercicios
            final ejercicios = await Entrenamientos.cargarEjercicios(
              doc.data()['ejercicios'],
            );
            //Agregas los ejercicios a la lista de ejercicios del entrenamiento
            entrenamiento.ejercicios.addAll(ejercicios);
            //Agregas el entrenamiento a la lista de entrenamientos
            entrenamientos.add(entrenamiento);
          }
          return entrenamientos;
        });
  }
}