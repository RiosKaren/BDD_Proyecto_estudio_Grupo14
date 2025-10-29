USE StudIA;
GO

-- Procedimiento para poder imsertar un nuevo apunte
CREATE PROCEDURE SP_InsertarApunte
    @id_materia INT,
    @titulo VARCHAR(100),
    @contenido TEXT,
    @fecha_creacion DATE = NULL,
    @nuevo_id_apunte INT OUTPUT
AS


