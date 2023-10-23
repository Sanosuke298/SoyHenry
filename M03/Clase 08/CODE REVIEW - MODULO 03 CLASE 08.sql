-- CR 8 FT17 M3

USE henry_m3;

-- Carga completa = Carga full
-- Carga delta = Carga incremental

-- 1) Crear una tabla que permita realizar el seguimiento de los usuarios que ingresan nuevos registros en fact_venta.

SELECT * FROM fact_venta; -- IdVenta Fecha Fecha_Entrega IdCanal IdCliente IdEmpleado IdProducto

DROP TABLE IF EXISTS fact_venta_auditoria;

CREATE TABLE IF NOT EXISTS fact_venta_auditoria (
	IdAuditoria_venta INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    IdVenta INT,
    Fecha DATE,
    Fecha_Entrega DATE,
    IdCanal INT,
    IdCliente INT,
    IdEmpleado INT,
    IdProducto INT,
    Precio DECIMAL(15,3),
    Cantidad INT,
    FechaAuditoria DATETIME,
    Usuario VARCHAR(30)
);

SELECT * FROM fact_venta_auditoria;


-- 2) Crear una acción que permita la carga de datos en la tabla anterior.

CREATE TRIGGER fact_venta_auditoria AFTER INSERT ON fact_venta
FOR EACH ROW
INSERT INTO fact_venta_auditoria (IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad, FechaAuditoria, Usuario)
VALUES (NEW.IdVenta, NEW.Fecha, NEW.Fecha_Entrega, NEW.IdCanal, NEW.IdCliente ,NEW.IdEmpleado, NEW.IdProducto, NEW.Precio, NEW.Cantidad, NOW(), CURRENT_USER())
;

TRUNCATE TABLE fact_venta;
TRUNCATE TABLE fact_venta_auditoria;
SELECT * FROM fact_venta;

INSERT INTO fact_venta (IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad)
SELECT IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
FROM venta
WHERE YEAR(Fecha) = 2020 AND outlier = 0;


SELECT  COUNT(IdCliente) FROM fact_venta_auditoria; -- 9061
SELECT COUNT(*) FROM fact_venta; -- 9061

SELECT * FROM venta;

-- 3) Crear una tabla que permita registrar la cantidad total registros, luego de cada ingreso la tabla fact_venta

CREATE TABLE IF NOT EXISTS fact_venta_registros (
	IdRegistros INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CantidadRegistros INT,
    Fecha DATETIME,
    Usuario VARCHAR(30)
);

SELECT * FROM fact_venta_Registros;

-- 4) Crear una acción que permita la carga de datos en la tabla anterior.
DROP TRIGGER fact_venta_registros;

CREATE TRIGGER fact_venta_registros AFTER INSERT ON fact_venta
FOR EACH ROW -- BEGIN
INSERT INTO fact_venta_registros (CantidadRegistros, Fecha, Usuario)
VALUES ((SELECT COUNT(*) FROM fact_venta), NOW(), CURRENT_USER());

select count(*) from fact_venta;

-- 6) Crear una tabla que permita realizar el seguimiento de la actualización de registros de la tabla fact_venta.

-- Actualizacion = Cuando cambiamos un registro o fila-> UPDATE
-- Insercion = Ingresamos un nuevo registro o fila -> INSERT
-- Eliminacion = Borramos un registro o fila -> DELETE
SELECT * FROM fact_venta;

CREATE TABLE IF NOT EXISTS fact_venta_cambios (
	IdCambio INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    IdVenta INT,
    Fecha DATE,
    Fecha_Entrega DATE,
    IdCanal INT,
    IdCliente INT,
    IdEmpleado INT,
    IdProducto INT,
    Precio DECIMAL (15,3),
    Cantidad INT,
    FechaCambio DATETIME,
    Usuario VARCHAR(30)
);

-- 7) Crear una acción que permita la carga de datos en la tabla anterior, para su actualización.

CREATE TRIGGER fact_venta_cambios AFTER UPDATE ON fact_venta
FOR EACH ROW
INSERT INTO fact_venta_cambios (IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad, FechaCambio, Usuario)
VALUES (OLD.IdVenta, OLD.Fecha, OLD.Fecha_Entrega, OLD.IdCanal, OLD.IdCliente, OLD.IdEmpleado, OLD.IdProducto, OLD.Precio, OLD.Cantidad, NOW(), CURRENT_USER());

SELECT * FROM fact_venta_cambios;

SELECT * FROM fact_venta;

UPDATE fact_venta 
SET Precio = 267
WHERE IdVenta = 82;

-- UNA VISTA DE PRECIOS VIEJOS Y NUEVOS PARA LOS CONTADORES O PARA EL AREA DE FINANZAS

