CREATE DOMAIN tipo_correo_electronico AS VARCHAR(255)
    CHECK (
        VALUE LIKE '_%@_%._%'
        );

CREATE DOMAIN tipo_estado_amistad AS VARCHAR(10)
    CHECK (
        VALUE IN ('solicitada', 'aceptada')
        );

CREATE TABLE paises (
                        id_pais SERIAL PRIMARY KEY,
                        nombre VARCHAR(63) NOT NULL UNIQUE
);

CREATE TABLE usuarios (
    correo_electronico tipo_correo_electronico PRIMARY KEY,
    contrasenia VARCHAR(255) NOT NULL,
    nombre VARCHAR(127) NOT NULL,
    apellido VARCHAR(127) NOT NULL,
    id_pais INT NOT NULL,
    nro_accesos INT DEFAULT 0,
    FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
);

CREATE TABLE amistades (
                           correo_usuario_1  tipo_correo_electronico NOT NULL,
                           correo_usuario_2  tipo_correo_electronico NOT NULL,
                           estado tipo_estado_amistad NOT NULL DEFAULT 'solicitada',
                           PRIMARY KEY (correo_usuario_1 , correo_usuario_2),
                           FOREIGN KEY (correo_usuario_1) REFERENCES usuarios(correo_electronico) ON DELETE CASCADE,
                           FOREIGN KEY (correo_usuario_2) REFERENCES usuarios(correo_electronico) ON DELETE CASCADE,
                           CHECK (correo_usuario_1 < correo_usuario_2)
);

CREATE TABLE grupos (
                        id_grupo SERIAL PRIMARY KEY,
                        nombre VARCHAR(255) NOT NULL
);

CREATE TABLE grupos_usuarios (
                                 correo_usuario tipo_correo_electronico NOT NULL,
                                 id_grupo INT NOT NULL,
                                 PRIMARY KEY (correo_usuario, id_grupo),
                                 FOREIGN KEY (correo_usuario) REFERENCES usuarios(correo_electronico) ON DELETE CASCADE,
                                 FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo) ON DELETE CASCADE
);

CREATE TABLE notificaciones (
                                id_notificacion SERIAL PRIMARY KEY,
                                tipo VARCHAR(31) NOT NULL,
                                fecha DATE DEFAULT CURRENT_DATE,
                                contenido VARCHAR(255) NOT NULL
);

CREATE TABLE notificaciones_usuarios (
                                         id_notificacion INT NOT NULL,
                                         correo_usuario tipo_correo_electronico NOT NULL,
                                         PRIMARY KEY (id_notificacion, correo_usuario),
                                         FOREIGN KEY (id_notificacion) REFERENCES notificaciones(id_notificacion) ON DELETE CASCADE,
                                         FOREIGN KEY (correo_usuario) REFERENCES usuarios(correo_electronico) ON DELETE CASCADE
);

CREATE TABLE mensajes (
                          id_mensaje SERIAL PRIMARY KEY,
                          contenido VARCHAR(1023) NOT NULL,
                          fecha DATE NOT NULL DEFAULT CURRENT_DATE,
                          correo_emisor tipo_correo_electronico NOT NULL,
                          correo_receptor tipo_correo_electronico NOT NULL,
                          FOREIGN KEY (correo_emisor) REFERENCES usuarios(correo_electronico) ON DELETE CASCADE,
                          FOREIGN KEY (correo_receptor) REFERENCES usuarios(correo_electronico) ON DELETE CASCADE
);

CREATE TABLE publicaciones (
                               id_publicacion SERIAL PRIMARY KEY,
                               fecha DATE DEFAULT CURRENT_DATE,
                               usuario_creador tipo_correo_electronico NOT NULL,
                               id_grupo INT,
                               FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo) ON DELETE SET NULL,
                               FOREIGN KEY (usuario_creador) REFERENCES usuarios(correo_electronico) ON DELETE CASCADE
);

CREATE TABLE publicaciones_textos_libres (
                                             id_publicacion INT PRIMARY KEY,
                                             texto VARCHAR(2047) NOT NULL,
                                             FOREIGN KEY (id_publicacion) REFERENCES publicaciones(id_publicacion) ON DELETE CASCADE
);

CREATE TABLE publicaciones_imagenes (
                                        id_publicacion INT PRIMARY KEY,
                                        contenido_imagen BYTEA NOT NULL,
                                        FOREIGN KEY (id_publicacion) REFERENCES publicaciones(id_publicacion) ON DELETE CASCADE
);

CREATE TABLE publicaciones_videos (
                                      id_publicacion INT PRIMARY KEY,
                                      contenido_video BYTEA NOT NULL,
                                      FOREIGN KEY (id_publicacion) REFERENCES publicaciones(id_publicacion) ON DELETE CASCADE
);

CREATE TABLE publicaciones_favoritas (
                                         correo_usuario tipo_correo_electronico NOT NULL,
                                         id_publicacion INT NOT NULL,
                                         PRIMARY KEY (correo_usuario, id_publicacion),
                                         FOREIGN KEY (correo_usuario) REFERENCES usuarios(correo_electronico) ON DELETE CASCADE,
                                         FOREIGN KEY (id_publicacion) REFERENCES publicaciones(id_publicacion) ON DELETE CASCADE
);
