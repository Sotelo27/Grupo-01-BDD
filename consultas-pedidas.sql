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