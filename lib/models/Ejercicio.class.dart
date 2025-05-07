// ignore_for_file: file_names, constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

enum TipoEjercicio {
  tiro,
  rebote,
  defensa,
  botar,
  pase,
}


class Ejercicio {
  final String id;
  final String nombre;
  final String descripcion;
  final TipoEjercicio tipo;
  final String? videoUrl;
  final String? idUsuario;

  Ejercicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.tipo,
    this.videoUrl,
    this.idUsuario,
  });


  factory Ejercicio.fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      tipo: TipoEjercicio.values.firstWhere(
        (e) => e.toString() == 'TipoEjercicio.${json['tipo']}',
        orElse: () => TipoEjercicio.tiro,
      ),
      videoUrl: json['videoUrl'],
      idUsuario: json['idUsuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'tipo': tipo.toString().split('.').last,
      'videoUrl': videoUrl,
      'idUsuario': idUsuario,
    };
  }

  Ejercicio copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    TipoEjercicio? tipo,
    String? videoUrl,
    String? idJugada,
    String? idUsuario,
  }) {
    return Ejercicio(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      videoUrl: videoUrl ?? this.videoUrl,
      idUsuario: idUsuario ?? this.idUsuario,
    );
  }
}