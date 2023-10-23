-- ## 6) ¿Cuál es el id del Producto cuyo nombre es EPSON COPYFAX 2000? 
SELECT IDProducto
FROM checkpoint_m21.producto
WHERE concepto = 'EPSON COPYFAX 2000';
-- Rta: 42737

-- ## 7) ¿Cuál es el canal de ventas con menor cantidad de ventas registradas?
SELECT cv.Canal, SUM(st.Cantidad) AS VentasTotales
FROM checkpoint_m21.venta st
JOIN checkpoint_m21.canal_venta cv ON st.IdCanal = cv.IdCanal
GROUP BY cv.Canal
ORDER BY VentasTotales ASC
LIMIT 1;
-- Rta: Telefónica, tiene 23219

-- ## 7) ¿Cuál es el canal de ventas con menor ventas registradas?
SELECT cv.Canal, SUM(st.Cantidad * st.Precio) AS VentasTotales
FROM checkpoint_m21.venta st
JOIN checkpoint_m21.canal_venta cv ON st.IdCanal = cv.IdCanal
GROUP BY cv.Canal
ORDER BY VentasTotales ASC;


-- 8) Cual fue el mes con mayor venta de la sucursal 13 para el año 2015 ?
SELECT 
    MONTH(Fecha) AS MesVenta,
    SUM(Precio * Cantidad) AS GananciaTotal
FROM checkpoint_m2.venta
WHERE YEAR(Fecha) = 2015 AND IdSucursal = 13
GROUP BY MesVenta
ORDER BY GananciaTotal asc;

-- 3 Marzo es el mes con la mayor venta de la sucursal 13 del año 2015

-- 9) Se define el tiempo de entrega como el tiempo en días transcurrido entre que se realiza la compra y se efectua la entrega.
-- Par analizar mejoras en el servicio, la dirección desea saber: cuál es el año con el promedio más alto de este tiempo de entrega.
-- (Fecha = Fecha de venta; Fecha_Entrega = Fecha de entrega)

SELECT YEAR (Fecha_Entrega) AS AnoVenta,
       AVG(DATEDIFF(Fecha_Entrega, Fecha)) AS promedio_entrega
FROM checkpoint_m21.venta
GROUP BY AnoVenta
ORDER BY promedio_entrega DESC
LIMIT 1;

SELECT YEAR(Fecha) AS AnoVenta,
       AVG(DATEDIFF(Fecha_Entrega, Fecha)) AS promedio_entrega
FROM checkpoint_m21.venta
GROUP BY AnoVenta
ORDER BY promedio_entrega DESC;

-- Rta: 2020 con 5.0864 o 5.0760 es el año con el promedio de entrega más alto

## 10) La dirección desea saber que tipo de producto tiene la mayor venta en 2020 (Tabla 'producto', campo Tipo = Tipo de producto)
#### Pista: acordate de las funciones de agregacion AVG/SUM/MIN/MAX
SELECT p.Tipo, SUM(v.Cantidad * v.Precio) AS GananciaTotal
FROM checkpoint_m2.venta v
JOIN checkpoint_m2.producto p ON v.IdProducto = p.IdProducto
WHERE YEAR(v.Fecha) = 2020
GROUP BY p.Tipo
ORDER BY GananciaTotal DESC
LIMIT 1;

-- INFORMATICA 15415353.58 es el tipo de producto con la mayor venta en 2020

## 10) La dirección desea saber que tipo de producto tiene la segunda mayor venta en 2015 (Tabla 'producto', campo Tipo = Tipo de producto)
#### Pista: acordate de las funciones de agregacion AVG/SUM/MIN/MAX
SELECT p.Tipo, SUM(v.Cantidad * v.Precio) AS GananciaTotal
FROM checkpoint_m21.venta v
JOIN checkpoint_m21.producto p ON v.IdProducto = p.IdProducto
WHERE YEAR(v.Fecha) = 2015
GROUP BY p.Tipo
ORDER BY GananciaTotal DESC;


## 11) ¿Cuál es el año y mes con la mayor cantidad de productos vendidos?
#### Informar la respuesta con 4 digitos para el año y 2 para el mes
#### Por ejemplo 201506 seria Junio 2015
#### Pista para agrupar por mes podes usar el   DATE_FORMAT( date,'%Y%m') --> YYYYMM o  DATE_FORMAT( date,'%m') --> MM 

SELECT DATE_FORMAT(Fecha, '%Y%m') AS AnoMes, SUM(Cantidad) AS CantidadTotal
FROM checkpoint_m2.venta
GROUP BY AnoMes
ORDER BY CantidadTotal DESC
LIMIT 1;

-- 202009 con 2148 es la fecha con mayor cantidad de productos vendidos

## 12) ¿Cuantos productos tienen la palabra DVD en alguna parte de su nombre/concepto? 
SELECT COUNT(*)
FROM checkpoint_m2.producto
WHERE Concepto LIKE '%DVD%';

-- 11 productos tienen la palabra DVD

## 13) ¿Cual de estos tipos de producto, tiene la menor diferencia de precio entre sus minimos y maximos?
##   1- GABINETES	  
##   2- GAMING	  
##   3- IMPRESIÓN	 

SELECT Tipo,
       MIN(Precio) AS MinPrice,
       MAX(Precio) AS MaxPrice,
       MAX(Precio) - MIN(Precio) AS PriceDifference
FROM checkpoint_m2.producto
WHERE Tipo IN ('GABINETES', 'GAMING', 'IMPRESIÓN')
GROUP BY Tipo
ORDER BY PriceDifference ASC
LIMIT 1;

-- Gaming con 46 de diferencia entre su mínimo 1542 y máximo 1588


## 14) Teniendo en cuenta que Fecha es la fecha real de compra, y Fecha_Entrega es la fecha real que se entrego el producto. ¿Cuantas ventas NO se entregaron el mismo mes en que fueron compradas?
#### Ejemplo
####| Venta |Fecha      | Fecha_Entrega |  |
####|-------|-----------|-------------- |-----|
####|  1    |2018-03-09 | 2018-03-25 | --> Se entrego el mismo mes que fue hecha la venta |
####|  2    |2020-06-29 | 2020-07-01 | --> No se entrego el mismo mes que la venta |


SELECT COUNT(*) AS DifferentMonthsSales
FROM checkpoint_m2.venta
WHERE MONTH(Fecha) != MONTH(Fecha_Entrega);

-- 6831 ventas no fueron entregadas el mismo mes de compra

## 15) Cual es el Id del empleado que mayor cantidad de productos vendio en toda la historia de las ventas?

SELECT IdEmpleado, SUM(Cantidad) AS TotalSold
FROM checkpoint_m2.venta
GROUP BY IdEmpleado
ORDER BY TotalSold DESC
LIMIT 1;

-- 1675 es el id del empleado con mayor cantidad de productos vendidos (1150)


SELECT COUNT(*) FROM checkpoint_m21.producto WHERE Tipo LIKE 'I%';




SELECT COUNT(*)
FROM checkpoint_m21.producto
WHERE Concepto LIKE '%GB%' and Precio < 400;