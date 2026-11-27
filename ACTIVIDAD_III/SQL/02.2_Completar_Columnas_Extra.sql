UPDATE s SET s.dimensiones = p.dimensiones
FROM staging_jardineria.dbo.stg_producto s
JOIN jardineria.dbo.producto p ON p.ID_producto = s.ID_producto;

UPDATE s SET s.descripcion_texto = c.descripcion_texto, s.Desc_Categoria = c.Desc_Categoria
FROM staging_jardineria.dbo.stg_categoria_producto s
JOIN jardineria.dbo.Categoria_producto c ON c.Id_Categoria = s.Id_Categoria;

UPDATE s SET s.nombre_contacto = c.nombre_contacto, s.apellido_contacto = c.apellido_contacto
FROM staging_jardineria.dbo.stg_cliente s
JOIN jardineria.dbo.cliente c ON c.ID_cliente = s.ID_cliente;