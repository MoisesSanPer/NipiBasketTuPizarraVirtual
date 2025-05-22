//Clase evento para el calendario que representa el evento del dia que estes clickando en ese caso
class Event {
  final String title;
  final String description;
  final DateTime date;

  Event({required this.title, required this.description, required this.date});
  // Convertir Event a Map (para JSON)
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
  };

  // Crear Event desde Map (desde JSON)
  factory Event.fromJson(Map<String, dynamic> json) => Event(
    title: json['title'],
    description: json['description'],
    date: DateTime.parse(json['date']),
  );
}