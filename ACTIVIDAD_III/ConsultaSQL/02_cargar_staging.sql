INSERT INTO staging_jardineria.dbo.stg_oficina (ID_oficina, Descripcion, ciudad, pais, region, codigo_postal)
SELECT ID_oficina, Descripcion, ciudad, pais, region, codigo_postal FROM jardineria.dbo.oficina;

INSERT INTO staging_jardineria.dbo.stg_empleado (ID_empleado, nombre, apellido1, apellido2, puesto, ID_oficina, ID_jefe)
SELECT ID_empleado, nombre, apellido1, apellido2, puesto, ID_oficina, ID_jefe FROM jardineria.dbo.empleado;

INSERT INTO staging_jardineria.dbo.stg_categoria_producto (Id_Categoria, Desc_Categoria)
SELECT Id_Categoria, Desc_Categoria FROM jardineria.dbo.Categoria_producto;

INSERT INTO staging_jardineria.dbo.stg_cliente (ID_cliente, nombre_cliente, ciudad, region, pais, codigo_postal, ID_empleado_rep_ventas, limite_credito)
SELECT ID_cliente, nombre_cliente, ciudad, region, pais, codigo_postal, ID_empleado_rep_ventas, limite_credito FROM jardineria.dbo.cliente;

INSERT INTO staging_jardineria.dbo.stg_pedido (ID_pedido, fecha_pedido, fecha_esperada, fecha_entrega, estado, ID_cliente)
SELECT ID_pedido, fecha_pedido, fecha_esperada, fecha_entrega, estado, ID_cliente FROM jardineria.dbo.pedido;

INSERT INTO staging_jardineria.dbo.stg_producto (ID_producto, nombre, Categoria, proveedor, cantidad_en_stock, precio_venta, precio_proveedor)
SELECT ID_producto, nombre, Categoria, proveedor, cantidad_en_stock, precio_venta, precio_proveedor FROM jardineria.dbo.producto;

INSERT INTO staging_jardineria.dbo.stg_detalle_pedido (ID_pedido, ID_producto, cantidad, precio_unidad, numero_linea)
SELECT ID_pedido, ID_producto, cantidad, precio_unidad, numero_linea FROM jardineria.dbo.detalle_pedido;

INSERT INTO staging_jardineria.dbo.stg_pago (ID_cliente, forma_pago, id_transaccion, fecha_pago, total)
SELECT ID_cliente, forma_pago, id_transaccion, fecha_pago, total FROM jardineria.dbo.pago;