SELECT v.Precio as Precio_Viejo, o.Precio as Precio_nuevo, v.IdVenta, v.FechaCambio, v.Usuario
FROM fact_venta o JOIN fact_venta_cambios v 
						ON (v.IdVenta = o.IdVenta);
                        
                        
-- CARGA INCREMENTAL

CREATE TABLE IF NOT EXISTS venta_novedades (
	IdVenta INT,
    Fecha DATE,
    Fecha_Entrega DATE,
    IdCanal INT,
    IdCliente INT,
    IdSucursal INT,
    IdEmpleado INT,
    IdProducto INT,
    Precio VARCHAR(30),
    Cantidad VARCHAR(30)
);


SELECT @@GLOBAL.secure_file_priv;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Venta_Actualizado.csv'
INTO TABLE venta_novedades
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES;

SELECT * FROM venta_novedades;
SELECT * FROM cliente;
drop table if exists cliente_novedades;
CREATE TABLE IF NOT EXISTS cliente_novedades (
	IdCliente INT,
    Provincia VARCHAR(80),
    Nombre_y_apellido VARCHAR(100),
    Domicilio VARCHAR(180),
    Telefono VARCHAR(30),
    Edad VARCHAR(5),
    Localidad VARCHAR(80),
    X VARCHAR(30),
    Y VARCHAR(30),
    Fecha_Alta DATE,
    Usuario_Alta VARCHAR(30),
    Fecha_Ultima_Modificacion DATE,
    Usuario_Ultima_Modificacion VARCHAR(30),
    Marca_Baja TINYINT,
    col10 VARCHAR(2)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Clientes_Actualizado.csv'
INTO TABLE cliente_novedades
FIELDS TERMINATED BY ';' ENCLOSED BY '\"' ESCAPED BY '\"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;


SELECT * FROM cliente_novedades; -- 3417

SELECT * FROM cliente; -- 3405

 -- CLIENTE
 
 ALTER TABLE cliente_novedades ADD Longitud DECIMAL(13,10) NOT NULL DEFAULT 0 AFTER Y,
								ADD Latitud DECIMAL(13,10) NOT NULL DEFAULT 0 AFTER Longitud;
                                
-- ALTER TABLE cliente_novedades DROP Latitud, DROP Longitud;

UPDATE cliente_novedades SET X = 0 WHERE X = '' OR X IS NULL;
UPDATE cliente_novedades SET Y = 0 WHERE Y = '' OR Y IS NULL;

UPDATE cliente_novedades SET Latitud = REPLACE(Y,',','.');
UPDATE cliente_novedades SET Longitud = REPLACE(x,',','.');

SELECT * FROM cliente_novedades;

ALTER TABLE cliente_novedades DROP X,
								DROP Y;

ALTER TABLE cliente_novedades DROP col10;

-- 'N/D'

UPDATE cliente_novedades SET Nombre_y_apellido = UC_WORDS(Nombre_y_apellido);
UPDATE cliente_novedades SET Domicilio = UC_WORDS(Domicilio);
UPDATE cliente_novedades SET Localidad = UC_WORDS(Localidad);

UPDATE cliente_novedades SET Nombre_y_apellido = 'N/D' WHERE Nombre_y_apellido = '' OR ISNULL(Nombre_y_apellido);
UPDATE cliente_novedades SET Provincia= 'N/D' WHERE Provincia = '' OR ISNULL(Provincia);
UPDATE cliente_novedades SET Telefono= 'N/D' WHERE Telefono= '' OR ISNULL(Telefono);
UPDATE cliente_novedades SET Localidad = 'N/D' WHERE Localidad= '' OR ISNULL(Localidad);
UPDATE cliente_novedades SET Domicilio = 'N/D' WHERE Domicilio = '' OR ISNULL(Domicilio);

ALTER TABLE cliente_novedades ADD IdLocalidad INT NOT NULL DEFAULT 0 AFTER Localidad;
select * from aux_localidad;

UPDATE cliente_novedades c JOIN aux_localidad a 
	ON (c.Provincia = a.Provincia_Original AND c.Localidad = a.Localidad_Original)
SET c.IdLocalidad = a.IdLocalidad;

SELECT * FROM cliente_novedades;
ALTER TABLE cliente_novedades DROP Provincia, DROP localidad;

ALTER TABLE cliente_novedades ADD Rango_Etario VARCHAR(30) NOT NULL DEFAULT '-' AFTER Edad;

select distinct rango_etario from cliente;
/*4_De 51 a 60 años
5_Desde 60 años
1_Hasta 30 años
2_De 31 a 40 años
3_De 41 a 50 años*/

UPDATE cliente_novedades SET Rango_Etario = '1_Hasta 30 años' WHERE Edad <= 30;
UPDATE cliente_novedades SET Rango_Etario = '2_De 31 a 40 años' WHERE Edad <= 40 AND Rango_Etario = '-';
UPDATE cliente_novedades SET Rango_Etario= '3_De 41 a 50 años' WHERE Edad <= 50 AND Rango_Etario = '-';
UPDATE cliente_novedades SET Rango_Etario = '4_De 51 a 60 años' WHERE Edad <= 60 AND Rango_Etario = '-';
UPDATE cliente_novedades SET Rango_Etario = '5_Desde 60 años' WHERE Edad > 60 AND Rango_Etario = '-';

SELECT DISTINCT Fecha_Ultima_Modificacion FROM cliente_novedades;
-- USE henry_m3;

SELECT c.*, cn.*
FROM cliente c, cliente_novedades cn
WHERE c.IdCliente = cn.IdCliente
AND (c.Nombre_y_apellido <> cn.Nombre_y_apellido OR
	c.Domicilio <> cn.Domicilio OR
    c.Telefono <> cn.Telefono OR
    c.Edad <> cn.Edad OR
    c.Rango_Etario <> cn.Rango_Etario OR
    c.IdLocalidad <> cn.IdLocalidad OR
    c.Longitud <> cn.Longitud OR
    c.Latitud <> cn.Latitud OR
    c.Fecha_Alta <> cn.Fecha_Alta OR
    c.Usuario_Alta <> cn.Usuario_Alta OR
    c.Fecha_Ultima_Modificacion <> cn.Fecha_Ultima_Modificacion OR
    c.usuario_Ultima_Modificacion <> cn.Usuario_Ultima_Modificacion OR
    c.Marca_baja <> cn.Marca_baja)
;

UPDATE cliente c JOIN cliente_novedades cn
					ON (c.IdCliente = cn.IdCliente)
SET c.Nombre_y_apellido = cn.Nombre_y_apellido,
	c.Domicilio = cn.Domicilio,
    c.Telefono = cn.Telefono,
    c.Edad = cn.Edad,
    c.Rango_Etario = cn.Rango_etario,
    c.IdLocalidad = cn.IdLocalidad,
    c.Longitud = cn.Longitud,
    c.Latitud = cn.Latitud,
    c.Fecha_Alta = cn.Fecha_Alta,
    c.Usuario_Alta = cn.Usuario_Alta,
    c.Fecha_Ultima_Modificacion = cn.Fecha_ultima_modificacion,
	c.Usuario_Ultima_Modificacion = cn.Usuario_Ultima_Modificacion,
    c.Marca_Baja = cn.Marca_Baja
WHERE c.IdCliente = cn.IdCliente
AND (c.Nombre_y_apellido <> cn.Nombre_y_apellido OR
	c.Domicilio <> cn.Domicilio OR
    c.Telefono <> cn.Telefono OR
    c.Edad <> cn.Edad OR
    c.Rango_Etario <> cn.Rango_Etario OR
    c.IdLocalidad <> cn.IdLocalidad OR
    c.Longitud <> cn.Longitud OR
    c.Latitud <> cn.Latitud OR
    c.Fecha_Alta <> cn.Fecha_Alta OR
    c.Usuario_Alta <> cn.Usuario_Alta OR
    c.Fecha_Ultima_Modificacion <> cn.Fecha_Ultima_Modificacion OR
    c.usuario_Ultima_Modificacion <> cn.Usuario_Ultima_Modificacion OR
    c.Marca_baja <> cn.Marca_baja);
    
SELECT * FROM cliente;
-- Eliminamos los registros que ya existian en clientes
DELETE FROM cliente_novedades WHERE IdCliente IN (SELECT DISTINCT IdCliente FROM cliente);

SELECT * FROM cliente_novedades;

-- Sumar los nuevos clientes, son 12

INSERT INTO cliente (IdCliente, Nombre_y_apellido, Domicilio, Telefono, Edad, Rango_Etario, IdLocalidad,Longitud, Latitud, Fecha_Alta, Usuario_Alta, Fecha_Ultima_Modificacion, Usuario_Ultima_Modificacion, Marca_baja)
SELECT IdCliente, Nombre_y_apellido, Domicilio, Telefono, Edad, Rango_Etario, IdLocalidad,Longitud, Latitud, Fecha_Alta, Usuario_Alta, Fecha_Ultima_Modificacion, Usuario_Ultima_Modificacion, Marca_baja
FROM cliente_novedades;

-- VENTA

select * from venta_novedades;
-- ELIMINAMOS LAS VENTAS YA EXISTENTES EN LA TABLA VENTA
DELETE FROM venta_novedades WHERE IdVenta IN (SELECT DISTINCT IdVenta FROM venta);

UPDATE venta_novedades SET Precio = 0 WHERE Precio = '' ;

UPDATE venta_novedades v JOIN producto p
							ON (v.IdProducto = p.IdProducto)
SET v.Precio = p.Precio
WHERE v.precio = 0;

UPDATE venta_novedades SET cantidad = 0 WHERE cantidad = '' ;

ALTER TABLE venta_novedades CHANGE cantidad cantidad INT NOT NULL DEFAULT 1;
ALTER TABLE venta_novedades CHANGE Precio Precio DECIMAL(15,3) NOT NULL DEFAULT 0;

ALTER TABLE venta_novedades ADD Outlier INT NOT NULL DEFAULT 0 AFTER Cantidad;

SELECT * FROM aux_venta;

INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEMpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 3 		-- OUTLIERS DE PRECIO
FROM venta_novedades v 
JOIN (SELECT IdProducto, AVG(Precio) as Media, STDDEV(Precio) as Desv FROM venta_novedades GROUP BY IdProducto) v2
			ON(v.IdProducto = v2.IdProducto )
WHERE v.Precio > (v2.Media + 3*v2.Desv) OR v.Precio < (v2.Media - 3*v2.Desv);

INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEMpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 2 		-- OUTLIERS DE CANTIDAD
FROM venta_novedades v 
JOIN (SELECT IdProducto, AVG(Cantidad) as Media, STDDEV(Cantidad) as Desv FROM venta_novedades GROUP BY IdProducto) v2
			ON(v.IdProducto = v2.IdProducto )
WHERE v.Cantidad > (v2.Media + 3*v2.Desv) OR v.Cantidad < (v2.Media - 3*v2.Desv);

UPDATE venta_novedades v JOIN aux_venta a 
							ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
SET v.Outlier = 1 ;

SELECT * FROM venta
ORDER BY Fecha DESC; -- FK IdEmpleado
SELECT * FROM venta_novedades;
SELECT * FROM empleado; -- PK IdEmpleado

INSERT INTO venta (IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Outlier)
SELECT IdVenta, Fecha, Fecha_Entrega, IdCanal, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Outlier
FROM venta_novedades;
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`henry_m3`.`venta`, CONSTRAINT `venta_fk_empleado` FOREIGN KEY (`IdEmpleado`) REFERENCES `empleado` (`IdEmpleado`) ON DELETE RESTRICT ON UPDATE RESTRICT)

