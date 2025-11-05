/*
MANEJO DE TRANSACCIONES Y TRANSACCIONES ANIDADAS

ESCENARIO:  Un estudiante completa un nuevo examen en una materia.
  1. INSERT: Registrar el nuevo examen en la tabla Examen
  2. INSERT: Crear un registro de actividad en tabla Pomodoro (sesión de estudio)
  3. UPDATE: Actualizar el progreso del estudiante en esa materia
*/

USE StudIA;
GO


-- ESTADO ANTES DE LA TRANSACCIÓN
-- Ver examenes actuales de Maria Gonzalez en Ingles
SELECT 
    e.id_examen,
    m.nombre_materia,
    e.fecha,
    e.puntaje,
    e.cantidad_preguntas
FROM Examen e
INNER JOIN Materia m ON e.id_materia = m.id_materia
WHERE e.id_materia = 1; -- Ingles

-- Ver sesiones Pomodoro de Maria
SELECT 
    p.id_pomodoro,
    u.nombre,
    p.fecha,
    p.duracion_estudio,
    p.duracion_descanso
FROM Pomodoro p
INNER JOIN Usuario u ON p.id_usuario = u.id_usuario
WHERE p.id_usuario = 1; -- Maria Gonzalez

-- Ver progreso actual de Maria en Ingles
SELECT 
    p.id_progreso,
    u.nombre AS estudiante,
    m.nombre_materia,
    p.avance_porcentual,
    p.comentarios
FROM Progreso p
INNER JOIN Usuario u ON p.id_usuario = u.id_usuario
INNER JOIN Materia m ON p.id_materia = m.id_materia
WHERE p.id_usuario = 1 AND p.id_materia = 1;


-------------------------------------
-- TRANSACCIÓN EXITOSA - PRUEBA 1
-------------------------------------

-- Variables para el nuevo examen y actualización de progreso
DECLARE @nuevo_id_examen INT = 8;
DECLARE @id_materia INT = 1;              -- Ingles
DECLARE @fecha_examen DATE = CAST(GETDATE() AS DATE);
DECLARE @puntaje_examen FLOAT = 8.5;
DECLARE @cantidad_preguntas INT = 20;

-- Variables para la sesión de estudio (Pomodoro)
DECLARE @nuevo_id_pomodoro INT = 8;
DECLARE @id_usuario INT = 1;              -- María González
DECLARE @duracion_estudio INT = 60;
DECLARE @duracion_descanso INT = 0;

-- Variables para actualizar progreso
DECLARE @nuevo_avance FLOAT = 85.0;
DECLARE @nuevos_comentarios NVARCHAR(MAX) = 'Continuar practicando listening.';

-- INICIA LA TRANSACCIÓN
BEGIN TRANSACTION;
BEGIN TRY
    -- OPERACIÓN 1: INSERT en tabla Examen
    INSERT INTO Examen (id_examen, id_materia, fecha, puntaje, cantidad_preguntas)
    VALUES (@nuevo_id_examen, @id_materia, @fecha_examen, @puntaje_examen, @cantidad_preguntas);

    -- OPERACIÓN 2: INSERT en tabla Pomodoro
    INSERT INTO Pomodoro (id_pomodoro, id_usuario, fecha, duracion_estudio, duracion_descanso)
    VALUES (@nuevo_id_pomodoro, @id_usuario, @fecha_examen, @duracion_estudio, @duracion_descanso);
    
    -- OPERACIÓN 3: UPDATE en tabla Progreso
    UPDATE Progreso
    SET 
        avance_porcentual = @nuevo_avance,
        comentarios = @nuevos_comentarios
    WHERE id_usuario = @id_usuario 
      AND id_materia = @id_materia;
    
    -- Si todo fue exitoso COMMIT
    COMMIT TRANSACTION;
    PRINT 'TRANSACCION COMPLETADA EXITOSAMENTE';

END TRY
BEGIN CATCH
    
    -- Si ocurre cualquier error ROLLBACK
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'ERROR: TRANSACCION REVERTIDA';
    END

END CATCH;

-- Verificar el resultado(ver datos despues de la transaccion)

SELECT 
    e.id_examen,
    m.nombre_materia,
    e.fecha,
    e.puntaje,
    e.cantidad_preguntas
FROM Examen e
INNER JOIN Materia m ON e.id_materia = m.id_materia
WHERE e.id_examen = @nuevo_id_examen;

SELECT 
    p.id_pomodoro,
    u.nombre,
    p.fecha,
    p.duracion_estudio
FROM Pomodoro p
INNER JOIN Usuario u ON p.id_usuario = u.id_usuario
WHERE p.id_pomodoro = @nuevo_id_pomodoro;

SELECT 
    p.avance_porcentual,
    p.comentarios
FROM Progreso p
WHERE p.id_usuario = @id_usuario AND p.id_materia = @id_materia;


--------------------------------------------------------
-- TRANSACCION CON ERROR FORZADO - PRUEBA 2
--------------------------------------------------------

-- Nuevas variables para la segunda prueba
DECLARE @nuevo_id_examen2 INT = 9;
DECLARE @nuevo_id_pomodoro2 INT = 9;

BEGIN TRANSACTION;

BEGIN TRY
    
    -- OPERACION 1: INSERT en Examen
    INSERT INTO Examen (id_examen, id_materia, fecha, puntaje, cantidad_preguntas)
    VALUES (@nuevo_id_examen2, @id_materia, @fecha_examen, 7.5, 15);
    

    -- Simulamos un error despues del primer INSERT
     THROW 50001, 'Error simulado: fallo en la conexión con el servidor', 1;
    --

    -- Este código NUNCA se ejecuta debido al error anterior
    INSERT INTO Pomodoro (id_pomodoro, id_usuario, fecha, duracion_estudio, duracion_descanso)
    VALUES (@nuevo_id_pomodoro2, @id_usuario, @fecha_examen, 45, 10);
    
    UPDATE Progreso
    SET avance_porcentual = 90.0
    WHERE id_usuario = @id_usuario AND id_materia = @id_materia;
    COMMIT TRANSACTION;
    PRINT 'TRANSACCION COMPLETADA EXITOSAMENTE';

END TRY
BEGIN CATCH
    
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'ERROR: TRANSACCION REVERTIDA';
    END

END CATCH;

-- Verificar que NO se insertaron los datos (el examen ID=9 no debe existir)
SELECT 
    COUNT(*) AS cantidad_examenes_con_id_9
FROM Examen
WHERE id_examen = @nuevo_id_examen2;
-- el resultado es 0, confirma que el ROLLBACK funciono correctamente.
