CREATE TYPE IDPersonal FROM INT NOT NULL;

DROP TYPE IDPersonal;

CREATE TYPE TAB_Personal 
AS TABLE (NroPersonal INT NOT NULL,
          Nombre VARCHAR(50) NOT NULL,
          Apellido VARCHAR(50) NOT NULL);

DECLARE @Personal TAB_Personal;

INSERT INTO @Personal 
VALUES (1, 'JORGE', 'MALDONADO');

SELECT * FROM @Personal;
