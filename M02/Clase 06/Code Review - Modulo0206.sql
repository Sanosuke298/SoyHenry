USE henry;
/*
DROP TABLE alumnos;
SELECT * FROM alumnos;
*/
SELECT * FROM alumno;
SELECT CURDATE();

SELECT * FROM cohorte;
SELECT * FROM instructor;
SELECT * FROM carrera;
SELECT * FROM alumno;

-- 2

SELECT * FROM cohorte
WHERE IdCohorte IN (1245,1246);

UPDATE cohorte
SET FechaInicio = null
WHERE IdCohorte IN (1245,1246);

DELETE FROM cohorte
WHERE IdCohorte IN (1245,1246);

-- 3 
SELECT * FROM cohorte WHERE IdCohorte = 1243;

SELECT DISTINCT(FechaIngreso)
FROM alumno
WHERE IdCohorte = 1243;

UPDATE cohorte
SET FechaInicio = '2022-05-16'
WHERE IdCohorte = 1243;

-- 4

select * 
from alumno
where IdAlumno = 165;
SELECT * 
FROM alumno
WHERE Nombre LIKE 'Regina'
;
UPDATE alumno
SET apellido = 'Ramirez'
WHERE IdAlumno = 165;

-- 5

SELECT IdAlumno, CedulaIdentidad AS DNI,
	CONCAT(nombre, ' ',apellido) AS 'Nombre y Apellido', 
    FechaNacimiento, FechaIngreso
FROM alumno
WHERE IdCohorte = 1243;
/*
SELECT a.IdAlumno, a.CedulaIdentidad AS DNI,
	CONCAT(a.nombre, ' ',a.apellido) AS 'Nombre y Apellido', 
    a.FechaNacimiento, a.FechaIngreso, c.FechaInicio AS 'Inicio de Cohorte'
FROM alumno a JOIN cohorte c
			ON (a.IdCohorte = c.IdCohorte AND a.IdCohorte = 1243);
*/

-- 6

SELECT * FROM carrera;
SELECT * FROM instructor;

SELECT * FROM cohorte;

SELECT IdInstructor
FROM cohorte
WHERE IdCarrera = 1;

SELECT *
FROM instructor
WHERE IdInstructor IN(1,1,1,1,2,2,3,4,5); -- between 1 and 5

-- Metodo de Joins
SELECT i.*, ca.Nombre
FROM cohorte c JOIN carrera ca ON(c.IdCarrera = ca.IdCarrera)
				JOIN instructor i ON (c.IdInstructor = i.IdInstructor)
WHERE c.IdCarrera = 1;

-- Metodo subconsulta

SELECT *
FROM instructor
WHERE IdInstructor IN (SELECT IdInstructor
							FROM cohorte
							WHERE IdCarrera = 1);

-- 7

SELECT IdAlumno, CONCAT(nombre,' ',apellido) AS 'Nombre y apellido',
		FechaIngreso, IdCohorte
FROM alumno
WHERE IdCohorte = 1235;

SELECT * FROM cohorte;

-- 8

SELECT YEAR(CURDATE()), MONTH(CURDATE()), DAY(CURDATE()), WEEKOFYEAR(CURDATE()), dayofyear(curdate());

SELECT IdAlumno, CONCAT(nombre,' ',apellido) AS 'Nombre y apellido',
		FechaIngreso, IdCohorte
FROM alumno
WHERE IdCohorte = 1235
AND FechaIngreso LIKE '2019%';

SELECT IdAlumno, CONCAT(nombre,' ',apellido) AS 'Nombre y apellido',
		FechaIngreso, IdCohorte
FROM alumno
WHERE IdCohorte = 1235
AND YEAR(FechaIngreso) = 2019;

SELECT IdAlumno, CONCAT(nombre,' ',apellido) AS 'Nombre y apellido',
		FechaIngreso, IdCohorte
FROM alumno
WHERE IdCohorte = 1235
AND FechaIngreso BETWEEN '2019-01-01' AND '2019-12-31';

SELECT IdAlumno, CONCAT_WS(' ',nombre,apellido) AS 'Nombre y apellido',
		FechaIngreso, IdCohorte
FROM alumno
WHERE IdCohorte = 1235
AND FechaIngreso BETWEEN '2019-01-01' AND '2019-12-31';
-- 9

SELECT alumno.nombre, alumno.apellido, alumno.fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON (alumno.idcohorte = cohorte.idCohorte)
INNER JOIN carrera
ON (cohorte.idcarrera = carrera.idCarrera);


/*
a) Tenemos que relacionar los IdCohorte a los que pertenecen los alumnos con los IdCohortes d e la tabla cohorte
	Relacionar el campo IdCarrera en cada cohorte con las Carreras existentes, los campos son IdCarrera y IdCohorte

b) Tenemos una relacion de 1:M, uno a muchos, cada alumno pertenece a una cohorte pero una cohorte tiene varios alumnos.

*/
-- c)
SELECT alumno.nombre, alumno.apellido, alumno.fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON (alumno.idcohorte = cohorte.idCohorte)
INNER JOIN carrera
ON (cohorte.idcarrera = carrera.idCarrera)
WHERE carrera.nombre LIKE 'Full Stack Developer';
-- Esta seria la manera correcta porque si tuviesemos una tercera carrera con el NOT LIKE tambien la traeria

