-- =============================================
-- SEEDER SCRIPT
-- =============================================
-- Este script puebla la base de datos con datos de ejemplo
-- para probar las funcionalidades de la red social.

-- 1. PAÍSES
-- Se insertan 4 países para poder agrupar usuarios.
INSERT INTO paises (id, nombre) VALUES
(1, 'Argentina'),
(2, 'Colombia'),
(3, 'España'),
(4, 'México');

-- 2. USUARIOS
-- Se insertan 6 usuarios de diferentes países.
INSERT INTO usuarios (correo_electronico, contrasenia, nombre, apellido, id_pais, nro_accesos) VALUES
    ('ana.perez@example.com', 'pass1', 'Ana', 'Perez', 1, 15),
    ('juan.garcia@example.com', 'pass12', 'Juan', 'Garcia', 2, 30),
    ('sofia.lopez@example.com', 'pass123', 'Sofia', 'Lopez', 1, 5),
    ('carlos.ruiz@example.com', 'pass1234', 'Carlos', 'Ruiz', 3, 22),
    ('lucia.martin@example.com', 'pass12345', 'Lucia', 'Martin', 4, 10),
    ('jose_martinez@gmail.com', 'pass123456', 'Jose', 'Martinez', 2, 10);

-- 3. AMISTADES
-- Se crean amistades aceptadas y una solicitud pendiente.
-- La restricción CHECK (usuario_1 < usuario_2) asegura el orden.
INSERT INTO amistades (usuario_1, usuario_2, estado) VALUES
('ana.perez@example.com', 'juan.garcia@example.com', 'aceptada'), -- Ana y Juan son amigos
('ana.perez@example.com', 'sofia.lopez@example.com', 'aceptada'), -- Ana y Sofia son amigas
('juan.garcia@example.com', 'sofia.lopez@example.com', 'aceptada'), -- Juan y Sofia son amigos
('carlos.ruiz@example.com', 'lucia.martin@example.com', 'solicitada'); -- Carlos envió una solicitud a Lucia

-- 4. GRUPOS Y MIEMBROS
-- Se crean dos grupos y se añaden usuarios a ellos.
INSERT INTO grupos (id, nombre, categoria) VALUES
(101, 'Amantes del Cine', 'Entretenimiento'),
(102, 'Desarrollo Web', 'Tecnología');

INSERT INTO grupos_usuarios (correo_usuario, id_grupo) VALUES
('ana.perez@example.com', 101),
('juan.garcia@example.com', 101),
('sofia.lopez@example.com', 102),
('carlos.ruiz@example.com', 102),
('juan.garcia@example.com', 102); -- Juan está en ambos grupos

-- 5. PUBLICACIONES
-- Se crean 5 publicaciones de diferentes tipos y autores.
INSERT INTO publicaciones (id, usuario_creador, id_grupo) VALUES
(1, 'ana.perez@example.com', NULL), -- Publicación de texto en el feed de Ana
(2, 'juan.garcia@example.com', NULL), -- Publicación de imagen en el feed de Juan
(3, 'sofia.lopez@example.com', NULL), -- Publicación de video en el feed de Sofia
(4, 'carlos.ruiz@example.com', 102), -- Publicación de texto en el grupo 'Desarrollo Web'
(5, 'juan.garcia@example.com', 101); -- Publicación de imagen "popular" en 'Amantes del Cine'

-- Se añade el contenido específico de cada publicación.
INSERT INTO publicaciones_textos_libres (id_publicacion, texto) VALUES
(1, 'Qué día increíble para pasear por el parque.'),
(4, 'Acabo de descubrir un framework de CSS increíble: Tailwind!');

-- Se cargan los archivos binarios desde la ruta absoluta dentro del contenedor
INSERT INTO publicaciones_imagenes (id_publicacion, contenido_imagen) VALUES
(2, pg_read_binary_file('/docker-entrypoint-initdb.d/imagen.jpg')),
(5, pg_read_binary_file('/docker-entrypoint-initdb.d/imagen.jpg'));

INSERT INTO publicaciones_videos (id_publicacion, contenido_video) VALUES
(3, pg_read_binary_file('/docker-entrypoint-initdb.d/2025-11-17 18-13-52.mkv'));

-- 6. PUBLICACIONES FAVORITAS
-- Se marcan publicaciones como favoritas para probar la consulta de popularidad.
INSERT INTO publicaciones_favoritas (correo_usuario, id_publicacion) VALUES
-- La publicación 5 es la más popular
('ana.perez@example.com', 5),
('sofia.lopez@example.com', 5),
('carlos.ruiz@example.com', 5),
-- Otras publicaciones con favoritos
('juan.garcia@example.com', 1),
('ana.perez@example.com', 2),
('lucia.martin@example.com', 4);

-- 7. MENSAJES
-- Se crean mensajes entre usuarios.
INSERT INTO mensajes (id, correo_emisor, correo_receptor, contenido) VALUES
(1, 'ana.perez@example.com', 'juan.garcia@example.com', 'Hola Juan! ¿Viste la nueva película?'),
(2, 'juan.garcia@example.com', 'ana.perez@example.com', 'Hola Ana! Sí, la vi anoche. ¡Hablemos en el grupo!');

-- 8. NOTIFICACIONES
-- Se crean notificaciones para los 3 casos de uso del enunciado.

-- Caso 1: Solicitud de amistad (Carlos a Lucia)
INSERT INTO notificaciones (id, tipo, contenido) VALUES
(10, 'amistad', 'Carlos Ruiz quiere ser tu amigo.');
INSERT INTO notificaciones_usuarios (id_notificacion, correo_usuario) VALUES
(10, 'lucia.martin@example.com');

-- Caso 2: Nueva publicación de un amigo (Juan, amigo de Ana, publica la #2)
INSERT INTO notificaciones (id, tipo, contenido) VALUES
(11, 'publicacion_amigo', 'Tu amigo Juan Garcia ha realizado una nueva publicación.');
INSERT INTO notificaciones_usuarios (id_notificacion, correo_usuario) VALUES
(11, 'ana.perez@example.com');

-- Caso 3: Nueva publicación en un grupo (Carlos publica en 'Desarrollo Web')
INSERT INTO notificaciones (id, tipo, contenido) VALUES
(12, 'publicacion_grupo', 'Hay una nueva publicación en el grupo Desarrollo Web.');
INSERT INTO notificaciones_usuarios (id_notificacion, correo_usuario) VALUES
(12, 'sofia.lopez@example.com'),
(12, 'juan.garcia@example.com'); -- Se notifica a todos los miembros del grupo (excepto al autor)

-- Fin del script
