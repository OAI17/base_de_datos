CREATE TABLE city (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100), 
    CountryCode VARCHAR(100), 
    District VARCHAR(100), 
    Population INT,
    FOREIGN KEY (CountryCode) REFERENCES country(Code));

CREATE TABLE countrylanguage (
    CountryCode VARCHAR(100) PRIMARY KEY,
    Language VARCHAR(100),
    IsOfficial VARCHAR(100),
    Percentage INT);
    --FOREIGN KEY (CountryCode) REFERENCES countrylanguage(CountryCode);


CREATE TABLE country (
    Code VARCHAR(100) PRIMARY KEY NOT NULL,
    Name VARCHAR(100),
    Continent VARCHAR(100),
    Region VARCHAR(100),
    SurfaceArea INT,
    IndepYear INT,
    Population INT,
    LifeExpectancy INT,
    GNP INT,
    GNPOld INT,
    LocalName VARCHAR(100),
    GovernmentForm VARCHAR(100),
    HeadOfState VARCHAR(100),
    Capital INT,
    Code2 VARCHAR(100));
    


CREATE TABLE Continent (
    Name VARCHAR(100),
    Area INT,
    Percent-total-mass INT,
    Most-populous-city VARCHAR(100),
);


-- Consultas
-- select * from city where CountryCode = 'USA'
-- select MAX(Population) AS max_pop FROM city;
-- select Name from city order by Population desc limit 1;
-- select code from country group by code