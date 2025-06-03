import 'package:flutter_test/flutter_test.dart';
import 'package:nipibasket_tupizarravirtual/models/Ejercicio.class.dart';

void main() {
  group('Ejercicio Model Test', () {
    final ejercicio = Ejercicio(
      id: 'e1',
      nombre: 'Dribbling',
      descripcion: 'Mejorar el control del balón',
      tipo: TipoEjercicio.botar,
      videoURL: 'http://video.com/ejercicio.mp4',
      idUsuario: 'user123',
    );

    test('toJson devuelve un mapa válido', () {
      final json = ejercicio.toJson();
      expect(json['id'], 'e1');
      expect(json['nombre'], 'Dribbling');
      expect(json['descripcion'], 'Mejorar el control del balón');
      expect(json['tipo'], 'botar');
      expect(json['videoUrl'], 'http://video.com/ejercicio.mp4');
      expect(json['idUsuario'], 'user123');
    });

    test('fromJson crea una instancia válida', () {
      final json = {
        'id': 'e1',
        'nombre': 'Dribbling',
        'descripcion': 'Mejorar el control del balón',
        'tipo': 'botar',
        'videoURL': 'http://video.com/ejercicio.mp4',
        'idUsuario': 'user123',
      };
      final nuevo = Ejercicio.fromJson(json);
      expect(nuevo.id, ejercicio.id);
      expect(nuevo.tipo, TipoEjercicio.botar);
    });

    test('copyWith modifica solo los campos especificados', () {
      final modificado = ejercicio.copyWith(nombre: 'Tiro libre');
      expect(modificado.nombre, 'Tiro libre');
      expect(modificado.descripcion, ejercicio.descripcion);
    });

    test('fromJson maneja tipo desconocido con valor por defecto', () {
      final json = {
        'id': 'e2',
        'nombre': 'Ejercicio desconocido',
        'descripcion': 'Tipo no válido',
        'tipo': 'invalido',
      };
      final ejercicioDesconocido = Ejercicio.fromJson(json);
      expect(ejercicioDesconocido.tipo, TipoEjercicio.tiro); // valor por defecto
    });

    test('videoURL e idUsuario pueden ser nulos', () {
      final ejercicioSinOpcionales = Ejercicio(
        id: 'e3',
        nombre: 'Defensa',
        descripcion: 'Ejercicio defensivo',
        tipo: TipoEjercicio.defensa,
      );
      expect(ejercicioSinOpcionales.videoURL, isNull);
      expect(ejercicioSinOpcionales.idUsuario, isNull);
    });
  });
}
