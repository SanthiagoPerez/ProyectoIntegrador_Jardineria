SELECT 'cliente' tabla, (SELECT COUNT(*) FROM jardineria.dbo.cliente) origen, (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_cliente) staging
UNION ALL SELECT 'pedido', (SELECT COUNT(*) FROM jardineria.dbo.pedido), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_pedido)
UNION ALL SELECT 'detalle_pedido', (SELECT COUNT(*) FROM jardineria.dbo.detalle_pedido), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_detalle_pedido)
UNION ALL SELECT 'producto', (SELECT COUNT(*) FROM jardineria.dbo.producto), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_producto)
UNION ALL SELECT 'empleado', (SELECT COUNT(*) FROM jardineria.dbo.empleado), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_empleado)
UNION ALL SELECT 'oficina', (SELECT COUNT(*) FROM jardineria.dbo.oficina), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_oficina)
UNION ALL SELECT 'categoria', (SELECT COUNT(*) FROM jardineria.dbo.Categoria_producto), (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_categoria_producto);