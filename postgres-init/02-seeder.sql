BEGIN;

-- 1. PAÍSES
INSERT INTO paises (nombre) VALUES
  ('Argentina'),
  ('Colombia'),
  ('España'),
  ('México');

-- 2. USUARIOS (referencia id_pais por nombre)
INSERT INTO usuarios (correo_electronico, contrasenia, nombre, apellido, id_pais, nro_accesos) VALUES
  ('ana.perez@example.com', 'pass1', 'Ana', 'Perez', (SELECT id_pais FROM paises WHERE nombre='Argentina'), 15),
  ('juan.garcia@example.com', 'pass12', 'Juan', 'Garcia', (SELECT id_pais FROM paises WHERE nombre='Colombia'), 30),
  ('sofia.lopez@example.com', 'pass123', 'Sofia', 'Lopez', (SELECT id_pais FROM paises WHERE nombre='Argentina'), 5),
  ('carlos.ruiz@example.com', 'pass1234', 'Carlos', 'Ruiz', (SELECT id_pais FROM paises WHERE nombre='España'), 22),
  ('lucia.martin@example.com', 'pass12345', 'Lucia', 'Martin', (SELECT id_pais FROM paises WHERE nombre='México'), 10),
  ('jose_martinez@gmail.com', 'pass123456', 'Jose', 'Martinez', (SELECT id_pais FROM paises WHERE nombre='Colombia'), 10);

-- 3. AMISTADES (respeta CHECK correo_usuario_1 < correo_usuario_2)
INSERT INTO amistades (correo_usuario_1, correo_usuario_2, estado) VALUES
  ('ana.perez@example.com', 'juan.garcia@example.com', 'aceptada'),
  ('ana.perez@example.com', 'sofia.lopez@example.com', 'aceptada'),
  ('juan.garcia@example.com', 'sofia.lopez@example.com', 'aceptada'),
  ('carlos.ruiz@example.com', 'lucia.martin@example.com', 'solicitada');

-- 4. GRUPOS y membresías
INSERT INTO grupos (nombre) VALUES ('Amantes del Cine'), ('Desarrollo Web');

INSERT INTO grupos_usuarios (correo_usuario, id_grupo) VALUES
  ('ana.perez@example.com', 1),
  ('juan.garcia@example.com', 1),
  ('sofia.lopez@example.com', 2),
  ('carlos.ruiz@example.com', 2),
  ('juan.garcia@example.com', 2);

-- 5. PUBLICACIONES
INSERT INTO publicaciones (usuario_creador, id_grupo) VALUES
  ('ana.perez@example.com', NULL),
  ('juan.garcia@example.com', NULL),
  ('sofia.lopez@example.com', NULL),
  ('carlos.ruiz@example.com', 2),
  ('juan.garcia@example.com', 1);

INSERT INTO publicaciones_textos_libres (id_publicacion, texto) VALUES
  (1, 'Qué día increíble para pasear por el parque.'),
  (4, 'Acabo de descubrir un framework de CSS increíble: Tailwind!');

-- Placeholders binarios en vez de pg_read_binary_file
INSERT INTO publicaciones_imagenes (id_publicacion, contenido_imagen) VALUES
  (2, decode('FFD8FFE0', 'hex')),
  (5, decode('FFD8FFE0', 'hex'));

INSERT INTO publicaciones_videos (id_publicacion, contenido_video) VALUES
  (3, decode('00000001', 'hex'));

-- 6. PUBLICACIONES FAVORITAS
INSERT INTO publicaciones_favoritas (correo_usuario, id_publicacion) VALUES
  ('ana.perez@example.com', 5),
  ('sofia.lopez@example.com', 5),
  ('carlos.ruiz@example.com', 5),
  ('juan.garcia@example.com', 1),
  ('ana.perez@example.com', 2),
  ('lucia.martin@example.com', 4);

-- 7. MENSAJES
INSERT INTO mensajes (correo_emisor, correo_receptor, contenido) VALUES
  ('ana.perez@example.com', 'juan.garcia@example.com', 'Hola Juan! ¿Viste la nueva película?'),
  ('juan.garcia@example.com', 'ana.perez@example.com', 'Hola Ana! Sí, la vi anoche. ¡Hablemos en el grupo!');

-- 8. NOTIFICACIONES
WITH n1 AS (
  INSERT INTO notificaciones (tipo, contenido) VALUES ('amistad', 'Carlos Ruiz quiere ser tu amigo.')
  RETURNING id_notificacion
)
INSERT INTO notificaciones_usuarios (id_notificacion, correo_usuario)
SELECT id_notificacion, 'lucia.martin@example.com' FROM n1;

WITH n2 AS (
  INSERT INTO notificaciones (tipo, contenido) VALUES ('publicacion_amigo', 'Tu amigo Juan Garcia ha realizado una nueva publicación.')
  RETURNING id_notificacion
)
INSERT INTO notificaciones_usuarios (id_notificacion, correo_usuario)
SELECT id_notificacion, 'ana.perez@example.com' FROM n2;

WITH n3 AS (
  INSERT INTO notificaciones (tipo, contenido) VALUES ('publicacion_grupo', 'Hay una nueva publicación en el grupo Desarrollo Web.')
  RETURNING id_notificacion
)
INSERT INTO notificaciones_usuarios (id_notificacion, correo_usuario)
SELECT n3.id_notificacion, gu.correo_usuario
FROM n3
JOIN grupos_usuarios gu ON gu.id_grupo = 2
WHERE gu.correo_usuario <> 'carlos.ruiz@example.com';

COMMIT;
