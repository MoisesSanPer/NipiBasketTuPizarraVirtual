// ignore_for_file: file_names, constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nipibasket_tupizarravirtual/models/Ejercicio.class.dart';

class Entrenamientos {
  final String id;
  final String nombre;
  final String? idUsuario;
  final List<Ejercicio> ejercicios;

  Entrenamientos({
    required this.id,
    required this.nombre,
    this.idUsuario,
    required this.ejercicios,
  });

  //Vacio para luego caragra datos de firebase
  factory Entrenamientos.fromJson(Map<String, dynamic> json) {
    return Entrenamientos(
      id: json['id'],
      nombre: json['nombre'],
      idUsuario: json['idUsuario'],
      ejercicios: [],
    );
  }

  //Codigo ayudado por IA ya que me resulto complicado sacar la referencia de otro documento
  //Metodo que carga los ejercicios de firebase
  static Future<List<Ejercicio>> cargarEjercicios(
    List<dynamic> listRefs,
  ) async {
    //Inicializa la lista de ejercicios vacia
    final ejercicios = <Ejercicio>[];
    //Recorre la lista de referencias a ejercicios
    for (final ref in listRefs.cast<DocumentReference>()) {
      //Guardas cada documento en  la variable  y con el .get() lo traes
      final doc = await ref.get();
      //El dodumento lo conviertes a un mapa y lo pasas al fromJson
      //para que te devuelva el objeto Ejercicio
      //y lo agregas a la lista de ejercicios
        ejercicios.add(Ejercicio.fromJson(doc.data()! as Map<String, dynamic>));
    }
    //Devuelve la lista de ejercicios
    return ejercicios;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      if (idUsuario != null) 'idUsuario': idUsuario,
      'ejercicios': ejercicios.map((e) => e.toJson()).toList(),
    };
  }

  Entrenamientos copyWith({
    String? id,
    String? nombre,
    String? idUsuario,
    List<Ejercicio>? ejercicios,
  }) {
    return Entrenamientos(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      idUsuario: idUsuario ?? this.idUsuario,
      ejercicios: ejercicios ?? this.ejercicios,
    );
  }
}
