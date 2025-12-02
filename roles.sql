-- rol administrador
CREATE ROLE administrador WITH LOGIN SUPERUSER;

-- rol usuario
CREATE ROLE usuario WITH LOGIN;

GRANT CONNECT ON DATABASE "tp-bdd" TO USUARIO;

GRANT USAGE ON SCHEMA public TO usuario;

GRANT INSERT ON publicaciones, publicaciones_textos_libres, publicaciones_imagenes, publicaciones_videos, grupos, mensajes TO usuario;

GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO usuario;