
-- Crear la tabla de Usuarios
CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol VARCHAR(20) NOT NULL
);

-- Insertar usuarios en la tabla
INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES
('usuario1@example.com', 'Nombre1', 'Apellido1', 'administrador'),
('usuario2@example.com', 'Nombre2', 'Apellido2', 'usuario'),
('usuario3@example.com', 'Nombre3', 'Apellido3', 'usuario'),
('usuario4@example.com', 'Nombre4', 'Apellido4', 'usuario'),
('usuario5@example.com', 'Nombre5', 'Apellido5', 'usuario');

-- Crear la tabla de Posts
CREATE TABLE Posts (
    id SERIAL PRIMARY KEY,
    título VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN NOT NULL,
    usuario_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

-- Insertar los posts
INSERT INTO Posts (título, contenido,fecha_creacion,fecha_actualizacion, destacado, usuario_id) VALUES
('Título del Post 1', 'Contenido del Post 1','2023-12-05',NULL,  false, 1),
('Título del Post 2', 'Contenido del Post 2','2023-12-05',NULL, true, 1),
('Título del Post 3', 'Contenido del Post 3','2023-12-05',NULL, false, 2),
('Título del Post 4', 'Contenido del Post 4','2023-12-05',NULL, true, 2),
('Título del Post 5', 'Contenido del Post 5','2023-12-05',NULL, false, NULL);

-- Crear la tabla de Comentarios
CREATE TABLE Comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (post_id) REFERENCES Posts(id)
);

-- Insertar los comentarios
INSERT INTO Comentarios (contenido, usuario_id, post_id) VALUES
('Contenido del comentario 1', 1, 1),
('Contenido del comentario 2', 2, 1),
('Contenido del comentario 3', 3, 1),
('Contenido del comentario 4', 1, 2),
('Contenido del comentario 5', 2, 2);


-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
-- nombre y email del usuario junto al título y contenido del post.
-- (1 Punto)


SELECT Usuarios.nombre, Usuarios.email, Posts.título, Posts.contenido
FROM Usuarios
INNER JOIN Posts ON Usuarios.id = Posts.usuario_id;


-- 3. Muestra el id, título y contenido de los posts de los administradores.
-- a. El administrador puede ser cualquier id.
-- (1 Punto).

SELECT Posts.id, Posts.título, Posts.contenido
FROM Posts
INNER JOIN Usuarios ON Posts.usuario_id = Usuarios.id
WHERE Usuarios.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario.
-- a. La tabla resultante debe mostrar el id e email del usuario junto con la
-- cantidad de posts de cada usuario.
-- (1 Punto)

SELECT Usuarios.id, Usuarios.email, COUNT(Posts.id) AS cantidad_posts
FROM Usuarios
LEFT JOIN Posts ON Usuarios.id = Posts.usuario_id
GROUP BY Usuarios.id, Usuarios.email;


-- 5. Muestra el email del usuario que ha creado más posts.
-- a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
-- (1 Punto)

SELECT Usuarios.email
FROM Usuarios
LEFT JOIN (
    SELECT usuario_id, COUNT(id) AS cantidad_posts
    FROM Posts
    GROUP BY usuario_id
) AS CountPosts ON Usuarios.id = CountPosts.usuario_id
ORDER BY cantidad_posts DESC
LIMIT 1;


-- 6. Muestra la fecha del último post de cada usuario.
-- (1 Punto)

SELECT Usuarios.id, Usuarios.email, MAX(Posts.fecha_creacion) AS ultimo_post
FROM Usuarios
LEFT JOIN Posts ON Usuarios.id = Posts.usuario_id
GROUP BY Usuarios.id, Usuarios.email;


-- 7. Muestra el título y contenido del post (artículo) con más comentarios.
-- (1 Punto)

SELECT Posts.título, Posts.contenido
FROM Posts
INNER JOIN (
    SELECT post_id, COUNT(id) AS cantidad_comentarios
    FROM Comentarios
    GROUP BY post_id
    ORDER BY cantidad_comentarios DESC
    LIMIT 1
) AS PostComentarios ON Posts.id = PostComentarios.post_id;


-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
-- de cada comentario asociado a los posts mostrados, junto con el email del usuario
-- que lo escribió

SELECT Posts.título AS título_post, Posts.contenido AS contenido_post, Comentarios.contenido AS contenido_comentario, Usuarios.email
FROM Posts
LEFT JOIN Comentarios ON Posts.id = Comentarios.post_id
LEFT JOIN Usuarios ON Comentarios.usuario_id = Usuarios.id;

-- 9. Muestra el contenido del último comentario de cada usuario.
-- (1 Punto)

SELECT Usuarios.email, Comentarios.contenido AS ultimo_comentario
FROM Usuarios
LEFT JOIN (
    SELECT usuario_id, contenido, MAX(fecha_creacion) AS ultima_fecha
    FROM Comentarios
    GROUP BY usuario_id, contenido
) AS UltimosComentarios ON Usuarios.id = UltimosComentarios.usuario_id
LEFT JOIN Comentarios ON UltimosComentarios.usuario_id = Comentarios.usuario_id AND UltimosComentarios.ultima_fecha = Comentarios.fecha_creacion;


-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.
-- (1 Punto)

SELECT Usuarios.email
FROM Usuarios
LEFT JOIN Comentarios ON Usuarios.id = Comentarios.usuario_id
WHERE Comentarios.id IS NULL;
