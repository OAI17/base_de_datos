--ejercicio 1
--Cree una tabla de `directors` con las columnas: Nombre, Apellido, Número de Películas.
CREATE TABLE directors (Nombre VARCHAR(50), Apellido VARCHAR(50), numpeliculas INT);

--ejercicio 2
--El top 5 de actrices y actores de la tabla `actors` que tienen la mayor experiencia (i.e. el mayor número 
--de películas filmadas) son también directores de las películas en las que participaron.
-- Basados en esta información, inserten, utilizando una subquery los valores correspondientes en la tabla `directors`.
INSERT INTO directors (Nombre, Apellido, numpeliculas)
SELECT actor.first_name, actor.last_name, COUNT(film.film_id) AS quantity FROM actor 
INNER JOIN film_actor film ON actor.actor_id = film.actor_id 
GROUP BY actor.actor_id ORDER BY quantity DESC LIMIT 5;

/*una onda asi con la subquey
INSERT INTO directors (Nombre, Apellido, numpeliculas)
SELECT actor.first_name, actor.last_name, quantity
FROM (
    SELECT actor.first_name, actor.last_name, COUNT(film.film_id) AS quantity FROM actor 
    INNER JOIN film_actor film ON actor.actor_id = film.actor_id 
    GROUP BY actor.actor_id ORDER BY quantity DESC LIMIT 5
    ) 
AS top5;
*/

--ejercicio3
--Agregue una columna `premium_customer` que tendrá un valor 'T' o 'F' de acuerdo a si el cliente es "premium" o no.
--Por defecto ningún cliente será premium.

ALTER TABLE customer 
ADD premium_customer VARCHAR(1) DEFAULT 'F';

/*
Además, ten en cuenta que la nueva columna se agregará al final de la tabla por defecto, 
a menos que especifiques una posición específica utilizando la cláusula AFTER. Por ejemplo:
ALTER TABLE mi_tabla
ADD nueva_columna VARCHAR(255) AFTER otra_columna;
*/

--ejercicio4
--Modifique la tabla customer. Marque con 'T' en la columna `premium_customer` de los 10 clientes 
--con mayor dinero gastado en la plataforma.

CREATE VIEW temp_table AS
    (SELECT customer_id, SUM(amount) AS spent_money FROM payment
    GROUP BY customer_id ORDER BY spent_money DESC LIMIT 10);

UPDATE customer SET premium_customer = 'T'
WHERE customer_id IN (SELECT customer_id FROM temp_table);             

--ejercicio5
--Listar, ordenados por cantidad de películas (de mayor a menor), 
--los distintos ratings de las películas existentes 
--(Hint: rating se refiere en este caso a la clasificación según edad: G, PG, R, etc).
SELECT rating, COUNT(rating) AS quantity FROM film 
GROUP BY rating ORDER BY quantity DESC;

--ejercicio6
--¿Cuáles fueron la primera y última fecha donde hubo pagos?
(SELECT payment_date FROM payment 
ORDER BY payment_date ASC LIMIT 1)
UNION
((SELECT payment_date FROM payment 
ORDER BY payment_date DESC LIMIT 1)
);

--ejercicio7
--Calcule, por cada mes, el promedio de pagos 
--(Hint: vea la manera de extraer el nombre del mes de una fecha).
SELECT MONTH(payment_date) AS mes, AVG(amount) FROM payment
GROUP BY mes;

--ejercicio8 
--Listar los 10 distritos que tuvieron mayor cantidad de alquileres (con la cantidad total de alquileres).
SELECT a.district, COUNT(p.payment_id) FROM address a
INNER JOIN customer c ON a.address_id = c.address_id
INNER JOIN payment p ON c.customer_id = p.customer_id
GROUP BY a.district;

--ejercicio9 
--Modifique la table `inventory_id` agregando una columna `stock` que sea un número entero y representa 
--la cantidad de copias de una misma película que tiene determinada tienda. 
--El número por defecto debería ser 5 copias.
ALTER TABLE inventory ADD stock INT DEFAULT 5 NOT NULL;

--ejercicio10
--Cree un trigger `update_stock` que, cada vez que se agregue un nuevo registro a la tabla rental, 
--haga un update en la tabla `inventory` restando una copia al stock de la película rentada 
--(Hint: revisar que el rental no tiene información directa sobre la tienda, sino sobre el cliente, que está 
--asociado a una tienda en particular).

/* SE HACE ALGO ASI
DELIMITER //
CREATE trigger update_stock 
AFTER INSERT ON rental
FOR EACH ROW 
BEGIN
    UPDATE inventory SET stock = stock - 1 WHERE NEW.inventory_id = inventory.inventory_id;
END;
//
DELIMITER;
*/

CREATE trigger update_stock 
AFTER INSERT ON rental
FOR EACH ROW 
    UPDATE inventory SET stock = stock - 1 WHERE NEW.inventory_id = inventory.inventory_id;

-- chequear que funcione 
INSERT INTO rental (rental_id,rental_date,invertory_id,customer_id,return_date,staff_id,last_update) 
VALUES (16050,2005-08-23 22:50:12,2666,393,2005-08-30 01:01:12,2);

--ejercicio11
--Cree una tabla `fines` que tenga dos campos: `rental_id` y `amount`. 
--El primero es una clave foránea a la tabla rental y el segundo es un valor numérico con dos decimales.
CREATE TABLE fines (fines_id INT AUTO_INCREMENT,
                    PRIMARY KEY(fines_id),
                    rental_id INT,
                    amount DECIMAL(5,2),
                    FOREIGN KEY (rental_id) REFERENCES rental(rental_id));

--ejercicio12
--Cree un procedimiento `check_date_and_fine` que revise la tabla `rental` y cree un registro en la tabla `fines`
--por cada `rental` cuya devolución (return_date) haya tardado más de 3 días (comparación con rental_date).
--El valor de la multa será el número de días de retraso multiplicado por 1.5.

DELIMITER //
CREATE PROCEDURE check_date_and_fine()
BEGIN
    INSERT INTO fines (rental_id, amount) 
    SELECT rental_id, 1.5*TIMESTAMPDIFF(DAY, rental_date, return_date) FROM rental 
    WHERE TIMESTAMPDIFF(DAY, rental_date, return_date) > 3 ;
END;
//
DELIMITER ;

--se ejeucata un procedimieneto con call nombre_procedimiento();

--ejercicio13
--Crear un rol `employee` que tenga acceso de inserción, eliminación y actualización a la tabla `rental`.
CREATE ROLE employee;
GRANT INSERT, DELETE, UPDATE ON sakila.rental TO employee;

--ejercicio14
--Revocar el acceso de eliminación a `employee` y crear un rol `administrator` 
--que tenga todos los privilegios sobre la BD `sakila`.

--REVOKE tipo_privilegio ON nombre_base_datos.nombre_tabla FROM 'nombre_usuario'@'localhost';

REVOKE DELETE ON *.* FROM employee;

CREATE ROLE administrator;
GRANT ALL PRIVILEGES ON sakila to administrator;

--ejercicio15
--Crear dos roles de empleado. A uno asignarle los permisos de `employee` y al otro de `administrator`.
CREATE ROLE employee1,employee2;
GRANT employee TO employee1;
GRANT administrator to employee2;
