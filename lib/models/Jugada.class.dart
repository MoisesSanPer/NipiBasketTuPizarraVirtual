// ignore_for_file: file_names, constant_identifier_names

enum TipoJugada {
  ataque,
  defensa,
}


class Jugada {
  final String id;
  final String nombre;
  final String descripcion;
  final TipoJugada tipo;
  final String? videoURL;
  final String? idUsuario;

  Jugada({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.tipo,
    this.videoURL,
    this.idUsuario,
  });


  factory Jugada.fromJson(Map<String, dynamic> json) {
    return Jugada(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      tipo: TipoJugada.values.firstWhere(
        (e) => e.toString() == 'TipoJugada.${json['tipo']}',
        orElse: () => TipoJugada.ataque,
      ),
      videoURL: json['videoURL'] as String?, 
      idUsuario: json['idUsuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'tipo': tipo.toString().split('.').last,
      'videoUrl': videoURL,
      'idUsuario': idUsuario,
    };
  }

  Jugada copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    TipoJugada? tipo,
    String? videoUrl,
    String? idJugada,
    String? idUsuario,
  }) {
    return Jugada(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      videoURL: videoUrl ?? this.videoURL,
      idUsuario: idUsuario ?? this.idUsuario,
    );
  }
}