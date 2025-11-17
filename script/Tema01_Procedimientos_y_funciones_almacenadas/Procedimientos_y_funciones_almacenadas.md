# Procedimientos y funciones almacenadas:
Los procedimientos almacenados y las funciones son dos tipos diferentes de objetos que proporcionan funcionalidades diferentes, aunque similares (cita).
Un procedimiento almacenado puede entenderse como un conjunto de instrucciones y comandos T-SQL precompilados a los que SQL Server puede acceder y ejecutar directamente. Todo el código definido dentro de un procedimiento se procesa como una sola unidad o lote de trabajo.
Esto ofrece una ventaja importante: disminuye el tráfico de red. En lugar de enviar múltiples sentencias T-SQL una por una, basta con enviar el nombre del procedimiento almacenado junto con los parámetros necesarios.
Los procedimientos almacenados no solo permiten ejecutar instrucciones como SELECT, INSERT, UPDATE o DELETE, sino que también pueden invocar a otros procedimientos, emplear estructuras de control de flujo, crear tablas temporales y realizar operaciones agregadas o cálculos complejos.
Cualquier desarrollador con los permisos adecuados para crear objetos en SQL Server puede definir un procedimiento almacenado. Además, SQL Server incluye cientos de procedimientos almacenados del sistema, identificados comúnmente por el prefijo SP
# Procedimientos y funciones almacenadas en SQL Server
Los procedimientos almacenados y las funciones representan dos tipos distintos de objetos en SQL Server, ambos diseñados para ofrecer funcionalidades especializadas aunque comparten ciertas similitudes.
## Procedimientos almacenados
Un procedimiento almacenado consiste en un conjunto de instrucciones y comandos T-SQL que han sido precompilados. Esto significa que SQL Server puede acceder y ejecutar el procedimiento directamente, procesando todo el código definido dentro de él como una sola unidad o lote de trabajo. (Dewson)
Una de las ventajas más relevantes de los procedimientos almacenados es la reducción del tráfico de red. En vez de enviar múltiples sentencias T-SQL una tras otra, basta con enviar el nombre del procedimiento almacenado y los parámetros necesarios para su ejecución.
Los procedimientos almacenados son muy versátiles, ya que permiten ejecutar diversas instrucciones como SELECT, INSERT, UPDATE o DELETE. Asimismo, pueden invocar otros procedimientos, utilizar estructuras de control de flujo, crear tablas temporales y realizar operaciones agregadas o cálculos complejos.
Cualquier desarrollador que cuente con los permisos apropiados para crear objetos en SQL Server está en condiciones de definir un procedimiento almacenado. Además, SQL Server proporciona una amplia variedad de procedimientos almacenados del sistema, los cuales suelen identificarse por un prefijo específico.
No tiene mucho sentido crear un procedimiento almacenado solo para ejecutar un conjunto de sentencias T-SQL una sola vez; por el contrario, un procedimiento almacenado es ideal cuando quieres ejecutar un conjunto de sentencias T-SQL muchas veces (Dewson)
Los procedimientos almacenados le dan a tu aplicación una única interfaz probada para acceder o manipular tus datos. Esto significa que mantienes la integridad de los datos, realizas las modificaciones o selecciones correctas sobre ellos y aseguras que los usuarios de la base de datos no necesiten conocer estructuras, diseños, relaciones o procesos relacionados necesarios para ejecutar una función específica. También puedes validar cualquier entrada de datos y asegurarte de que los datos que ingresan al procedimiento almacenado sean correctos.
## Estructura y elementos principales de un procedimiento almacenado en SQL Server
Para definir un procedimiento almacenado en SQL Server, se debe iniciar siempre con la instrucción CREATE PROCEDURE. Esta instrucción proporciona una sintaxis flexible que extiende las capacidades básicas de T-SQL con comandos adicionales diseñados específicamente para la creación de procedimientos.
### Componentes principales de la sintaxis
- nombre_procedimiento: Es el identificador único que se le asigna al procedimiento almacenado. Permite invocar el procedimiento cada vez que se necesite ejecutar su lógica.
- Parámetros (@param): Permiten recibir valores de entrada o devolver valores de salida, haciendo que el procedimiento sea reutilizable y adaptable a diferentes escenarios.
- OUTPUT: Sirve para devolver valores al llamador del procedimiento, facilitando la comunicación de resultados o datos procesados.
- Valores por defecto: Permiten hacer opcional el envío de ciertos parámetros, proporcionando flexibilidad en la ejecución del procedimiento.
- AS BEGIN ... END: Este bloque delimita el conjunto de instrucciones T-SQL que serán ejecutadas por el procedimiento almacenado. Todo el código a ejecutar se ubica dentro de este bloque.
- SET NOCOUNT ON: Instrucción utilizada para evitar que se devuelvan mensajes de “X filas afectadas” en la ejecución, lo cual mejora el rendimiento, especialmente en procedimientos que ejecutan múltiples operaciones.
- GO: Se utiliza para separar lotes de instrucciones dentro de un script, facilitando la organización y ejecución secuencial de los comandos.
---

