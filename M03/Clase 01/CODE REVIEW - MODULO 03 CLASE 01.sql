-- CR 1 FT17 M3

USE adventureworks;

-- 1) Crear un procedimiento que recibe como parámetro una fecha y muestre la cantidad de órdenes ingresadas en esa fecha.

SELECT * FROM salesorderheader;

SELECT COUNT(*)
FROM salesorderheader
;
/*
DROP PROCEDURE totalOrdenes;
DROP PROCEDURE IF EXISTS totalOrdenes;
CREATE TABLE IF NOT EXISTS salesorderheader;
*/
DROP PROCEDURE IF EXISTS totalOrdenes;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS totalOrdenes(IN fecha DATE)
BEGIN
	SELECT COUNT(*)
    FROM salesorderheader
    WHERE OrderDate = fecha;
END $$

DELIMITER ;

CALL totalOrdenes('2003-09-20');
CALL totalOrdenes('2002-9-22');
CALL totalOrdenes('2003-09-22');


-- 2) Crear una función que calcule el valor nominal de un margen bruto determinado por el usuario a partir del precio de lista de los productos.

SET GLOBAL log_bin_trust_function_creators = 1;

SHOW VARIABLES LIKE 'log_bin_trust_function_creators';

DELIMITER $$

CREATE FUNCTION IF NOT EXISTS margenBruto (precio DECIMAL(10,2), margen DECIMAL(10,2)) RETURNS DECIMAL(15,3)
BEGIN
	DECLARE margenBruto DECIMAL(15,3);
    
    SET margenBruto = precio * margen;
    
    RETURN margenBruto;
END $$

DELIMITER ; 
-- Error Code: 1418. This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration and binary logging is enabled (you *might* want to use the less safe log_bin_trust_function_creators variable)

SELECT margenBruto(100,1.5);

-- 3)

SELECT * FROM product;

SELECT ProductID, Name, margenBruto(StandardCost,1.2) as 'Precio con Margen del 20%', StandardCost, ListPrice,
						ROUND((ListPrice - margenBruto(StandardCost,1.2)),2) as 'Diferencia'
FROM product
WHERE ListPrice > 0 AND StandardCost > 0
ORDER BY Name ASC;

-- 4)

SELECT CustomerId, SUM(Freight) as TotalTransporte
FROM salesorderheader
WHERE	OrderDate BETWEEN '2002-01-01' AND '2002-12-31'					 -- OrderDate <='2002-01-01' AND orderDare >= '2002-12-31'
GROUP BY CustomerId
ORDER BY TotalTransporte DESC
LIMIT 10;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS gastoTransporte (IN FechaDesde DATE,IN FechaHasta DATE )
BEGIN
	SELECT CustomerId, SUM(Freight) AS TotalTransporte
    FROM salesorderheader 
    WHERE OrderDate BETWEEN FechaDesde AND FechaHasta
    GROUP BY CustomerId
    ORDER BY TotalTransporte DESC
    LIMIT 10;
END $$

DELIMITER ; 

CALL gastoTransporte('2002-01-01','2003-01-01');
CALL gastoTransporte('2003-01-01','2003-12-31');

-- 5) 

SELECT * FROM shipmethod;
SELECT NOW();
-- INSERT INTO shipmethod (Name, ShipBase, ShipRate, ModifiedDate)

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS cargaShipMethod(IN Nombre VARCHAR(50), IN ShipBase DOUBLE, IN ShipRate DOUBLE)
BEGIN
	INSERT INTO shipmethod (Name, ShipBase, ShipRate, ModifiedDate)
    VALUES (Nombre, ShipBase, ShipRate, NOW());
END $$

DELIMITER ;

SELECT * FROM shipmethod;

CALL cargaShipMethod('Prueba',8.75,1.25);