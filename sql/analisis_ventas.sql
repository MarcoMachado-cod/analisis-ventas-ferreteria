-- ====================
--		EXPLORACION
-- =====================

SELECT * 
FROM ferreteria_limpio fl  -- Probamos que este bien cargdo el csv
LIMIT 10;

-- ¿Cuántas ventas hay registradas?

SELECT count(*) 
FROM ferreteria_limpio fl;  -- Verificamos la cantidad de filas

-- ¿Cuántos clientes diferentes hay?

SELECT count(DISTINCT nombre_cliente) AS clientes_distintos
FROM ferreteria_limpio fl;

-- ¿Cuántos productos diferentes se vendieron?

SELECT count(DISTINCT fl.producto) AS productos
FROM ferreteria_limpio fl;

-- ¿Cuántas categorías de productos existen?

SELECT count(DISTINCT fl.categoria ) AS categorias
FROM ferreteria_limpio fl;

-- ¿Qué sucursales existen?

SELECT count(DISTINCT fl.sucursal) AS sucursales
FROM ferreteria_limpio fl;

-- ¿Qué medios de pago se utilizan?

SELECT DISTINCT fl.medio_pago 
FROM ferreteria_limpio fl;

-- ====================
--		VENTAS
-- =====================

-- ¿Cuál es la facturación total?

SELECT sum(total_venta) AS facturacion_total
FROM ferreteria_limpio fl;

-- ¿Cuántas unidades se vendieron?

SELECT sum(cantidad) AS unidades_vendidas
FROM ferreteria_limpio fl;

-- ¿Cuál es el ticket promedio?

SELECT AVG(total_venta) AS ticket_promedio
FROM ferreteria_limpio fl;

-- ¿Cuál fue la venta más alta?

SELECT fl.id_venta, fl.nombre_cliente, fl.sucursal, fl.provincia, fl.producto, fl.categoria, fl.total_venta  
FROM ferreteria_limpio fl
ORDER by fl.total_venta DESC
LIMIT 1;

-- ¿Cuál fue la venta más baja?

SELECT fl.id_venta, fl.nombre_cliente, fl.sucursal, fl.provincia, fl.producto, fl.categoria, fl.total_venta  
FROM ferreteria_limpio fl
ORDER by fl.total_venta asc
LIMIT 1;

-- ¿Cuántas ventas superaron los $100.000?

SELECT count(*) 
FROM ferreteria_limpio fl
WHERE fl.total_venta > 100000;

-- ====================
--		PRODUCTOS
-- =====================

-- ¿Cuánto facturó cada producto?

SELECT fl.producto, sum(fl.total_venta) AS facturacion
FROM ferreteria_limpio fl
GROUP by fl.producto
ORDER BY facturacion desc;


-- ¿Cuántas unidades se vendieron de cada producto?

SELECT fl.producto, sum(fl.cantidad) AS unidades_vendidas
FROM ferreteria_limpio fl
GROUP by fl.producto
ORDER BY unidades_vendidas desc;

-- ¿Qué producto tiene el precio unitario más alto?

SELECT fl.producto, fl.categoria, fl.precio_unitario
FROM ferreteria_limpio fl
ORDER BY fl.precio_unitario desc
LIMIT 1;

-- ¿Qué categorías generan mayor facturación?

SELECT fl.categoria, sum(fl.total_venta) AS facturacion
FROM ferreteria_limpio fl
GROUP by fl.categoria 
ORDER BY facturacion desc;

-- ¿Qué categorías venden mayor cantidad de unidades?

SELECT fl.categoria, sum(fl.cantidad) AS unidades_vendidas
FROM ferreteria_limpio fl
GROUP by fl.categoria 
ORDER BY unidades_vendidas desc;


-- ====================
--		SUCURSALES
-- =====================

-- ¿Qué sucursal tiene mayor facturación?

SELECT fl.sucursal, sum(fl.total_venta) AS facturacion
FROM ferreteria_limpio fl
GROUP by fl.sucursal  
ORDER BY facturacion DESC
LIMIT 1;

-- ¿Qué sucursal vende más unidades?

SELECT fl.sucursal , sum(fl.cantidad) AS unidades_vendidas
FROM ferreteria_limpio fl
GROUP by fl.sucursal  
ORDER BY unidades_vendidas DESC
LIMIT 1;

-- ¿Cuál tiene el mayor ticket promedio?

SELECT fl.sucursal,
		ROUND((SUM(fl.total_venta) / COUNT(DISTINCT fl.id_venta))::numeric, 2) AS ticket_promedio
FROM ferreteria_limpio fl
GROUP BY fl.sucursal
ORDER BY ticket_promedio DESC
LIMIT 1;

-- ¿Cuánto representa cada sucursal del total de ventas?

SELECT fl.sucursal,
       ROUND((SUM(fl.total_venta) * 100 / (SELECT SUM(total_venta) FROM ferreteria_limpio))::numeric, 2) AS porcentaje_del_total
