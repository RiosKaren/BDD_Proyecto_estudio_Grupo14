--CARGA DE DATOS REPRESENTATIVOS

-- TipoUsuario
INSERT INTO TipoUsuario (id_tipo_usuario, nombre_tipo) VALUES
(1, 'Administrador'),
(2, 'Estudiante');

-- Usuario
INSERT INTO Usuario (id_usuario, nombre, correo, password, nivel_educativo, id_tipo_usuario) VALUES
(1, 'María González', 'maria.g@example.com', 'pass123', 'Secundario', 2),
(2, 'Juan Pérez', 'juan.p@example.com', 'pass456', 'Universitario', 2),
(3, 'Admin Sistema', 'admin@example.com', 'admin123', 'N/A', 1),
(4, 'Lucía Fernández', 'lucia.f@example.com', 'lucia123', 'Universitario', 2),
(5, 'Carlos López', 'carlos.l@example.com', 'carlos123', 'Secundario', 2),
(6, 'Ana Martínez', 'ana.m@example.com', 'ana123', 'Universitario', 2),
(7, 'Diego Ramírez', 'diego.r@example.com', 'diego123', 'Autodidacta', 2),
(8, 'Sofía Torres', 'sofia.t@example.com', 'sofia123', 'Universitario', 2);

-- Materia
INSERT INTO Materia (id_materia, id_usuario, nombre_materia, descripcion) VALUES
(1, 1, 'Inglés', 'Gramática básica y vocabulario inicial.'),
(2, 2, 'Historia Universal', 'Principales civilizaciones y hechos históricos.'),
(3, 4, 'Matemática', 'Álgebra y trigonometría.'),
(4, 5, 'Arte', 'Historia del arte y movimientos artísticos.'),
(5, 6, 'Ciencias Naturales', 'Biología y ecología básica.'),
(6, 7, 'Geografía', 'Regiones y climas del mundo.'),
(7, 8, 'Filosofía', 'Corrientes filosóficas clásicas y modernas.');

-- Apunte
INSERT INTO Apunte (id_apunte, id_materia, titulo, contenido, fecha_creacion) VALUES
(1, 1, 'Presente Simple', 'El presente simple se usa para hábitos y rutinas. Ej: I play soccer.', '2025-09-01'),
(2, 2, 'Antigua Roma', 'La civilización romana influyó en política y derecho.', '2025-09-05'),
(3, 3, 'Teorema de Pitágoras', 'En un triángulo rectángulo: a² + b² = c².', '2025-09-07'),
(4, 4, 'Renacimiento', 'El arte renacentista destacó por el realismo y la perspectiva.', '2025-09-08'),
(5, 5, 'Ecosistemas', 'Un ecosistema es una comunidad de organismos y su entorno.', '2025-09-10'),
(6, 6, 'Continentes', 'Los cinco continentes principales: América, Europa, Asia, África y Oceanía.', '2025-09-12'),
(7, 7, 'Sócrates', 'Filósofo griego que propuso el método socrático de diálogo.', '2025-09-13');

-- Flashcard
INSERT INTO Flashcard (id_flashcard, id_apunte, pregunta, respuesta, aciertos, errores) VALUES
(1, 1, 'Traduce: "She plays piano."', 'Ella toca el piano.', 4, 1),
(2, 2, '¿En qué año cayó el Imperio Romano de Occidente?', '476 d.C.', 2, 2),
(3, 3, 'Formula del teorema de Pitágoras', 'a² + b² = c²', 3, 1),
(4, 4, '¿Qué artista pintó la Mona Lisa?', 'Leonardo da Vinci', 5, 0),
(5, 5, '¿Qué es un ecosistema?', 'Una comunidad de organismos y su entorno.', 4, 2),
(6, 6, '¿Cuál es el continente más grande?', 'Asia.', 3, 0),
(7, 7, '¿Quién fue Sócrates?', 'Filósofo griego clásico.', 2, 1);

-- Examen
INSERT INTO Examen (id_examen, id_materia, fecha, puntaje, cantidad_preguntas) VALUES
(1, 1, '2025-09-10', 9.0, 15),
(2, 2, '2025-09-15', 7.5, 20),
(3, 3, '2025-09-17', 8.0, 10),
(4, 4, '2025-09-18', 6.5, 12),
(5, 5, '2025-09-19', 9.2, 18),
(6, 6, '2025-09-20', 7.0, 15),
(7, 7, '2025-09-21', 8.7, 14);

-- Pomodoro
INSERT INTO Pomodoro (id_pomodoro, id_usuario, fecha, duracion_estudio, duracion_descanso) VALUES
(1, 1, '2025-09-20', 25, 5),
(2, 2, '2025-09-21', 50, 10),
(3, 4, '2025-09-22', 30, 5),
(4, 5, '2025-09-23', 45, 10),
(5, 6, '2025-09-24', 60, 15),
(6, 7, '2025-09-25', 40, 5),
(7, 8, '2025-09-26', 35, 7);

-- Progreso
INSERT INTO Progreso (id_progreso, id_usuario, id_materia, avance_porcentual, comentarios) VALUES
(1, 1, 1, 75, 'Muy buen desempeño en inglés, mejorar listening.'),
(2, 2, 2, 50, 'Avanzó en historia, falta repasar Edad Media.'),
(3, 4, 3, 60, 'Comprende bien álgebra, reforzar trigonometría.'),
(4, 5, 4, 80, 'Excelente análisis de arte renacentista.'),
(5, 6, 5, 55, 'Debe repasar ciclos de nutrientes.'),
(6, 7, 6, 65, 'Buen conocimiento de regiones, reforzar climas tropicales.'),
(7, 8, 7, 70, 'Entiende filosofía clásica, revisar corrientes modernas.');