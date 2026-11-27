CREATE TABLE datamart_jardineria.dbo.dim_tiempo (
  sk_tiempo INT NOT NULL PRIMARY KEY,          -- formato AAAAMMDD
  fecha DATE NOT NULL UNIQUE,
  anio SMALLINT, semestre TINYINT, trimestre TINYINT, mes TINYINT,
  nombre_mes VARCHAR(15), dia TINYINT, dia_semana VARCHAR(15));

CREATE TABLE datamart_jardineria.dbo.dim_producto (
  sk_producto INT IDENTITY(1,1) PRIMARY KEY,
  id_producto VARCHAR(15) NOT NULL UNIQUE,     -- llave natural
  codigo_producto VARCHAR(15), nombre_producto VARCHAR(70),
  nombre_categoria VARCHAR(50), proveedor VARCHAR(50), dimensiones VARCHAR(25),
  precio_venta DECIMAL(15,2), precio_proveedor DECIMAL(15,2));

CREATE TABLE datamart_jardineria.dbo.dim_categoria (
  sk_categoria INT IDENTITY(1,1) PRIMARY KEY,
  id_categoria INT NOT NULL UNIQUE,            -- llave natural
  nombre_categoria VARCHAR(50), descripcion VARCHAR(MAX));

CREATE TABLE datamart_jardineria.dbo.dim_cliente (
  sk_cliente INT IDENTITY(1,1) PRIMARY KEY,
  id_cliente INT NOT NULL UNIQUE,              -- llave natural
  nombre_cliente VARCHAR(50), nombre_contacto VARCHAR(61),
  ciudad VARCHAR(50), region VARCHAR(50), pais VARCHAR(50),
  limite_credito DECIMAL(15,2));

CREATE TABLE datamart_jardineria.dbo.dim_empleado (
  sk_empleado INT IDENTITY(1,1) PRIMARY KEY,
  id_empleado INT NOT NULL UNIQUE,             -- llave natural
  nombre_completo VARCHAR(152), puesto VARCHAR(50), oficina VARCHAR(10),
  ciudad_oficina VARCHAR(30), pais_oficina VARCHAR(50));

CREATE TABLE datamart_jardineria.dbo.dim_estado_pedido (
  sk_estado TINYINT IDENTITY(1,1) PRIMARY KEY,
  estado VARCHAR(15) NOT NULL UNIQUE,
  es_venta_efectiva BIT);

CREATE TABLE datamart_jardineria.dbo.fact_ventas (
  sk_venta BIGINT IDENTITY(1,1) PRIMARY KEY,
  sk_tiempo INT NOT NULL REFERENCES datamart_jardineria.dbo.dim_tiempo(sk_tiempo),
  sk_producto INT NOT NULL REFERENCES datamart_jardineria.dbo.dim_producto(sk_producto),
  sk_categoria INT NOT NULL REFERENCES datamart_jardineria.dbo.dim_categoria(sk_categoria),
  sk_cliente INT NOT NULL REFERENCES datamart_jardineria.dbo.dim_cliente(sk_cliente),
  sk_empleado INT NOT NULL REFERENCES datamart_jardineria.dbo.dim_empleado(sk_empleado),
  sk_estado TINYINT NOT NULL REFERENCES datamart_jardineria.dbo.dim_estado_pedido(sk_estado),
  id_detalle_pedido INT NOT NULL UNIQUE,
  id_pedido INT NOT NULL,                      -- dimensión degenerada
  numero_linea SMALLINT NOT NULL,
  cantidad INT NOT NULL CHECK (cantidad > 0),
  precio_unidad DECIMAL(15,2),
  importe_total DECIMAL(15,2),
  costo_total DECIMAL(15,2),
  margen DECIMAL(15,2));