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
BEGIN
    
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS asignarCurso;
DROP PROCEDURE IF EXISTS desasignarCurso;
DROP PROCEDURE IF EXISTS ingresarNota;