CREATE FUNCTION alea(p_min INT, p_max INT)
RETURNS INTEGER
BEGIN
	DECLARE tmp INT;
	IF p_min > p_max THEN
		SET tmp := p_min;
		SET p_min := p_max;
		SET p_max := p_min;
	END IF;
	RETURN p_min + FLOOR(RAND() * (p_max - p_min));
END