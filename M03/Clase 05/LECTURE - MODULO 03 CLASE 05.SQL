-- LECTURE

SELECT COUNT(Id_Empleado), Id_Empleado
FROM empleado
GROUP BY Id_Empleado; -- 1968 1674

SELECT *
 FROM empleado
 WHERE Id_Empleado IN (1968,1674);
 
 select * from sucursal;
 
 SELECT * FROM venta;		-- TABLA DE HECHOS
 SELECT * FROM producto;    -- TABLA DE DIMENSIONES
 
 SELECT * FROM cliente;
 USE henry_m3;
 
 -- 10 PT1 
CREATE TABLE IF NOT EXISTS cargo (
	IdCargo INT NOT NULL AUTO_INCREMENT,
    Cargo VARCHAR(50),
    PRIMARY KEY(IdCargo)
);

INSERT INTO cargo (Cargo)
SELECT DISTINCT cargo FROM empleado
ORDER BY Cargo;

SELECT * FROM cargo;

ALTER TABLE empleado ADD IdCargo INT DEFAULT 0 AFTER Cargo;

SELECT * FROM empleado;

UPDATE empleado e JOIN cargo g
						ON (g.Cargo = e.Cargo)
SET e.IdCargo = g.IdCargo;

ALTER TABLE empleado DROP Cargo;
-- 
SELECT * FROM venta;