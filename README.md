# Proyecto Integrador – Data Mart de Ventas para Jardinería

Aquí reunimos en un solo lugar, todo lo que construimos durante el curso, desde el diseño del modelo estrella hasta las pruebas de calidad de datos.

## Introducción

Las empresas guardan muchísima información sobre lo que venden, pero tenerla guardada no significa que sea fácil de aprovechar. La base de datos Jardinería es un buen ejemplo: sirve para registrar el día a día (clientes, pedidos, productos, pagos), pero responder una pregunta tan simple como cuál es el producto más vendido obliga a armar consultas largas con varios `JOIN`.

En este proyecto resolvimos ese problema construyendo un Data Mart de ventas con modelo estrella. Pasamos por todo el camino: diseñamos el modelo, creamos una base de staging para limpiar los datos sin tocar el origen, hicimos el proceso ETL hasta cargar el Data Mart y, como cierre, agregamos pruebas para comprobar la calidad de los datos. Este repositorio reúne todos los informes, scripts, diagramas y respaldos de esas actividades en un solo lugar.

## ¿De qué trató la materia?

Bases de Datos II nos llevó a ver una base de datos desde el punto de vista del **análisis** y no solo del registro diario. Partimos de **Jardinería**, una base transaccional (OLTP) con oficinas, empleados, clientes, pedidos, productos y pagos, y la convertimos paso a paso en un **Data Mart** capaz de responder preguntas de negocio como *¿cuál es el producto más vendido?* sin tener que armar consultas largas con muchos `JOIN`.

En el camino trabajamos estos temas:

- **Modelo dimensional (estrella):** tabla de hechos, dimensiones, grano y llaves sustitutas (Kimball y Ross, 2013).
- **Staging:** una base intermedia donde se copian los datos del origen para limpiarlos sin tocar la base original.
- **Proceso ETL:** extracción, transformación y carga de los datos.
- **Calidad de datos:** comprobar que lo cargado esté completo, sin duplicados, consistente y con sentido.
- **Backups:** respaldar cada etapa para poder restaurarla.
- **Control de versiones con Git y GitHub:** este repositorio.

## Cómo trabajamos

Lo hicimos en cuatro etapas, una detrás de otra, y cada una quedó en su propia carpeta. Primero diseñamos el modelo estrella para saber qué datos necesitábamos. Luego copiamos los datos de Jardinería a una base de staging, donde pudimos limpiarlos sin tocar el origen. De ahí los cargamos al Data Mart, y al final probamos la calidad de los datos en todo el recorrido para confirmar que no se perdió ni se dañó nada.

## Cómo organizamos las carpetas

```text
ProyectoIntegrador_Jardineria/
├── README.md
├── ACTIVIDAD_I/          Modelo estrella
│   ├── Informe (Word y PDF)
│   ├── modelo_estrella.jpeg
│   └── SQL.rar
├── ACTIVIDAD_II/         Base de datos Staging
│   ├── Informe (Word y PDF)
│   ├── 01_crear_staging.sql
│   ├── 02_cargar_staging.sql
│   ├── Crear Tablas.sql
│   ├── Staging.rar
│   └── Backup/
├── ACTIVIDAD_III/        Proceso ETL y Data Mart
│   ├── Informe (Word y PDF)
│   ├── EA3_Grupo#25_ProcesoETL.zip
│   └── SQL/
├── Backup/               Respaldos de las bases de datos (.bak)
└── Pruebas_Calidad/      Pruebas de calidad de datos
    ├── Pruebas_Calidad.sql
    └── Resultados.png
```

Organizamos el repositorio siguiendo el mismo orden en que hicimos el trabajo: una carpeta por cada actividad (`ACTIVIDAD_I`, `ACTIVIDAD_II` y `ACTIVIDAD_III`), de modo que se leen en el orden del proceso, del modelo al Data Mart.

- En cada carpeta de actividad dejamos el informe que entregamos y los archivos que lo acompañan (scripts, diagramas y comprimidos), para que cada una se entienda por separado.
- Los respaldos de las bases de datos (`.bak`: Jardineria, Staging_Jardineria y Datamart_Jardineria) están en `Backup/`, aparte de las actividades, porque son archivos pesados y sirven para restaurar las bases.
- Las pruebas de calidad de datos tienen su propia carpeta, `Pruebas_Calidad/`, como pide la actividad, con el script de las pruebas y una captura con los resultados.
- En la raíz solo está este `README.md`, que es la puerta de entrada al proyecto.

## Las actividades

### Modelo estrella (`ACTIVIDAD_I`)
Analizamos las ocho tablas de Jardinería y diseñamos un Data Mart de ventas. El **grano** es una línea de pedido: un producto vendido dentro de un pedido en una fecha. El modelo tiene **6 dimensiones** (tiempo, producto, categoría, cliente, empleado y estado del pedido) y una tabla de hechos, `fact_ventas`, con las medidas `cantidad`, `importe_total`, `costo_total` y `margen`. Lo implementamos en MySQL 8.4 para comprobar que responde las preguntas de negocio.

### Staging (`ACTIVIDAD_II`)
Creamos la base `Staging_Jardineria`, cargamos los datos del origen y validamos que todo llegara bien: conteos de registros origen vs. destino, sumas de control y revisión de integridad. También hicimos y verificamos los backups.

### Proceso ETL y Data Mart (`ACTIVIDAD_III`)
Aplicamos limpieza y normalización en Staging (quitar espacios sobrantes, reemplazar vacíos por etiquetas como *Sin región* o *N/A*, y unificar los países al español). Después creamos `Datamart_Jardineria`, cargamos primero las dimensiones y luego los hechos, y validamos con una suma de control del importe.

