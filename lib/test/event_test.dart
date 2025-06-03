import 'package:flutter_test/flutter_test.dart';
import 'package:nipibasket_tupizarravirtual/models/Event.class.dart';

void main() {
  group('Event Model Test', () {
    final event = Event(
      title: 'Entrenamiento',
      description: 'Sesión de práctica en cancha',
      date: DateTime.parse('2025-06-03T10:00:00.000Z'),
    );

    test('toJson devuelve un mapa válido', () {
      final json = event.toJson();
      expect(json['title'], 'Entrenamiento');
      expect(json['description'], 'Sesión de práctica en cancha');
      expect(json['date'], '2025-06-03T10:00:00.000Z');
    });

    test('fromJson crea una instancia válida', () {
      final json = {
        'title': 'Entrenamiento',
        'description': 'Sesión de práctica en cancha',
        'date': '2025-06-03T10:00:00.000Z',
      };
      final nuevoEvento = Event.fromJson(json);
      expect(nuevoEvento.title, event.title);
      expect(nuevoEvento.description, event.description);
      expect(nuevoEvento.date, event.date);
    });

    test('date se convierte correctamente desde y hacia ISO 8601', () {
      final json = event.toJson();
      final reconstruido = Event.fromJson(json);
      expect(reconstruido.date, event.date);
    });
  });
}
