USE StudIA;
GO
--Carga masiva de datos
SET NOCOUNT ON; --Quita el contador y acelera la carga

BEGIN TRY
    ---------------------------------------------------
    BEGIN TRANSACTION;
    
    DECLARE @i INT = 9; -- 9 porque en el script original solo hay 8 .Empieza después de los datos ya insertados
    WHILE @i <= 50000 
    BEGIN
        INSERT INTO Usuario (id_usuario, nombre, correo, password, nivel_educativo, id_tipo_usuario)
        VALUES (@i, 'Usuario ' + CAST(@i AS VARCHAR), 'user' + CAST(@i AS VARCHAR) + '@studia.com', 'pass123', 'Universitario', 2);
        SET @i = @i + 1;
    END --Carga 48.992 usuarios para llegar a 50.000

   ---------------------------------------------------
    DECLARE @m INT = 8; -- Empezamos después de los datos ya insertados
    DECLARE @userId INT;
    WHILE @m <= 500000
    BEGIN
      
        SET @userId = (ABS(CHECKSUM(NEWID())) % 50000) + 1;   -- Asigna la materia a un usuario aleatorio (IDs 1-50000)
        INSERT INTO Materia (id_materia, id_usuario, nombre_materia, descripcion)
        VALUES (@m, @userId, 'Materia Nro ' + CAST(@m AS VARCHAR), 'Descripción de la materia...');
        SET @m = @m + 1;
    END --Carga 500.000 materias

    ---------------------------------------------------
    DECLARE @a INT = 8; -- Empezamos después de los datos ya insertados
    DECLARE @materiaId INT;
    WHILE @a <= 2000000 -- 2 Millones de apuntes
    BEGIN
        -- Asigna el apunte a una materia aleatoria (IDs 1-500000)
        SET @materiaId = (ABS(CHECKSUM(NEWID())) % 500000) + 1;
        
        INSERT INTO Apunte (id_apunte, id_materia, titulo, contenido, fecha_creacion)
        VALUES (
            @a, 
            @materiaId, 
            'Título del Apunte ' + CAST(@a AS VARCHAR), -- Un título único para buscar
            'Este es el contenido del apunte...', 
            GETDATE() - (ABS(CHECKSUM(NEWID())) % 365) -- Fecha aleatoria
        );
        SET @a = @a + 1;
    END --Cargamos 2.000.000 apuntes.

    ---------------------------------------------------

    
    COMMIT TRANSACTION;
    END 

    TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
END CATCH
SET NOCOUNT OFF; --Se activa de nuevo el contador
GO

-- ================================================================
-- DEMOSTRACIÓN DE RENDIMIENTO
-- ================================================================
-- Limpiamos caché 
DBCC DROPCLEANBUFFERS; -- Limpia los datos de la memoria
DBCC FREEPROCCACHE;   -- Limpia los planes de ejecución de la memoria
GO

SET STATISTICS IO, TIME ON; -- Activa estadísticas de tiempo y lecturas

-----------------------------------------------
-- 1 - Consulta sin indice
-----------------------------------------------
-- Buscamos un apunte específico por su título
-- Usamos la tabla Apunte de tu DDL
SELECT * FROM Apunte 
WHERE titulo = 'Título del Apunte 1500000'; -- Un apunte que sabemos que existe

SET STATISTICS IO, TIME OFF;
GO

-----------------------------------------------
-- Se crea el indice para ver si hay mejoras
-----------------------------------------------

CREATE INDEX idx_apunte_titulo ON Apunte(titulo); -- Creamos el índice No Agrupado sobre la columna 'titulo' de la tabla 'Apunte'

-----------------------------------------------
-- Consulta con indice
-----------------------------------------------

-- Limpiamos caché
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

-- Activamos las estadísticas de nuevo
SET STATISTICS IO, TIME ON;

-- EXACTAMENTE la misma consulta de antes
SELECT * FROM Apunte 
WHERE titulo = 'Título del Apunte 1500000';

SET STATISTICS IO, TIME OFF;
GO

--limpieza
-- Eliminar el indice para repetir la demo
DROP INDEX idx_apunte_titulo ON Apunte;
GO

