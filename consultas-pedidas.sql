-- Registrar un usuario
INSERT INTO usuarios (correo_electronico, contrasenia, nombre, apellido, id_pais)
VALUES ('john_doe@gmail.com', 'StrongP@ssw0rd', 'John', 'Doe', 1);

-- Listar todos los usuarios de la red social
SELECT *
FROM usuarios;

-- Variación solo nombre y apellido
SELECT nombre, apellido
FROM usuarios;

-- Listar todas las amistades de la red social
SELECT correo_usuario_1, correo_usuario_2
FROM amistades;

-- Listar los amigos de un usuario particular de la red social
SELECT a.correo_usuario_1
FROM amistades a
WHERE a.correo_usuario_2 = 'ana.perez@example.com'
UNION
SELECT a.correo_usuario_2
FROM amistades a
WHERE a.correo_usuario_1 = 'ana.perez@example.com';

-- Listar todos los mensajes de la red social
SELECT contenido
FROM mensajes;

-- Contar la cantidad de usuarios de cada pais
SELECT p.nombre AS pais, COUNT(u.id_pais) AS cantidad_usuarios
FROM paises p
LEFT JOIN usuarios u ON p.id_pais = u.id_pais
GROUP BY p.nombre;

-- Realizar una publicación tipo texto libre
INSERT INTO publicaciones (id_publicacion, correo_usuario_creador)
VALUES (1, 'ana.perez@example.com');
INSERT INTO publicaciones_textos_libres (id_publicacion, texto)
VALUES (1, 'Ejemplo de texto libre');


-- Realizar una publicación (tipo imagen).
WITH p AS (
INSERT INTO publicaciones (usuario_creador, id_grupo)
VALUES ('ana.perez@example.com', NULL)
    RETURNING id
    )
INSERT INTO publicaciones_imagenes (id_publicacion, contenido_imagen)
SELECT id, pg_read_binary_file('/docker-entrypoint-initdb.d/imagen.jpg')
FROM p;
-- Un select para ver que se hizo bien
SELECT * FROM publicaciones p
JOIN publicaciones_imagenes pi ON p.id_publicacion = pi.id_publicacion;

-- Realizar una publicación (tipo video).
INSERT INTO publicaciones (id_publicacion, usuario_creador, id_grupo)
VALUES (102, 'ana.perez@example.com', NULL);

INSERT INTO publicaciones_videos (id_publicacion, contenido_video)
VALUES (102, pg_read_binary_file('/docker-entrypoint-initdb.d/2025-11-17 18-13-52.mkv'));

-- Actualizar una publicación (tipo texto).
UPDATE publicaciones_textos_libres
SET texto = 'Texto actualizado, mostrando un update'
WHERE id_publicacion = 1;
-- ahora un select para ver que se hizo bien
SELECT * FROM publicaciones_textos_libres;

-- Actualizar una publicación (tipo imagen).
select * from publicaciones_imagenes;
UPDATE publicaciones_imagenes
SET contenido_imagen = pg_read_binary_file('/docker-entrypoint-initdb.d/imagen_new.jpg')
WHERE id_publicacion = 2;

-- Actualizar una publicación (tipo video).
UPDATE publicaciones_videos
SET contenido_video = pg_read_binary_file('/docker-entrypoint-initdb.d/2025-11-17 18-13-52.mkv')
WHERE id_publicacion = 102;

-- Eliminar una publicación (tipo texto).
DELETE FROM publicaciones_textos_libres
WHERE id_publicacion = 1;
-- Un select para ver que se hizo bien
SELECT * FROM publicaciones_textos_libres;

-- Eliminar una publicación (tipo imagen).
DELETE FROM publicaciones_imagenes
WHERE id_publicacion = 2;

-- Eliminar una publicación (tipo video).
DELETE FROM publicaciones 
WHERE id_publicacion = 102;

-- Desregistrar a un usuario de la aplicación (dar un ejemplo).
DELETE FROM usuarios
WHERE correo_electronico = 'lucia.martin@example.com';

-- Mostrar las publicaciones más populares ordenadas por cantidad de “favoritos” que poseen.
select * from publicaciones_favoritas;
SELECT p.id_publicacion id_publicacion , p.usuario_creador, COUNT(pf.correo_usuario) AS cantidad_favoritos
FROM publicaciones p
LEFT JOIN publicaciones_favoritas pf ON p.id_publicacion = pf.id_publicacion
GROUP BY p.id_publicacion, p.usuario_creador
ORDER BY cantidad_favoritos DESC;

-- Mostrar los usuarios más populares basandose en la cantidad de publicaciones “favoritas” que poseen sus publicaciones.
SELECT u.correo_electronico, u.nombre, u.apellido, COUNT(pf.correo_usuario) AS cantidad_favoritos
FROM usuarios u
LEFT JOIN publicaciones p ON u.correo_electronico = p.usuario_creador
LEFT JOIN publicaciones_favoritas pf ON p.id_publicacion = pf.id_publicacion
GROUP BY u.correo_electronico, u.nombre, u.apellido
ORDER BY cantidad_favoritos DESC;
