DELETE FROM DBO.Cargo;

DELETE FROM DBO.Personal;

DELETE FROM DBO.Seccion
WHERE CodSeccion > 1;

DELETE FROM DBO.Cargo
WHERE CodCargo IN (400, 600, 800);
