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
SELECT usuario_1, usuario_2
FROM amistades;

-- Listar los amigos de un usuario particular de la red social
SELECT a.usuario_1
FROM amistades a
WHERE a.usuario_2 = 'ana.perez@example.com'
UNION
SELECT a.usuario_2
FROM amistades a
WHERE a.usuario_1 = 'ana.perez@example.com';

-- Listar todos los mensajes de la red social
SELECT contenido
FROM mensajes;

-- Contar la cantidad de usuarios de cada pais
SELECT p.nombre AS pais, COUNT(u.id_pais) AS cantidad_usuarios
FROM paises p
LEFT JOIN usuarios u ON p.id = u.id_pais
GROUP BY p.nombre;

-- Realizar una publicación tipo texto libre -- TODO: capaz para las claves subrogadas (por ej IDs) sea mejor usar SERIAL (no del estándar pero si de postgres) en lugar de INT para no tener problemas con la repetición de IDs
INSERT INTO publicaciones (id, usuario_creador)
VALUES (1, 'ana.perez@example.com');
INSERT INTO publicaciones_textos_libres (id_publicacion, texto)
VALUES (1, 'Ejemplo de texto libre');

-- TODO: Realizar una publicación (tipo imagen).
-- TODO: Realizar una publicación (tipo video).
-- TODO: Actualizar una publicación (tipo texto).
-- TODO: Actualizar una publicación (tipo imagen).
-- TODO: Actualizar una publicación (tipo video).
-- TODO: Eliminar una publicación (tipo texto).
-- TODO: Eliminar una publicación (tipo imagen).
-- TODO: Eliminar una publicación (tipo video).
-- TODO: Desregistrar a un usuario de la aplicación (dar un ejemplo).
-- TODO: Mostrar las publicaciones más populares ordenadas por cantidad de “favoritos” que poseen.
-- TODO: Mostrar los usuarios más populares basandose en la cantidad de publicaciones “favoritas” que poseen sus publicaciones.