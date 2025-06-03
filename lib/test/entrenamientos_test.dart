import 'package:flutter_test/flutter_test.dart';
import 'package:nipibasket_tupizarravirtual/models/Entrenamientos.class.dart';
import 'package:nipibasket_tupizarravirtual/models/Ejercicio.class.dart';
import 'package:nipibasket_tupizarravirtual/models/Jugada.class.dart';

void main() {
  group('Entrenamientos Model Test', () {
    final ejercicio = Ejercicio(
      id: 'e1',
      nombre: 'Dribbling',
      descripcion: 'Mejorar el control del balón',
      tipo: TipoEjercicio.botar,
      idUsuario: 'user123',
    );

    final jugada = Jugada(
      id: 'j1',
      nombre: 'Pick and Roll',
      descripcion: 'Jugada ofensiva',
      tipo: TipoJugada.ataque,
    );

    final entrenamiento = Entrenamientos(
      id: 't1',
      nombre: 'Sesión 1',
      idUsuario: 'user123',
      ejercicios: [ejercicio],
      jugadas: [jugada],
    );

    test('toJson devuelve un mapa válido', () {
      final json = entrenamiento.toJson();
      expect(json['id'], 't1');
      expect(json['nombre'], 'Sesión 1');
      expect(json['idUsuario'], 'user123');
      expect(json['ejercicios'], isA<List>());
      expect(json['jugadas'], isA<List>());
    });

    test('fromJson crea una instancia válida con listas vacías', () {
      final json = {
        'id': 't1',
        'nombre': 'Sesión 1',
        'idUsuario': 'user123',
      };
      final nuevo = Entrenamientos.fromJson(json);
      expect(nuevo.id, 't1');
      expect(nuevo.nombre, 'Sesión 1');
      expect(nuevo.idUsuario, 'user123');
      expect(nuevo.ejercicios, isEmpty);
      expect(nuevo.jugadas, isEmpty);
    });

    test('copyWith modifica solo los campos especificados', () {
      final modificado = entrenamiento.copyWith(nombre: 'Sesión 2');
      expect(modificado.nombre, 'Sesión 2');
      expect(modificado.id, entrenamiento.id);
    });
  });
}
