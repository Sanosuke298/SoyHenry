-- CR 7 FT 17 M3

USE henry_m3;
-- 1)
-- VENTAS = PRECIO * CANTIDAD

SELECT * FROM venta; -- IdSucursal IdCliente
SELECT * FROM cliente; -- IdCliente  IdLocalidad
SELECT * FROM sucursal; -- IdSucursal IdLocalidad
SELECT * FROM localidad; -- IdLocalidad Localidad IdProvincia
SELECT * FROM provincia; -- IdProvincia Provincia

-- Total de ventas por provincia y localidad

SELECT p.Provincia as Provincia, l.Localidad as Ciudad, SUM(v.Precio * v.Cantidad) AS Ventas
FROM venta v JOIN sucursal s
				ON (s.IdSucursal = v.IdSucursal)
			JOIN localidad l
				ON (l.IdLocalidad = s.IdLocalidad) 
			JOIN provincia p
				ON (p.IdProvincia = l.IdProvincia)
WHERE YEAR(v.Fecha) = 2020 AND v.Outlier = 0    -- Outlier = 0 vamos a calcular sin tener en cuenta los outliers de precio y cantidad
GROUP BY 1, 2
ORDER BY 1;
-- 0.078 sec
-- Indices creados = 0.078 sec
-- Que producto se vendio mas por sucursal
SELECT * from sucursal; -- IdSucursal Sucursal
SELECT * FROM venta; -- IdSucursal IdProducto Cantidad
SELECT * FROM producto; -- IdProducto Nombre IdTipoProducto
SELECT * FROM tipo_producto; -- IdTipoProducto Tipo_Producto

SELECT DISTINCT s.IdSucursal ,s.Sucursal as Sucursal, p.IdProducto ,p.Nombre AS Producto, SUM(v.Cantidad)
FROM venta v JOIN sucursal s 
				ON (v.IdSucursal = s.IdSucursal) 
			JOIN producto p
				ON (v.IdProducto = p.IdProducto)
GROUP BY 1,2,3,4
ORDER BY 5 DESC;
-- 0.281 SEC
-- Despues de los index= 0.453 sec

SELECT 	venta.Nombre, 
		venta.SumaVentas, 
        venta.CantidadVentas, 
        venta.SumaVentasOutliers,
        compra.SumaCompras, 
        compra.CantidadCompras,
        ((venta.SumaVentas / compra.SumaCompras - 1) * 100) as margen
FROM
	(SELECT 	p.Nombre,
			SUM(v.Precio * v.Cantidad * v.Outlier) 	as 	SumaVentas,
			SUM(v.Outlier) 							as	CantidadVentas,
			SUM(v.Precio * v.Cantidad) 				as 	SumaVentasOutliers,
			COUNT(*) 								as	CantidadVentasOutliers
	FROM venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto
			AND YEAR(v.Fecha) = 2019)
	GROUP BY p.Nombre) AS venta
JOIN
	(SELECT 	p.Nombre,
			SUM(c.Precio * c.Cantidad) 				as SumaCompras,
			COUNT(*)								as CantidadCompras
	FROM compra c JOIN producto p
		ON (c.IdProducto = p.IdProducto
			AND YEAR(c.Fecha) = 2019)
	GROUP BY p.Nombre) as compra
ON (venta.Nombre = compra.Nombre); 
-- 0.109 sec
-- Despues del index = 0.125


-- 2)

-- PK -> Valor unico, no tiene que haber nulos y que para cada fila o registro en la tabla le corresponda solo una PK
SELECT * FROM venta; -- IdVenta
SELECT COUNT(*) FROM venta WHERE IdVenta IS NULL or IdVenta = ''; 

ALTER TABLE venta ADD PRIMARY KEY(IdVenta);

SELECT * from canal_venta; 

ALTER TABLE canal_venta ADD PRIMARY KEY(IdCanal);

SELECT * FROM cliente; -- IdCliente

ALTER TABLE cliente ADD PRIMARY KEY(IdCliente);

SELECT * FROM compra; -- IdCompra

ALTER TABLE compra ADD PRIMARY KEY(IdCompra);

SELECT * FROM empleado;   -- IdEmpleado

ALTER TABLE empleado ADD PRIMARY KEY(IdEmpleado2); -- Nos da error porque tenemos valores duplicados
ALTER TABLE empleado ADD PRIMARY KEY(IdEmpleado); -- Esta columna ya esta normalizada y tenemos la PK

SELECT * FROM gasto; -- IdGasto

ALTER TABLE gasto ADD PRIMARY KEY(IdGasto);

SELECT * FROM producto; -- IdProducto 

SELECT COUNT(*) FROM producto WHERE Nombre IS NULL OR Nombre = ''; -- No hay vacios
SELECT DISTINCT Nombre, COUNT(*) FROM producto GROUP BY Nombre; -- Tenemos nombres repetidos

