CREATE TABLE staging_jardineria.dbo.stg_oficina (
  ID_oficina INT NOT NULL PRIMARY KEY,
  Descripcion VARCHAR(10), ciudad VARCHAR(30), pais VARCHAR(50),
  region VARCHAR(50), codigo_postal VARCHAR(10),
  fecha_carga DATETIME DEFAULT GETDATE());

CREATE TABLE staging_jardineria.dbo.stg_empleado (
  ID_empleado INT NOT NULL PRIMARY KEY,
  nombre VARCHAR(50), apellido1 VARCHAR(50), apellido2 VARCHAR(50),
  puesto VARCHAR(50), ID_oficina INT, ID_jefe INT,
  fecha_carga DATETIME DEFAULT GETDATE());

CREATE TABLE staging_jardineria.dbo.stg_categoria_producto (
  Id_Categoria INT NOT NULL PRIMARY KEY,
  Desc_Categoria VARCHAR(50),
  fecha_carga DATETIME DEFAULT GETDATE());

CREATE TABLE staging_jardineria.dbo.stg_cliente (
  ID_cliente INT NOT NULL PRIMARY KEY,
  nombre_cliente VARCHAR(50), ciudad VARCHAR(50), region VARCHAR(50),
  pais VARCHAR(50), codigo_postal VARCHAR(10),
  ID_empleado_rep_ventas INT, limite_credito NUMERIC(15,2),
  fecha_carga DATETIME DEFAULT GETDATE());

CREATE TABLE staging_jardineria.dbo.stg_pedido (
  ID_pedido INT NOT NULL PRIMARY KEY,
  fecha_pedido DATE, fecha_esperada DATE, fecha_entrega DATE,
  estado VARCHAR(15), ID_cliente INT,
  fecha_carga DATETIME DEFAULT GETDATE());

CREATE TABLE staging_jardineria.dbo.stg_producto (
  ID_producto VARCHAR(15) NOT NULL PRIMARY KEY,
  nombre VARCHAR(70), Categoria INT, proveedor VARCHAR(50),
  cantidad_en_stock SMALLINT, precio_venta NUMERIC(15,2), precio_proveedor NUMERIC(15,2),
  fecha_carga DATETIME DEFAULT GETDATE());

CREATE TABLE staging_jardineria.dbo.stg_detalle_pedido (
  ID_pedido INT NOT NULL, ID_producto VARCHAR(15) NOT NULL,
  cantidad INT, precio_unidad NUMERIC(15,2), numero_linea SMALLINT,
  fecha_carga DATETIME DEFAULT GETDATE(),
  PRIMARY KEY (ID_pedido, ID_producto));

CREATE TABLE staging_jardineria.dbo.stg_pago (
  ID_cliente INT NOT NULL, forma_pago VARCHAR(40),
  id_transaccion VARCHAR(50) NOT NULL, fecha_pago DATE, total NUMERIC(15,2),
  fecha_carga DATETIME DEFAULT GETDATE(),
  PRIMARY KEY (ID_cliente, id_transaccion));