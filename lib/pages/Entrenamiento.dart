// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nipibasket_tupizarravirtual/models/Ejercicio.class.dart';
import 'package:nipibasket_tupizarravirtual/models/Entrenamientos.class.dart';
import 'package:nipibasket_tupizarravirtual/models/Jugada.class.dart';
import 'package:nipibasket_tupizarravirtual/services/EjerciciosServices.dart';
import 'package:nipibasket_tupizarravirtual/services/EntrenamietoService.dart';
import 'package:nipibasket_tupizarravirtual/services/JugadasServices.dart';
import 'package:uuid/uuid.dart';

class Entrenamiento extends StatelessWidget {
  final UserCredential userCredential;
  final EntrenamientoService entrenamientoService;
  const Entrenamiento({
    super.key,
    required this.userCredential,
    required this.entrenamientoService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Entrenamientos',
          style: TextStyle(color: Colors.white),
        ),
        leading: null,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 45, 102, 168),
      ),
      body: StreamBuilder<List<Entrenamientos>>(
        stream: entrenamientoService.obtenerEntrenamientosComoStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar datos'));
          }
          final entrenamiento = snapshot.data!;
          return ListView.separated(
            itemCount: entrenamiento.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entrenamientoActual = entrenamiento[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entrenamientoActual.nombre,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text(
                                            "Ejercicios del Entrenamiento",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors
                                                      .blue, // Puedes cambiar el color
                                            ),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                if (entrenamientoActual
                                                    .ejercicios
                                                    .isEmpty)
                                                  const Text(
                                                    'No hay ejercicios en este entrenamiento',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  )
                                                else
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        "Ejercicios incluidos:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      ...entrenamientoActual
                                                          .ejercicios
                                                          .map(
                                                            (e) => Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    left: 8,
                                                                    bottom: 4,
                                                                  ),
                                                              child: Text(
                                                                "• ${e.nombre}",
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                    ],
                                                  ),
                                                const SizedBox(height: 16),
                                                if (entrenamientoActual
                                                    .jugadas
                                                    .isEmpty)
                                                  const Text(
                                                    'No hay jugadas en este entrenamiento',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  )
                                                else
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        "Jugadas incluidas:",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      ...entrenamientoActual
                                                          .jugadas
                                                          .map(
                                                            (e) => Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    left: 8.0,
                                                                    bottom: 4,
                                                                  ),
                                                              child: Text(
                                                                "• ${e.nombre}",
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text(
                                                "Cerrar",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  showEditDialog(context, entrenamientoActual);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDeleteDialog(
                                    entrenamientoActual,
                                    context,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ejercicios: ${entrenamientoActual.ejercicios.length}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jugadas: ${entrenamientoActual.jugadas.length}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDialog(context);
        },
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void showDeleteDialog(
    Entrenamientos entrenamientoActual,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar borrado'),
          content: Text(
            '¿Estás seguro de que quieres borrar el entrenamiento "${entrenamientoActual.nombre}"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Borrar', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await borrarEntrenamiento(entrenamientoActual.id, context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> borrarEntrenamiento(
    String entrenamientoId,
    BuildContext context,
  ) async {
    try {
      // Llama al método de servicio para eliminar el entrenamiento
      await entrenamientoService.eliminarEntrenamiento(entrenamientoId);
      // Puedes mostrar el SnackBar aquí si quieres que aparezca después de la eliminación exitosa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrenamiento borrado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al borrar: $e')));
    }
  }

  Future<void> showAddDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final ejerciciosServices = EjerciciosServices(userCredential.user);
    final jugadasServices = JugadasServices(userCredential.user);
    final selectedEjercicioRefs = <DocumentReference>[];
    final selectedJugadasRefs = <DocumentReference>[]; // Lista de referencias

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Añadir Entrenamiento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del entrenamiento',
                      ),
                      maxLength: 15,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    ),
                    const SizedBox(height: 20),
                    const Text('Selecciona ejercicios:'),
                    const SizedBox(height: 10),
                    // StreamBuilder para obtener la lista de ejercicios
                    StreamBuilder<List<Ejercicio>>(
                      stream: ejerciciosServices.obtenerEjerciciosComoStream(),
                      builder: (context, snapshot) {
                        final ejercicios = snapshot.data ?? [];
                        return Column(
                          children:
                              // Recorre la lista de ejercicios y crea un CheckboxListTile para cada uno
                              ejercicios.map((ejercicio) {
                                // Crear referencia al documento del ejercicio de la lista que recojes
                                final docRef = FirebaseFirestore.instance
                                    .collection('Ejercicio')
                                    .doc(ejercicio.id);
                                return CheckboxListTile(
                                  title: Text(ejercicio.nombre),
                                  // Compara la referencia del ejercicio con la lista de referencias seleccionadas
                                  // y marca el checkbox si está en la lista
                                  value: selectedEjercicioRefs.any(
                                    (ref) => ref.path == docRef.path,
                                  ),
                                  onChanged: (bool? selected) {
                                    setState(() {
                                      // Si el checkbox está seleccionado, lo agregas a la lista
                                      // Si no, lo eliminas de la lista
                                      if (selected == true) {
                                        selectedEjercicioRefs.add(docRef);
                                      } else {
                                        selectedEjercicioRefs.removeWhere(
                                          (ref) => ref.path == docRef.path,
                                        );
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Selecciona jugadas:'),
                    const SizedBox(height: 10),
                    // StreamBuilder para obtener la lista de ejercicios
                    StreamBuilder<List<Jugada>>(
                      stream: jugadasServices.obtenerJugadasComoStream(),
                      builder: (context, snapshot) {
                        final jugadas = snapshot.data ?? [];
                        return Column(
                          children:
                              // Recorre la lista de ejercicios y crea un CheckboxListTile para cada uno
                              jugadas.map((jugada) {
                                // Crear referencia al documento del ejercicio de la lista que recojes
                                final docRef = FirebaseFirestore.instance
                                    .collection('Jugadas')
                                    .doc(jugada.id);
                                return CheckboxListTile(
                                  title: Text(jugada.nombre),
                                  // Compara la referencia del ejercicio con la lista de referencias seleccionadas
                                  // y marca el checkbox si está en la lista
                                  value: selectedJugadasRefs.any(
                                    (ref) => ref.path == docRef.path,
                                  ),
                                  onChanged: (bool? selected) {
                                    setState(() {
                                      // Si el checkbox está seleccionado, lo agregas a la lista
                                      // Si no, lo eliminas de la lista
                                      if (selected == true) {
                                        selectedJugadasRefs.add(docRef);
                                      } else {
                                        selectedJugadasRefs.removeWhere(
                                          (ref) => ref.path == docRef.path,
                                        );
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 147, 15, 199),
                  ),
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El nombre no puede estar vacío'),
                        ),
                      );
                      return;
                    }

                    try {
                      //Forma para setear el id de forma automatica
                      //Genera un nuevo ID único para el entrenamiento que sera igual que el del documento
                      final nuevoId = Uuid().v4();
                      // Crea un nuevo entrenamiento
                      entrenamientoService.agregarEntrenamiento(
                        Entrenamientos(
                          id: nuevoId,
                          nombre: nameController.text,
                          ejercicios: [],
                          jugadas: [],
                        ),
                        selectedEjercicioRefs,
                        selectedJugadasRefs,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Entrenamiento creado correctamente'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al crear entrenamiento: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> showEditDialog(
    BuildContext context,
    Entrenamientos entrenamiento,
  ) async {
    final nameController = TextEditingController(text: entrenamiento.nombre);
    final ejerciciosServices = EjerciciosServices(userCredential.user);
    final jugadasServices = JugadasServices(userCredential.user);
    // Lista de referencias a ejercicios seleccionados
    // Inicializa la lista de referencias con los ejercicios actuales del entrenamiento
    // Recorre la lista de ejercicios y crea una referencia a cada uno
    // y los agregas a la lista de referencias seleccionadas
    final ejercicioSeleccionados =
        entrenamiento.ejercicios
            .map(
              (e) => FirebaseFirestore.instance
                  .collection('Ejercicio')
                  .doc((e is String ? e : e.id) as String?),
            )
            .toList();
    final jugadaSeleccionadas =
        entrenamiento.jugadas
            .map(
              (e) => FirebaseFirestore.instance
                  .collection('Jugadas')
                  .doc((e is String ? e : e.id) as String?),
            )
            .toList();
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Entrenamiento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del entrenamiento',
                      ),
                      maxLength: 15,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    ),
                    const SizedBox(height: 20),
                    const Text('Selecciona ejercicios:'),
                    const SizedBox(height: 10),
                    StreamBuilder<List<Ejercicio>>(
                      stream: ejerciciosServices.obtenerEjerciciosComoStream(),
                      builder: (context, snapshot) {
                        final ejercicios = snapshot.data ?? [];
                        return Column(
                          children:
                              ejercicios.map((ejercicio) {
                                //Referencia al documento del ejercicio de la lista que recojes
                                //Puedes ya que el id es el mismo que el del documento
                                final docRef = FirebaseFirestore.instance
                                    .collection('Ejercicio')
                                    .doc(ejercicio.id);
                                return CheckboxListTile(
                                  title: Text(ejercicio.nombre),
                                  // Compara la referencia del ejercicio con la lista de referencias seleccionadas
                                  value: ejercicioSeleccionados.any(
                                    (ref) => ref.path == docRef.path,
                                  ),
                                  onChanged: (bool? selected) {
                                    // Si el checkbox está seleccionado, lo agregas a la lista
                                    // Si no, lo eliminas de la lista
                                    setState(() {
                                      if (selected == true) {
                                        ejercicioSeleccionados.add(docRef);
                                      } else {
                                        ejercicioSeleccionados.removeWhere(
                                          (ref) => ref.path == docRef.path,
                                        );
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Selecciona jugadas:'),
                    const SizedBox(height: 10),
                    StreamBuilder<List<Jugada>>(
                      stream: jugadasServices.obtenerJugadasComoStream(),
                      builder: (context, snapshot) {
                        final jugadas = snapshot.data ?? [];
                        return Column(
                          children:
                              jugadas.map((jugada) {
                                //Referencia al documento del ejercicio de la lista que recojes
                                //Puedes ya que el id es el mismo que el del documento
                                final docRef = FirebaseFirestore.instance
                                    .collection('Jugadas')
                                    .doc(jugada.id);
                                return CheckboxListTile(
                                  title: Text(jugada.nombre),
                                  // Compara la referencia del ejercicio con la lista de referencias seleccionadas
                                  value: jugadaSeleccionadas.any(
                                    (ref) => ref.path == docRef.path,
                                  ),
                                  onChanged: (bool? selected) {
                                    // Si el checkbox está seleccionado, lo agregas a la lista
                                    // Si no, lo eliminas de la lista
                                    setState(() {
                                      if (selected == true) {
                                        jugadaSeleccionadas.add(docRef);
                                      } else {
                                        jugadaSeleccionadas.removeWhere(
                                          (ref) => ref.path == docRef.path,
                                        );
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 147, 15, 199),
                  ),
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El nombre no puede estar vacío'),
                        ),
                      );
                      return;
                    }
                    try {
                      // Actualiza el entrenamiento en Firestore es la diferencia con el otro
                      await entrenamientoService.editarEntrenamiento(
                        Entrenamientos(
                          id: entrenamiento.id,
                          nombre: nameController.text,
                          ejercicios: [],
                          jugadas: [],
                        ),
                        ejercicioSeleccionados,
                        jugadaSeleccionadas,
                      );

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Entrenamiento actualizado correctamente',
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error al actualizar entrenamiento: $e',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
