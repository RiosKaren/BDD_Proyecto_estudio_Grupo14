# Manejo de tipos de datos JSON dentro de SQL

## Contexto: ¿Qué es JSON?
El tipo de datos **JSON** (**JavaScript Object Notation** o *Notación de Objetos de JavaScript*) es un formato de texto serializado para guardar datos
(especificamente, objetos de **JavaScript**) de manera "legible", proveniente de este mismo lenguaje. Su sintaxis es codigo de JavaScript valido,
el cual define y declara la estructura de un objeto y sus tipos dentro de este.

A pesar de esta relación directa, el formato JSON se utiliza de manera masiva e independiente a JavaScript, dado a que los .json son archivos
de texto con una sintexis legible por cualquier persona, convirtiendolo en un formato altamente portable y adapatable. Se usa tanto para el manejo
de información en la web (empaquetación de datos para enviarse a travez de WebSockets o HTTP, exportación de objetos directamente desde JavaScript
corriendo en un navegador, etc) o localmente (bases de datos, guardado de configuraciones de programas, entre otros).

Es común ver el uso de JSON en Bases de Datos, especialmente en motores NoSQL como MongoDB o Azure Cosmos, pero tambien en aquellas donde se necesite
guardar objetos variados no definidos de manera sencilla y prolija.

## JSON en SQL
JSON no es un tipo de dato dentro del estandar SQL, pero dado a que es un formato de texto, podemos guardarlo en una columna con tipo de dato `NVARCHAR`. La
mayoria de los motores de SQL modernos contienen funciones predefinidas para el "parsing" y manejo de contenido JSON, e incluso tipos de datos nativos a
esos motores (osea, que estan fuera del estandar y no son portables entre sistemas con diferente suites de software).

# JSON en SQL Server: Evolución y Características

## Introducción
En SQL Server, JSON no es considerado un tipo de dato tradicional como `INT` o `VARCHAR`. El soporte para trabajar con JSON fue incorporado a partir de 
**SQL Server 2016**, permitiendo manipular datos semiestructurados dentro de columnas de tipo `NVARCHAR(MAX)`.

## Soporte de JSON en SQL Server
Desde **SQL Server 2016**, se introdujo un conjunto de funciones que permiten leer, escribir y manipular datos semiestructurados en columnas 
tradicionales, específicamente en `NVARCHAR`. Aunque JSON podía ser manipulado y validado mediante funciones integradas, no existía un tipo 
de dato nativo para su almacenamiento.

## Evolución hacia el tipo de dato nativo JSON
A diferencia de otros motores de bases de datos como PostgreSQL con su tipo `jsonb`, SQL Server no contaba con un tipo de dato 
JSON nativo hasta hace poco. Fue con la versión preliminar de **SQL Server 2025** cuando se introdujo un tipo de dato JSON nativo, capaz de 
almacenar documentos en un formato binario optimizado, mejorando el rendimiento y la eficiencia en el manejo de datos JSON.

---

# JSON en SQL Server (2016–2022)

## Almacenamiento
En las versiones comprendidas entre 2016 y 2022, los datos JSON se almacenan como texto dentro de columnas:

- `NVARCHAR(MAX)`
- `NVARCHAR(n)`

Esto se debe a que JSON aún no era reconocido como un tipo de dato nativo, pero SQL Server ya incluía funciones para validarlo y manipularlo.

## Ejemplo de inserción de datos JSON
A continuación se muestra un ejemplo representativo del almacenamiento de JSON en SQL Server:

```sql
INSERT INTO Apunte (id_apunte, id_materia, titulo, contenido)
VALUES (
    1,
    101,
    'Regresión Lineal',
    N'{"introduccion":"Definición","ejemplo":"y = a + bx","tags":["estadística","modelos"]}'
);

--Inserción inváida
INSERT INTO Apunte (id_apunte, id_materia, titulo, contenido)
VALUES (
    2,
    101,
    'Ejemplo Inválido',
    N'Introducción: Definición, Ejemplo: y = a + bx'
);
```
## Ejemplo de consulta
Extraer un campo específico con JSON_VALUE
```sql
SELECT 
    titulo,
    JSON_VALUE(contenido, '$.ejemplo') AS ejemplo_formula
FROM Apunte
WHERE id_apunte = 1;
```
## Ejemplo de actualización 
```sql
UPDATE Apunte
SET contenido = JSON_MODIFY(contenido, '$.ejemplo', 'y = a + bx + c')
WHERE id_apunte = 1;
```
## Ejemplo delete
```sql
UPDATE Apunte
SET contenido = JSON_MODIFY(contenido, 'delete $.tags')
WHERE id_apunte = 2;
```
# Conclusiones:
En conclusión, el soporte de JSON en SQL Server permite integrar datos semiestructurados dentro de un entorno relacional, combinando la flexibilidad del formato JSON con la solidez de las bases de datos tradicionales. Aunque inicialmente se almacenaba como texto en columnas NVARCHAR, las funciones nativas (JSON_VALUE, JSON_QUERY, JSON_MODIFY, OPENJSON) facilitan operaciones CRUD y consultas eficientes. Con la incorporación del tipo de dato JSON nativo en versiones recientes, se logra mayor rendimiento y optimización en escenarios modernos que requieren manejar información estructurada y semiestructurada de manera conjunta.


## Referencias
- Documentación oficial de Microsoft sobre JSON en SQL Server:  
  https://learn.microsoft.com/es-es/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver17
- Documentación en Geeks For Geeks sobre el uso de JSON en SQL:
  https://www.geeksforgeeks.org/sql/working-with-json-in-sql/
- Estandar SQL en el ISO:
  https://www.iso.org/standard/76583.html
- JSON.org:
  https://www.json.org/json-es.html
- Documentación de Mozilla de JSON en MDN Docs:
  https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/JSON