ALTER TABLE producto ADD PRIMARY KEY(IdProducto);

SELECT * FROM proveedor; -- IdProveedor

ALTER TABLE proveedor ADD PRIMARY KEY(IdProveedor);

SELECT * FROM sucursal; -- IdSucursal

ALTER TABLE sucursal ADD PRIMARY KEY(IdSucursal);

SELECT * FROM tipo_Gasto; -- IdTipoGasto

ALTER TABLE tipo_gasto ADD PRIMARY KEY(IdTipoGasto);

-- 3) Genere la indexación de los campos que representen fechas o ID en las tablas:
/*
venta.
cana_venta.
producto.
tipo_producto.
sucursal.
empleado.
localidad.
proveedor.
gasto.
cliente.
compra.
*/

SELECT * FROM canal_venta; -- Lo establecimos antes
SELECT * FROM producto; -- IdProducto lo establecimos antes IdTipoProducto
ALTER TABLE producto ADD INDEX(IdTipoProducto);
/*
CREATE INDEX tipo_producto ON producto (IdTipoProducto); -- DUPLICATE INDEX
DROP INDEX tipo_producto ON producto;
*/

SELECT * FROM tipo_producto;  -- Lo establecimos antes

SELECT * FROM sucursal;  -- IdSucursal lo establecimos antes IdLocalidad
ALTER TABLE sucursal ADD INDEX(IdLocalidad);

SELECT * FROM empleado;  -- IdEmpleado lo establecimos antes IdSucursal IdSector IdCargo
ALTER TABLE empleado ADD INDEX (IdSucursal);
ALTER TABLE empleado ADD INDEX(IdSector);
ALTER TABLE empleado ADD INDEX(IdCargo);

SELECT * FROM localidad; -- IdLocalidad es PK desde que creamos la tabla  IdProvincia

ALTER TABLE localidad ADD INDEX(IdProvincia);

SELECT * FROM proveedor; -- IdLocalidad
ALTER TABLE proveedor ADD INDEX(IdLocalidad);

SELECT * FROM gasto; -- IdGasto es PK, IdSucursal IdTipoGasto Fecha
ALTER TABLE gasto ADD INDEX(IdSucursal);
ALTER TABLE gasto ADD INDEX(IdTipoGasto);
ALTER TABLE gasto ADD INDEX(Fecha);

SELECT * FROM cliente; -- IdLocalidad
ALTER TABLE cliente ADD INDEX(IdLocalidad);

SELECT * FROM compra; -- Fecha IdProducto IdProveedor
ALTER TABLE compra ADD INDEX(Fecha);
ALTER TABLE compra ADD INDEX(IdProducto);
ALTER TABLE compra ADD INDEX(IdProveedor);

SELECT * FROM venta; -- IdCanal IdCliente IdSucursal IdEmpleado IdProducto Fecha Fecha_Entrega
ALTER TABLE venta ADD INDEX(Fecha);
ALTER TABLE venta ADD INDEX(Fecha_Entrega);
ALTER TABLE venta ADD INDEX(IdCanal);
ALTER TABLE venta ADD INDEX(IdCliente);
ALTER TABLE venta ADD INDEX(IdSucursal);
ALTER TABLE venta ADD INDEX(IdEmpleado);
ALTER TABLE venta ADD INDEX(IdProducto);

-- CROSS JOIN   ESTO NO ES FULL OUTER JOIN


SELECT * FROM venta; 
-- IdCanal canal_venta
-- IdCliente cliente
-- IdSucursal sucursal
-- IdEmpleado empleado
-- IdProducto producto