FROM ferreteria_limpio fl
GROUP BY fl.sucursal
ORDER BY porcentaje_del_total DESC;

-- ¿Qué provincia genera mayor facturación?

SELECT fl.provincia , sum(fl.total_venta) AS facturacion
FROM ferreteria_limpio fl
GROUP by fl.provincia   
ORDER BY facturacion DESC
LIMIT 1;

-- ¿Qué categoría es la más vendida en cada sucursal?

-- forma 1: 

SELECT sucursal, categoria, total_vendido
FROM (
    SELECT fl.sucursal,
           fl.categoria,
           SUM(fl.cantidad) AS total_vendido,
           ROW_NUMBER() OVER (
               PARTITION BY fl.sucursal
               ORDER BY SUM(fl.cantidad) DESC
           ) AS numero
    FROM ferreteria_limpio fl
    GROUP BY fl.sucursal, fl.categoria
) AS ranking
WHERE numero = 1;

-- forma 2:

SELECT DISTINCT ON (sucursal)
       sucursal,
       categoria,
       SUM(cantidad) AS total_vendido
FROM ferreteria_limpio
GROUP BY sucursal, categoria
ORDER BY sucursal, total_vendido DESC;


-- ====================
--		CLIENTES
-- =====================

-- ¿Cuáles son los 10 clientes que más gastaron?

SELECT fl.id_cliente, fl.nombre_cliente, SUM(total_venta) AS total_gastado
FROM ferreteria_limpio fl
GROUP BY id_cliente, nombre_cliente
ORDER BY total_gastado DESC
LIMIT 10;

-- ¿Cuántas compras realizó cada cliente?

SELECT fl.id_cliente, fl.nombre_cliente, count(fl.id_venta) AS compras
FROM ferreteria_limpio fl
GROUP BY fl.id_cliente, fl.nombre_cliente 
ORDER BY compras DESC;

-- ¿Qué clientes realizaron más de una compra?

SELECT fl.nombre_cliente, count(fl.id_cliente) AS compras
FROM ferreteria_limpio fl 
GROUP BY fl.nombre_cliente 
HAVING count(fl.id_cliente) > 1;

-- ¿Cuántos clientes compraron más de una vez?

SELECT COUNT(*) AS clientes_recurrentes
FROM (
    SELECT id_cliente
    FROM ferreteria_limpio
    GROUP BY id_cliente
    HAVING COUNT(id_venta) > 1
) AS recurrentes;


-- ====================
--		MEDIOS DE PAGO
-- =====================

-- ¿Cuál es el medio de pago más utilizado?

SELECT fl.medio_pago, count(*) AS pagos
FROM ferreteria_limpio fl
GROUP BY fl.medio_pago
ORDER BY pagos DESC
LIMIT 1;

-- ¿Cuánto dinero se facturó por cada medio de pago?

SELECT fl.medio_pago, sum(total_venta) AS facturacion
FROM ferreteria_limpio fl 
GROUP BY fl.medio_pago
ORDER BY facturacion DESC;

-- ¿Cuántas ventas hubo por cada medio de pago?

SELECT fl.medio_pago, count(id_venta) AS ventas
FROM ferreteria_limpio fl 
GROUP BY fl.medio_pago 
ORDER BY ventas DESC;

-- ¿Cuál tiene el mayor ticket promedio?

SELECT fl.medio_pago, round(avg(fl.total_venta)::NUMERIC, 2) AS promedio_ventas
FROM ferreteria_limpio fl 
GROUP BY fl.medio_pago 
ORDER BY promedio_ventas DESC;

SELECT fl.medio_pago, round((sum(fl.total_venta) / count(DISTINCT fl.id_venta)):: NUMERIC, 2) AS promedio_ventas
FROM ferreteria_limpio fl 
GROUP BY fl.medio_pago 
ORDER BY promedio_ventas DESC;


-- ¿Qué medio de pago genera más facturación?

SELECT fl.medio_pago, sum(total_venta) AS facturacion
FROM ferreteria_limpio fl 
GROUP BY fl.medio_pago
ORDER BY facturacion DESC
LIMIT 1;

-- Porcentaje que representa cada medio de pago

SELECT fl.medio_pago, 
	   round((sum(fl.total_venta) * 100 / (SELECT SUM(total_venta) FROM ferreteria_limpio))::numeric, 2)  AS facturacion
FROM ferreteria_limpio fl 
GROUP BY fl.medio_pago
ORDER BY facturacion DESC
LIMIT 1;


-- ====================
--		TABLAS
-- ====================

-- provincias

CREATE TABLE provincias (
	id_provincia SERIAL PRIMARY KEY,
	nombre varchar(50) NOT NULL
);

INSERt INTO provincias (nombre)
SELECT fl.provincia
FROM ferreteria_limpio fl
GROUP BY fl.provincia;

SELECT * FROM provincias;

-- sucursales

CREATE TABLE sucursales (
	id_sucursal SERIAL PRIMARY KEY,
	id_provincia int NOT NULL,
	nombre varchar(50) NOT NULL
);

