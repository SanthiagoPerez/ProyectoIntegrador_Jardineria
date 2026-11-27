UPDATE staging_jardineria.dbo.stg_cliente SET
  nombre_cliente  = LTRIM(RTRIM(nombre_cliente)),
  nombre_contacto = LTRIM(RTRIM(nombre_contacto)),
  apellido_contacto = LTRIM(RTRIM(apellido_contacto)),
  ciudad = LTRIM(RTRIM(ciudad)),
  region = ISNULL(NULLIF(LTRIM(RTRIM(region)), ''), 'Sin región'),
  pais   = ISNULL(NULLIF(LTRIM(RTRIM(pais)), ''), 'Sin país');

UPDATE staging_jardineria.dbo.stg_producto SET
  nombre = LTRIM(RTRIM(nombre)),
  proveedor = ISNULL(NULLIF(LTRIM(RTRIM(proveedor)), ''), 'Sin proveedor'),
  dimensiones = ISNULL(NULLIF(LTRIM(RTRIM(dimensiones)), ''), 'N/A');

UPDATE staging_jardineria.dbo.stg_empleado SET
  nombre = LTRIM(RTRIM(nombre)),
  apellido1 = LTRIM(RTRIM(apellido1)),
  apellido2 = NULLIF(LTRIM(RTRIM(apellido2)), ''),
  puesto = ISNULL(NULLIF(LTRIM(RTRIM(puesto)), ''), 'Sin puesto');

-- Normalizamos los nombres del país de los 
-- clientes que estan en inglés con las oficinas en español
UPDATE staging_jardineria.dbo.stg_cliente SET pais = CASE pais
  WHEN 'Spain' THEN 'España'
  WHEN 'USA' THEN 'EEUU'
  WHEN 'France' THEN 'Francia'
  WHEN 'United Kingdom' THEN 'Inglaterra'
  ELSE pais END;