**Orden de ejecución de los scripts** (carpeta `ACTIVIDAD_III/SQL`):

| Paso | Script | ¿Qué hace? |
|---|---|---|
| 1 | `1.1_VerificacionStaging_completo_consistente.sql` | Verifica que Staging esté completo |
| 2 | `02.1_Recargar_tablasStaging_Cambiadas.sql` | Recarga las tablas que cambiaron |
| 3 | `02.2_Completar_Columnas_Extra.sql` | Llena las columnas que faltaban para el modelo |
| 4 | `02.3_Validar_Extraccion.sql` | Compara conteos y sumas entre origen y Staging |
| 5 | `02.4_Integridad_Staging.sql` | Busca registros huérfanos en Staging |
| 6 | `03.1_Limpieza_Normalizacion.sql` | Limpia y normaliza los datos |
| 7 | `4.1_Creacion_datamart_jardineria.sql` | Crea la base del Data Mart |
| 8 | `04.2_Crear_Dimensiones_Hechos.sql` | Crea las 6 dimensiones y la tabla de hechos |
| 9 | `05.1_Cargar_Dimensiones.sql` | Carga las dimensiones |
| 10 | `05.1_Cargar_Hechos.sql` | Carga `fact_ventas` |

### Pruebas de calidad de datos (`Pruebas_Calidad`)
Es el cierre del proyecto. En esta carpeta dejamos el script con las pruebas (`Pruebas_Calidad.sql`) y una captura con los resultados (`Resultados.png`). El detalle de qué se comprueba está en la sección siguiente.

## Qué tipo de pruebas se realizaron

Hicimos 20 pruebas en total, todas en el script `Pruebas_Calidad.sql`. Se ejecutan juntas y devuelven una tabla con el tipo de prueba, el valor esperado, el valor obtenido y el estado (**OK** o **FALLA**). Las pruebas cubren los datos en todo el recorrido: Jardinería (origen), Staging y Data Mart. Las agrupamos en seis tipos:

| Tipo de prueba | ¿Qué comprobamos? |
|---|---|
| **Completitud** | Que no haya valores vacíos en campos clave: clientes sin país, productos sin proveedor y ventas sin costo |
| **Consistencia** | Que los conteos de detalles coincidan entre Jardinería, Staging y el Data Mart, y que el importe de las ventas y la suma de los pagos no cambien al pasar de una base a otra |
| **Exactitud** | Que `importe_total` sea igual a cantidad por precio, y que `margen` sea igual a importe menos costo |
| **Integridad** | Que no haya pedidos sin cliente, detalles sin producto ni hechos sin dimensión de tiempo |
| **Unicidad** | Que no haya clientes duplicados (en el origen y en Staging) ni detalles duplicados en `fact_ventas` |
| **Validez** | Que no haya cantidades menores o iguales a cero ni precios negativos, que las fechas tengan sentido y que no haya líneas con margen negativo |

### Resultados

De las 20 pruebas, 16 salieron **OK** y 4 salieron **FALLA**. La captura completa está en `Pruebas_Calidad/Resultados.png`.

Todas las pruebas que revisan la carga (conteos, sumas de control, integridad y cálculo de las medidas) dieron OK, lo que quiere decir que el proceso ETL no perdió ni alteró datos. Las cuatro que fallaron muestran problemas que ya venían en los datos originales de Jardinería, y no errores de la carga:

| Prueba | Resultado |
|---|---|
| Clientes duplicados en Jardinería (origen) | 1 |
| Pedidos entregados sin fecha de entrega | 3 |
| Pedidos con fecha esperada anterior a la fecha del pedido | 4 |
| Líneas de venta con margen negativo | 8 |

Dejamos estos casos documentados como hallazgos. Corregirlos implicaría cambiar los datos del sistema de origen, algo que está fuera del alcance de este proyecto.

## Lo que descubrimos con el Data Mart

| Pregunta de negocio | Respuesta |
|---|---|
| Producto más vendido (unidades) | **Thymus Vulgaris (AR-009)**, con 961 unidades |
| Categoría con más productos | **Ornamentales**, con 154 de los 276 productos |
| Año con más ventas | **2008**, con 96.535 u. m. en ventas efectivas |

Y algunas cosas que encontramos en la calidad de los datos:

- Hay pedidos en tres estados: 61 entregados, 30 pendientes y 24 rechazados, por eso `dim_estado_pedido` tiene el indicador `es_venta_efectiva`.
- 13 pedidos no tienen líneas de detalle y el pedido 101 tiene una línea repetida.
- La categoría *Herbáceas* no tiene productos y 129 de los 276 productos nunca se han vendido.

## Tecnologías

- SQL Server (ETL y Data Mart)
- MySQL 8.4 (validación del modelo estrella)
- Git y GitHub (control de versiones)
- El diagrama del modelo estrella está en la carpeta `ACTIVIDAD_I`

## Lo que aprendimos

- Que **no basta con mover los datos** de un lugar a otro: hay que limpiarlos, validarlos y comprobar que quedaron completos.
- Que definir bien el **grano** del modelo es la decisión que más pesa en un diseño dimensional.
- Que tener un Staging nos permite equivocarnos y repetir el proceso sin dañar la base original.
- Que probar la calidad de los datos con un script nos da confianza en que los resultados son confiables.

## Autores

- **Sara Gabriela Castro Mora**
- **Santiago Pérez Pino** 

---