SELECT * FROM sucursales;

INSERT INTO sucursales (nombre, id_provincia) 
SELECT fl.sucursal, p.id_provincia 		     
FROM ferreteria_limpio fl  					  
INNER JOIN provincias p ON p.nombre = fl.provincia 
GROUP BY fl.sucursal, p.id_provincia; 

-- clientes

CREATE TABLE clientes (
	id_cliente int PRIMARY KEY,
	nombre_cliente varchar(50) NOT NULL
);

INSERT INTO clientes (id_cliente, nombre_cliente)
SELECT id_cliente, min(nombre_cliente)
FROM ferreteria_limpio fl 
GROUP BY id_cliente;

SELECT * FROM clientes;

-- categorias

CREATE TABLE categorias (
	id_categorias serial PRIMARY KEY,
	nombre varchar(50) NOT NULL 
);

INSERT INTO categorias (nombre)
SELECT fl.categoria 
FROM ferreteria_limpio fl 
GROUP BY fl.categoria; 

SELECT * FROM categorias;

-- productos

CREATE TABLE productos (
	id_producto serial PRIMARY KEY,
	id_categorias int NOT NULL,
	nombre varchar(50)
);

INSERT INTO productos (nombre, id_categorias)
SELECT fl.producto , c.id_categorias
FROM ferreteria_limpio fl
INNER JOIN categorias c ON c.nombre = fl.categoria 
GROUP BY fl.producto , c.id_categorias;

SELECT * FROM productos;

-- medios_pago
 
CREATE TABLE medios_pagos (
	id_medios_pagos serial PRIMARY KEY, 
	nombre varchar(50) NOT NULL 
);


INSERT INTO medios_pagos (nombre)
SELECT fl.medio_pago
FROM ferreteria_limpio fl 
GROUP BY fl.medio_pago;

SELECT * FROM medios_pagos;

-- venta

CREATE TABLE ventas (
	id_venta int PRIMARY KEY,	
	id_sucursal int NOT NULL,
	id_cliente int NOT NULL,
	id_producto int NOT NULL,	
	id_medios_pagos int NOT NULL,
	cantidad int NOT NULL,
	precio_unitario NUMERIC NOT NULL,
	total_venta NUMERIC NOT NULL,	
	fecha_hora timestamp NOT NULL
);

INSERT INTO ventas (id_venta,id_sucursal,id_cliente,id_producto,id_medios_pagos,cantidad,precio_unitario,total_venta,fecha_hora)
SELECT fl.id_venta,	
	sucursales.id_sucursal,
	fl.id_cliente,
	productos.id_producto,	
	medios_pagos.id_medios_pagos,
	fl.cantidad,
	fl.precio_unitario,
	fl.total_venta,
	fl.fecha_hora::timestamp
FROM ferreteria_limpio fl
INNER JOIN sucursales ON sucursales.nombre = fl.sucursal
INNER JOIN productos ON productos.nombre = fl.producto 
INNER JOIN medios_pagos ON medios_pagos.nombre = fl.medio_pago  

SELECT * FROM ventas;

SELECT COUNT(*) FROM ferreteria_limpio;  -- debe coincidir con:
SELECT COUNT(*) FROM ventas;  


-- ====================
--		ANALISIS
-- ====================

-- 1) Ventas con nombre del cliente

SELECT v.id_venta, c.nombre_cliente, v.total_venta AS ventas_cliente
FROM ventas v 
INNER JOIN clientes c 
ON v.id_cliente = c.id_cliente;

-- 2) Productos vendidos

SELECT v.id_venta, p.nombre, v.cantidad, v.precio_unitario 
FROM ventas v 
INNER JOIN productos p 
ON v.id_producto = p.id_producto;

-- 3) Productos y sus categorías

SELECT p.nombre AS producto, categorias.nombre AS categoria
FROM productos p 
INNER JOIN categorias 
ON p.id_categorias  = categorias.id_categorias;


-- 4) Ventas con sucursal y provincia

SELECT v.id_venta, s.nombre, p.nombre, v.total_venta 
FROM ventas v 
INNER JOIN sucursales s 
	ON v.id_sucursal = s.id_sucursal
INNER JOIN provincias p 
	ON s.id_provincia = p.id_provincia;

-- 5) Reporte completo de ventas

SELECT v.id_venta, c.nombre_cliente, productos.nombre, categorias.nombre, s.nombre, p.nombre, mp.nombre,v.total_venta AS facturacion
FROM ventas v 
INNER JOIN clientes c 
	ON v.id_cliente  = c.id_cliente 
INNER JOIN productos
	ON v.id_producto = productos.id_producto 
INNER JOIN categorias 
	ON productos.id_categorias = categorias.id_categorias 
INNER JOIN sucursales s 
	ON v.id_sucursal = s.id_sucursal 
INNER JOIN provincias p 
	ON p.id_provincia = s.id_provincia 
INNER JOIN medios_pagos mp 
	ON v.id_medios_pagos = mp.id_medios_pagos;