### Ejemplo de procedimiento almacenado
A continuación se presenta un ejemplo de cómo se implementa un procedimiento almacenado que encapsula la lógica de inserción en una tabla y protege la integridad de la estructura interna:
```sql
CREATE PROCEDURE InsertarApunte
@id_materia INT,
@titulo VARCHAR(100),
@contenido NVARCHAR(MAX)
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO Apunte (id_materia, titulo, contenido, fecha_creacion)
VALUES (@id_materia, @titulo, @contenido, CAST(GETDATE() AS DATE));
END;
GO
```
Este procedimiento permite insertar un nuevo registro en la tabla Apunte utilizando los parámetros proporcionados, asegurando que los usuarios no necesiten conocer detalles internos de la tabla ni la lógica de inserción específica.

## Capacidades avanzadas de procedimientos almacenados y funciones definidas por el usuario
### Manejo de transacciones en procedimientos almacenados
Los procedimientos almacenados permiten iniciar, confirmar (COMMIT) o revertir (ROLLBACK) transacciones dentro de su ejecución. Esto garantiza la consistencia y atomicidad en operaciones críticas. Por ejemplo, se puede comenzar una transacción para actualizar el nivel educativo de un usuario, y confirmarla al finalizar correctamente:
```sql
BEGIN TRAN;
UPDATE Usuario SET nivel_educativo = 'Universitario' WHERE id_usuario = 1;
COMMIT;
```
### Control de errores con TRY...CATCH
Dentro de los procedimientos almacenados, se puede implementar manejo de errores utilizando las estructuras TRY...CATCH. Esto permite capturar excepciones y registrar errores en tablas de auditoría, facilitando el monitoreo y la depuración. Por ejemplo:
```sql
BEGIN TRY
INSERT INTO Materia(nombre_materia) VALUES ('Estadística');
END TRY
BEGIN CATCH
INSERT INTO LogErrores VALUES (ERROR_MESSAGE(), GETDATE());
END CATCH;
```
### Optimización con parámetros
Los procedimientos almacenados pueden aceptar parámetros para filtrar resultados o modificar la lógica sin necesidad de reescribir el código. Un ejemplo es un procedimiento que devuelve exámenes según el identificador de materia:
```sql
CREATE PROCEDURE ObtenerExamenesPorMateria
@id_materia INT
AS
BEGIN
SELECT * FROM Examen WHERE id_materia = @id_materia;
END;
```
### Encapsulación de lógica compleja
Es posible combinar múltiples operaciones en un solo procedimiento almacenado, como el cálculo de promedios, la actualización de progreso y el registro de auditoría, todo en una sola ejecución. Esto facilita la gestión y el mantenimiento de la lógica de negocio compleja.
## Funciones definidas por el usuario (UDFs)
Las funciones definidas por el usuario son otro tipo de objeto en SQL Server que complementa las capacidades de los procedimientos almacenados.
### Funciones escalares
Estas funciones devuelven un único valor. Por ejemplo, se puede crear una función para calcular el porcentaje de aciertos en una flashcard:
```sql
CREATE FUNCTION CalcularPorcentajeAciertos (@aciertos INT, @errores INT)
RETURNS FLOAT
AS
BEGIN
RETURN (CAST(@aciertos AS FLOAT) / (@aciertos + @errores)) * 100;
END;
```
### Funciones de tabla (Table-Valued Functions, TVF)
Las funciones de tabla devuelven un conjunto de filas, similar a una tabla. Un ejemplo es una función que retorna todas las flashcards de un apunte en formato tabular:
```sql
CREATE FUNCTION ObtenerFlashcardsPorApunte (@id_apunte INT)
RETURNS TABLE
AS
RETURN (
SELECT pregunta, respuesta, aciertos, errores
FROM Flashcard
WHERE id_apunte = @id_apunte
);
```
---

