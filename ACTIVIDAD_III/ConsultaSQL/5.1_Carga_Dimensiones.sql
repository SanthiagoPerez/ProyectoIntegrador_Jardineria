-- DIM_TIEMPO: calendario completo de los años que cubren los pedidos
WITH rango AS (
  SELECT DATEFROMPARTS(MIN(YEAR(fecha_pedido)),1,1) AS ini,
         DATEFROMPARTS(MAX(YEAR(fecha_pedido)),12,31) AS fin
  FROM staging_jardineria.dbo.stg_pedido),
cal AS (
  SELECT ini AS fecha, fin FROM rango
  UNION ALL
  SELECT DATEADD(DAY,1,fecha), fin FROM cal WHERE fecha < fin)
INSERT INTO datamart_jardineria.dbo.dim_tiempo
  (sk_tiempo, fecha, anio, semestre, trimestre, mes, nombre_mes, dia, dia_semana)
SELECT CONVERT(INT, CONVERT(CHAR(8), fecha, 112)), fecha, YEAR(fecha),
  CASE WHEN MONTH(fecha) <= 6 THEN 1 ELSE 2 END,
  DATEPART(QUARTER, fecha), MONTH(fecha),
  CHOOSE(MONTH(fecha),'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'),
  DAY(fecha),
  CHOOSE(DATEDIFF(DAY,'19000101',fecha) % 7 + 1,'Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo')
FROM cal
OPTION (MAXRECURSION 0);

-- DIM_CATEGORIA
INSERT INTO datamart_jardineria.dbo.dim_categoria (id_categoria, nombre_categoria, descripcion)
SELECT Id_Categoria, LTRIM(RTRIM(Desc_Categoria)), descripcion_texto
FROM staging_jardineria.dbo.stg_categoria_producto;

-- DIM_PRODUCTO (desnormaliza el nombre de la categoría)
INSERT INTO datamart_jardineria.dbo.dim_producto
  (id_producto, codigo_producto, nombre_producto, nombre_categoria, proveedor, dimensiones, precio_venta, precio_proveedor)
SELECT p.ID_producto, p.ID_producto, p.nombre, c.Desc_Categoria, p.proveedor, p.dimensiones, p.precio_venta, p.precio_proveedor
FROM staging_jardineria.dbo.stg_producto p
LEFT JOIN staging_jardineria.dbo.stg_categoria_producto c ON c.Id_Categoria = p.Categoria;

-- DIM_CLIENTE
INSERT INTO datamart_jardineria.dbo.dim_cliente
  (id_cliente, nombre_cliente, nombre_contacto, ciudad, region, pais, limite_credito)
SELECT ID_cliente, nombre_cliente,
  LTRIM(RTRIM(ISNULL(nombre_contacto,'') + ' ' + ISNULL(apellido_contacto,''))),
  ciudad, region, pais, limite_credito
FROM staging_jardineria.dbo.stg_cliente;

-- DIM_EMPLEADO (une datos de la oficina)
INSERT INTO datamart_jardineria.dbo.dim_empleado
  (id_empleado, nombre_completo, puesto, oficina, ciudad_oficina, pais_oficina)
SELECT e.ID_empleado,
  e.nombre + ' ' + e.apellido1 + ISNULL(' ' + e.apellido2, ''),
  e.puesto, o.Descripcion, o.ciudad, o.pais
FROM staging_jardineria.dbo.stg_empleado e
LEFT JOIN staging_jardineria.dbo.stg_oficina o ON o.ID_oficina = e.ID_oficina;

-- DIM_ESTADO_PEDIDO
INSERT INTO datamart_jardineria.dbo.dim_estado_pedido (estado, es_venta_efectiva)
SELECT DISTINCT estado, CASE WHEN estado = 'Entregado' THEN 1 ELSE 0 END
FROM staging_jardineria.dbo.stg_pedido;