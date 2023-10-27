--ejercicio1 
ALTER TABLE person
ADD total_medals INT DEFAULT 0; 

--ejercicio2 
CREATE VIEW id_cantidad_medallas AS 
(SELECT person.id, COUNT(*) AS cantidad FROM medal 
INNER JOIN competitor_event comp_event ON medal.id = comp_event.medal_id
INNER JOIN games_competitor games_comp ON comp_event.competitor_id = games_comp.id
INNER JOIN person ON games_comp.person_id = person.id
WHERE medal.medal_name != 'NA'
GROUP BY person.id);

UPDATE person
SET total_medals = (SELECT cantidad from id_cantidad_medallas WHERE person.id = id);

--ejercicio3 
CREATE VIEW arg_players_id AS 
(SELECT games_comp.person_id, person.full_name FROM games_competitor games_comp
INNER JOIN person ON games_comp.person_id = person.id
INNER JOIN person_region ON person.id = person_region.person_id
INNER JOIN noc_region ON person_region.region_id = noc_region.id
WHERE noc_region.noc = 'ARG');

SELECT * FROM
((SELECT arg_players_id.full_name,medal.medal_name,COUNT(*) AS quantity FROM medal 
INNER JOIN competitor_event comp_event ON medal.id = comp_event.medal_id
INNER JOIN games_competitor games_comp ON comp_event.competitor_id = games_comp.id
INNER JOIN arg_players_id ON arg_players_id.person_id = games_comp.person_id
WHERE medal.medal_name = 'Gold'
GROUP BY arg_players_id.person_id)
UNION
(SELECT arg_players_id.full_name,medal.medal_name,COUNT(*) AS quantity FROM medal 
INNER JOIN competitor_event comp_event ON medal.id = comp_event.medal_id
INNER JOIN games_competitor games_comp ON comp_event.competitor_id = games_comp.id
INNER JOIN arg_players_id ON arg_players_id.person_id = games_comp.person_id
WHERE medal.medal_name = 'Silver'
GROUP BY arg_players_id.person_id)
UNION
(SELECT arg_players_id.full_name,medal.medal_name,COUNT(*) AS quantity FROM medal 
INNER JOIN competitor_event comp_event ON medal.id = comp_event.medal_id
INNER JOIN games_competitor games_comp ON comp_event.competitor_id = games_comp.id
INNER JOIN arg_players_id ON arg_players_id.person_id = games_comp.person_id
WHERE medal.medal_name = 'Bronze'
GROUP BY arg_players_id.person_id)) AS RESULT
ORDER BY full_name;

--ejercicio4
SELECT sport.sport_name, COUNT(*) AS cantidad FROM medal 
INNER JOIN competitor_event comp_event ON medal.id = comp_event.medal_id
INNER JOIN event ON comp_event.event_id = event.id
INNER JOIN sport ON event.sport_id = sport.id
INNER JOIN games_competitor games_comp ON comp_event.competitor_id = games_comp.id
INNER JOIN person ON games_comp.person_id = person.id
INNER JOIN person_region ON person.id = person_region.person_id
INNER JOIN noc_region ON person_region.region_id = noc_region.id
WHERE noc_region.noc = 'ARG'
GROUP BY sport.sport_name;

--ejercicio5
SELECT noc_reg.noc,
    (SELECT COUNT(*) FROM medal 
    INNER JOIN competitor_event comp_event ON medal.id = comp_event.medal_id
    INNER JOIN games_competitor games_comp ON comp_event.competitor_id = games_comp.id
    INNER JOIN person ON games_comp.person_id = person.id
    INNER JOIN person_region ON person.id = person_region.person_id
    INNER JOIN noc_region ON person_region.region_id = noc_region.id
    WHERE medal.medal_name = 'Gold' AND noc_region.noc = noc_reg.noc) AS gold,
    (SELECT COUNT(*) FROM medal 
    INNER JOIN competitor_event comp_event ON medal.id = comp_event.medal_id
    INNER JOIN games_competitor games_comp ON comp_event.competitor_id = games_comp.id
    INNER JOIN person ON games_comp.person_id = person.id
    INNER JOIN person_region ON person.id = person_region.person_id
    INNER JOIN noc_region ON person_region.region_id = noc_region.id
    WHERE medal.medal_name = 'Silver' AND noc_region.noc = noc_reg.noc) AS silver,
    (SELECT COUNT(*) FROM medal 
    INNER JOIN competitor_event comp_event ON medal.id = comp_event.medal_id
    INNER JOIN games_competitor games_comp ON comp_event.competitor_id = games_comp.id
    INNER JOIN person ON games_comp.person_id = person.id
    INNER JOIN person_region ON person.id = person_region.person_id
    INNER JOIN noc_region ON person_region.region_id = noc_region.id
    WHERE medal.medal_name = 'Bronze' AND noc_region.noc = noc_reg.noc) AS bronze
FROM noc_region AS noc_reg;

--ejercicio6 
(SELECT noc_region.noc, COUNT(medal.id) AS cantidad FROM medal 
INNER JOIN competitor_event comp_event ON medal.id = comp_event.medal_id
INNER JOIN games_competitor games_comp ON comp_event.competitor_id = games_comp.id
INNER JOIN person ON games_comp.person_id = person.id
INNER JOIN person_region ON person.id = person_region.person_id
INNER JOIN noc_region ON person_region.region_id = noc_region.id
WHERE medal.medal_name != 'NA'
GROUP BY noc_region.noc
ORDER BY cantidad DESC LIMIT 1)
UNION 
(SELECT noc_region.noc, COUNT(medal.id) AS cantidad FROM medal 
INNER JOIN competitor_event comp_event ON medal.id = comp_event.medal_id
INNER JOIN games_competitor games_comp ON comp_event.competitor_id = games_comp.id
INNER JOIN person ON games_comp.person_id = person.id
INNER JOIN person_region ON person.id = person_region.person_id
INNER JOIN noc_region ON person_region.region_id = noc_region.id
WHERE medal.medal_name != 'NA'
GROUP BY noc_region.noc
ORDER BY cantidad ASC LIMIT 1)

--ejercicio7 
--a
CREATE trigger increase_number_of_medals 
AFTER INSERT ON competitor_event
FOR EACH ROW 
    UPDATE person SET total_medals = total_medals + 1 
    WHERE NEW.competitor_id = (SELECT id FROM games_competitor 
                                WHERE NEW.competitor_id = id AND
                                (SELECT id FROM person WHERE id = games_competitor.person_id)); 
--b
CREATE trigger decrease_number_of_medals
AFTER DELETE ON competitor_event
FOR EACH ROW 
    UPDATE person SET total_medals = total_medals - 1 
    WHERE OLD.competitor_id = (SELECT id FROM games_competitor 
                                WHERE OLD.competitor_id = id AND
                                (SELECT id FROM person WHERE id = games_competitor.person_id)); 

--ejercicio8
DELIMITER //
CREATE PROCEDURE add_new_medalists(IN event_id INT, IN g_id INT ,IN s_id INT,IN b_id INT)
BEGIN
    INSERT INTO olympics.competitor_event (event_id, competitor_id, medal_id) VALUES (event_id,g_id,1);
    INSERT INTO olympics.competitor_event (event_id, competitor_id, medal_id) VALUES (event_id,s_id,2);
    INSERT INTO olympics.competitor_event (event_id, competitor_id, medal_id) VALUES (event_id,b_id,3);
END //
DELIMITER ;

--ejercicio9 
CREATE ROLE organizer;
GRANT DELETE ON olympics.games TO organizer;
GRANT UPDATE (games_name) ON olympics.games TO organizer; 
