CREATE DATABASE StudIA;
GO
USE StudIA;
GO

-- Table: Apunte
CREATE TABLE Apunte (
    id_apunte int  NOT NULL,
    id_materia int  NOT NULL,
    titulo varchar(100)  NOT NULL,
    contenido text  NOT NULL,
    fecha_creacion date  NULL DEFAULT CAST(GETDATE() AS DATE),
    CONSTRAINT Apunte_pk PRIMARY KEY  (id_apunte)
);

-- Table: Examen
CREATE TABLE Examen (
    id_examen int  NOT NULL,
    id_materia int  NOT NULL,
    fecha date  NULL DEFAULT CAST(GETDATE() AS DATE),
    puntaje float  NULL,
    cantidad_preguntas int  NULL,
    CONSTRAINT Examen_pk PRIMARY KEY  (id_examen)
);

-- Table: Flashcard
CREATE TABLE Flashcard (
    id_flashcard int  NOT NULL,
    id_apunte int  NOT NULL,
    pregunta varchar(255)  NOT NULL,
    respuesta varchar(500)  NOT NULL,
    aciertos int  NULL DEFAULT 0,
    errores int  NULL DEFAULT 0,
    CONSTRAINT Flashcard_pk PRIMARY KEY  (id_flashcard)
);

-- Table: Materia
CREATE TABLE Materia (
    id_materia int  NOT NULL,
    id_usuario int  NOT NULL,
    nombre_materia varchar(100)  NOT NULL,
    descripcion text  NULL,
    CONSTRAINT Materia_pk PRIMARY KEY  (id_materia)
);

-- Table: Pomodoro
CREATE TABLE Pomodoro (
    id_pomodoro int  NOT NULL,
    id_usuario int  NOT NULL,
    fecha date  NULL DEFAULT CAST(GETDATE() AS DATE),
    duracion_estudio int  NOT NULL,
    duracion_descanso int  NOT NULL,
    CONSTRAINT Pomodoro_pk PRIMARY KEY  (id_pomodoro)
);

-- Table: Progreso
CREATE TABLE Progreso (
    id_progreso int  NOT NULL,
    id_usuario int  NOT NULL,
    id_materia int  NOT NULL,
    avance_porcentual float  NULL,
    comentarios text  NULL,
    CONSTRAINT CHECK_0 CHECK (( avance_porcentual BETWEEN 0 AND 100 )),
    CONSTRAINT Progreso_pk PRIMARY KEY  (id_progreso)
);

-- Table: TipoUsuario
CREATE TABLE TipoUsuario (
    id_tipo_usuario int  NOT NULL,
    nombre_tipo varchar(30)  NOT NULL,
    CONSTRAINT TipoUsuario_pk PRIMARY KEY  (id_tipo_usuario)
);

-- Table: Usuario
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

-- foreign keys

-- Reference: FK_0 (table: Usuario)
ALTER TABLE Usuario ADD CONSTRAINT FK_0
    FOREIGN KEY (id_tipo_usuario)
    REFERENCES TipoUsuario (id_tipo_usuario);

-- Reference: FK_1 (table: Materia)
ALTER TABLE Materia ADD CONSTRAINT FK_1
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario (id_usuario);

-- Reference: FK_2 (table: Apunte)
ALTER TABLE Apunte ADD CONSTRAINT FK_2
    FOREIGN KEY (id_materia)
    REFERENCES Materia (id_materia);

-- Reference: FK_3 (table: Flashcard)
ALTER TABLE Flashcard ADD CONSTRAINT FK_3
    FOREIGN KEY (id_apunte)
    REFERENCES Apunte (id_apunte);

-- Reference: FK_4 (table: Examen)
ALTER TABLE Examen ADD CONSTRAINT FK_4
    FOREIGN KEY (id_materia)
    REFERENCES Materia (id_materia);

-- Reference: FK_5 (table: Pomodoro)
ALTER TABLE Pomodoro ADD CONSTRAINT FK_5
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario (id_usuario);

-- Reference: FK_6 (table: Progreso)
ALTER TABLE Progreso ADD CONSTRAINT FK_6
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario (id_usuario);

-- Reference: FK_7 (table: Progreso)
ALTER TABLE Progreso ADD CONSTRAINT FK_7
    FOREIGN KEY (id_materia)
    REFERENCES Materia (id_materia);