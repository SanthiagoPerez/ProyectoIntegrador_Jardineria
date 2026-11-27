DELETE FROM staging_jardineria.dbo.stg_pago;
DELETE FROM staging_jardineria.dbo.stg_detalle_pedido;
DELETE FROM staging_jardineria.dbo.stg_producto;

INSERT INTO staging_jardineria.dbo.stg_producto (ID_producto, nombre, Categoria, proveedor, cantidad_en_stock, precio_venta, precio_proveedor)
SELECT ID_producto, nombre, Categoria, proveedor, cantidad_en_stock, precio_venta, precio_proveedor FROM jardineria.dbo.producto;

INSERT INTO staging_jardineria.dbo.stg_detalle_pedido (ID_pedido, ID_producto, cantidad, precio_unidad, numero_linea)
SELECT ID_pedido, ID_producto, cantidad, precio_unidad, numero_linea FROM jardineria.dbo.detalle_pedido;

INSERT INTO staging_jardineria.dbo.stg_pago (ID_cliente, forma_pago, id_transaccion, fecha_pago, total)
SELECT ID_cliente, forma_pago, id_transaccion, fecha_pago, total FROM jardineria.dbo.pago;