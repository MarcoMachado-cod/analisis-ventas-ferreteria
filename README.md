# Análisis de ventas de una ferretería

## Descripción del proyecto
Proyecto de análisis de datos orientado a la limpieza, transformación y análisis de ventas de una ferretería mediante Python y PostgreSQL.

## Objetivos
- Limpiar y preparar los datos para su análisis.
- Identificar patrones de ventas y comportamiento de los clientes.
- Analizar la facturación por producto, categoría y sucursal.
- Realizar consultas SQL para responder preguntas de negocio.

## Fuente de datos
- Kaggle


## Herramientas utilizadas
- Python (Pandas y NumPy)
- PostgreSQL
- Power BI

## Etapas del proyecto

### 1. Limpieza y transformación de datos con Python

El dataset inicial (`retail_ferreteria.csv`) contenía **3.150 filas y 15 columnas**. Durante la exploración se identificaron valores negativos, registros duplicados, valores nulos e inconsistencias en los datos de los clientes.

Para esta etapa se utilizó Python, junto con las librerías Pandas y NumPy.

#### Exploración de los datos

Se realizaron las siguientes verificaciones:

- Estructura del dataset.
- Tipos de datos 
- Valores faltantes, duplicados e inconsistentes
- Estadísticas descriptivas.
- Distribución de productos y ventas

#### Limpieza y transformación

**1. Tratamiento de valores negativos**

Se identificaron 20 registros con valores negativos en la columna `total_venta`, los cuales pude identificar que fueron por errores de carga. Se aplicó el valor absoluto para convertirlos en positivos.

**2. Normalización de nombres de clientes**

Se eliminaron prefijos y tratamientos como `Sr.` y `Sra.` de la columna `nombre_cliente`, con el objetivo de unificar los nombres y facilitar su análisis.

**3. Tratamiento de valores nulos e inconsistencias**

Se completaron los valores faltantes de las siguientes columnas:

- `promo_producto`: se reemplazaron los nulos y los valores `???` por `sin promo`.
- `promo_pago`: se reemplazaron los nulos por `sin promo`.
- `otros_productos`: se reemplazaron los nulos por `ninguno`.
- `medio_pago`: se reemplazaron los nulos por `sin especificar`.

Para las columnas numéricas `cantidad` y `precio_unitario`, se calcularon los valores faltantes cuando era posible utilizando `total_venta` y el dato disponible de la otra columna.

**4. Ajuste de tipos de datos y precisión**

Se redondearon los valores de `precio_unitario` a dos decimales y los de `cantidad` al entero más cercano.

**5. Eliminación de registros duplicados**

Se identificaron ventas con `id_venta` repetidos y se revisaron los registros involucrados. Se determinó que correspondían a duplicaciones de carga y no a ventas diferentes.

Para conservar el registro con información más completa, se priorizaron las filas que tenían un medio de pago especificado antes de eliminar los duplicados.

**6. Generación de identificadores únicos por nombre de cliente**

Se detectaron identificadores de cliente compartidos por personas con nombres diferentes. Para resolver esta inconsistencia, se generaron nuevos valores de `id_cliente` agrupando por `nombre_cliente`.

Esta solución permite distinguir los nombres diferentes, aunque no garantiza identificar de manera inequívoca a cada persona cuando existen nombres iguales.

#### Exportación del dataset limpio

Una vez realizadas las transformaciones, se exportó el resultado a `ferreteria_limpio.csv`, que se utiliza como base para la siguiente etapa del proyecto.

### 2. Análisis de datos con SQL

En esta etapa se utilizó PostgreSQL para analizar el dataset limpio. El objetivo fue explorar la información y responder preguntas de negocio relacionadas con las ventas, los productos, las sucursales, los clientes y los medios de pago.

#### Exploración de los datos

Se realizaron consultas iniciales para conocer la estructura y el contenido del dataset. Ademas de realizar una verificacion con los resultados obtenidos en la primer etapa:

- Verificación de los registros cargados.
- Recuento de ventas registradas.
- Identificación de clientes, productos, categorías y sucursales diferentes.
- Identificación de los medios de pago utilizados.

#### Análisis de ventas

Se desarrollaron consultas para analizar el rendimiento general de las ventas:

- Cálculo de la facturación total.
- Cálculo de las unidades vendidas.
- Cálculo del ticket promedio.
- Identificación de las ventas de mayor y menor importe.
- Recuento de las ventas superiores a $100.000.

#### Análisis de productos

Se analizaron los productos y las categorías para identificar cuáles tienen mayor participación en las ventas:

- Facturación total por producto.
- Cantidad de unidades vendidas por producto.
- Facturación total por categoría.
- Cantidad de unidades vendidas por categoría.

#### Análisis de sucursales

Se realizaron consultas para comparar el rendimiento de las distintas sucursales:

