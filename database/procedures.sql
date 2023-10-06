USE Proyecto2;

DROP PROCEDURE IF EXISTS registrarEstudiante;
DELIMITER $$
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

    DECLARE idCarrera INT DEFAULT 1;

    SET idCarrera = FormatIDCarrera(in_id_carrera);

    IF NOT CarreraExisteID(idCarrera) THEN
        SET @custom_message = CONCAT('La carrera con id ', in_id_carrera, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    IF NOT ValidateEmail(in_correo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo no es valido';
    END IF;

    START TRANSACTION;

    INSERT INTO Estudiante(carnet, nombre, apellido, fecha_nacimiento, correo, telefono, direccion, dpi, id_carrera, creditos, fecha_creacion)
    VALUES (in_carnet, in_nombre, in_apellido, in_fecha_nacimiento, in_correo, in_telefono, in_direccion, in_dpi, idCarrera, 0, NOW());

    COMMIT;

    SELECT 'Estudiante creado exitosamente' AS message;
    SELECT * FROM Estudiante;

END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS crearCarrera;
DELIMITER $$
CREATE PROCEDURE crearCarrera(
    IN in_nombre VARCHAR(50)
)
BEGIN

    IF CarreraExisteNombre(in_nombre) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La carrera ya existe';
    END IF;

    START TRANSACTION;

    INSERT INTO Carrera(nombre)
    VALUES (in_nombre);

    COMMIT;
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS registrarDocente;
DELIMITER $$
CREATE PROCEDURE registrarDocente(
    IN in_nombre VARCHAR(50),
    IN in_apellido VARCHAR(50),
    IN in_fecha_nacimiento DATE,
    IN in_correo VARCHAR(50),
    IN in_telefono VARCHAR(8),
    IN in_direccion VARCHAR(100),
    IN in_dpi BIGINT(13),
    IN in_siif INT
)
BEGIN
   IF NOT ValidateEmail(in_correo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El correo no es válido';
    END IF;

    START TRANSACTION;

    INSERT INTO Docente(nombre, apellido, fecha_nacimiento, correo, telefono, direccion, dpi, registro_siif, fecha_creacion)
    VALUES (in_nombre, in_apellido, in_fecha_nacimiento, in_correo, in_telefono, in_direccion, in_dpi, in_siif, NOW());

    COMMIT;

    SELECT 'Docente creado exitosamente' AS message;
    SELECT * FROM Docente;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS crearCurso;
DELIMITER $$
CREATE PROCEDURE crearCurso(
    IN in_id_curso INT,
    IN in_nombre VARCHAR(50),
    IN in_creditos_necesarios INT,
    IN in_creditos_otorgados INT,
    IN in_id_carrera INT,
    IN _es_obligatorio BOOLEAN
)

BEGIN
    DECLARE idCarrera INT DEFAULT 1;
    SET idCarrera = FormatIDCarrera(in_id_carrera);

    IF NOT CarreraExisteID(idCarrera) THEN
        SET @custom_message = CONCAT('La carrera con id ', in_id_carrera, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    IF NOT IsIntPositive(in_creditos_necesarios) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los créditos necesarios deben ser un entero positivo';
    END IF;

    IF NOT IsIntPositive(in_creditos_otorgados) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los créditos otorgados deben ser un entero positivo';
    END IF;

    START TRANSACTION;

    INSERT INTO Curso(id_curso, nombre, creditos_necesarios, creditos_otorgados, id_carrera, es_obligatorio)
    VALUES (in_id_curso, in_nombre, in_creditos_necesarios, in_creditos_otorgados, idCarrera, _es_obligatorio);

    COMMIT;

END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS habilitarCurso;
DELIMITER $$
CREATE PROCEDURE habilitarCurso(
    IN in_id_curso INT,
    IN in_ciclo VARCHAR(50),
    IN in_id_docente INT,
    IN in_cupo_maximo INT,
    IN in_seccion CHAR(1)
)

BEGIN

    IF NOT CursoExisteID(in_id_curso) THEN
        SET @custom_message = CONCAT('El curso con id ', in_id_curso, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    IF NOT ValidarCiclo(in_ciclo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ciclo no es válido';
    END IF;

    IF NOT IsIntPositive(in_cupo_maximo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cupo máximo debe ser un entero positivo';
    END IF;

    IF SeccionExisteID(in_seccion, in_id_curso) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sección ya existe';
    END IF;

    START TRANSACTION ;

    INSERT INTO CursoHabilitado(id_curso, ciclo, registro_siif, cupo_maximo, seccion, fecha_creacion, cantidad_inscritos)
    VALUES (in_id_curso, in_ciclo, in_id_docente, in_cupo_maximo, in_seccion, NOW(), 0);

    COMMIT;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS agregarHorario;
DELIMITER $$
CREATE PROCEDURE agregarHorario(
    IN in_id_curso_habilitado INT,
    IN in_dia_semana INT,
    IN in_horario VARCHAR(15)
)
BEGIN
    IF NOT CursoHabilitadoExisteID(in_id_curso_habilitado) THEN
        SET @custom_message = CONCAT('El curso habilitado con id ', in_id_curso_habilitado, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    IF in_dia_semana > 7 OR in_dia_semana < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El día de la semana no es válido';
    END IF;

    IF NOT ValidarHorario(in_horario) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El horario no es válido';
    END IF;

    START TRANSACTION;
    INSERT INTO HorarioCurso(id_curso_habilitado,dia, horario)
    VALUES (in_id_curso_habilitado, in_dia_semana, in_horario);
END;
$$
DELIMITER ;

/*
    Verificar que el alumno exista
    Verificar que el alumno no este asignado al mismo curso, en la misma seccion, en el mismo ciclo
    Verificar que el alumno tenga los creditos necesarios para inscribirse al curso
    Verificar que la clase a la que el alumno se quiere inscribir no este llena
    Verificar que el curso exista
    Verificar que el curso pertecezca a la carrera del alumno o area comun
*/

DROP PROCEDURE IF EXISTS asignarCurso;
DELIMITER $$
CREATE PROCEDURE asignarCurso(
    IN in_id_curso INT,
    IN in_ciclo VARCHAR(50),
    IN in_seccion CHAR(1),
    IN in_carnet BIGINT(9)
)
BEGIN
    IF NOT EstudianteExiste(in_carnet) THEN
        SET @custom_message = CONCAT('El estudiante con carnet ', in_carnet, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    IF NOT CursoExisteID(in_id_curso) THEN
        SET @custom_message = CONCAT('El curso con id ', in_id_curso, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    IF NOT CursoHabilitadoExisteID(in_id_curso) THEN
        SET @custom_message = CONCAT('El curso habilitado con id ', in_id_curso, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    IF NOT SeccionExisteID(in_seccion, in_id_curso) THEN
        SET @custom_message = CONCAT('La sección ', in_seccion, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    IF NOT ValidarCiclo(in_ciclo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ciclo no es válido';
    END IF;

    IF CursoHabilitadoLleno(in_id_curso, in_seccion, in_ciclo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El curso habilitado esta lleno';
    END IF;

    IF EstudianteInscrito(in_id_curso, in_seccion, in_ciclo, in_carnet) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante ya esta asignado a este curso';
    END IF;

    IF NOT EstudianteTieneCreditos(in_carnet, in_id_curso) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no tiene los creditos necesarios para inscribirse a este curso';
    END IF;

    IF NOT EstudiantePerteneceCarrera(in_carnet, in_id_curso) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no pertenece a la carrera de este curso';
    END IF;

    START TRANSACTION;

    INSERT INTO AsignacionCurso(id_asignacion_curso, id_curso_habilitado, carnet_estudiante)
    VALUES (NULL, in_id_curso, in_carnet);

    UPDATE CursoHabilitado
    SET cantidad_inscritos = cantidad_inscritos + 1
    WHERE id_curso_habilitado = in_id_curso;

    COMMIT;

END; $$
DELIMITER ;

DROP PROCEDURE IF EXISTS desasignarCurso;
DROP PROCEDURE IF EXISTS ingresarNota;
DROP PROCEDURE IF EXISTS generarActa;

-- Getters

DROP PROCEDURE IF EXISTS consultarPensum;
DELIMITER $$
CREATE PROCEDURE consultarPensum(
    IN in_id_carrera INT
)
BEGIN
    DECLARE idCarrera INT DEFAULT 1;
    SET idCarrera = FormatIDCarrera(in_id_carrera);

    IF NOT CarreraExisteID(idCarrera) THEN
        SET @custom_message = CONCAT('La carrera con id ', in_id_carrera, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    SELECT
        id_curso AS 'Codigo de curso',
        nombre AS 'Nombre',
        es_obligatorio AS 'Obligatorio',
        creditos_necesarios AS 'Creditos necesarios'
    FROM Curso
    WHERE id_carrera = idCarrera OR id_carrera = 1;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS consultarEstudiante;
DELIMITER $$
CREATE PROCEDURE consultarEstudiante(
    IN in_carnet BIGINT(9)
)
BEGIN
    IF NOT EstudianteExiste(in_carnet) THEN
        SET @custom_message = CONCAT('El estudiante con carnet ', in_carnet, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    SELECT
        E.carnet AS 'Carnet',
        CONCAT(E.nombre, ' ', E.apellido) AS 'Nombre',
        E.correo AS 'Correo',
        E.telefono AS 'Telefono',
        E.direccion AS 'Direccion',
        E.dpi AS 'DPI',
        C.nombre AS 'Carrera',
        E.creditos AS 'Creditos'
    FROM Estudiante E
    INNER JOIN Carrera C
    ON E.id_carrera = C.id_carrera
    WHERE E.carnet = in_carnet;
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS consultarDocente;
DELIMITER $$
CREATE PROCEDURE consultarDocnente(
    IN in_siif INT
)
BEGIN
    IF NOT DocenteExisteSIIF(in_siif) THEN
        SET @custom_message = CONCAT('El docente con registro siif ', in_siif, ' no existe');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @custom_message;
    END IF;

    SELECT
        registro_siif AS 'Registro SIIF',
        CONCAT(nombre, ' ', apellido) AS 'Nombre',
        fecha_nacimiento AS 'Fecha de nacimiento',
        correo AS 'Correo',
        telefono AS 'Telefono',
        direccion AS 'Direccion',
        dpi AS 'DPI'
    FROM Docente
    WHERE registro_siif = in_siif;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS consultarAsignados;
DROP PROCEDURE IF EXISTS consultarAprobacion;
DROP PROCEDURE IF EXISTS consultarActas;
DROP PROCEDURE IF EXISTS consultarDesasignacion;
DROP PROCEDURE IF EXISTS historialTransacciones;