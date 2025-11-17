/*
 MANEJO DE TIPOS DE DATOS JSON
*/

-- ================================================================
-- 1. Creacion de la BDD alternativa.

CREATE DATABASE StudIA2;    
GO

USE StudIA2;
GO

--Tablas originales del modelo
CREATE TABLE TipoUsuario (
    id_tipo_usuario int  NOT NULL,
    nombre_tipo varchar(30)  NOT NULL,
    CONSTRAINT TipoUsuario_pk PRIMARY KEY  (id_tipo_usuario)
);

CREATE TABLE Usuario (
    id_usuario int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    correo varchar(150)  NOT NULL,
    password varchar(255)  NOT NULL,
    nivel_educativo varchar(50)  NULL,
    id_tipo_usuario int  NOT NULL,
    CONSTRAINT AK_0 UNIQUE (correo),
    CONSTRAINT Usuario_pk PRIMARY KEY  (id_usuario)
);

CREATE TABLE Materia (
    id_materia int  NOT NULL,
    id_usuario int  NOT NULL,
    nombre_materia varchar(100)  NOT NULL,
    descripcion text  NULL,
    CONSTRAINT Materia_pk PRIMARY KEY  (id_materia)
);

-- ================================================================
-- 2. Creamos 'contenido' como NVARCHAR(MAX)
CREATE TABLE Apunte (
    id_apunte int  NOT NULL,
    id_materia int  NOT NULL,
    titulo varchar(100)  NOT NULL,
    contenido NVARCHAR(MAX)  NOT NULL,
    fecha_creacion date  NULL DEFAULT CAST(GETDATE() AS DATE),
    CONSTRAINT Apunte_pk PRIMARY KEY  (id_apunte),
--Validamos que 'contenido' sea JSON
    CONSTRAINT CK_Apunte_Contenido_JSON CHECK (ISJSON(contenido) = 1) 
);

-- Claves Foraneas
ALTER TABLE Usuario ADD CONSTRAINT FK_0
    FOREIGN KEY (id_tipo_usuario)
    REFERENCES TipoUsuario (id_tipo_usuario);

ALTER TABLE Materia ADD CONSTRAINT FK_1
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario (id_usuario);

ALTER TABLE Apunte ADD CONSTRAINT FK_2
    FOREIGN KEY (id_materia)
    REFERENCES Materia (id_materia);
GO


-- 3.Insertamos datos de ejemplo
-- ================================================================
INSERT INTO TipoUsuario (id_tipo_usuario, nombre_tipo) VALUES
(1, 'Administrador'),
(2, 'Estudiante');

INSERT INTO Usuario (id_usuario, nombre, correo, password, nivel_educativo, id_tipo_usuario) VALUES
(1, 'Mar�a Gonz�lez', 'maria.g@example.com', 'pass123', 'Secundario', 2),
(2, 'Juan P�rez', 'juan.p@example.com', 'pass456', 'Universitario', 2);

INSERT INTO Materia (id_materia, id_usuario, nombre_materia, descripcion) VALUES
(1, 1, 'Inglés', 'Gramática básica y vocabulario inicial.'),
(2, 2, 'Historia Universal', 'Principales civilizaciones y hechos históricos.'),
(3, 2, 'Matemática', 'Álgebra y trigonometría.');
GO


-- 4.Insertamos apuntes tipo JSON
-- ================================================================
INSERT INTO Apunte (id_apunte, id_materia, titulo, contenido, fecha_creacion)
VALUES (
    1, 
    1, 
    'Presente Simple', 
    
    /*N por el NVARCHAR*/
    N'{ 
        "tema": "Presente Simple",
        "definicion": "Se usa para hábitos y rutinas.",
        "reglas": ["Usar ''s'' para He/She/It", "Usar ''do/does'' para preguntas"],
        "ejemplos": [
            {"oracion": "I play soccer", "traduccion": "Yo juego al fútbol"},
            {"oracion": "She plays piano", "traduccion": "Ella toca el piano"}
        ]
    }', 
    '2025-09-01'
);

INSERT INTO Apunte (id_apunte, id_materia, titulo, contenido, fecha_creacion)
VALUES (
    2, 
    2, 
    'Antigua Roma', 
    N'{
        "tema": "Antigua Roma",
        "puntos_clave": ["Influencia en política y derecho"],
        "eventos": [
            {"nombre": "Fundación", "año": -753},
            {"nombre": "Caída del Imperio (Occidente)", "año": 476}
        ]
    }', 
    '2025-09-05'
);
GO



--5. Demostramos la restriccion (falla)
-- ================================================================

    INSERT INTO Apunte (id_apunte, id_materia, titulo, contenido, fecha_creacion)
    VALUES (3, 3, 'Prueba Fallida', 'Esto no es JSON', '2025-01-01');
    

-- ================================================================
-- PASO 5: DEMOSTRACIÓN DE CONSULTAS JSON (CORREGIDO)
-- ================================================================
-- 1. Leer un valor simple (string) con JSON_VALUE

-- 'definicion'' del apunte 1
SELECT 
    id_apunte,
    titulo,
    JSON_VALUE(contenido, '$.definicion') AS DefinicionDelJSON
FROM 
    Apunte
WHERE
    id_apunte = 1;


-- 2. Leer un objeto/array completo con JSON_QUERY

--Lista de 'ejemplos' del apunte 1:
SELECT 
    JSON_QUERY(contenido, '$.ejemplos') AS Ejemplos
FROM 
    Apunte
WHERE 
    id_apunte = 1;

-- 3. Buscar usando un valor DENTRO del JSON

-- Apuntes que mencionen el a�o 476:
PRINT '--- 3. Buscando apuntes que mencionen el año 476: ---';
SELECT 
    id_apunte,
    titulo,
    contenido
FROM 
    Apunte
WHERE 
    -- La 'ñ' en "año" requiere comillas dobles en la ruta
    JSON_VALUE(contenido, '$.eventos[1]."año"') = 476;

GO
