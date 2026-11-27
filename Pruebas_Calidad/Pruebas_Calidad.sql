SELECT * FROM (

SELECT 'Completitud' tipo, 'fact_ventas sin costo' prueba, 0 esperado,
  (SELECT COUNT(*) FROM datamart_jardineria.dbo.fact_ventas WHERE costo_total IS NULL) obtenido
UNION ALL SELECT 'Completitud', 'dim_cliente sin pais', 0,
  (SELECT COUNT(*) FROM datamart_jardineria.dbo.dim_cliente WHERE pais IS NULL OR pais = '')
UNION ALL SELECT 'Completitud', 'dim_producto sin proveedor', 0,
  (SELECT COUNT(*) FROM datamart_jardineria.dbo.dim_producto WHERE proveedor IS NULL OR proveedor = '')


UNION ALL SELECT 'Unicidad', 'Clientes duplicados en Jardineria (origen)', 0,
  (SELECT COUNT(*) FROM (SELECT nombre_cliente FROM jardineria.dbo.cliente GROUP BY nombre_cliente HAVING COUNT(*) > 1) x)
UNION ALL SELECT 'Unicidad', 'Clientes duplicados en Staging', 0,
  (SELECT COUNT(*) FROM (SELECT nombre_cliente FROM staging_jardineria.dbo.stg_cliente GROUP BY nombre_cliente HAVING COUNT(*) > 1) x)
UNION ALL SELECT 'Unicidad', 'Detalles duplicados en fact_ventas', 0,
  (SELECT COUNT(*) FROM (SELECT id_pedido, sk_producto FROM datamart_jardineria.dbo.fact_ventas GROUP BY id_pedido, sk_producto HAVING COUNT(*) > 1) x)


UNION ALL SELECT 'Integridad', 'Pedidos sin cliente (Staging)', 0,
  (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_pedido p LEFT JOIN staging_jardineria.dbo.stg_cliente c ON c.ID_cliente = p.ID_cliente WHERE c.ID_cliente IS NULL)
UNION ALL SELECT 'Integridad', 'Detalles sin producto (Staging)', 0,
  (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_detalle_pedido d LEFT JOIN staging_jardineria.dbo.stg_producto p ON p.ID_producto = d.ID_producto WHERE p.ID_producto IS NULL)
UNION ALL SELECT 'Integridad', 'Hechos sin dimension tiempo', 0,
  (SELECT COUNT(*) FROM datamart_jardineria.dbo.fact_ventas f LEFT JOIN datamart_jardineria.dbo.dim_tiempo t ON t.sk_tiempo = f.sk_tiempo WHERE t.sk_tiempo IS NULL)


UNION ALL SELECT 'Consistencia', 'Detalles: Jardineria vs Staging (diferencia)', 0,
  (SELECT (SELECT COUNT(*) FROM jardineria.dbo.detalle_pedido) - (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_detalle_pedido))
UNION ALL SELECT 'Consistencia', 'Detalles: Staging vs fact_ventas (diferencia)', 0,
  (SELECT (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_detalle_pedido) - (SELECT COUNT(*) FROM datamart_jardineria.dbo.fact_ventas))
UNION ALL SELECT 'Consistencia', 'Importe: Staging vs Data Mart (diferencia)', 0,
  (SELECT CAST((SELECT SUM(cantidad*precio_unidad) FROM staging_jardineria.dbo.stg_detalle_pedido) - (SELECT SUM(importe_total) FROM datamart_jardineria.dbo.fact_ventas) AS INT))
UNION ALL SELECT 'Consistencia', 'Pagos: Jardineria vs Staging (diferencia de suma)', 0,
  (SELECT CAST((SELECT SUM(total) FROM jardineria.dbo.pago) - (SELECT SUM(total) FROM staging_jardineria.dbo.stg_pago) AS INT))


UNION ALL SELECT 'Validez', 'Cantidades <= 0', 0,
  (SELECT COUNT(*) FROM datamart_jardineria.dbo.fact_ventas WHERE cantidad <= 0)
UNION ALL SELECT 'Validez', 'Precios negativos', 0,
  (SELECT COUNT(*) FROM datamart_jardineria.dbo.fact_ventas WHERE precio_unidad < 0)
UNION ALL SELECT 'Validez', 'Fecha esperada anterior a fecha de pedido', 0,
  (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_pedido WHERE fecha_esperada < fecha_pedido)
UNION ALL SELECT 'Validez', 'Entregados sin fecha de entrega', 0,
  (SELECT COUNT(*) FROM staging_jardineria.dbo.stg_pedido WHERE estado = 'Entregado' AND fecha_entrega IS NULL)
UNION ALL SELECT 'Validez', 'Lineas con margen negativo', 0,
  (SELECT COUNT(*) FROM datamart_jardineria.dbo.fact_ventas WHERE margen < 0)


UNION ALL SELECT 'Exactitud', 'importe_total distinto de cantidad x precio', 0,
  (SELECT COUNT(*) FROM datamart_jardineria.dbo.fact_ventas WHERE importe_total <> cantidad * precio_unidad)
UNION ALL SELECT 'Exactitud', 'margen distinto de importe - costo', 0,
  (SELECT COUNT(*) FROM datamart_jardineria.dbo.fact_ventas WHERE margen <> importe_total - costo_total)
) r
CROSS APPLY (SELECT CASE WHEN r.obtenido = r.esperado THEN 'OK' ELSE 'FALLA' END AS estado) e
ORDER BY tipo, prueba;