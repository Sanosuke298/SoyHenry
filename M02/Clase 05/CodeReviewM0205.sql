CREATE DATABASE henry;
USE henry;

CREATE TABLE carrera (
	IdCarrera INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(40),
    PRIMARY KEY(IdCarrera)
);

-- Error Code: 1075. Incorrect table definition; there can be only one auto column and it must be defined as a key

-- DROP TABLE carrera;

CREATE TABLE instructor (
	IdInstructor INT NOT NULL AUTO_INCREMENT,
    CedulaIdentidad VARCHAR(25) NOT NULL,
    Nombre VARCHAR(30) NOT NULL,
    Apellido VARCHAR(30) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    FechaIncorporacion DATE,
    PRIMARY KEY(IdInstructor)
);



CREATE TABLE cohorte (
	IdCohorte INT NOT NULL AUTO_INCREMENT,		-- Lo que hace esta funcion es poner automaticamente los numeros a los registros
    Codigo VARCHAR(30) NOT NULL,
    IdCarrera INT NOT NULL,
    FechaInicio DATE,
    FechaFinalizacion DATE,
    IdInstructor INT NOT NULL,
    PRIMARY KEY(IdCohorte),
    FOREIGN KEY(IdCarrera) REFERENCES carrera(IdCarrera),
    FOREIGN KEY(IdInstructor) REFERENCES instructor(IdInstructor)
);

CREATE TABLE alumno (
	IdAlumno INT NOT NULL AUTO_INCREMENT,
    CedulaIdentidad VARCHAR(30) NOT NULL,
    Nombre VARCHAR(40) NOT NULL,
    Apellido VARCHAR(40) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    FechaIngreso DATE NOT NULL,
    IdCohorte INT NOT NULL,
    PRIMARY KEY(IdAlumno),
    FOREIGN KEY (IdCohorte) REFERENCES cohorte(IdCohorte)
);

SELECT * FROM alumno;
SELECT * FROM carrera;
SELECT * FROM cohorte;
SELECT * FROM instructor;

/*
forma de crear foreign keys despues de inicializar las tablas
ALTER TABLE alumno ADD CONSTRAINT alumno_fk_cohorte FOREIGN KEY(IdCohorte) REFERENCES cohorte(IdCohorte) ON DELETE RESTRICT ON UPDATE RESTRICT;
*/


/*
-- Cuantos alumnos pertenecen a la cohorte 123?
SELECT COUNT(IdAlumno), IdCohorte
FROM alumnos
WHERE IdCohorte = 123
GROUP BY IdCohorte;
*/

CREATE TABLE IF NOT EXISTS alumnos (
	IdAlumno INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(40) NOT NULL,
    Apellido VARCHAR(40) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Ciudad VARCHAR(50) NOT NULL,
    Pais VARCHAR(50) NOT NULL,
    CedulaIdentidad VARCHAR(80) NOT NULL,
    PRIMARY KEY(IdAlumno)
);

ALTER TABLE instructores RENAME TO instructor; -- MODIFICAR NOMBRE DE TABLAS
ALTER TABLE alumnos CHANGE Ciudades Ciudad VARCHAR(50) NOT NULL ; -- MODIFICAR NOMBRES DE COLUMNAS
ALTER TABLE alumnos ADD IdCohorte INT NOT NULL;-- CREACION DE COLUMNAS
ALTER TABLE alumnos DROP IdCohorte; -- ELIMINAR COLUMNAS

-- LECTURE

-- Insertar datos

INSERT INTO alumnos (nombre, apellido, fechaNacimiento, ciudad, pais, cedulaIdentidad)
VALUES ('Maria','Becerra','2000-04-01', 'Rosario','Argentina',38547612);
SELECT * FROM alumnos;
INSERT INTO alumnos (nombre, apellido, fechaNacimiento, ciudad, pais, cedulaIdentidad)
VALUES ('El','Duki','1998-09-08','Santa Fe','Colombia','39876541');

-- Opcion 2:
INSERT INTO alumnos (nombre, apellido, fechaNacimiento, ciudad, pais, cedulaIdentidad)
VALUES ('Jeronimo','Gonzalez','1988-08-09','Cordoba','Argentina',33687456),
		('Ricardo','Lorenzo','1975-02-10','La Paz','Bolivia',20856147),
		('Carlos','Rey','1985-06-11','Montevideo','Uruguay',25478396);

SELECT * FROM alumnos;

