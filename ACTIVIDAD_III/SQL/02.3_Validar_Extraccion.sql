SELECT 'oficina' tabla, (SELECT COUNT(*) FROM jardineria.dbo.oficina) origen, (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_oficina) staging
UNION ALL SELECT 'empleado', (SELECT COUNT(*) FROM jardineria.dbo.empleado), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_empleado)
UNION ALL SELECT 'categoria', (SELECT COUNT(*) FROM jardineria.dbo.Categoria_producto), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_categoria_producto)
UNION ALL SELECT 'cliente', (SELECT COUNT(*) FROM jardineria.dbo.cliente), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_cliente)
UNION ALL SELECT 'pedido', (SELECT COUNT(*) FROM jardineria.dbo.pedido), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_pedido)
UNION ALL SELECT 'producto', (SELECT COUNT(*) FROM jardineria.dbo.producto), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_producto)
UNION ALL SELECT 'detalle_pedido', (SELECT COUNT(*) FROM jardineria.dbo.detalle_pedido), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_detalle_pedido)
UNION ALL SELECT 'pago', (SELECT COUNT(*) FROM jardineria.dbo.pago), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_pago);

SELECT (SELECT SUM(total) FROM jardineria.dbo.pago) origen_pago,
       (SELECT SUM(total) FROM staging_jardineria.dbo.stg_pago) staging_pago;