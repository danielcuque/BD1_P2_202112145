DROP DATABASE IF EXISTS Proyecto2;

CREATE DATABASE Proyecto2;

USE Proyecto2;

CREATE TABLE IF NOT EXISTS Estudiante(
    carnet BIGINT(9) NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(8) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    dpi BIGINT(13) NOT NULL,
    id_carrera INT NOT NULL,
    creditos INT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS Carrera(
    id_carrera INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Docente(
    id_docente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(8) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    dpi BIGINT(13) NOT NULL,
    registro_siif INT NOT NULL,
    fecha_creacion DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Curso(
    id_curso INT NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos_necesarios INT NOT NULL,
    creditos_otorgados INT NOT NULL,
    id_carrera INT NOT NULL,
    es_obligatorio BOOLEAN NOT NULL
);


CREATE TABLE IF NOT EXISTS CursoHabilitado(
    id_curso_habilitado INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    id_curso INT NOT NULL,
    ciclo VARCHAR(2) NOT NULL,
    id_docente INT NOT NULL,
    cupo_maximo INT NOT NULL,
    seccion CHAR NOT NULL,
    fecha_creacion DATE NOT NULL,
    cantidad_inscritos INT NOT NULL
);

CREATE TABLE IF NOT EXISTS HorarioCurso(
    id_horario_curso INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_curso_habilitado INT NOT NULL,
    dia VARCHAR(10) NOT NULL,
    horario VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS AsignacionCurso(
    id_asignacion_curso INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_curso_habilitado INT NOT NULL,
    carnet_estudiante BIGINT(9) NOT NULL,
    ciclo VARCHAR(2) NOT NULL,
    seccion CHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS Nota(
  id_nota INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  id_asignacion_curso INT NOT NULL,
  nota INT NOT NULL
);


CREATE TABLE IF NOT EXISTS Acta(
    id_acta INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_curso_habilitado INT NOT NULL,
    ciclo VARCHAR(2) NOT NULL,
    fecha DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS HistorialTransacciones(
    id_transaccion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    tipo_transaccion VARCHAR(20) NOT NULL
);


ALTER TABLE Estudiante ADD CONSTRAINT FK_Estudiante_Carrera FOREIGN KEY (id_carrera) REFERENCES Carrera(id_carrera);
ALTER TABLE Curso ADD CONSTRAINT FK_Curso_Carrera FOREIGN KEY (id_carrera) REFERENCES Carrera(id_carrera);
ALTER TABLE CursoHabilitado ADD CONSTRAINT FK_CursoHabilitado_Curso FOREIGN KEY (id_curso) REFERENCES Curso(id_curso);
ALTER TABLE CursoHabilitado ADD CONSTRAINT FK_CursoHabilitado_Docente FOREIGN KEY (id_docente) REFERENCES Docente(id_docente);
ALTER TABLE HorarioCurso ADD CONSTRAINT FK_HorarioCurso_CursoHabilitado FOREIGN KEY (id_curso_habilitado) REFERENCES CursoHabilitado(id_curso_habilitado);
ALTER TABLE AsignacionCurso ADD CONSTRAINT FK_AsignacionCurso_CursoHabilitado FOREIGN KEY (id_curso_habilitado) REFERENCES CursoHabilitado(id_curso_habilitado);
ALTER TABLE AsignacionCurso ADD CONSTRAINT FK_AsignacionCurso_Estudiante FOREIGN KEY (carnet_estudiante) REFERENCES Estudiante(carnet);
ALTER TABLE Nota ADD CONSTRAINT FK_Nota_AsignacionCurso FOREIGN KEY (id_asignacion_curso) REFERENCES AsignacionCurso(id_asignacion_curso);
ALTER TABLE Acta ADD CONSTRAINT FK_Acta_CursoHabilitado FOREIGN KEY (id_curso_habilitado) REFERENCES CursoHabilitado(id_curso_habilitado);
