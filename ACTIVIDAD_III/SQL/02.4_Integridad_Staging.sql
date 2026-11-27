SELECT COUNT(*) AS pedidos_sin_cliente FROM staging_jardineria.dbo.stg_pedido p
LEFT JOIN staging_jardineria.dbo.stg_cliente c ON p.ID_cliente = c.ID_cliente WHERE c.ID_cliente IS NULL;

SELECT COUNT(*) AS detalles_sin_producto FROM staging_jardineria.dbo.stg_detalle_pedido d
LEFT JOIN staging_jardineria.dbo.stg_producto p ON d.ID_producto = p.ID_producto WHERE p.ID_producto IS NULL;

SELECT COUNT(*) AS clientes_sin_vendedor FROM staging_jardineria.dbo.stg_cliente WHERE ID_empleado_rep_ventas IS NULL;