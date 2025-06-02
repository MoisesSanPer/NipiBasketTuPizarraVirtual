import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Cifrado de contraseña el cual finalemnete no uso  debido a que firebase usa uno propio
extension StringHashing on String {
  /// Calcula el  hash de la cadena usando el algoritmo especificado.
  /// Soporta 'md5', 'sha1' y 'sha256'.:
  String hash(String algorithm) {
    final bytes = utf8.encode(this);
    Digest digest;

    if (algorithm.toLowerCase() == 'sha1') {
      digest = sha1.convert(bytes);
    } else if (algorithm.toLowerCase() == 'sha256') {
      digest = sha256.convert(bytes);
    } else {
      throw UnsupportedError('Algoritmo no soportado: $algorithm');
    }
     print(digest.toString());
    return digest.toString();
  }

  String get sha1Hash => hash('sha1');
  String get sha256Hash => hash('sha256');
}
