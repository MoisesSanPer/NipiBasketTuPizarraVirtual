import 'package:flutter_test/flutter_test.dart';
import 'package:nipibasket_tupizarravirtual/models/Jugada.class.dart';

void main() {
  group('Jugada Model Test', () {
    final jugada = Jugada(
      id: '001',
      nombre: 'Pick and Roll',
      descripcion: 'Una jugada clásica de ataque',
      tipo: TipoJugada.ataque,
      videoURL: 'http://video.com/jugada.mp4',
      idUsuario: 'user123',
    );

    test('toJson devuelve un mapa válido', () {
      final json = jugada.toJson();
      expect(json, {
        'id': '001',
        'nombre': 'Pick and Roll',
        'descripcion': 'Una jugada clásica de ataque',
        'tipo': 'ataque',
        'videoUrl': 'http://video.com/jugada.mp4',
        'idUsuario': 'user123',
      });
    });

    test('fromJson crea una instancia válida', () {
      final json = {
        'id': '001',
        'nombre': 'Pick and Roll',
        'descripcion': 'Una jugada clásica de ataque',
        'tipo': 'ataque',
        'videoURL': 'http://video.com/jugada.mp4',
        'idUsuario': 'user123',
      };
      final nuevaJugada = Jugada.fromJson(json);
      expect(nuevaJugada.id, jugada.id);
      expect(nuevaJugada.tipo, TipoJugada.ataque);
    });

    test('copyWith modifica solo los campos especificados', () {
      final modificada = jugada.copyWith(nombre: 'Zona 2-3');
      expect(modificada.nombre, 'Zona 2-3');
      expect(modificada.descripcion, jugada.descripcion);
    });

    test('fromJson maneja tipo desconocido con valor por defecto', () {
      final json = {
        'id': '002',
        'nombre': 'Desconocida',
        'descripcion': 'Tipo no válido',
        'tipo': 'invalido',
      };
      final jugadaDesconocida = Jugada.fromJson(json);
      expect(jugadaDesconocida.tipo, TipoJugada.ataque); // valor por defecto
    });

    test('videoURL e idUsuario pueden ser nulos', () {
      final jugadaSinOpcionales = Jugada(
        id: '003',
        nombre: 'Defensa en zona',
        descripcion: 'Cobertura en zona',
        tipo: TipoJugada.defensa,
      );
      expect(jugadaSinOpcionales.videoURL, isNull);
      expect(jugadaSinOpcionales.idUsuario, isNull);
    });
  });
}
