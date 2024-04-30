/*
* CREACIÓN DEL SQL: AGUSTÍN. A MARQUEZ PIÑA
* INSERTAR DATOS EN LAS TABLAS: AGUSTÍN. A MARQUEZ PIÑA
* ESTABLECER LAS FOREIGN KEYS (FK Y PFK): AGUSTÍN. A MARQUEZ PIÑA
* ESTABLECER LAS PRIMARY KEYS (PK Y/O AK): AGUSTÍN. A MARQUEZ PIÑA
*
* CREACIÓN DEL SQL: 15/04/2024
* ULTIMA MODIFICACIÓN: 16/04/2024
* TIPO DE BASE DE DATOS: MySQL 5.0
* MODELO DE BASE DE DATOS: MySQL 5.0
*/
-- Elimina la base de datos si ya existe para evitar conflictos de nombres y 
-- asegurar una creación limpia
DROP DATABASE IF EXISTS DAW_BD_AGUSTIN_PINA_VERSION3;
-- Crea la base de datos con el nombre específico proporcionado
CREATE DATABASE DAW_BD_AGUSTIN_PINA;
-- Selecciona la base de datos recién creada para comenzar a operar sobre ella
USE DAW_BD_AGUSTIN_PINA;

-- Creación de la tabla CURSOS
CREATE TABLE `CURSOS`(
  `CODIGO_CURSO` Char(4) NOT NULL, -- Almacena el curso actual "DAW1" o "DAW2"
  `NOMBRE_CURSO` Varchar(45) -- "Puede llevar el nombre del curso completo.
);

-- Define el código de curso como la primary key de la tabla.
ALTER TABLE `CURSOS` ADD PRIMARY KEY (`CODIGO_CURSO`);

-- Creación de la tabla MODULOS
CREATE TABLE `MODULOS`(
  `CODIGO_MODULO` Char(4) NOT NULL,
  `NOMBRE_MODULO` Varchar(20) NOT NULL,
  `HORAS_TOTALES` Int NOT NULL,
  `HORAS_SEMANALES` Int
);

-- Define el código de modulo como la primary key de la tabla.
ALTER TABLE `MODULOS` ADD PRIMARY KEY (`CODIGO_MODULO`);

-- Creación de la tabla ALUMNOS
CREATE TABLE `ALUMNOS`(
  `NIA_ALUMNO` Char(9) NOT NULL,
  `DNI_ALUMNO` Char(9) NOT NULL,
  `GENERO_ALUMNO` Char(1) NOT NULL,
  `FECHA_NACIMIENTO` Date NOT NULL,
  `NOMBRE_ALUMNO` Varchar(20) NOT NULL,
  `APELLIDO1_ALUMNO` Char(20) NOT NULL,
  `APELLIDO2_ALUMNO` Char(20) NOT NULL,
  `DIRECCION_ALUMNO` Varchar(255) NOT NULL
);

-- Define el NIA de los alumnos como la primary key de la tabla.
ALTER TABLE `ALUMNOS` ADD PRIMARY KEY (`NIA_ALUMNO`);

-- Define el DNI de los alumnos como la alternative key de la tabla.
ALTER TABLE `ALUMNOS` ADD UNIQUE `DNI_ALUMNO` (`DNI_ALUMNO`);

-- Creación de la tabla ESPECIALIDADES
CREATE TABLE `ESPECIALIDADES`(
  `ESPECIALIDAD` Varchar(5) NOT NULL,
  `NOMBRE_ESPECIALIDAD` Varchar(60) NOT NULL,
  `DESCRIPCION_ESPECIALIDAD` Varchar(150) NOT NULL
);
ALTER TABLE `ESPECIALIDADES` ADD PRIMARY KEY (`ESPECIALIDAD`);

-- Creación de la tabla PROFESORES
CREATE TABLE `PROFESORES`(
  `CODIGO_PROFESOR` Char(5) NOT NULL,
  `NOMBRE_PROFESOR` Varchar(20) NOT NULL,
  `APELLIDO_PROFESOR` Varchar(20) NOT NULL,
  `ESPECIALIDAD` Varchar(5) NOT NULL
);

ALTER TABLE `PROFESORES` ADD PRIMARY KEY (`CODIGO_PROFESOR`);
ALTER TABLE `PROFESORES` ADD CONSTRAINT `FK_ESPECIALIDAD` FOREIGN KEY (`ESPECIALIDAD`) 
REFERENCES `ESPECIALIDADES` (`ESPECIALIDAD`) ON DELETE CASCADE ON UPDATE CASCADE;

