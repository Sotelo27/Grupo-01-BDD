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

-- Contar la cantidad de usuarios de cada pais
SELECT p.nombre AS pais, COUNT(u.id_pais) AS cantidad_usuarios
FROM paises p
LEFT JOIN usuarios u ON p.id = u.id_pais
GROUP BY p.nombre;

-- Realizar una publicación tipo texto libre
INSERT INTO publicaciones (id, usuario_creador)
VALUES (1, 'ana.perez@example.com');
INSERT INTO publicaciones_textos_libres (id_publicacion, texto)
VALUES (1, 'Ejemplo de texto libre');

