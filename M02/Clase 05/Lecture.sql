-- LECTURE FT 17

CREATE DATABASE henry;
-- CTRL + ENTER

-- Indicarle a MySQL que base de datos quiero usar ;USE nombre
USE henry;

CREATE TABLE alumno (
	CedulaIdentidad VARCHAR(12),
    Nombre VARCHAR(25),
    Apellido VARCHAR(25),
    Fecha_Ingreso DATE,   -- TIPO DE DATO DATE: REPRESENTA FECHAS
    Fecha_Nacimiento DATE,
    PRIMARY KEY(CedulaIdentidad)
);

SELECT * FROM alumno;

-- Modificamos para añadir una columna

ALTER TABLE alumno DROP Fecha_Nacimiento;			-- ELIMINAR COLUMNAS
ALTER TABLE alumno ADD Direccion VARCHAR(80);		-- AÑADIR COLUMNAS

-- Eliminar un objeto

DROP TABLE alumno;
DROP DATABASE henry;
/*
USE henry_sql;

SELECT * FROM alumno;

CREATE VIEW Total_Alumnos AS
SELECT * FROM alumno;

SELECT * FROM total_alumnos;
*/

CREATE TABLE alumno (
	IdAlumno INT AUTO_INCREMENT,
	CedulaIdentidad VARCHAR(12),
    Nombre VARCHAR(25),
    Apellido VARCHAR(25),
    Fecha_Ingreso DATE,   -- TIPO DE DATO DATE: REPRESENTA FECHAS
    Fecha_Nacimiento DATE,
    PRIMARY KEY(IdAlumno)
);
# Comentar asi
