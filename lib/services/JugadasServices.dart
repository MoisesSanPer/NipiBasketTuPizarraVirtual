import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nipibasket_tupizarravirtual/models/Jugada.class.dart';

class JugadasServices {
  final User? user;

  JugadasServices(this.user);
//Metodo que obtiene las jugadas de la base de datos
 Stream<List<Jugada>> obtenerJugadasComoStream() {
  return FirebaseFirestore.instance
      .collection('Jugadas')
      .where('idUsuario', whereIn: ['',user?.uid])
      .snapshots() // Obtiene un Stream<QuerySnapshot>
      .map((querySnapshot) {
        // Convierte cada documento en un Map y luego en String (JSON)
        final listaDeDatos = querySnapshot.docs
            .map((doc) => doc.data()).map((data) {
              // Convierte el Map a un objeto Jugada
              return Jugada.fromJson(data);
            }).toList();
        
        return listaDeDatos;
      });
}
}