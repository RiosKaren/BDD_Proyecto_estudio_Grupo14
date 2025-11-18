# Manejo de Transacciones y Transacciones Anidadas

## INTRODUCCIÓN

En el contexto de bases de datos relacionales, garantizar la consistencia e integridad de los datos es fundamental. Las transacciones proporcionan un mecanismo robusto para asegurar que las operaciones complejas se ejecuten de manera confiable, incluso ante fallos del sistema o errores en la ejecución.

El manejo adecuado de transacciones permite que múltiples operaciones se traten como una unidad atómica de trabajo, donde todas las operaciones se completan exitosamente o ninguna de ellas se aplica, evitando así estados inconsistentes en la base de datos.

## ¿QUÉ ES UNA TRANSACCIÓN?

Una **transacción** es un conjunto de una o más operaciones lógicas que se ejecutan como una **única unidad de trabajo**. Para mantener la base de datos en un estado consistente, la transacción debe ejecutarse en su totalidad o no ejecutarse en absoluto.

## PROPIEDADES ACID

Para garantizar la integridad, las transacciones deben cumplir con las propiedades **ACID**:

### A - Atomicidad (Atomicity)
La transacción es indivisible. O se ejecutan todas sus operaciones, o no se ejecuta ninguna. No existen las "transacciones a medias". Si ocurre un error en cualquier punto, todas las operaciones realizadas hasta ese momento se revierten.

### C - Consistencia (Consistency)
La transacción lleva a la base de datos de un estado válido a otro estado válido. No puede violar las reglas de integridad definidas (como claves foráneas, restricciones UNIQUE, CHECK, entre otras).

### I - Aislamiento (Isolation)
Las transacciones que se ejecutan de forma concurrente (al mismo tiempo) no deben interferir entre sí. Es como si cada transacción se ejecutara sola en el sistema, una después de la otra (en serie), aunque en la práctica se estén ejecutando en paralelo.

### D - Durabilidad (Durability)
Una vez que una transacción ha finalizado exitosamente (ha hecho *commit*), sus cambios son permanentes y deben sobrevivir a cualquier falla posterior del sistema (como un corte de energía).

## SINTAXIS BÁSICA EN SQL SERVER

```sql
BEGIN TRANSACTION [nombre_transaccion]
    -- Operaciones SQL
    
    -- Si todo es exitoso
    COMMIT TRANSACTION [nombre_transaccion]
    
    -- Si ocurre un error
    ROLLBACK TRANSACTION [nombre_transaccion]
```

### Manejo de Errores con TRY-CATCH

```sql
BEGIN TRY
    BEGIN TRANSACTION
        -- Operaciones SQL
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION
    -- Manejo del error
    PRINT ERROR_MESSAGE()
END CATCH
```

## APLICACIONES PRÁCTICAS

### Completar un Examen y Actualizar el Progreso

Cuando un estudiante termina un examen, el sistema debe realizar tres operaciones que forman una unidad indivisible:

1. **INSERT** en la tabla **Examen**: Registrar el nuevo examen con su puntaje
2. **INSERT** en la tabla **Pomodoro**: Registrar la sesión de estudio realizada
3. **UPDATE** en la tabla **Progreso**: Actualizar el avance porcentual y comentarios del estudiante

**¿Por qué una transacción?** Estas tres operaciones están relacionadas lógicamente. Si el sistema registra el examen pero falla antes de actualizar el progreso, los datos serían inconsistentes. Una transacción asegura que **todas** las operaciones se completen o **ninguna** se aplique.

## TRANSACCIONES ANIDADAS (TA)

El modelo clásico de transacciones es "plano": una sola unidad de trabajo. Las **transacciones anidadas**, propuestas originalmente por Moss (1985), permiten descomponer una transacción grande en una jerarquía de **sub-transacciones** más pequeñas.

### Modelo y Propiedades de las TA

Las propiedades ACID se reformulan para el modelo anidado:

#### Jerarquía de Ejecución
Una sub-transacción hija siempre comienza después y termina antes que su transacción madre.

#### Herencia de Actualizaciones
Cuando una sub-transacción hija **valida** (*commits*), sus actualizaciones (y los bloqueos que adquirió) son **heredadas por su madre**. Los cambios no se hacen permanentes en la BD hasta que la transacción raíz valide.

#### Commit Definitivo
Los cambios solo se hacen permanentes en la base de datos cuando la **transacción raíz valida**.

#### Atomicidad Jerárquica
- Si una transacción madre **abandona** (*aborts*), todas sus descendientes (hijas, nietas, etc.) también son abandonadas automáticamente.
- Si una sub-transacción hija abandona, **no obliga** a que su madre abandone. Esto permite un control de errores más fino, donde la madre puede reintentar la operación o ejecutar una alternativa.

### Características del Modelo

#### Transacciones Opcionales vs. Obligatorias
- **Obligatoria:** Si esta sub-transacción abandona, su madre también debe abandonar.
- **Opcional:** Si abandona, su madre puede continuar su ejecución.

#### Modos de Ejecución
- **Secuencial (;):** Las hijas se ejecutan una a la vez, de izquierda a derecha.
- **Paralela (||):** Las hijas pueden ejecutarse simultáneamente.
- **Alternativa (∇):** Las hijas se ejecutan una a la vez, y solo una de ellas puede validar; las demás son descartadas.

## VARIABLES DEL SISTEMA ÚTILES

- **@@TRANCOUNT:** Devuelve el número de transacciones activas en la conexión actual
- **@@ERROR:** Devuelve el código del último error ocurrido
- **XACT_STATE():** Devuelve el estado de la transacción actual

## VENTAJAS DEL USO DE TRANSACCIONES

1. **Garantía de Integridad:** Asegura que los datos permanezcan consistentes
2. **Control de Errores:** Permite revertir cambios cuando algo falla
3. **Operaciones Complejas:** Facilita la coordinación de múltiples operaciones relacionadas
4. **Recuperación ante Fallos:** Protege contra fallos del sistema
5. **Concurrencia Controlada:** Gestiona el acceso simultáneo a los datos

## MEJORES PRÁCTICAS

1. Mantener las transacciones lo más cortas posible
2. Siempre implementar manejo de errores con TRY-CATCH
3. Verificar @@TRANCOUNT antes de hacer ROLLBACK
4. Evitar interacción del usuario dentro de una transacción
5. Usar puntos de guardado (SAVEPOINT) para transacciones complejas
6. Documentar claramente la lógica de las transacciones
7. Probar escenarios de error para validar el comportamiento

## CONCLUSIONES

El manejo adecuado de transacciones es esencial para mantener la integridad y consistencia de los datos en sistemas de bases de datos. Las transacciones garantizan que las operaciones se ejecuten de manera confiable siguiendo las propiedades ACID.

Las transacciones anidadas proporcionan un modelo más flexible para manejar operaciones complejas, permitiendo un control de errores más específico y la posibilidad de ejecutar sub-operaciones de manera condicional.

La implementación correcta de transacciones, junto con un manejo robusto de errores, es fundamental para desarrollar aplicaciones de base de datos confiables y mantenibles.


## Referencias
- Doucet, A., Gançarski, S., Leguizamo, V., León, C., & Rukoz, M. (2001). Un prototipo de manejador de transacciones anidadas con restricciones de integridad.
- https://learn.microsoft.com/es-es/sql/t-sql/language-elements/rollback-transaction-transact-sql?view=sql-server-ver17

