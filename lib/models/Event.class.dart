//Clase evento para el calendario que representa el evento del dia que estes clickando en ese caso
class Event {
  final String title;
  final String description;
  final DateTime date;

  Event({required this.title, required this.description, required this.date});
}