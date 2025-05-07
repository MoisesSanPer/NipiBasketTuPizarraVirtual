// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  //Este es el formato del calendario
  CalendarFormat _calendarFormat = CalendarFormat.month;
  //Este es el  dia que estar redondeado del calendario al iniciar
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }
//Este metodo es el que se encarga de obtener los entrenamientos del dia seleccionado y este filtrada segun el dia mes y año que clickes 
  List<Event> _getEntrenamientosForDay(DateTime fecha) {
    return _events[DateTime(fecha.year, fecha.month, fecha.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _createCalendar(),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  // Este es el metodo que crea el calendario
  Widget _createCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2018, 1, 1),
      lastDay: DateTime.utc(2032, 12, 31),
      //Esta propiedad es la que se refiere a que se reondee de otro color el dia que se ha selecciondo
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      eventLoader: _getEntrenamientosForDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      //Evento que se ejecuta cuando se selecciona un dia lo haces que dia que este selecionado con el focus  sacado de la documentacion de flutter
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      //Evento que se ejecuta cuando se cambia el formato del calendario 
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      //Este evento se tiene que poner para que cuando se haga un Hot reload y se haga interactivo el calendario  se actuazlie 
      //el focus day a uno predertminado 
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        markersMaxCount: 4,
        markerSize: 10,
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        //Para  que el usuario sepa que dia ha seleccionado se le pone un color diferente al dia que ha seleccionado
        todayDecoration: BoxDecoration(
          color: const Color.fromARGB(255, 16, 134, 231).withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
      ),
    );
  }
  /// Este metodo es el que se encarga de construir la lista de eventos
  Widget _buildEventList() {
    final events = _getEntrenamientosForDay(_selectedDay ?? _focusedDay);

    if (events.isEmpty) {
      return Center(child: Text('No hay entrenamientos  para este día'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(event.title),
            subtitle: Text(event.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteEvent(event),
            ),
          ),
        );
      },
    );
  }
  //Esdte evento  no es el definitvio ya que lo que voy ha hacer es que se muestre una lista de entrenamientos 
  //y de ahi se pueda seleccionar el entrenamiento que quieres para cada dia 
  Future<void> _showAddEventDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Añadir Evento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty) return;

              final newEvent = Event(
                title: titleController.text,
                description: descController.text,
                date: _selectedDay ?? _focusedDay,
              );

              setState(() {
                final day = DateTime(
                  (_selectedDay ?? _focusedDay).year,
                  (_selectedDay ?? _focusedDay).month,
                  (_selectedDay ?? _focusedDay).day,
                );
                
                _events[day] = [..._events[day] ?? [], newEvent];
              });

              Navigator.pop(context);
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteEvent(Event event) {
    setState(() {
      final day = DateTime(event.date.year, event.date.month, event.date.day);
      _events[day]?.removeWhere((e) => e.title == event.title && e.description == event.description);
      if (_events[day]?.isEmpty ?? false) {
        _events.remove(day);
      }
    });
  }
}

//Example Class to represent an event
class Event {
  final String title;
  final String description;
  final DateTime date;

  Event({
    required this.title,
    required this.description,
    required this.date,
  });
}