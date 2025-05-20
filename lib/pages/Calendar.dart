// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, unused_local_variable, use_build_context_synchronously, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nipibasket_tupizarravirtual/models/Event.class.dart';
import 'package:nipibasket_tupizarravirtual/services/EntrenamietoService.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final EntrenamientoService entrenamientoService = EntrenamientoService(
    FirebaseAuth.instance.currentUser,
  );
  //Este es el formato del calendario
  CalendarFormat _calendarFormat = CalendarFormat.month;
  //Este es el  dia que estar redondeado del calendario al iniciar
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Event>> listevents = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  //Este metodo es el que se encarga de obtener los entrenamientos del dia seleccionado y este filtrada segun el dia mes y año que clickes
  List<Event> _getEntrenamientosForDay(DateTime fecha) {
    return listevents[DateTime(fecha.year, fecha.month, fecha.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_createCalendar(), Expanded(child: _buildEventList())],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntrenamientoDialog,
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
      headerStyle: HeaderStyle(formatButtonVisible: true, titleCentered: true),
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

  //Evenento que se ejecuta cuando se pulsa el boton de añadir evento
  //Este metodo es el que se encarga de mostrar el dialogo para añadir un entrnamiento
  //En este caso se le pasa el entrenamiento que se ha seleccionado y se añade al calendario
  Future<void> _showAddEntrenamientoDialog() async {
    // Obtener la lista de entrenamientos
    final entrenamientos =
        await entrenamientoService.obtenerEntrenamientosComoStream().first;
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Seleccionar Entrenamiento'),
            content: SizedBox(
              //limita el brode lo maximo posible 
              width: double.maxFinite,
              child: ListView.builder(
                //Opcion  para que podamos scrollear en la app y evitar el overflow
                shrinkWrap: true,
                itemCount: entrenamientos.length,
                itemBuilder: (context, index) {
                  final entrenamiento = entrenamientos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(entrenamiento.nombre),
                      subtitle: Text(
                        'Ejercicios: ${entrenamiento.ejercicios.length}',
                      ),
                      onTap: () {
                        // Al seleccionar un entrenamiento, lo añadimos al calendario
                        final newEvent = Event(
                          title: entrenamiento.nombre,
                          description:
                              'Entrenamiento con ${entrenamiento.ejercicios.length} ejercicios',
                          date: _selectedDay ?? _focusedDay,
                        );
                        setState(() {
                          final day = DateTime(
                            (_selectedDay ?? _focusedDay).year,
                            (_selectedDay ?? _focusedDay).month,
                            (_selectedDay ?? _focusedDay).day,
                          );
                          // Añadimos el evento a la lista de eventos del día seleccionado
                          // Si ya hay eventos, los añadimos a la lista, con los puntos de propagacion basandote en el dia que hayas seleccionado
                          listevents[day] = [...listevents[day] ?? [], newEvent];
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
            ],
          ),
    );
  }
  //Metodo que se encarga de eliminar el evento del calendario en el dia en este caso que tengas añadido
  void _deleteEvent(Event event) {
    setState(() {
      //Se obtiene el dia del evento y se elimina de la lista de eventos
      final day = DateTime(event.date.year, event.date.month, event.date.day);
      //Se elimina el evento de la lista de eventos filtrandiolo por el dia
      //En este caso se elimina el evento que tenga el mismo titulo y la misma descripcion
      listevents[day]?.removeWhere(
        (e) => e.title == event.title && e.description == event.description,
      );
      if (listevents[day]?.isEmpty ?? false) {
        listevents.remove(day);
      }
    });
  }
}