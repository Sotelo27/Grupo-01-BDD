-- 1. PAÍSES (sin id porque ya es SERIAL)
INSERT INTO paises (nombre) VALUES
                                ('Argentina'),
                                ('Colombia'),
                                ('España'),
                                ('México');

-- (Opcional) capturar los IDs si los necesitás después
WITH p AS (
    SELECT id, nombre FROM paises
)
SELECT * FROM p;


-- 2. USUARIOS (id_pais sigue siendo FK válido igual que antes)
INSERT INTO usuarios (correo_electronico, contrasenia, nombre, apellido, id_pais, nro_accesos) VALUES
                                                                                                   ('ana.perez@example.com', 'pass1', 'Ana', 'Perez', 1, 15),
                                                                                                   ('juan.garcia@example.com', 'pass12', 'Juan', 'Garcia', 2, 30),
                                                                                                   ('sofia.lopez@example.com', 'pass123', 'Sofia', 'Lopez', 1, 5),
                                                                                                   ('carlos.ruiz@example.com', 'pass1234', 'Carlos', 'Ruiz', 3, 22),
                                                                                                   ('lucia.martin@example.com', 'pass12345', 'Lucia', 'Martin', 4, 10),
                                                                                                   ('jose_martinez@gmail.com', 'pass123456', 'Jose', 'Martinez', 2, 10);


-- 3. AMISTADES (queda igual, no usa id)
INSERT INTO amistades (usuario_1, usuario_2, estado) VALUES
                                                         ('ana.perez@example.com', 'juan.garcia@example.com', 'aceptada'),
                                                         ('ana.perez@example.com', 'sofia.lopez@example.com', 'aceptada'),
                                                         ('juan.garcia@example.com', 'sofia.lopez@example.com', 'aceptada'),
                                                         ('carlos.ruiz@example.com', 'lucia.martin@example.com', 'solicitada');


-- 4. GRUPOS (eran id manual, ahora es SERIAL → no enviamos id)
WITH g AS (
    INSERT INTO grupos (nombre, categoria) VALUES
                                               ('Amantes del Cine', 'Entretenimiento'),
                                               ('Desarrollo Web', 'Tecnología')
        RETURNING id, nombre
)
SELECT * FROM g;

-- Vincular usuarios a grupos usando IDs reales generados
-- (Los id van a ser 1 y 2 salvo que ya tengas filas previas)
INSERT INTO grupos_usuarios (correo_usuario, id_grupo) VALUES
                                                           ('ana.perez@example.com', 1),
                                                           ('juan.garcia@example.com', 1),
                                                           ('sofia.lopez@example.com', 2),
                                                           ('carlos.ruiz@example.com', 2),
                                                           ('juan.garcia@example.com', 2);


-- 5. PUBLICACIONES (id era manual → ahora es SERIAL)
WITH pub AS (
    INSERT INTO publicaciones (usuario_creador, id_grupo) VALUES
                                                              ('ana.perez@example.com', NULL),
                                                              ('juan.garcia@example.com', NULL),
                                                              ('sofia.lopez@example.com', NULL),
                                                              ('carlos.ruiz@example.com', 2),
                                                              ('juan.garcia@example.com', 1)
        RETURNING id, usuario_creador
)
SELECT * FROM pub;

-- Agregar contenido a las publicaciones usando su id real
INSERT INTO publicaciones_textos_libres (id_publicacion, texto) VALUES
                                                                    (1, 'Qué día increíble para pasear por el parque.'),
                                                                    (4, 'Acabo de descubrir un framework de CSS increíble: Tailwind!');

INSERT INTO publicaciones_imagenes (id_publicacion, contenido_imagen) VALUES
                                                                          (2, pg_read_binary_file('/docker-entrypoint-initdb.d/imagen.jpg')),
                                                                          (5, pg_read_binary_file('/docker-entrypoint-initdb.d/imagen.jpg'));

INSERT INTO publicaciones_videos (id_publicacion, contenido_video) VALUES
    (3, pg_read_binary_file('/docker-entrypoint-initdb.d/2025-11-17 18-13-52.mkv'));


-- 6. PUBLICACIONES FAVORITAS (queda igual, usa FK a id creado)
INSERT INTO publicaciones_favoritas (correo_usuario, id_publicacion) VALUES
                                                                         ('ana.perez@example.com', 5),
                                                                         ('sofia.lopez@example.com', 5),
                                                                         ('carlos.ruiz@example.com', 5),
                                                                         ('juan.garcia@example.com', 1),
                                                                         ('ana.perez@example.com', 2),
                                                                         ('lucia.martin@example.com', 4);


-- 7. MENSAJES (sin enviar id, que se genere solo)
INSERT INTO mensajes (correo_emisor, correo_receptor, contenido) VALUES
                                                                     ('ana.perez@example.com', 'juan.garcia@example.com', 'Hola Juan! ¿Viste la nueva película?'),
                                                                     ('juan.garcia@example.com', 'ana.perez@example.com', 'Hola Ana! Sí, la vi anoche. ¡Hablemos en el grupo!');


-- 8. NOTIFICACIONES (sin enviar id o usando RETURNING si las vas a referenciar)
WITH n1 AS (
    INSERT INTO notificaciones (tipo, contenido) VALUES
                                                     ('amistad', 'Carlos Ruiz quiere ser tu amigo.')
        RETURNING id
)
INSERT INTO notificaciones_usuarios (id_notificacion, correo_usuario)
SELECT id, 'lucia.martin@example.com' FROM n1;

WITH n2 AS (
    INSERT INTO notificaciones (tipo, contenido) VALUES
                                                     ('publicacion_amigo', 'Tu amigo Juan Garcia ha realizado una nueva publicación.')
        RETURNING id
)
INSERT INTO notificaciones_usuarios (id_notificacion, correo_usuario)
SELECT id, 'ana.perez@example.com' FROM n2;

WITH n3 AS (
    INSERT INTO notificaciones (tipo, contenido) VALUES
                                                     ('publicacion_grupo', 'Hay una nueva publicación en el grupo Desarrollo Web.')
        RETURNING id
)
INSERT INTO notificaciones_usuarios (id_notificacion, correo_usuario)
SELECT id, correo_usuario
FROM n3, grupos_usuarios
WHERE id_grupo = 2 AND correo_usuario <> 'carlos.ruiz@example.com';
