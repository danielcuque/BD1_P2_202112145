USE Proyecto2;

DROP FUNCTION IF EXISTS AsignacionCursoExisteID;
DELIMITER $$
CREATE FUNCTION AsignacionCursoExisteID (param_id_curso_habilitado INT, param_id_estudiante INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE EXISTE BOOLEAN DEFAULT FALSE;
    IF (SELECT COUNT(*) FROM AsignacionCurso WHERE id_curso_habilitado = param_id_curso_habilitado AND carnet_estudiante = param_id_estudiante) > 0 THEN
        SET EXISTE = TRUE;
    END IF;
    RETURN EXISTE;
END;
$$
DELIMITER ;

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

DROP FUNCTION IF EXISTS CursoHabilitadoExiste;
DELIMITER $$
CREATE FUNCTION CursoHabilitadoExiste (param_id_curso INT, param_ciclo VARCHAR(2), param_seccion CHAR) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE EXISTE BOOLEAN DEFAULT FALSE;
    IF (SELECT COUNT(*) FROM CursoHabilitado WHERE id_curso = param_id_curso AND ciclo = param_ciclo AND seccion = param_seccion) > 0 THEN
        SET EXISTE = TRUE;
    END IF;
    RETURN EXISTE;
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

DROP FUNCTION IF EXISTS TodosLosAlumnosEstanCalificados;
DELIMITER $$
CREATE FUNCTION TodosLosAlumnosEstanCalificados (param_id_curso_habilitado INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE TODOS_CALIFICADOS BOOLEAN DEFAULT FALSE;
    DECLARE inscritos INT DEFAULT 0;
    DECLARE calificados INT DEFAULT 0;

    SELECT cantidad_inscritos INTO inscritos
    FROM CursoHabilitado
    WHERE id_curso_habilitado = param_id_curso_habilitado;

    SELECT COUNT(*) INTO calificados
    FROM AsignacionCurso
    WHERE id_curso_habilitado = param_id_curso_habilitado AND calificado = 1;

    IF (inscritos = calificados) THEN
        SET TODOS_CALIFICADOS = TRUE;
    END IF;

    RETURN TODOS_CALIFICADOS;
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

DROP FUNCTION IF EXISTS EstudianteActivo;
DELIMITER $$
CREATE FUNCTION EstudianteActivo (param_curso_habilitado INT, param_id_estudiante INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN

    DECLARE ACTIVO BOOLEAN DEFAULT FALSE;

    IF (SELECT asignado FROM AsignacionCurso WHERE id_curso_habilitado = param_curso_habilitado AND carnet_estudiante = param_id_estudiante) = 1 THEN
        SET ACTIVO = TRUE;
    END IF;

    RETURN ACTIVO;
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

DROP FUNCTION IF EXISTS FormatFecha;
DELIMITER $$

CREATE FUNCTION FormatFecha (param_fecha VARCHAR(25)) RETURNS DATE
DETERMINISTIC
BEGIN
    DECLARE fecha DATE DEFAULT '1980-03-10';
    SET fecha = STR_TO_DATE(param_fecha, '%d-%m-%Y');
    RETURN fecha;
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

DROP FUNCTION IF EXISTS ObtenerAsignacionCurso;
DELIMITER $$
CREATE FUNCTION ObtenerAsignacionCurso (param_id_curso_habilitado INT, param_id_estudiante INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE idAsignacionCurso INT DEFAULT 0;
    SELECT id_asignacion_curso INTO idAsignacionCurso
    FROM AsignacionCurso
    WHERE id_curso_habilitado = param_id_curso_habilitado AND carnet_estudiante = param_id_estudiante;
    RETURN idAsignacionCurso;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS ObtenerCreditosCurso;
DELIMITER $$
CREATE FUNCTION ObtenerCreditosCurso (param_id_curso INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE creditos INT DEFAULT 0;
    SELECT creditos_otorgados INTO creditos
    FROM Curso
    WHERE id_curso = param_id_curso;
    RETURN creditos;
END;
$$
DELIMITER ;

DROP FUNCTION IF EXISTS ObtenerCreditosEstudiante;
DELIMITER $$
CREATE FUNCTION ObtenerCreditosEstudiante (param_id_estudiante INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE creditos INT DEFAULT 0;
    SELECT creditos INTO creditos
    FROM Estudiante
    WHERE carnet = param_id_estudiante;
    RETURN creditos;
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

DROP FUNCTION IF EXISTS ObtenerFormatoCiclo;
DELIMITER $$
CREATE FUNCTION ObtenerFormatoCiclo (param_ciclo VARCHAR(2)) RETURNS VARCHAR(100)
DETERMINISTIC
    BEGIN

        DECLARE ciclo VARCHAR(100) DEFAULT '';

        IF (param_ciclo = '1S') THEN
            SET ciclo = 'PRIMER SEMESTRE';
        ELSEIF (param_ciclo = '2S') THEN
            SET ciclo = 'SEGUNDO SEMESTRE';
        ELSEIF (param_ciclo = 'VJ') THEN
            SET ciclo = 'VACACIONES DE JUNIO';
        ELSEIF (param_ciclo = 'VD') THEN
            SET ciclo = 'VACACIONES DE DICIEMBRE';
        END IF;

        RETURN ciclo;
    end; $$
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