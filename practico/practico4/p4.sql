-- PARTE I
-- ej1
--Listar el nombre de la ciudad y el nombre del país de todas las ciudades que pertenezcan a 
--países con una población menor a 10000 habitantes.
SELECT city.Name, country.Name FROM city 
INNER JOIN country ON city.CountryCode = country.Code 
WHERE country.Population > 10000;

--ej2
--Listar todas aquellas ciudades cuya población sea mayor que la población promedio entre todas las ciudades.
SELECT Name FROM city 
WHERE Population > (SELECT AVG(Population) FROM city);

--ej3
--Listar todas aquellas ciudades no asiáticas cuya población sea igual o mayor a la población total de algún país de Asia.
SELECT city.Name FROM city
INNER JOIN country ON city.CountryCode = country.Code
WHERE country.Continent != 'Asia' AND 
city.Population >= (SELECT MIN(Population) FROM country WHERE Continent = 'Asia');

--ej4
--Listar aquellos países junto a sus idiomas no oficiales,
--que superen en porcentaje de hablantes a cada uno de los idiomas oficiales del país.
SELECT c.Name, cl.LanguageCountry from country c
INNER JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.IsOfficial = 'F' 
AND cl.Percentage > (SELECT MAX(cl_max.Percentage) FROM countrylanguage cl_max WHERE cl_max.IsOfficial = 'T' AND cl_max.CountryCode = cl.CountryCode GROUP BY CountryCode);
                                --maximo porcentaje de los idiomas oficiales 

--REFLEXION -> Los apodos son globales, puedo acceder a apodos externos dentro de consultas internas 

--ej5
--Listar (sin duplicados) aquellas regiones que tengan países con una superficie menor a 1000 km2 
--y exista (en el país) al menos una ciudad con más de 100000 habitantes. 
SELECT DISTINCT country.Region FROM country  
WHERE country.SurfaceArea < 1000 
AND 100000 <= (SELECT MAX(Population) FROM city WHERE CountryCode = country.Code);

--ej6
--Listar el nombre de cada país con la cantidad de habitantes de su ciudad más poblada.
--(Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas escalares o usando agrupaciones, encontrar ambas).
SELECT c.Name, MAX(cy.Population) FROM country c 
INNER JOIN city cy ON c.Code = cy.CountryCode
GROUP BY cy.CountryCode;

SELECT c.Name, (SELECT MAX(Population) FROM city WHERE CountryCode = c.Code) FROM country c;  
-- No da igual porque esta tiene campos null 

--ej7
--Listar aquellos países y sus lenguajes no oficiales cuyo porcentaje de hablantes sea mayor al 
--promedio de hablantes de los lenguajes oficiales.
SELECT c.Name, cl.LanguageCountry FROM country c
INNER JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.IsOfficial = 'F' 
AND cl.Percentage > (SELECT AVG(cl_max.Percentage) FROM countrylanguage cl_max WHERE cl_max.IsOfficial = 'T' AND cl_max.CountryCode = cl.CountryCode GROUP BY CountryCode);

--ej8
--Listar la cantidad de habitantes por continente ordenado en forma descendente.
SELECT c.Continent, SUM(c.Population) FROM country c 
GROUP BY c.Continent;
-- REFELXION : El sum se aplica entre los elementos que agrupa group by

--ej9
--Listar el promedio de esperanza de vida (LifeExpectancy) por continente con una esperanza de vida entre 40 y 70 años.
SELECT Continent, AVG(LifeExpectancy) 
FROM (SELECT Continent, LifeExpectancy FROM country WHERE  40 <= LifeExpectancy AND LifeExpectancy <= 70) AS filtered_data
GROUP BY Continent;

--ej10
--Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente.
SELECT Continent,MAX(Population),MIN(Population),AVG(Population), SUM(Population) FROM country 
GROUP BY Continent;
-- Los ceros en Oseania y Africa se dan porque hay paises sin habitantes
    --SELECT Name,Continent FROM country WHERE Population = 0;

-- PARTE II
--Si en la consulta 6 se quisiera devolver, además de las columnas ya solicitadas, 
--el nombre de la ciudad más poblada. ¿Podría lograrse con agrupaciones? ¿y con una subquery escalar?

SELECT c.Name, 
(SELECT MAX(Population) FROM city WHERE CountryCode = c.Code) AS max_population_city,
(SELECT Name FROM city WHERE Population = max_population_city AND CountryCode = c.Code)
FROM country c;  
-- No puede lograrse con agrupaciones, pero si con una subquery. Pero hay que suponer que no hay paises con el mismo
-- nombre ni tampoco dos ciudades de un pais con la misma cantidad de habitantes
