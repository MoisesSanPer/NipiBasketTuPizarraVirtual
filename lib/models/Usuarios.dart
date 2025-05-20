// ignore_for_file: file_names
class Usuarios {
  final String uuid;
  final String email;
  final String username;

  Usuarios({
    required this.uuid,
    required this.email,
    required this.username,
  });

  // Constructor copyWith
  Usuarios copyWith({
    String? uuid,
    String? email,
    String? username,
  }) {
    return Usuarios(
      uuid: uuid ?? this.uuid,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  // Método fromJson
  factory Usuarios.fromJson(Map<String, dynamic> json) {
    return Usuarios(
      uuid: json['uuid'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
    );
  }

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'email': email,
      'username': username,
    };
  }

  // Sobreescritura del operador == y hashCode para comparación de objetos
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Usuarios &&
        other.uuid == uuid &&
        other.email == email &&
        other.username == username;
  }

  @override
  int get hashCode => uuid.hashCode ^ email.hashCode ^ username.hashCode;

  // Método toString para representación en cadena
  @override
  String toString() {
    return 'Usuarios(uuid: $uuid, email: $email, username: $username)';
  }
}