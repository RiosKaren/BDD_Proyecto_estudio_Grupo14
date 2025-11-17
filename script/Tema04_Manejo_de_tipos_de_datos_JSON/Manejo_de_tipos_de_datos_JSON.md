# JSON en SQL Server: Evolución y Características

## Introducción
En SQL Server, JSON no es considerado un tipo de dato tradicional como `INT` o `VARCHAR`. El soporte para trabajar con JSON fue incorporado a partir de 
**SQL Server 2016**, permitiendo manipular datos semiestructurados dentro de columnas de tipo `NVARCHAR(MAX)`.

## ¿Qué es JSON?
**JSON (JavaScript Object Notation)** es un formato ligero y basado en texto para el intercambio de datos. Su estructura permite representar objetos 
y arreglos de manera organizada y sencilla, facilitando la transferencia y almacenamiento de información entre sistemas.

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
## Referencias
- Documentación oficial de Microsoft sobre JSON en SQL Server:  
  https://learn.microsoft.com/es-es/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver17

