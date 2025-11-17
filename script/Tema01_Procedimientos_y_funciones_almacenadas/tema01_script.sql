USE StudIA;
GO
/*
    ░-░-░ ░E░J░E░M░P░L░O░S░ ░D░E░ ░P░R░O░C░E░D░I░M░I░E░N░T░O░S░ ░A░L░M░A░C░E░N░A░D░O░S░
*/
--Procedimiento para poder imsertar un nuevo apunte
CREATE PROCEDURE SP_InsertarApunte
    @id_materia INT,
    @titulo VARCHAR(100),
    @contenido TEXT,
    @fecha_creacion DATE = NULL,
    @nuevo_id_apunte INT OUTPUT
AS
--Insertar un nuevo apunte con validación JSON
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
CREATE PROCEDURE ActualizarProgreso
    @id_usuario INT,
    @id_materia INT,
    @avance FLOAT,
    @comentarios TEXT
AS
--Actualizar progreso de una materia
BEGIN
    UPDATE Progreso
    SET avance_porcentual = @avance,
        comentarios = @comentarios
    WHERE id_usuario = @id_usuario AND id_materia = @id_materia;
END;

/*
    ░-░-░ ░E░J░E░M░P░L░O░S░ ░D░E░ ░F░U░N░C░I░O░N░E░S░ ░A░L░M░A░C░E░N░A░D░A░S░
*/
--Obtención de flashcards por apunte
CREATE PROCEDURE ObtenerFlashcardsPorApunte
    @id_apunte INT
AS
BEGIN
    SELECT pregunta, respuesta, aciertos, errores
    FROM Flashcard
    WHERE id_apunte = @id_apunte;
END;
--Calcular porcentaje de aciertos en una flashcard
CREATE FUNCTION CalcularPorcentajeAciertos (@aciertos INT, @errores INT)
RETURNS FLOAT
AS
BEGIN
    RETURN (CAST(@aciertos AS FLOAT) / NULLIF(@aciertos + @errores, 0)) * 100;
END;
--Función de tabla: exámenes por materia
CREATE FUNCTION ExamenesPorMateria (@id_materia INT)
RETURNS TABLE
AS
RETURN (
    SELECT id_examen, fecha, puntaje, cantidad_preguntas
    FROM Examen
    WHERE id_materia = @id_materia
);