UPDATE venta_novedades 
SET IdEmpleado = (IdSucursal * 1000000) + IdEmpleado;

DELETE FROM venta_novedades WHERE IdVenta IN (SELECT IdVenta FROM venta);






 -- REPASO
 
 
 /*
 Funcion MARGENBRUTO -> Margen Precio
 Retorna precio * margen
 
 SIGNOS DEL DELIMITER $$ && // 
 */
 
 
 DELIMITER &&
 
 CREATE FUNCTION margenBruto (precio DECIMAL(15,3), margen DECIMAL(9,3)) RETURNS DECIMAL(15,3)
 BEGIN
	DECLARE margenBruto DECIMAL(15,3);
    
    SET margenBruto = precio * margen;
    
    RETURN margenBruto;
 END &&
 
 DELIMITER ;
 
 DROP FUNCTION margenBruto;
 
 SELECT Precio, margenBruto(Precio, 1.20) as Margen
 FROM venta;
 
 -- Funcion Ventana
 
 SELECT IdVenta,fecha, precio * cantidad as Venta,
		AVG(precio * cantidad) OVER (PARTITION BY Fecha ) as Promedio_venta
FROM venta;

SELECT * FROM aux_venta;


/*

VENTA
CLIENTE
CANAL_VENTA
SUCURSAL
PRODUCTO

*/

