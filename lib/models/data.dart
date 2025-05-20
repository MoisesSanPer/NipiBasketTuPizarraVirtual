import 'package:nipibasket_tupizarravirtual/models/Ejercicio.class.dart';
import 'package:nipibasket_tupizarravirtual/models/Entrenamientos.class.dart';

List<Entrenamientos> entrenamientosData = [
    Entrenamientos(
      id: '1',
      nombre: 'Fundamentos Básicos',
      ejercicios: [
        Ejercicio(
          id: '1',
          nombre: 'Tiro libre',
          descripcion: '50 tiros desde la línea de libre',
          tipo: TipoEjercicio.tiro,
        ),
        Ejercicio(
          id: '2',
          nombre: 'Drible de control',
          descripcion: 'Drible en zigzag entre conos',
          tipo: TipoEjercicio.botar,
        ),
      ],
    ),
    Entrenamientos(
      id: '2',
      nombre: 'Defensa Intensiva',
      ejercicios: [
        Ejercicio(
          id: '3',
          nombre: 'Posición defensiva',
          descripcion: 'Mantener posición baja por 30 segundos',
          tipo: TipoEjercicio.defensa,
        ),
      ],
    ),
  ];