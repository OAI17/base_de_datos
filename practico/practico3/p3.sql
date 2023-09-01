use world; 

-- Parte I

-- ej1
SELECT city.Name,country.Name,country.Region,country.GovernmentForm FROM city 
INNER JOIN country ON city.CountryCode = country.Code 
ORDER BY city.Population DESC LIMIT 10;

--ej2
SELECT Name,Capital FROM country ORDER BY Population ASC LIMIT 10;
-- adicional : sacando los nulls
     SELECT Name,Capital FROM country WHERE Capital IS NOT NULL ORDER BY Population ASC LIMIT 10;

--ej3
SELECT country.Name, country.Continent, countrylanguage.LanguageCountry FROM country 
INNER JOIN countrylanguage ON country.CODE = countrylanguage.CountryCode;

--ej4
SELECT country.Name, city.Name FROM country 
INNER JOIN city ON country.Capital = city.ID
ORDER BY SurfaceArea DESC LIMIT 20;

--ej5
SELECT city.Name, countrylanguage.LanguageCountry, countrylanguage.Percentage FROM city 
INNER JOIN countrylanguage ON city.CountryCode = countrylanguage.CountryCode 
WHERE countrylanguage.IsOfficial = 'T' ORDER BY city.Population;

--ej6 
(SELECT Name,Population FROM country ORDER BY Population DESC LIMIT 10)
UNION 
(SELECT Name,Population FROM country WHERE Population >= 100 ORDER BY Population ASC LIMIT 10);

--ej7
(SELECT country.Name FROM country 
INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'T' AND countrylanguage.LanguageCountry = 'English')
INTERSECT
(SELECT country.Name FROM country 
INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial = 'T' AND  countrylanguage.LanguageCountry = 'French');

--ej8
-- EXCEPT ES COMO A-B
(SELECT country.Name FROM country 
INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.LanguageCountry = 'English')
EXCEPT
(SELECT country.Name FROM country 
INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.LanguageCountry = 'Spanish');


-- Parte II
--eja
(SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code AND country.Name = 'Argentina')
EXCEPT
(SELECT city.Name, country.Name
FROM city
INNER JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Argentina');

-- Devuelve lo mismo porque reste los conjuntos con un except y me dio vacio
-- Es lo mismo porque tanto where como el on imponen una condicion sobre el conjunto de datos respuesta

--ejb
(SELECT city.Name, country.Name
FROM city
LEFT JOIN country ON city.CountryCode = country.Code AND country.Name = 'Argentina')
EXCEPT
(SELECT city.Name, country.Name
FROM city
LEFT JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Argentina');

-- No devuelve lo mismo porque le reste al conjunto mas grande el conjunto menor y no quedo un set vacio
-- TIENE QUE VER CON LOS NULLS 