-- Creación de la tabla MATRICULAS_MODULOS
CREATE TABLE `MATRICULAS_MODULOS`(
  `CODIGO_MATRICULA` Char(5) NOT NULL,
  `NIA_ALUMNO` Char(9) NOT NULL,
  `CODIGO_MODULO` Char(4) NOT NULL,
  `CODIGO_PROFESOR` Char(5) NOT NULL,
  `FECHA_MATRICULA` Date NOT NULL,
  `CONVOCATORIAS_RESTANTES` Int NOT NULL,
  `ESPECIALIDAD` Varchar(5) NOT NULL,
  `FALTAS_ALUMNO` Int NOT NULL
);

-- Define las PFK de la entidad "Matricula Modulos".
ALTER TABLE `MATRICULAS_MODULOS` ADD PRIMARY KEY (`CODIGO_MODULO`, `NIA_ALUMNO`, `CODIGO_PROFESOR`, `CODIGO_MATRICULA`);

-- Define la PFK código de modulo como foreign key en la tabla.
ALTER TABLE `MATRICULAS_MODULOS` ADD CONSTRAINT `APARECE EN` FOREIGN KEY (`CODIGO_MODULO`) 
REFERENCES `MODULOS` (`CODIGO_MODULO`) ON DELETE CASCADE ON UPDATE CASCADE;

-- Define la PFK NIA de alumno como foreign key en la tabla.
ALTER TABLE `MATRICULAS_MODULOS` ADD CONSTRAINT `CURSA` FOREIGN KEY (`NIA_ALUMNO`) 
REFERENCES `ALUMNOS` (`NIA_ALUMNO`) ON DELETE CASCADE ON UPDATE CASCADE;

-- Define la PFK código de profesor
ALTER TABLE `MATRICULAS_MODULOS` ADD CONSTRAINT `IMPARTE` FOREIGN KEY (`CODIGO_PROFESOR`) 
REFERENCES `PROFESORES` (`CODIGO_PROFESOR`) ON DELETE CASCADE ON UPDATE CASCADE;

-- Creación de la tabla CATALOGO_MODULOS
CREATE TABLE `CATALOGO_MODULOS`(
  `CODIGO_CURSO` Char(4) NOT NULL,
  `CODIGO_MODULO` Char(4) NOT NULL
);

-- Define las primary keys de catalogo de modulos, siendo estas código de curso y 
-- código de modulo.
ALTER TABLE `CATALOGO_MODULOS` ADD PRIMARY KEY (`CODIGO_CURSO`, `CODIGO_MODULO`);

-- Define la foreign key 1 de catalogo de modulos, siendo esta código de curso.
ALTER TABLE `CATALOGO_MODULOS` ADD CONSTRAINT `DEFINE` FOREIGN KEY (`CODIGO_CURSO`) 
REFERENCES `CURSOS` (`CODIGO_CURSO`) ON DELETE CASCADE ON UPDATE CASCADE;

-- Define la foreign key 1 de catalogo de modulos, siendo esta código de modulo.
ALTER TABLE `CATALOGO_MODULOS` ADD CONSTRAINT `ESTA EN` FOREIGN KEY (`CODIGO_MODULO`) 
REFERENCES `MODULOS` (`CODIGO_MODULO`) ON DELETE CASCADE ON UPDATE CASCADE;

-- Tabla de calificaciones: Almacena las calificaciones de los alumnos por módulo, 
-- profesor y matrícula.
CREATE TABLE `CALIFICACIONES`
(
  `CODIGO_MODULO` Char(4) NOT NULL,
  `NIA_ALUMNO` Char(9) NOT NULL,
  `CODIGO_PROFESOR` Char(5) NOT NULL,
  `CODIGO_MATRICULA` Char(5) NOT NULL,
  `PRIMERA_EVALUACION` Int NOT NULL,
  `SEGUNDA_EVALUACION` Int NOT NULL,
  `ORDINARIA` Int NOT NULL,
  `EXTRAORDINARIA` Int
);

-- Define la primary key de la tabla de calificaciones, es compuesta, son 4 PFK.
ALTER TABLE `CALIFICACIONES` ADD PRIMARY KEY (`CODIGO_MODULO`, `NIA_ALUMNO`, `CODIGO_PROFESOR`, `CODIGO_MATRICULA`);

-- Relación que asegura que cada calificación se asocie con una matrícula válida.
ALTER TABLE `CALIFICACIONES` ADD CONSTRAINT `CALIFICA` 
FOREIGN KEY (`CODIGO_MODULO`, `NIA_ALUMNO`, `CODIGO_PROFESOR`, `CODIGO_MATRICULA`) 
REFERENCES `MATRICULAS_MODULOS` (`CODIGO_MODULO`, `NIA_ALUMNO`, `CODIGO_PROFESOR`, `CODIGO_MATRICULA`) 
ON DELETE CASCADE ON UPDATE CASCADE;