## Ventajas de las funciones frente a los procedimientos almacenados
- Se pueden utilizar directamente en consultas (SELECT).
- Son ideales para cálculos reutilizables y para encapsular lógica que devuelve resultados tabulares.
- A diferencia de los procedimientos, las funciones no permiten manejar transacciones ni control de flujo complejo.
---
## SP VS Consulta directa
Obtener todos los exámenes de una materia específica, filtrando por id_materia
```sql
--Consulta con procedimiento
CREATE PROCEDURE ObtenerDetalleExamenesPorMateria
    @id_materia INT,
    @orden_por_puntaje BIT = 0 -- 1: ordena por puntaje descendente, 0: por fecha ascendente
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        e.id_examen,
        e.fecha,
        e.puntaje,
        e.cantidad_preguntas,
        m.nombre_materia,
        u.nombre AS nombre_usuario,
        p.avance_porcentual
    FROM Examen e
    INNER JOIN Materia m ON e.id_materia = m.id_materia
    INNER JOIN Progreso p ON m.id_materia = p.id_materia
    INNER JOIN Usuario u ON p.id_usuario = u.id_usuario
    WHERE e.id_materia = @id_materia
    ORDER BY 
        CASE WHEN @orden_por_puntaje = 1 THEN e.puntaje END DESC,
        CASE WHEN @orden_por_puntaje = 0 THEN e.fecha END ASC;
END;

```
```sql
--Consulta equivalente
SELECT 
    e.id_examen,
    e.fecha,
    e.puntaje,
    e.cantidad_preguntas,
    m.nombre_materia,
    u.nombre AS nombre_usuario,
    p.avance_porcentual
FROM Examen e
INNER JOIN Materia m ON e.id_materia = m.id_materia
INNER JOIN Progreso p ON m.id_materia = p.id_materia
INNER JOIN Usuario u ON p.id_usuario = u.id_usuario
WHERE e.id_materia = 2
ORDER BY e.puntaje DESC;
```
---
### Resultados de comparación:
```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
EXEC ObtenerDetalleExamenesPorMateria @id_materia = 2, @orden_por_puntaje = 1;
SET STATISTICS TIME OFF;
SET STATISTICS TIME ON;
SELECT 
    e.id_examen,
    e.fecha,
    e.puntaje,
    e.cantidad_preguntas,
    m.nombre_materia,
    u.nombre AS nombre_usuario,
    p.avance_porcentual
FROM Examen e
INNER JOIN Materia m ON e.id_materia = m.id_materia
INNER JOIN Progreso p ON m.id_materia = p.id_materia
INNER JOIN Usuario u ON p.id_usuario = u.id_usuario
WHERE e.id_materia = 2
ORDER BY e.puntaje DESC;
SET STATISTICS TIME OFF;
```
---

SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 3 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
Table 'Examen'. Scan count 1, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Usuario'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Progreso'. Scan count 1, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Materia'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 4 ms.

(1 fila afectada)
Table 'Examen'. Scan count 1, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Usuario'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Progreso'. Scan count 1, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
Table 'Materia'. Scan count 0, logical reads 2, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

---

La ejecución del procedimiento almacenado y la consulta directa arrojó tiempos muy similares, con diferencias mínimas (0 ms vs. 4 ms). Aunque el impacto en este caso es insignificante debido al bajo volumen de datos, la comparación demuestra que sí existe una diferencia en la forma en que SQL Server procesa ambos enfoques.
El procedimiento almacenado aprovecha la caché del plan de ejecución, lo que le otorga mayor estabilidad y eficiencia en escenarios repetitivos o con grandes volúmenes de información. La consulta directa, en cambio, genera planes ad hoc que pueden variar y consumir más recursos cuando se ejecutan con parámetros distintos.

# Conclusiones
Los procedimientos y funciones almacenados en SQL Server son herramientas poderosas que permiten a los desarrolladores encapsular lógica compleja y reutilizable dentro de la base de datos. Los procedimientos almacenados, al ser precompilados, ofrecen ventajas significativas como la reducción del tráfico de red y la mejora del rendimiento al ejecutar múltiples instrucciones T-SQL como una sola unidad . Además, permiten manejar transacciones, controlar errores y optimizar el uso de parámetros, lo que garantiza la consistencia y la integridad de los datos . Por otro lado, las funciones definidas por el usuario (UDFs) proporcionan una forma eficiente de realizar cálculos y transformaciones de datos dentro de las consultas SQL . Las funciones escalares devuelven un único valor, mientras que las funciones de tabla (TVF) pueden devolver conjuntos de filas, lo que las hace ideales para encapsular lógica que necesita ser reutilizada en múltiples consultas . Aunque las funciones no permiten manejar transacciones ni control de flujo complejo, su capacidad para ser utilizadas directamente en consultas (SELECT, WHERE, JOIN, APPLY) las hace extremadamente útiles para cálculos reutilizables . En resumen, tanto los procedimientos almacenados como las funciones en SQL Server son esenciales para el desarrollo de aplicaciones robustas y eficientes, permitiendo a los desarrolladores mantener la integridad de los datos y optimizar el rendimiento de las consultas.

---

## Referencias
- Dewson, R. (s.f.). SQL Server for Developers - Fourth Edition. Apress.
- https://learn.microsoft.com/es-es/sql/relational-databases/stored-procedures/stored-procedures-database-engine?view=sql-server-ver17
- https://learn.microsoft.com/es-es/sql/relational-databases/user-defined-functions/user-defined-functions?view=sql-server-ver17












