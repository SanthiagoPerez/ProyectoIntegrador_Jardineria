INSERT INTO datamart_jardineria.dbo.fact_ventas
  (sk_tiempo, sk_producto, sk_categoria, sk_cliente, sk_empleado, sk_estado,
   id_detalle_pedido, id_pedido, numero_linea, cantidad, precio_unidad,
   importe_total, costo_total, margen)
SELECT
  CONVERT(INT, CONVERT(CHAR(8), p.fecha_pedido, 112)),
  dp.sk_producto, dc.sk_categoria, dcl.sk_cliente, de.sk_empleado, des.sk_estado,
  ROW_NUMBER() OVER (ORDER BY d.ID_pedido, d.numero_linea),
  d.ID_pedido, d.numero_linea, d.cantidad, d.precio_unidad,
  d.cantidad * d.precio_unidad,
  d.cantidad * pr.precio_proveedor,
  d.cantidad * d.precio_unidad - d.cantidad * pr.precio_proveedor
FROM staging_jardineria.dbo.stg_detalle_pedido d
JOIN staging_jardineria.dbo.stg_pedido p    ON p.ID_pedido = d.ID_pedido
JOIN staging_jardineria.dbo.stg_producto pr ON pr.ID_producto = d.ID_producto
JOIN staging_jardineria.dbo.stg_cliente c   ON c.ID_cliente = p.ID_cliente
JOIN datamart_jardineria.dbo.dim_producto dp       ON dp.id_producto = pr.ID_producto
JOIN datamart_jardineria.dbo.dim_categoria dc      ON dc.id_categoria = pr.Categoria
JOIN datamart_jardineria.dbo.dim_cliente dcl       ON dcl.id_cliente = c.ID_cliente
JOIN datamart_jardineria.dbo.dim_empleado de       ON de.id_empleado = c.ID_empleado_rep_ventas
JOIN datamart_jardineria.dbo.dim_estado_pedido des ON des.estado = p.estado;