INSERT INTO alumnos (nombre, apellido, fechaNacimiento, ciudad, pais, cedulaIdentidad)
VALUES ('Carlos','Principe','1985-06-11','Montevideo','Uruguay', '');

/*
UPDATE alumnos 
SET CedulaIdentidad = '25478397'
WHERE IdAlumno = 6;
*/

-- Opcion 3:
INSERT INTO alumnos 
VALUES ('Ernesto','Corvalan','1997-1-13','Ciudad de Mexico','Mexico',37854698);
-- Error Code: 1136. Column count doesn't match value count at row 1

INSERT INTO alumnos 
VALUES (7,'Ernesto','Corvalan','1997-1-13','Ciudad de Mexico','Mexico',37854698),
		(8,'Roberto','Carlos','1997-1-13','Caleta Olivia','Argentina',37589145),
        (9,'Luis','Rodriguez','1976-03-14','Santiago de Chile','Chile', 2089636963),
        (10,'Hernan','Crespo','199-09-15','Medellin','Colombia','39851247');

SELECT * FROM alumnos;

-- Modificar datos: 

UPDATE alumnos
SET nombre = 'Mauro'
; -- SIN EL WHERE O FILTRADO ES UN DESASTRE

UPDATE alumnos 
SET CedulaIdentidad = '25478397'
WHERE IdAlumno = 6;
SELECT * FROM alumnos;

UPDATE alumnos
SET nombre = 'Pablo'
WHERE IdAlumno = 4;

-- TRUNCATE TABLE alumnos;

-- Opcion 2:

UPDATE alumnos
SET nombre = 'Mauro', apellido='Lombardo'
WHERE cedulaIdentidad = '39876541';

SELECT * FROM alumnos;

-- Eliminar datos:

DELETE FROM alumnos WHERE IdAlumno = 6;
DELETE FROM alumnos WHERE IdAlumno > 10 AND Nombre = 'Maria';

DELETE FROM alumnos;
TRUNCATE TABLE alumnos;
-- ROLLBACK;
-- ALTER TABLE instructor DROP FechaNacimiento;  Para eliminar una columna

-- Consultar los datos: 

/* SELECT campos, columnas, funciones
FROM de que tabla salen estos campos
WHERE condicion de filtrado, no es olbigatorio
*/

SELECT IdAlumno, Nombre, Apellido
FROM alumnos;

SELECT IdAlumno, Nombre, Apellido, FechaNacimiento Ciudad, Pais, Cedulaidentidad
FROM alumnos;

SELECT * 
FROM alumnos;

SELECT IdAlumno, Nombre
FROM alumnos
WHERE Pais = 'Uruguay';

SELECT * 
FROM alumnos 
WHERE IdAlumno >= 5;

-- Operadores aritmeticos:

SELECT Nombre + Apellido
FROM alumnos;

/*
SELECT nombreProducto, subtotal + impuestos
FROM productos;

SELECT nombreProducto, precio * cantidad
FROM venta;
*/

-- Operadores relacionales:
SELECT *
FROM alumnos
WHERE IdAlumno = 2;

SELECT * 
FROM alumnos
WHERE IdAlumno != 2;
SELECT * 
FROM alumnos
WHERE IdAlumno <> 2;

SELECT *
FROM alumnos
WHERE FechaNacimiento > '2000-01-01';
SELECT *
FROM alumnos
WHERE FechaNacimiento < '2000-01-01';

SELECT * FROM alumnos
WHERE FechaNacimiento BETWEEN '1997-01-01' AND '2000-01-01';

SELECT * FROM alumnos
WHERE IdAlumno BETWEEN 5 AND 10;

SELECT * FROM alumnos
WHERE Nombre = 'Luis';

SELECT * FROM alumnos
WHERE Nombre LIKE 'M%';

SELECT  * FROM alumnos
WHERE Nombre LIKE '%os';

SELECT * FROM alumnos
WHERE Nombre LIKE '%ui%';

SELECT * FROM alumnos
WHERE FechaNacimiento LIKE '%2000-01-01%';


SELECT * FROM alumnos
WHERE Nombre IN ('Maria','Carlos','Ernesto');


SELECT * FROM alumnos
WHERE Pais = 'Uruguay' AND Ciudad = 'Montevideo';

SELECT * FROM alumnos
WHERE Pais = 'Chile' OR Pais = 'Argentina';

SELECT * FROM alumnos
WHERE Pais NOT LIKE 'Argentina';

