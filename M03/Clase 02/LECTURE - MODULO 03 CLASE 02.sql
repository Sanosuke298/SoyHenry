-- LECTURE
 
 -- inner join
 
 SELECT * FROM product;
 SELECT * FROM salesorderheader;
 SELECT * FROM salesorderdetail;
 
 SELECT s.salesOrderId, s.OrderQty, p.Name, p.ListPrice, p.ProductID
 FROM salesorderdetail s INNER JOIN product p
				ON (s.ProductID = p.ProductID)
;
SELECT * FROM contact;

SELECT s.ContactId, SUM(s.Freight) AS TotalTransporte, CONCAT(c.Title,c.FirstName,' ',c.LastName) as Nombre, c.Phone
FROM salesorderheader s INNER JOIN contact c
				ON (c.ContactId = s.ContactID)
WHERE s.OrderDate BETWEEN '2002-01-01' AND '2003-01-01'
GROUP BY s.ContactId, Nombre
ORDER BY TotalTransporte DESC
LIMIT 10;

SELECT s.ContactID, c.FirstName, SUM(s.TotalDue) as 'Total Venta'
FROM salesorderheader s JOIN contact c 
			ON (s.ContactId = c.ContactID)
GROUP BY 1 
ORDER BY 3 DESC;

-- LEFT JOIN

SELECT DISTINCT p.ProductID, p.Name, s.LineTotal
FROM product p LEFT JOIN salesorderdetail s 
			ON (s.ProductID = p.ProductID)
-- WHERE s.SalesOrderId IS NULL;
;
-- RIGHT JOIN

SELECT DISTINCT p.ProductID, p.Name, s.LineTotal
FROM salesorderdetail s RIGHT JOIN product p
			ON (s.ProductID = p.ProductID)
-- WHERE s.SalesOrderId IS NULL;
;

SELECT * FROM product;
USE bd_ventas;

select p.IdProducto, p.Concepto, v.IdVenta, v.Precio * v.Cantidad as Venta
FROM venta v RIGHT JOIN producto p
		ON (p.IdProducto = v.IdProducto);

-- FULL OUTER JOIN

-- FULL OUTER JOIN = RIGHT JOIN + LEFT JOIN -> RIGHT JOIN UNION LEFT JOIN

SELECT p.IdProducto, p.Concepto, v.IdVenta, v.Precio * v.Cantidad as Venta
FROM producto p RIGHT JOIN venta v
			ON(v.IdProducto = p.IdProducto)
union 
SELECT p.IdProducto, p.Concepto, v.IdVenta, v.Precio * v.Cantidad
FROM producto p LEFT JOIN venta v
			ON (v.IdProducto = p.IdProducto)

;	