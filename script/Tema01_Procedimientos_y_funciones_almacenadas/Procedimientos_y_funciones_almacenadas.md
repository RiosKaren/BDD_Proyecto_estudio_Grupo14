# Procedimientos y funciones almacenadas

Los procedimientos almacenados y las funciones son dos tipos diferentes de objetos que proporcionan funcionalidades diferentes, 
aunque similares. (Dewson)
Un procedimiento almacenado puede entenderse como un conjunto de instrucciones y comandos **T-SQL precompilados** a los que SQL Server puede acceder y 
ejecutar directamente. Todo el código definido dentro de un procedimiento se procesa como una sola unidad o lote de trabajo.
Esto ofrece una ventaja importante: **disminuye el tráfico de red**. En lugar de enviar múltiples sentencias T-SQL una por una, basta con enviar 
el nombre del procedimiento almacenado junto con los parámetros necesarios.

Los procedimientos almacenados no solo permiten ejecutar instrucciones como `SELECT`, `INSERT`, `UPDATE` o `DELETE`, sino que también pueden:
- Invocar otros procedimientos
- Emplear estructuras de control de flujo
- Crear tablas temporales
- Realizar operaciones agregadas o cálculos complejos

Cualquier desarrollador con los permisos adecuados para crear objetos en SQL Server puede definir un procedimiento almacenado. Además, SQL Server 
incluye cientos de procedimientos almacenados del sistema, identificados comúnmente por un prefijo.

---

## Procedimientos y funciones almacenadas en SQL Server

Los procedimientos almacenados y las funciones representan dos tipos distintos de objetos en SQL Server, ambos diseñados para ofrecer 
funcionalidades especializadas aunque comparten ciertas similitudes.

### Procedimientos almacenados

Un procedimiento almacenado consiste en un conjunto de instrucciones y comandos T-SQL que han sido precompilados. 
Esto significa que SQL Server puede acceder y ejecutar el procedimiento directamente, procesando todo el código definido dentro de él como 
una sola unidad o lote de trabajo. (Dewson)

**Ventajas principales:**
- Reducción del tráfico de red
- Versatilidad para ejecutar múltiples operaciones
- Encapsulación de lógica compleja
- Validación de datos de entrada
- Seguridad mediante permisos `EXECUTE`

No tiene mucho sentido crear un procedimiento almacenado solo para ejecutar un conjunto de sentencias T-SQL una sola vez; por el contrario, 
un procedimiento almacenado es ideal cuando quieres ejecutar un conjunto de sentencias T-SQL muchas veces (Dewson).

Los procedimientos almacenados le dan a tu aplicación una **única interfaz probada** para acceder o manipular tus datos. Esto significa que:
- Mantienes la integridad de los datos
- Realizas las modificaciones correctas
- Evitas que los usuarios necesiten conocer estructuras internas
- Validas cualquier entrada de datos

---

## Estructura y elementos principales de un procedimiento almacenado en SQL Server

Para definir un procedimiento almacenado en SQL Server, se debe iniciar siempre con la instrucción `CREATE PROCEDURE`. Esta instrucción proporciona una sintaxis flexible que extiende las capacidades básicas de T-SQL con comandos adicionales.

**Componentes principales de la sintaxis:**
- **nombre_procedimiento**: identificador único del procedimiento.
- **Parámetros (@param)**: valores de entrada o salida.
- **OUTPUT**: devuelve valores al llamador.
- **Valores por defecto**: hacen opcional el envío de parámetros.
- **AS BEGIN ... END**: bloque de instrucciones T-SQL.
- **SET NOCOUNT ON**: evita mensajes de “X filas afectadas”.
- **GO**: separa lotes de instrucciones.

### Ejemplo de procedimiento almacenado

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
