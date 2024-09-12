-- #### EVALUACIÓN FINAL MÓDULO 2 ####

USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title AS NombrePeliculas
FROM film;


-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title AS NombrePeliculas, rating AS Calificacion
FROM film
WHERE rating = "PG-13";


--  3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title AS NombrePeliculas, description AS Descripcion
FROM film
WHERE description LIKE "%amazing%";


-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title AS NombrePeliculas, length AS Duracion
FROM film
WHERE length > 120;


-- 5. Recupera los nombres de todos los actores.

SELECT first_name AS Nombre, last_name AS Apellidos
FROM actor; 


-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name AS Nombre, last_name AS Apellido
FROM actor
WHERE last_name = "Gibson";


-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name AS Nombre, last_name AS Apellido, actor_id 
FROM actor
WHERE actor_id BETWEEN 10 AND 20;


-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title AS Titulo, rating AS Calificacion
FROM film
WHERE rating NOT IN ("R", "PG-13");


-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT COUNT(film_id) AS TotalPelis, rating AS Calificacion
FROM film
GROUP BY rating;


-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT customer.customer_id AS ID_Cliente, customer.first_name AS NombreCliente, customer.last_name AS ApellidoCliente, COUNT(rental.rental_id) AS TotalPelisAlquiladas 
FROM rental
INNER JOIN customer ON rental.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name;


-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT category.name AS NombreCategoria, COUNT(rental.rental_id) AS Total_Pelis_Alquiladas
FROM rental 
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id                             -- Rental / Inventory 
INNER JOIN film ON inventory.film_id = film.film_id                                              -- Inventory / Film  
INNER JOIN film_category ON film.film_id = film_category.film_id                                 -- Film / Film_category
INNER JOIN category ON film_category.category_id = category.category_id                          -- Film_Category / Category 
GROUP BY category.name;


-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT AVG(length) AS DuracionMedia, rating AS Clasificacion
FROM film 
GROUP BY rating;


--  13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT actor.first_name AS NombreActores, actor.last_name AS ApellidoActores, film.title AS TituloPelicula
FROM actor 
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film.film_id = film_actor.film_id
WHERE film.title = "Indian Love";


--  14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title AS Titulo, description AS Descripcion
FROM film 
WHERE description LIKE "%dog%" AND description LIKE  "%cat%";


-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

SELECT actor_id AS IDActor, first_name AS NombreActor, last_name AS ApellidoActor
FROM actor
WHERE actor_id NOT IN (
    SELECT actor_id
    FROM film_actor
);


--  16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title AS Titulo, release_year AS AñoEstreno
FROM film
WHERE release_year BETWEEN 2005 AND 2010;


--  17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT film.title AS Titulo, category.name AS Categoria  
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id                 -- Film / Film_category
INNER JOIN category ON film_category.category_id = category.category_id           -- Film_category / Category
WHERE category.name = "Family";


-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT actor.first_name AS NombreActores, actor.last_name AS ApeliidoActores, COUNT(film.film_id)
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id                                          -- Actor / Film_actor
INNER JOIN film ON film_actor.film_id = film.film_id                                                   -- Film_actor / Film
GROUP BY actor.first_name, actor.last_name
HAVING COUNT(film.film_id) > 10;


-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title AS Titulo, rating AS Clasificacion, length AS Duracion
FROM film
WHERE rating = "R" AND length > 120;


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT category.name AS Categoria, AVG(film.length) AS MediaDuracion 
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id                 -- Film / Film_category
INNER JOIN category ON film_category.category_id = category.category_id          -- Film_category / Category
GROUP BY category.name
HAVING AVG(film.length) > 120;


-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT CONCAT(actor.first_name, " ", actor.last_name) AS NombreActor, COUNT(film_actor.film_id) AS CantidadPelis
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id                              -- Actor / Film_actor
GROUP BY actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) >= 5;


-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT title AS Titulo, rental_duration AS DuracionAlquiler
FROM film
WHERE rental_duration IN (                                           
		SELECT rental_id
        FROM rental
        WHERE rental_duration > 5
);


-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
    -- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT first_name AS NombreActor, last_name AS ApellidoActor
FROM actor
WHERE actor_id NOT IN (                                              -- Filtro para eliminar actor_id de la subconsulta
    SELECT DISTINCT film_actor.actor_id
    FROM film_actor
    JOIN film ON film_actor.film_id = film.film_id                                      -- Film_actor / Film
    JOIN film_category ON film.film_id = film_category.film_id                          -- Film / Film_category
    JOIN category ON film_category.category_id = category.category_id                    -- Film_category /  category
    WHERE category.name = "Horror"
);


-- #############
-- ### BONUS ###
-- #############

-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT film.title AS Titulo, film.length AS Duracion, category.name AS Categoria 
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id                       -- Film / Film_category
INNER JOIN category ON film_category.category_id = category.category_id                -- Film_category / Category
WHERE category.name = "Comedy" AND film.length > 180;


--  25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.

	-- Tabla film_actor (actor_id, film_id) uso SELF JOIN. 
    
SELECT A.first_name AS Nombre1, 					-- Primer Actor = A
	   A.last_name AS Apellido1,                    -- Segundo Actor = B 
       B.first_name AS Nombre2, 
       B.last_name AS Apellido2, 
       COUNT(film_A.film_id) AS PeliculasJuntas
       
FROM film_actor AS film_A

JOIN film_actor AS film_B                               -- unión de actores de la misma peli
	ON film_A.film_id = film_B.film_id
    -- film_actor
JOIN actor AS A                                         -- uno con la tabala actor (info del primer actor)
	ON film_A.actor_id = A.actor_id
    
JOIN actor AS B 										-- uno con la tabala actor (info del segundo actor)
	ON film_B.actor_id = B.actor_id
    
WHERE film_A.actor_id < film_B.actor_id                     -- *** cada par de actores aparece solo una vez **** 

GROUP BY A.first_name, A.last_name, B.first_name, B.last_name

HAVING COUNT(film_A.film_id) > 0;                           -- *** solo muestra pares de actores que tienen una peli en común, si tuviesen 0 no salen***











