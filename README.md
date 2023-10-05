#### Tomas Marmay ~ famaf 2023

##### Frecuent commands
- `source file` : load *file* into current database from mysql  
- `SHOW DATABASES;`
- `SHOW TABLES;`
- `call procedure_name` : execute *prodecure_name* 


##### Tables operations
- `CREATE TABLE table_name (col_1 type_1,..,col_n type_n, integrity-constraint);`
- `DROP TABLE table_name;`
- `ALTER TABLE ADD COLUMN col_1 type_1;`
- `ALTER TABLE DROP COLUMN col_1;` 
- `INSERT INTO table_name (col_1,...,col_n) VALUES (val_1,...,val_n);`
- `DELETE FROM table_name WHERE condition;`
- `UPDATE table_name SET col_1 = val_1 WHERE condition;`

##### Join syntax
![allcases](src/join.jpeg)

##### Inner join :
![innerjoin](src/inner_join.png) 

##### Left join:
![leftjoin](src/left_join.png)

##### Right join:
![rightjoin](src/right_join.png)

##### Full join 
![fulljoin](src/full_join.png)

##### Set operations
- `UNION` : just the union of two sets
- `INTERSECT` : just the intersect of two sets
- `EXCEPT` : compare two result sets and retrieve rows that are present in the first set but not in the second (like subtraction)
![setoperation](src/set_operation.png)
*ALL is used for keep duplicates*

##### Nested queries
![nested](src/nested1.png) 
where nested query could be 
![nested](src/nested2.png)
check columns are or not into nested query
![nested](src/nested3.png)
be careful it can cause strange behavior
![nested](src/nested4.png)
check if nested query is empty or not and then compre with *EXISTS* OR *NOT EXISTS*

##### Aggregation functions
![aggregation_functions](src/aggregation_functions.png)

##### Group by
![group_by](src/group_by.png)

##### Having
![having](src/having.png)
*HAVING* filter after *GROUP BY*
*WHERE* filter before *GROUP BY*

##### Procedure example
![procedure](src/prodecure.png)
First we need to change the delimiter *;* to *//* and then change it back it, only is needed if there are more than one query

##### Trigger example 
![trigger](src/trigger.png)
with *NEW* we can access the data of the new entry 

##### Prvilegies
- How to grant privilegies 
![otorgar](src/otorgar_privilegio.png)
- How to revoke privilegies
![quitar](src/revocar_privilegio.png)

##### Roles
- How to create rol
![rol](src/crear_rol.png)
- How to assign rol 
![asignar](src/asignar_rol.png)
- Example 
![ejemplo](src/asignar_rol.png)
