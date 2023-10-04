USE Proyecto2;

/* Procedures to handle data */

DROP PROCEDURE IF EXISTS registrarEstudiante;
DELIMITER //
CREATE PROCEDURE registrarEstudiante(
    IN in_carnet BIGINT(9),
    IN in_nombre VARCHAR(50),
    IN in_apellido VARCHAR(50),
    IN in_fecha_nacimiento DATE,
    IN in_correo VARCHAR(50),
    IN in_telefono VARCHAR(8),
    IN in_direccion VARCHAR(100),
    IN in_dpi BIGINT(13),
    IN in_id_carrera INT
)
BEGIN

    START TRANSACTION;

    INSERT INTO Estudiante(carnet, nombre, apellido, fecha_nacimiento, correo, telefono, direccion, dpi, id_carrera, creditos, fecha_creacion)
    VALUES (in_carnet, in_nombre, in_apellido, in_fecha_nacimiento, in_correo, in_telefono, in_direccion, in_dpi, in_id_carrera, 0, NOW());

    COMMIT;

    SELECT 'Estudiante creado exitosamente' AS message;

END;
//
DELIMITER ;

DROP PROCEDURE IF EXISTS crearCarrera;
DROP PROCEDURE IF EXISTS registrarDocente;
DROP PROCEDURE IF EXISTS crearCurso;
DROP PROCEDURE IF EXISTS habilitarCurso;
DROP PROCEDURE IF EXISTS agregarHorario;
DROP PROCEDURE IF EXISTS asignarCurso;
DROP PROCEDURE IF EXISTS desasignarCurso;
DROP PROCEDURE IF EXISTS ingresarNota;