SELECT * FROM venta;

SELECT * FROM venta
WHERE IdCliente = 969;

SELECT * FROM venta
WHERE Precio = 813.120;

/*
for item in venta:
	if precio == 813.20:
		print(linea)
*/
SELECT * FROM producto;
SELECT * FROM venta;


SELECT format(SUM(v.Precio * v.Cantidad),2,'es_ES') AS Ventas, p.IdProducto, p.Nombre
FROM producto p LEFT JOIN venta v
				 ON(p.IdProducto = v.IdProducto)

GROUP BY 2
;

-- 1000000.00
-- 1.000.000,00

 -- REGLA DE LAS TRES SIGMAS
 
SELECT v.*, o.Promedio, o.Maximo, o.Minimo
FROM venta v
JOIN (SELECT IdProducto, ROUND(AVG(Cantidad),2) as Promedio,  ROUND(AVG(Cantidad) - (3 * stddev(Cantidad)),2) as Minimo,
													 ROUND(AVG(cANTIDAD) + (3 * stddev(Cantidad)),2) as Maximo
											FROM venta
											GROUP BY IdProducto) as o  -- Error Code: 1248. Every derived table must have its own alias

 ON (v.IdProducto = o.IdProducto)
 WHERE v.Cantidad > o.Maximo OR v.Cantidad < o.Minimo;

