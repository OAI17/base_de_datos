--ejercicio 1
CREATE TABLE `stocks` (
	store_id INT NOT NULL,
	product_id INT NOT NULL,
    quantity INT,
    PRIMARY KEY (store_id,product_id),
    FOREIGN KEY (store_id) REFERENCES stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

source "path"/data_stocks.sql

--ejercicio 2
/*
Listar los precios de lista máximos y mínimos en cada categoría retornando
solamente aquellas categorías que tiene el precio de lista máximo superior a
5000 o el precio de lista mínimo inferior a 400.
*/
SELECT c.category_id, MAX(list_price) AS max_price, MIN(list_price) AS min_price FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id
HAVING max_price > 5000 AND min_price < 400;

--ejericio 3
/*
Crear un procedimiento `add_product_stock_to_store` que tomará un
nombre de store, un nombre de producto y una cantidad entera donde
actualizará la cantidad del producto en la store especificada (i.e., solo sumará el
valor de entrada al valor corriente en la tabla `stocks`)
*/
DELIMITER //
CREATE PROCEDURE add_product_stock_to_store(IN s_name VARCHAR (255), IN p_name VARCHAR (255) ,IN add_quantity INT)
BEGIN
    DECLARE s_id INT;
    DECLARE p_id INT;

    SELECT store_id INTO s_id FROM stores WHERE s_name = store_name;

    SELECT product_id INTO p_id FROM products WHERE p_name = product_name;
    
    UPDATE stocks SET quantity = quantity + add_quantity WHERE store_id = s_id AND product_id = p_id;    

END //
DELIMITER ;

call add_product_stock_to_store("nacho hdp", "Trek 820 - 2016", 3);

--ejercicio 4
/*
Crear un trigger llamado `decrease_product_stock_on_store` que
decrementará el valor del campo `quantity` de la tabla `stocks` con el valor
del campo `quantity` de la tabla `order_items`.
El trigger se ejecutará luego de un `INSERT` en la tabla `order_items` y deberá
actualizar el valor en la tabla `stocks` de acuerdo al valor correspondiente.
*/
CREATE trigger decrease_product_stock_on_store 
AFTER INSERT ON order_items
FOR EACH ROW 
    UPDATE stocks SET quantity = quantity - NEW.quantity 
    WHERE NEW.product_id = stocks.product_id 
        AND stocks.store_id = (SELECT store_id FROM orders WHERE NEW.order_id = orders.order_id);
--NEW permite acceder a los valores de order_items (la tabla que se le hace una accion)

--ejemplos para probar el trigger
INSERT INTO orders(order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id,staff_id)
VALUES(1616,136,3,'20181228','20181228',NULL,3,8);
INSERT INTO order_items(order_id, item_id, product_id, quantity, list_price,discount) VALUES(1616,2,1,2,429.00,0.2);

--ejercicio 5
/*
Devuelva el precio de lista promedio por brand para todos los productos con
modelo de año (`model_year`) entre 2016 y 2018.
*/
SELECT brands.brand_id,AVG(list_price) AS AVG_PRICE FROM brands 
INNER JOIN products ON brands.brand_id = products.brand_id
WHERE 2016 <= model_year AND model_year <= 2018
GROUP BY brand_id ORDER BY brand_id; 

--ejercicio 6
/*
Liste el número de productos y ventas para cada categoría de producto.
Tener en cuenta que una venta (`orders` table) es completada cuando la
columna `order_status` = 4
*/

SELECT category_name, COUNT(DISTINCT p.product_id) AS cant_productos,SUM(quantity) AS cant_ventas FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id 
INNER JOIN categories cn ON p.category_id = cn.category_id
WHERE o.order_status = 4
GROUP BY p.category_id ORDER BY category_name;

--ejrcicio 7 
/*
Crear el rol `human_care_dept` y asignarle permisos de creación sobre la tabla
`staffs` y permiso de actualización sobre la columna `active` de la tabla
`staffs`.
*/
CREATE ROLE human_care_dept;
GRANT CREATE ON bicyclestores.staffs TO human_care_dept;
GRANT UPDATE (active) ON bicyclestores.staffs TO human_care_dept; 