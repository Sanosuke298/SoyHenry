-- CR 7 FT 17 

USE henry;

-- 1 

SELECT * FROM carrera;
SELECT COUNT(IdCarrera)
FROM carrera;

-- 2

SELECT * FROM alumno;

SELECT COUNT(IdAlumno)
FROM alumno;

-- 3
-- Error Code: 1140. In aggregated query without GROUP BY, expression #2 of SELECT list contains nonaggregated column 'henry.alumno.IdCohorte'; this is incompatible with sql_mode=only_full_group_by

SELECT COUNT(IdAlumno) as 'Total Alumnos', IdCohorte
FROM alumno
GROUP BY IdCohorte; -- 2

-- 4

SELECT CONCAT(nombre, ' ',apellido) 'Nombre Apellido', FechaIngreso
FROM alumno
ORDER BY FechaIngreso DESC;

-- 5

SELECT nombre
FROM alumno;

SELECT CONCAT(nombre, ' ',apellido) 'Nombre Apellido', FechaIngreso
FROM alumno
ORDER BY FechaIngreso ASC
LIMIT 1;

SELECT CONCAT(nombre, ' ',apellido) 'Nombre Apellido', FechaIngreso
FROM alumno
WHERE IdAlumno = 1;

SELECT MIN(FechaIngreso) FROM alumno;

SELECT CONCAT(nombre, ' ',apellido) 'Nombre Apellido', FechaIngreso
FROM alumno
WHERE FechaIngreso = '2022-01-18';

-- M3 PROFUNDIZAMOS
SELECT CONCAT(nombre, ' ',apellido) 'Nombre Apellido', FechaIngreso
FROM alumno
WHERE FechaIngreso = (SELECT MIN(FechaIngreso) FROM alumno);


-- 6
SELECT MIN(FechaIngreso) FROM alumno;

-- 7

SELECT CONCAT(Nombre, ' ',apellido) 'Nombre Apellido',FechaIngreso
FROM alumno
ORDER BY FechaIngreso DESC
LIMIT 1;

-- 8

select curdate();
SELECT YEAR(CURDATE());

SELECT COUNT(IdAlumno), YEAR(FechaIngreso) as Año_de_ingreso
FROM alumno
GROUP BY Año_de_ingreso;


-- 9

SELECT WEEKOFYEAR(curdate());

SELECT WEEKOFYEAR(FechaIngreso) Semana, YEAR(FechaIngreso) Año, COUNT(IdAlumno) Cantidad
FROM alumno
GROUP BY Año, Semana
ORDER BY Semana;

SELECT *
FROM alumno
WHERE YEAR(FechaIngreso) = 2019;
SELECT WEEKOFYEAR('2019-12-04');
SELECT * FROM alumno
WHERE weekofyear(FechaIngreso) = 1;

-- 10

SELECT COUNT(IdAlumno), YEAR(FechaIngreso) AÑO 
FROM alumno
GROUP BY YEAR(FechaIngreso)
HAVING COUNT(IdAlumno) > 20;

SELECT COUNT(IdAlumno), YEAR(FechaIngreso) AÑO
FROM alumno
WHERE YEAR(FechaIngreso) > 2019
GROUP BY YEAR(FechaIngreso);

 
-- 11

SELECT * FROM instructor;

SELECT TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()) Edad, Nombre, Apellido
FROM instructor;
SELECT YEAR(FechaNacimiento) Año, Nombre, Apellido
FROM instructor;

SELECT * FROM instructor;

SELECT CONCAT(Nombre,' ',apellido) 'Nombre y apellido', TIMESTAMPDIFF(YEAR,FechaNacimiento,CURDATE()) Edad,
		DATE_ADD(FechaNacimiento, INTERVAL (TIMESTAMPDIFF(YEAR,FechaNacimiento,CURDATE())) YEAR) Verifica
FROM instructor;

-- 12

-- Calculamos la edad para cada alumno
SELECT CONCAT(Nombre, ' ', apellido) 'Nombre Apellido', TIMESTAMPDIFF(YEAR,FechaNacimiento, CURDATE()) Edad
FROM alumno;

/*
UPDATE alumno
SET Nombre = 'Conde', apellido = 'Dracula'
WHERE IdAlumno = 127;
*/

SELECT SUM(TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE())), COUNT(IdAlumno)
FROM alumno;

-- Calculamos el promedio a mano Suma / Cantidad
SELECT (SUM(TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()))/ COUNT(IdAlumno)) AS Promedio_Edad
FROM alumno;

-- Calculamos el valor promedio utilizando AVG
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE())),0) AS Promedio_Edad
FROM alumno;

SELECT CURDATE(); -- CURRENT DATE - FECHA DE HOY

-- Obtenemos el valor promedio de la edad de los alumnos, agrupado por cohorte
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE())),0) AS Promedio_Edad, IdCohorte
FROM alumno
GROUP BY IdCohorte;

-- 13
-- Obtenemos el valor promedio para la edad
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE())),0) AS Promedio_Edad
FROM alumno; -- 33

-- Utilizamos ese valor para comparar los alumnos que tengan una edad mayor
SELECT * 
FROM alumno
WHERE TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()) >= 33;

-- M3 PROFUNDIZAREMOS

-- Se puede resolver con subconsultas de esta forma, anidando la consulta donde obtenermos Pormedio Edad
SELECT *, TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()) AS Edad
FROM alumno
WHERE TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()) >= (
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE())),0) AS Promedio_Edad
FROM alumno)
;

USE henry_2;

SELECT * FROM colesterol;


-- PYMYSQL

USE henry_2;
USE adventureworks;
USE bd_ventas;
USE HENRY;

SELECT * FROM alumno;

SELECT * FROM colesterol;