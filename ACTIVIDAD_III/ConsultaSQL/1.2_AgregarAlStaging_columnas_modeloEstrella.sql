ALTER TABLE staging_jardineria.dbo.stg_producto ADD dimensiones VARCHAR(25) NULL;
ALTER TABLE staging_jardineria.dbo.stg_categoria_producto ADD descripcion_texto VARCHAR(MAX) NULL;
ALTER TABLE staging_jardineria.dbo.stg_cliente ADD nombre_contacto VARCHAR(30) NULL, apellido_contacto VARCHAR(30) NULL;