- Identificación de la sucursal con mayor facturación.
- Identificación de la sucursal con mayor cantidad de unidades vendidas.
- Cálculo del ticket promedio por sucursal.
- Cálculo del porcentaje de facturación que representa cada sucursal sobre el total.
- Identificación de la provincia con mayor facturación.
- Identificación de la categoría con mayor cantidad de unidades vendidas en cada sucursal.

#### Análisis de clientes

Se desarrollaron consultas orientadas a conocer el comportamiento de compra de los clientes:

- Identificación de los clientes con mayor gasto total.
- Recuento de compras por cliente.
- Identificación de los clientes que realizaron más de una compra.
- Cálculo de la cantidad de clientes recurrentes.

#### Análisis de medios de pago

Se analizaron las preferencias de pago y su relación con la facturación:

- Identificación del medio de pago más utilizado.
- Facturación total por medio de pago.
- Cantidad de ventas por medio de pago.
- Cálculo del ticket promedio según el medio de pago.

#### Funcionalidades SQL utilizadas

Durante el análisis se aplicaron distintas herramientas de SQL:

- **Agregaciones:** `SUM()`, `AVG()` y `COUNT()`.
- **Agrupación y filtrado:** `GROUP BY`, `WHERE` y `HAVING`.
- **Ordenamiento y limitación de resultados:** `ORDER BY` y `LIMIT`.
- **Subconsultas:** para calcular porcentajes sobre la facturación total y contar clientes recurrentes.
- **Funciones de ventana:** `ROW_NUMBER()` para identificar la categoría más vendida por sucursal.
- **Instrucciones específicas de PostgreSQL:** `DISTINCT ON` para seleccionar la categoría con mayor cantidad de unidades vendidas en cada sucursal.

### 3. Consultas SQL: relaciones entre tablas

Se relacionaron las distintas tablas de la base de datos mediante consultas SQL, utilizando INNER JOIN para combinar información de diferentes entidades.

Se construyó una consulta general que integra información de siete tablas: ventas, clientes, productos, categorias, sucursales, provincias y medios_pagos.

Esto permitió reunir en un único resultado información comercial y geográfica de cada venta, incluyendo el cliente, el producto, su categoría, la sucursal, la provincia, el medio de pago y el importe facturado.

### 4. Visualización y análisis con Power BI

En esta etapa se desarrolló un dashboard en Power BI conectado a la base de datos de PostgreSQL. El objetivo es transformar los datos trabajados en las etapas anteriores en indicadores y visualizaciones que permitan explorar el comportamiento de las ventas de la ferretería.

#### Indicadores principales (KPI)

El dashboard presenta tarjetas con indicadores generales para obtener una visión rápida del negocio:

- **Facturación total:** suma de los importes registrados en las ventas.
- **Cantidad de clientes:** total de clientes considerados en el análisis.
- **Ticket promedio:** importe promedio de las ventas.
- **Producto más vendido:** producto con mayor cantidad de unidades vendidas.
- **Sucursal con mayor facturacion:** sucursal que registra el mayor importe facturado.

#### Visualizaciones

Se incorporaron distintos gráficos para analizar la información desde diferentes perspectivas:

- **Facturación por categoría:** gráfico de rectángulos (treemap) para comparar el aporte de cada categoría a la facturación.
- **Facturación por producto:** gráfico de barras para comparar los importes vendidos por producto.
- **Distribución por medio de pago:** gráfico de anillo para observar la participación de cada medio de pago en las ventas.
- **Evolución de la facturación:** gráfico de líneas que permite observar cómo varía la facturación a lo largo del tiempo.
- **Facturación mensual:** gráfico de columnas para comparar los importes facturados por mes.

#### Filtros e interacción

Para facilitar la exploración del dashboard se agregaron segmentadores que permiten filtrar la información por:

- Sucursal.
- Año.
- Mes.
- Medio de pago.

Estos filtros permiten analizar los indicadores y las visualizaciones según distintos períodos y dimensiones del negocio.

## Principales resultados

A partir del análisis realizado con SQL y Power BI, se identificaron los siguientes resultados:

- **Sucursal con mayor facturación:** Sucursal de Cordoba, representando el 26,88% de la facturación total.
- **Producto más vendido:** Martillo, con 1002 unidades vendidas.
- **Categoría con mayor facturación:** Herramientas manuales, con una facturación de $69.831.680.
- **Medio de pago más utilizado:** Transferencia, representando el 22,29% de las ventas.
- **Clientes recurrentes:** 63 clientes realizaron más de una compra.

### Dashboard

El siguiente dashboard permite visualizar los principales indicadores y analizar el comportamiento de las ventas mediante filtros interactivos.

![Dashboard de ventas](ferreteriadashboard.png)

## Autor
Marco Machado