ALTER TABLE venta ADD CONSTRAINT venta_fk_canal FOREIGN KEY(IdCanal) REFERENCES canal_venta (IdCanal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT venta_fk_sucursal FOREIGN KEY(IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT venta_fk_empleado FOREIGN KEY(IdEmpleado) REFERENCES empleado (IdEmpleado) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT venta_fk_producto FOREIGN KEY(IdProducto) REFERENCES producto (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;

SELECT * FROM compra;
-- IdProducto producto
-- IdProveedor proveedor

ALTER TABLE compra ADD CONSTRAINT compra_fk_proveedor FOREIGN KEY(IdProveedor) REFERENCES proveedor (IdProveedor) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE compra ADD CONSTRAINT compra_fk_producto FOREIGN KEY(IdProducto) REFERENCES producto (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;

SELECT * FROM gasto;
-- IdSucursal sucursal
-- IdTipoGasto tipo_gasto

ALTER TABLE gasto ADD FOREIGN KEY(IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE gasto ADD FOREIGN KEY(IdTipoGasto) REFERENCES tipo_gasto (IdTipoGasto) ON DELETE RESTRICT ON UPDATE RESTRICT;

SELECT * FROM cliente c LEFT JOIN venta v ON (v.IdCliente = c.IdCliente) WHERE v.IdVenta IS NULL;
-- Clientes que nunca hicieron compras
DELETE FROM cliente WHERE IdCliente = 59; -- ME DEJA PORQUE NO HAY RESTRICCIONES CON ESE REGISTRO

SELECT * FROM venta WHERE IdCliente = 969; -- COMO ESTE CLIENTE EXISTE EN LAS VENTAS, NO LO PUEDO ELIMINAR
DELETE FROM cliente WHERE IdCliente = 969; -- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`henry_m3`.`venta`, CONSTRAINT `cliente_fk_venta` FOREIGN KEY (`IdCliente`) REFERENCES `cliente` (`IdCliente`) ON DELETE RESTRICT ON UPDATE RESTRICT)


SELECT * FROM producto;
-- IdTipoProducto tipo_producto
ALTER TABLE producto ADD FOREIGN KEY(IdTipoProducto) REFERENCES tipo_producto (IdTipoProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;

SELECT * FROM sucursal;
-- IdLocalidad localidad
ALTER TABLE sucursal ADD FOREIGN KEY(IdLocalidad) REFERENCES Localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;

SELECT * FROM proveedor;
-- IdLocalidad localidad
ALTER TABLE proveedor ADD FOREIGN KEY(IdLocalidad) REFERENCES Localidad (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;

SELECT * FROM empleado;
-- IdSucursal sucursal
-- IdSector sector
-- IdCargo cargo

ALTER TABLE empleado ADD FOREIGN KEY(IdCargo) REFERENCES cargo (IdCargo) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE empleado ADD FOREIGN KEY(IdSector) REFERENCES sector (IdSector) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE empleado ADD FOREIGN KEY (IdSucursal) REFERENCES sucursal (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;

SELECT * FROM localidad;
-- IdProvincia provincia

ALTER TABLE localidad ADD FOREIGN KEY(IdProvincia) REFERENCES provincia (IdProvincia) ON DELETE RESTRICT ON UPDATE RESTRICT;



-- 5)  
/*IdVenta
Fecha
Fecha_Entrega
IdCanal
IdCliente
IdEmpleado
IdProducto
Precio
Cantidad*/

CREATE TABLE IF NOT EXISTS fact_venta (
	IdVenta INT,
    Fecha DATE,
    Fecha_Entrega DATE,
    IdCanal INT,
    IdCliente INT,
    IdEmpleado INT,
    IdProducto INT,
    Precio DECIMAL(15,3),
    Cantidad INT
);

-- 6) 

INSERT INTO fact_venta
SELECT IdVenta, Fecha, Fecha_entrega, IdCanal, IdCliente, IdEmpleado, IdProducto, Precio, Cantidad
FROM venta
WHERE YEAR(Fecha) = 2020 AND outlier = 0;
SELECT * FROM fact_venta;

ALTER TABLE fact_venta ADD PRIMARY KEY(IdVenta);
ALTER TABLE fact_venta ADD INDEX(Fecha);
ALTER TABLE fact_venta ADD INDEX(Fecha_Entrega);
ALTER TABLE fact_venta ADD INDEX(IdCanal);
ALTER TABLE fact_Venta ADD INDEX(IdCliente);
ALTER TABLE fact_Venta ADD INDEX(IdEmpleado);
ALTER TABLE fact_venta ADD INDEX (IdProducto);

SELECT * FROM producto;

select * from fact_Venta
where idproducto = 42737;

DROP TABLE IF EXISTS dim_cliente;
CREATE TABLE IF NOT EXISTS dim_cliente(
	IdCliente INT,
    Nombe_y_apellido VARCHAR(150),
    Domicilio VARCHAR(200),
    Telefono VARCHAR(40),
    Rango_Etario VARCHAR(30),
    IdLocalidad INT
);

INSERT INTO dim_cliente
SELECT IdCliente, Nombre_y_apellido, Domicilio, Telefono, Rango_etario, IdLocalidad
FROM cliente;

ALTER TABLE dim_cliente ADD PRIMARY KEY(IdCliente);
ALTER TABLE fact_venta ADD FOREIGN KEY (IdCliente) REFERENCES dim_cliente (IdCliente) ON DELETE RESTRICT ON UPDATE RESTRICT;

CREATE TABLE IF NOT EXISTS dim_producto (
	IdProducto INT,
    Nombre VARCHAR(100)
);

INSERT INTO dim_producto
SELECT IdProducto, Nombre
FROM producto
ORDER BY 1;

ALTER TABLE dim_producto ADD PRIMARY KEY(IdProducto);
ALTER TABLE fact_venta ADD FOREIGN KEY (IdProducto) REFERENCES dim_producto (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;

SELECT * FROM dim_producto;

