import 'package:flutter_test/flutter_test.dart';
import 'package:nipibasket_tupizarravirtual/models/Usuarios.dart';

void main() {
  group('Usuarios Model Test', () {
    final usuario = Usuarios(
      uuid: '123',
      email: 'test@example.com',
      username: 'testuser',
      photoURL: 'http://example.com/photo.jpg',
    );

    test('toJson devuelve un mapa válido', () {
      final json = usuario.toJson();
      expect(json, {
        'uuid': '123',
        'email': 'test@example.com',
        'username': 'testuser',
        'photoURL': 'http://example.com/photo.jpg',
      });
    });

    test('fromJson crea una instancia válida', () {
      final json = {
        'uuid': '123',
        'email': 'test@example.com',
        'username': 'testuser',
        'photoURL': 'http://example.com/photo.jpg',
      };
      final nuevoUsuario = Usuarios.fromJson(json);
      expect(nuevoUsuario, usuario);
    });

    test('copyWith modifica solo los campos especificados', () {
      final modificado = usuario.copyWith(email: 'nuevo@example.com');
      expect(modificado.email, 'nuevo@example.com');
      expect(modificado.uuid, usuario.uuid);
    });

    test('== y hashCode funcionan correctamente', () {
      final otroUsuario = Usuarios(
        uuid: '123',
        email: 'test@example.com',
        username: 'testuser',
        photoURL: 'http://example.com/photo.jpg',
      );
      expect(usuario, otroUsuario);
      expect(usuario.hashCode, otroUsuario.hashCode);
    });
  });
}
