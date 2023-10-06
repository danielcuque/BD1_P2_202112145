USE Proyecto2;

-- Calls to create a new career
CALL crearCarrera('Area Comun');
CALL crearCarrera('Ingenieria en Ciencias y Sistemas');
CALL crearCarrera('Ingenieria Industrial');
CALL crearCarrera('Ingenieria Mecanica');
CALL crearCarrera('Ingenieria Civil');


-- Calls to create a new student

CALL registrarEstudiante(
    202112145,
    'Daniel',
    'Cuque',
    '1999-12-12',
    'danielcuque78@gmail.com',
    '12345678',
    'Guatemala',
    3024465830102,
    1
);

CALL registrarEstudiante(
    202112146,
    'Juan',
    'Perez',
    '1999-12-12',
    'correo@gmail.com',
    '12345678',
    'Guatemala',
    3024465830102,
    1
);

CALL registrarEstudiante(
    202112147,
    'Pedro',
    'Perez',
    '1999-12-12',
    'pedroperez@gmail.com',
    '87654321',
    'San Marcos',
    3024465830102,
    2
);

CALL registrarEstudiante(
    202112148,
    'Ana',
    'González',
    '2000-05-25',
    'anagonzalez@gmail.com',
    '78901234',
    'Ciudad Guatemala',
    3056789012345,
    3
);


CALL registrarEstudiante(
    202112149,
    'Carlos',
    'López',
    '2001-03-18',
    'carloslopez@gmail.com',
    '65432109',
    'Villa Nueva',
    3012345678901,
    3
);

CALL registrarEstudiante(
    202112150,
    'María',
    'Martínez',
    '1999-08-09',
    'mariamartinez@gmail.com',
    '87650987',
    'Quetzaltenango',
    3023456789012,
    2
);

CALL registrarEstudiante(
    202112152,
    'Laura',
    'Hernández',
    '1998-11-15',
    'laurahernandez@gmail.com',
    '89012345',
    'Antigua Guatemala',
    3012345678901,
    3
);

CALL registrarEstudiante(
    202112153,
    'Eduardo',
    'Díaz',
    '2000-09-30',
    'eduardodiaz@gmail.com',
    '67890123',
    'Quetzaltenango',
    3023456789012,
    2
);

CALL registrarEstudiante(
    202112154,
    'Isabel',
    'Sánchez',
    '2003-06-07',
    'isabelsanchez@gmail.com',
    '56789012',
    'Villa Nueva',
    3045678901234,
    1
);

CALL registrarEstudiante(
    202012133,
    'Armando',
    'Parades',
    '2001-01-01',
    'jorgeramirez@gmail.com',
    '45678901',
    'Ciudad Guatemala',
    3012345678901,
    1
);

-- Calls to create a new teacher

CALL registrarDocente('Carlos', 'Gómez', '1980-03-10', 'carlos.gomez@email.com', '12345678', 'Ciudad de Guatemala', 1234567890123, 101);
CALL registrarDocente('Elena', 'Martínez', '1975-11-22', 'elena.martinez@email.com', '98765432', 'Villa Nueva', 9876543210987, 102);
CALL registrarDocente('José', 'López', '1985-07-05', 'jose.lopez@email.com', '55555555', 'Quetzaltenango', 5555555555555, 103);
CALL registrarDocente('Ana', 'Ramírez', '1978-09-15', 'ana.ramirez@email.com', '11111111', 'Escuintla', 1111111111111, 104);
CALL registrarDocente('Miguel', 'Hernández', '1982-02-28', 'miguel.hernandez@email.com', '22222222', 'Antigua Guatemala', 2222222222222, 105);

-- Calls to create a new course

CALL crearCurso(
    348,
    'QUIMICA GENERAL 1',
    0,
    3,
    0,
    TRUE
);

CALL crearCurso(
    39,
    'DEPORTES 1',
    0,
    1,
    0,
    FALSE
);

CALL crearCurso(
    69,
    'TECNICA COMPLEMENTARIA',
    0,
    1,
    0,
    TRUE
);

CALL crearCurso(
    17,
    'AREA SOCIAL HUMANISTICA 1',
    0,
    3,
    0,
    TRUE
);

CALL crearCurso(
    6,
    'IDIOMA TECNICO 1',
    0,
    4,
    0,
    TRUE
);

CALL crearCurso(
    960,
    'MATEMATICA PARA COMPUTACION 1',
    33,
    5,
    1,
    TRUE
);

CALL crearCurso(
    770,
    'IPC1',
    33,
    4,
    1,
    TRUE
);

CALL crearCurso(
    771,
    'IPC2',
    33,
    5,
    1,
    FALSE
);

CALL crearCurso(
    962,
    'MATEMATICA PARA COMPUTACION 2',
    33,
    5,
    1,
    TRUE
);

CALL crearCurso(
    796,
    'LENGUAJES FORMALES Y DE PROGRAMACION',
    33,
    3,
    3,
    FALSE
);

CALL habilitarCurso(
    348,
    '1S',
    101,
    110,
    'A'
);

CALL habilitarCurso(
    348,
    '1S',
    101,
    110,
    'B'
);

CALL habilitarCurso(
    6,
    '1S',
    102,
    60,
    'C'
);

CALL habilitarCurso(
    39,
    '1S',
    103,
    110,
    'A'
);

/*  */

CALL agregarHorario(
    1,
    1,
    '9:00-10:40'
);

CALL agregarHorario(
    1,
    2,
    '9:50-11:30'
);

CALL agregarHorario(
    2,
    7,
    '19:00-20:40'
);

CALL agregarHorario(
    2,
    3,
    '19:00-20:40'
);

CALL agregarHorario(
    3,
    4,
    '7:00-8:40'
);

CALL agregarHorario(
    3,
    5,
    '7:50-9:30'
);

CALL agregarHorario(
    4,
    6,
    '15:00-16:40'
);

CALL agregarHorario(
    4,
    7,
    '15:50-17:30'
);

/* Asignaciones  */

CALL asignarCurso(
    348,
    '1S',
    'A',
    202112145
);


CALL asignarCurso(
    6,
    '1S',
    'C',
    202112145
);

CALL asignarCurso(
    39,
    '1S',
    'A',
    202112145
);

CALL asignarCurso(
    348,
    '1S',
    'A',
    202112146
);

CALL asignarCurso(
    39,
    '1S',
    'A',
    202112146
);

/* Desasignaciones */

CALL desasignarCurso(
    39,
    '1S',
    'A',
    202112145
);

/* Ingreso de notas */

CALL ingresarNota(
    348,
    '1S',
    'A',
    202112145,
    100
);

CALL ingresarNota(
    6,
    '1S',
    'C',
    202112145,
    50
);

CALL ingresarNota(
    348,
    '1S',
    'A',
    202112146,
    100
);

CALL generarActa(
    348,
    '1S',
    'A'
);

/* GETTERS */
CALL consultarPensum(1);
CALL consultarPensum(2);

CALL consultarEstudiante(202112145);

CALL consultarDocente(101);

CALL consultarAsignados(
    348,
    '1S',
    2023,
    'A'
);

CALL consultarAsignados(
    6,
    '1S',
    2023,
    'C'
);

CALL consultarAprobacion(
    348,
    '1S',
    2023,
    'A'
);

CALL consultarActas(348);

CALL consultarDesasignacion(
    39,
    '1S',
    2023,
    'A'
);

CALL historialTransacciones();