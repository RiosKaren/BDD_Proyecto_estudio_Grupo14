USE StudIA;
GO

/*
    ░-░-░ EJEMPLOS DE PROCEDIMIENTOS ALMACENADOS ░-░-░
*/

-- Procedimiento para insertar un nuevo apunte
CREATE PROCEDURE SP_InsertarApunte
    @id_materia INT,
    @titulo VARCHAR(100),
    @contenido NVARCHAR(MAX),
    @fecha_creacion DATE = NULL,
    @nuevo_id_apunte INT OUTPUT
AS
BEGIN
    INSERT INTO Apunte (id_materia, titulo, contenido, fecha_creacion)
    VALUES (@id_materia, @titulo, @contenido, ISNULL(@fecha_creacion, GETDATE()));

    SET @nuevo_id_apunte = SCOPE_IDENTITY();
END;
GO

-- Procedimiento para insertar un apunte validando JSON
CREATE PROCEDURE InsertarApunteJSON
    @id_materia INT,
    @titulo VARCHAR(100),
    @contenido NVARCHAR(MAX)
AS
BEGIN
    IF ISJSON(@contenido) = 1
    BEGIN
        INSERT INTO Apunte (id_materia, titulo, contenido, fecha_creacion)
        VALUES (@id_materia, @titulo, @contenido, GETDATE());
    END
    ELSE
    BEGIN
        RAISERROR('El contenido no es JSON válido.', 16, 1);
    END
END;
GO

-- Procedimiento para actualizar progreso
CREATE PROCEDURE ActualizarProgreso
    @id_usuario INT,
    @id_materia INT,
    @avance FLOAT,
    @comentarios NVARCHAR(MAX)
AS
BEGIN
    UPDATE Progreso
    SET avance_porcentual = @avance,
        comentarios = @comentarios
    WHERE id_usuario = @id_usuario AND id_materia = @id_materia;
END;
GO
