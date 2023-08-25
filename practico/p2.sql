CREATE TABLE country (
    Code varchar(100) PRIMARY KEY NOT NULL,
    Name varchar(100),
    Continent varchar(100),
    Region varchar(100),
    SurfaceArea int,
    IndepYear int,
    Population int,
    LifeExpectancy int,
    GNP int,
    GNPOld int,
    LocalName varchar(100),
    GovernmentForm varchar(100),
    HeadOfState varchar(100),
    Capital int,
    Code2 varchar(100));

CREATE TABLE city (
    ID int AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    CountryCode varchar(100),
    District varchar(100),
    Population int,
    FOREIGN KEY (CountryCode) REFERENCES country(Code));

CREATE TABLE countrylanguage (
    CountryCode varchar(100),
    LanguageCountry varchar(100),
    IsOfficial varchar(100),
    Percentage numeric(5,2),
    PRIMARY KEY (CountryCode, LanguageCountry),
    FOREIGN KEY (CountryCode) REFERENCES country(Code));

    
CREATE TABLE Continent (
    Name varchar(100) PRIMARY KEY,
    Area int,
    PercentTotalMass numeric(5,2),
    MostPopulousCity varchar(100));


-- Consultas
-- select * from city where CountryCode = 'USA';
-- select MAX(Population) AS max_pop FROM city;
-- select Name from city order by Population desc limit 1;
-- select code from country group by code

INSERT INTO `Continent` VALUES ('AFRICA', 30370000, 20.4, 'Cairo, Egypt');
INSERT INTO `Continent` VALUES ('ANTARCTICA', 14000000, 9.2, 'McMurdo Station');
INSERT INTO `Continent` VALUES ('ASIA', 45579000, 29.5, 'Mumbai, India');
INSERT INTO `Continent` VALUES ('EUROPE', 10180000, 6.8, 'Instanbul, Turquia');
INSERT INTO `Continent` VALUES ('NORTH AMERICA', 24709000, 16.5, 'Ciudad de Mexico, Mexico');
INSERT INTO `Continent` VALUES ('OCEANIA', 8600000, 5.9, 'Sidney, Australia');
INSERT INTO `Continent` VALUES ('SOUTH AMERICA', 1784000, 12.0, 'Sao Paulo, Brazil');
ALTER TABLE country ADD FOREIGN KEY (Continent) REFERENCES Continent(Name);

-- Consultas
SELECT Name, Region FROM country ORDER BY Name;
SELECT Name, Population FROM country ORDER BY Population DESC LIMIT 10;
SELECT Name, Region, SurfaceArea, GovernmentForm ORDER BY SurfaceArea ASC LIMIT 10;
SELECT Name FROM country WHERE IndepYear IS NULL;
SELECT Percentage, LanguageCountry FROM countrylanguage WHERE IsOfficial = 'T';