SELECT alumno.nombre, alumno.apellido, alumno.fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON (alumno.idcohorte = cohorte.idCohorte)
INNER JOIN carrera
ON (cohorte.idcarrera = carrera.idCarrera)
WHERE carrera.nombre NOT LIKE 'Data Science' AND carrera.nombre NOT LIKE 'Ciber Seguridad';

-- d)

SELECT alumno.nombre, alumno.apellido, alumno.fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON (alumno.idcohorte = cohorte.idCohorte)
INNER JOIN carrera
ON (cohorte.idcarrera = carrera.idCarrera)
WHERE carrera.nombre = 'Full Stack Developer';
-- Esta seria la manera correcta porque si tuviesemos una tercera carrera con el != tambien la traeria

SELECT alumno.nombre, alumno.apellido, alumno.fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON (alumno.idcohorte = cohorte.idCohorte)
INNER JOIN carrera
ON (cohorte.idcarrera = carrera.idCarrera)
WHERE carrera.nombre != 'Data Science';

SELECT alumno.nombre, alumno.apellido, alumno.fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON (alumno.idcohorte = cohorte.idCohorte)
INNER JOIN carrera
ON (cohorte.idcarrera = carrera.idCarrera)
WHERE carrera.IdCarrera = 1;


-- LECTURE

SELECT Nombre, Apellido, FechaIngreso
FROM alumno
ORDER BY FechaIngreso ASC;

SELECT Nombre, Apellido, FechaIngreso
FROM alumno
ORDER BY FechaIngreso DESC;

SELECT Nombre, Apellido, FechaIngreso
FROM alumno
ORDER BY Apellido DESC;

SELECT Nombre, Apellido, FechaIngreso		-- 1, 2, 3
FROM alumno
ORDER BY 2 DESC;

SELECT Nombre, Apellido, FechaIngreso
FROM alumno
where apellido = 'Ramirez'
ORDER BY Apellido DESC;

SELECT Nombre, Apellido, FechaIngreso
FROM alumno
ORDER BY FechaIngreso DESC
LIMIT 2;

-- Cuales son los primeros alumnos que ingresaron a Henry?
SELECT Nombre, Apellido, FechaIngreso
FROM alumno
ORDER BY FechaIngreso ASC
LIMIT 2;

-- Cuantos alumnos hay en la cohorte 1235
SELECT COUNT(IdAlumno)
FROM alumno
WHERE IdCohorte = 1235;

SELECT COUNT(*)
FROM alumno;

SELECT SUM(IdAlumno)
FROM alumno
WHERE IdCohorte = 1235;

/*
SELECT SUM(Cantidad)
FROM producto
WHERE IdProducto = 12345
;
*/

-- IdAlumno promedio
SELECT SUM(IdAlumno) / COUNT(IdAlumno)
FROM alumno;

SELECT AVG(IdAlumno)
FROM alumno;


SELECT MIN(FechaIngreso)
FROM alumno;

SELECT MAX(FechaIngreso)
FROM alumno;

-- Error Code: 1140. In aggregated query without GROUP BY, expression #2 of SELECT list contains nonaggregated column 'henry.alumno.Nombre'; this is incompatible with sql_mode=only_full_group_by

SELECT MAX(FechaIngreso), Nombre
FROM alumno
GROUP BY IdAlumno
order by 1 DESC
LIMIT 1;


SELECT COUNT(IdAlumno)
FROM alumno
WHERE IdCohorte = 1235;

SELECT COUNT(IdAlumno), IdCohorte
FROM alumno
GROUP BY IdCohorte;

SELECT COUNT(IdAlumno), IdCohorte
FROM alumno
WHERE COUNT(IdAlumno) = 20
GROUP BY IdCohorte;
-- Error Code: 1111. Invalid use of group function

-- Cuales son las cohortes que tienen 20 alumnos
SELECT COUNT(IdAlumno), IdCohorte
FROM alumno
-- WHERE COUNT(IdAlumno) = 20
GROUP BY IdCohorte
HAVING COUNT(IdAlumno) = 20;

SELECT COUNT(IdAlumno), IdCohorte
FROM alumno
-- WHERE COUNT(IdAlumno) = 20
GROUP BY 2
HAVING COUNT(IdAlumno) = 20;

-- ORDEN DE SENTENCIAS

/*
SELECT campos, funciones, pedimos que va a mostrarse en pantalla
FROM ¿desde donde van a salir estos datos?
-- PASAN A SER OPCIONALES
WHERE aplicamos el filtrado para la consulta
GROUP BY Agrupamos los campos segun lo necesario
HAVING Establece filtros para los campos de GROUP BY, HAVING VA UNICAMENTE CUANDO HAY UN GROUP BY
ORDER BY Ordenamos segun un criterio ASC o DESC
LIMIT Limitamos la cantidad de registros
*/

/*
UPDATE tabla
SET campo/s a cambiar por el/los valor/es
WHERE filtrado
*/

/*
DELETE FROM tabla WHERE condicion de filtrado
*/

SELECT Nombre, Apellido, FechaIngreso
WHERE FechaIngreso LIKE '2019%'
FROM alumno
LIMIT 2
ORDER BY Apellido DESC;
-- Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'FROM alumno LIMIT 2 ORDER BY Apellido DESC' at line 3

select now();