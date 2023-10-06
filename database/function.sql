USE Proyecto2;

DROP FUNCTION IF EXISTS  CarreraExisteID;
DELIMITER $$
CREATE FUNCTION CarreraExisteID (param_id_carrera INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE EXISTE BOOLEAN DEFAULT FALSE;
    IF (SELECT COUNT(*) FROM Carrera WHERE id_carrera = param_id_carrera) > 0 THEN
        SET EXISTE = TRUE;
    END IF;
    RETURN EXISTE;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS  CarreraExisteNombre;
DELIMITER $$
CREATE FUNCTION CarreraExisteNombre (param_nombre_carrera VARCHAR(200)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE EXISTE BOOLEAN DEFAULT FALSE;
    IF (SELECT COUNT(*) FROM Carrera WHERE nombre = param_nombre_carrera) > 0 THEN
        SET EXISTE = TRUE;
    END IF;
    RETURN EXISTE;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS CursoExisteID;
DELIMITER $$
CREATE FUNCTION CursoExisteID (param_id_curso INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE EXISTE BOOLEAN DEFAULT FALSE;
    IF (SELECT COUNT(*) FROM Curso WHERE id_curso = param_id_curso) > 0 THEN
        SET EXISTE = TRUE;
    END IF;
    RETURN EXISTE;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS CursoHabilitadoLleno;
DELIMITER $$
CREATE FUNCTION CursoHabilitadoLleno (param_id_curso INT, param_ciclo VARCHAR(2), param_seccion CHAR) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE LLENO BOOLEAN DEFAULT FALSE;
    DECLARE cupo INT DEFAULT 0;
    DECLARE inscritos INT DEFAULT 0;
    DECLARE curso_habilitado INT DEFAULT 0;

    SET curso_habilitado = ObtenerCursoHabilitado(param_id_curso, param_seccion, param_ciclo);

    SELECT COUNT(*) INTO inscritos
    FROM AsignacionCurso
    WHERE id_curso_habilitado = curso_habilitado;

    SELECT cupo_maximo INTO cupo
    FROM CursoHabilitado
    WHERE id_curso_habilitado = curso_habilitado;

    IF (inscritos >= cupo) THEN
        SET LLENO = TRUE;
    END IF;

    RETURN LLENO;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS DocenteExisteSIIF;
DELIMITER $$
CREATE FUNCTION DocenteExisteSIIF (param_siif INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE EXISTE BOOLEAN DEFAULT FALSE;
    IF (SELECT COUNT(*) FROM Docente WHERE registro_siif = param_siif) > 0 THEN
        SET EXISTE = TRUE;
    END IF;
    RETURN EXISTE;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS EstudianteExiste;
DELIMITER $$
CREATE FUNCTION EstudianteExiste (param_id_estudiante INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE EXISTE BOOLEAN DEFAULT FALSE;
    IF (SELECT COUNT(*) FROM Estudiante WHERE carnet = param_id_estudiante) > 0 THEN
        SET EXISTE = TRUE;
    END IF;
    RETURN EXISTE;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS IsAlpha;
DELIMITER $$
CREATE FUNCTION IsAlpha (input VARCHAR(1000)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE IS_VALID BOOLEAN DEFAULT FALSE;

    IF (input REGEXP '^[A-Za-z]+$') THEN
        SET IS_VALID = TRUE;
    END IF;
    RETURN IS_VALID;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS IsIntPositive;
DELIMITER $$
CREATE FUNCTION IsIntPositive (input VARCHAR(1000)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE IS_VALID BOOLEAN DEFAULT FALSE;

    IF (input REGEXP '^[0-9]+$') THEN
        SET IS_VALID = TRUE;
    END IF;
    RETURN IS_VALID;
END;
$$
DELIMITER ;


DROP FUNCTION IF EXISTS CursoHabilitadoExisteID;
DELIMITER $$
CREATE FUNCTION CursoHabilitadoExisteID (param_id_curso_habilitado INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE EXISTE BOOLEAN DEFAULT FALSE;
    IF (SELECT COUNT(*) FROM CursoHabilitado WHERE id_curso_habilitado = param_id_curso_habilitado) > 0 THEN
        SET EXISTE = TRUE;
    END IF;
    RETURN EXISTE;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS EstudianteInscrito;
DELIMITER $$
CREATE FUNCTION EstudianteInscrito (param_id_curso INT,  param_ciclo VARCHAR(2), param_id_estudiante INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Check if student is already enrolled in the course in the current cycle

    DECLARE INSCRITO BOOLEAN DEFAULT FALSE;
    DECLARE contador INT DEFAULT 0;

    SELECT COUNT(*) INTO contador
    FROM AsignacionCurso AS AC
    WHERE
    AC.carnet_estudiante = param_id_estudiante
    AND AC.id_curso_habilitado IN (
        SELECT id_curso_habilitado
        FROM CursoHabilitado
        WHERE id_curso = param_id_curso AND ciclo = param_ciclo
    );

    IF (contador > 0) THEN
        SET INSCRITO = TRUE;
    END IF;

    RETURN INSCRITO;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS EstudiantePerteneceCarrera;
DELIMITER $$
CREATE FUNCTION EstudiantePerteneceCarrera (param_id_estudiante INT, param_id_curso INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN

    DECLARE PERTENECE BOOLEAN DEFAULT FALSE;
    DECLARE id_carrera_curso INT DEFAULT 0;
    DECLARE id_carrera_estudiante INT DEFAULT 0;

    SELECT id_carrera INTO id_carrera_curso
    FROM Curso
    WHERE id_curso = param_id_curso;

    SELECT id_carrera INTO id_carrera_estudiante
    FROM Estudiante
    WHERE carnet = param_id_estudiante;

    IF (id_carrera_curso = 1 OR id_carrera_curso = id_carrera_estudiante) THEN
        SET PERTENECE = TRUE;
    END IF;

    RETURN PERTENECE;
END;
$$
DELIMITER ;


DROP FUNCTION IF EXISTS EstudianteTieneCreditos;
DELIMITER $$
CREATE FUNCTION EstudianteTieneCreditos (param_id_estudiante INT, param_id_curso INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN

    DECLARE creditos_requeridos INT DEFAULT 0;
    DECLARE creditos_estudiante INT DEFAULT 0;
    DECLARE TIENE_CREDITOS BOOLEAN DEFAULT FALSE;

    SELECT creditos_necesarios INTO creditos_requeridos
    FROM Curso
    WHERE id_curso = param_id_curso;

    SELECT creditos FROM Estudiante WHERE carnet = param_id_estudiante INTO creditos_estudiante;

    IF (creditos_estudiante >= creditos_requeridos) THEN
        SET TIENE_CREDITOS = TRUE;
    END IF;

    RETURN TIENE_CREDITOS;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS FormatIDCarrera;
DELIMITER $$
CREATE FUNCTION FormatIDCarrera (param_id_carrera INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE id_carrera INT DEFAULT 0;
    SET id_carrera = param_id_carrera + 1;
    RETURN id_carrera;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS ObtenerCursoHabilitado;
DELIMITER $$
CREATE FUNCTION ObtenerCursoHabilitado (
    param_id_curso INT,
    param_seccion CHAR,
    param_ciclo VARCHAR(2)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE idCursoHabilitado INT DEFAULT 0;
    SELECT id_curso_habilitado INTO idCursoHabilitado
    FROM CursoHabilitado
    WHERE id_curso = param_id_curso AND seccion = param_seccion AND ciclo = param_ciclo and fecha_actual = YEAR(NOW());
    RETURN idCursoHabilitado;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS SafeInput;
DELIMITER $$
CREATE FUNCTION SafeInput (input VARCHAR(1000)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE IS_SAFE BOOLEAN DEFAULT FALSE;
    IF (input NOT REGEXP '[^A-Za-z0-9@.]') THEN
        SET IS_SAFE = TRUE;
    END IF;
    RETURN IS_SAFE;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS SeccionExisteID;
DELIMITER $$
CREATE FUNCTION SeccionExisteID (param_seccion CHAR, param_id_curso INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE EXISTE BOOLEAN DEFAULT FALSE;
    IF(SELECT COUNT(*) FROM CursoHabilitado WHERE id_curso = param_id_curso AND seccion = param_seccion) > 0 THEN
        SET EXISTE = TRUE;
    END IF;
    RETURN EXISTE;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS ValidarCiclo;
DELIMITER $$
CREATE FUNCTION ValidarCiclo (param_ciclo VARCHAR(2)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE IS_VALID BOOLEAN DEFAULT FALSE;
    IF (param_ciclo REGEXP '^[1-2V][SJD]$') THEN
        SET IS_VALID = TRUE;
    END IF;
    RETURN IS_VALID;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS ValidateEmail;
DELIMITER $$
CREATE FUNCTION ValidateEmail (email VARCHAR(1000)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
   DECLARE IS_VALID BOOLEAN DEFAULT FALSE;
    IF (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$') THEN
        SET IS_VALID = TRUE;
    END IF;
    RETURN IS_VALID;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS ValidarHorario;
DELIMITER $$
CREATE FUNCTION ValidarHorario(param_horario VARCHAR(20)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE IS_VALID BOOLEAN DEFAULT FALSE;
    IF (param_horario REGEXP '^[0-9]{1,2}:[0-9]{2}-[0-9]{1,2}:[0-9]{2}$') THEN
        SET IS_VALID = TRUE;
    END IF;
    RETURN IS_VALID;
end; $$
DELIMITER ;