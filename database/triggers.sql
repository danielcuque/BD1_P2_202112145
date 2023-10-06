USE Proyecto2;

DELIMITER //

CREATE TRIGGER Estudiante_Insert
AFTER INSERT ON Estudiante
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se insertó un estudiante', 'INSERT');
END;

CREATE TRIGGER Estudiante_Update
AFTER UPDATE ON Estudiante
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se actualizó un estudiante', 'UPDATE');
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER Carrera_Insert
AFTER INSERT ON Carrera
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se insertó una carrera', 'INSERT');
END;

CREATE TRIGGER Carrera_Update
AFTER UPDATE ON Carrera
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se actualizó una carrera', 'UPDATE');
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER Docente_Insert
AFTER INSERT ON Docente
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se insertó un docente', 'INSERT');
END;

CREATE TRIGGER Docente_Update
AFTER UPDATE ON Docente
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se actualizó un docente', 'UPDATE');
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER Curso_Insert
AFTER INSERT ON Curso
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se insertó un curso', 'INSERT');
END;

CREATE TRIGGER Curso_Update
AFTER UPDATE ON Curso
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se actualizó un curso', 'UPDATE');
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER CursoHabilitado_Insert
AFTER INSERT ON CursoHabilitado
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se insertó un curso habilitado', 'INSERT');
END;

CREATE TRIGGER CursoHabilitado_Update
AFTER UPDATE ON CursoHabilitado
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se actualizó un curso habilitado', 'UPDATE');
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER HorarioCurso_Insert
AFTER INSERT ON HorarioCurso
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se insertó un horario de curso', 'INSERT');
END;

CREATE TRIGGER HorarioCurso_Update
AFTER UPDATE ON HorarioCurso
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se actualizó un horario de curso', 'UPDATE');
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER AsignacionCurso_Insert
AFTER INSERT ON AsignacionCurso
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se asignó un curso a un estudiante', 'INSERT');
END;

CREATE TRIGGER AsignacionCurso_Update
AFTER UPDATE ON AsignacionCurso
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se actualizó la asignación de un curso a un estudiante', 'UPDATE');
END;

//

DELIMITER ;


DELIMITER //

CREATE TRIGGER Nota_Insert
AFTER INSERT ON Nota
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se insertó una nota', 'INSERT');
END;

CREATE TRIGGER Nota_Update
AFTER UPDATE ON Nota
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se actualizó una nota', 'UPDATE');
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER Acta_Insert
AFTER INSERT ON Acta
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se insertó un acta', 'INSERT');
END;

CREATE TRIGGER Acta_Update
AFTER UPDATE ON Acta
FOR EACH ROW
BEGIN
    CALL insertarTransaccion('Se actualizó un acta', 'UPDATE');
END;

//

DELIMITER ;
