INSERT INTO dbo.Cargo (CodCargo, DescripcionCargo)
VALUES (NEXT VALUE FOR SEQ_Cargo, 'Facturador');

INSERT INTO dbo.Cargo 
VALUES (NEXT VALUE FOR SEQ_Cargo, 'Contador');

INSERT INTO dbo.Cargo (DescripcionCargo)
VALUES ('Auxiliar Contable');

INSERT INTO dbo.Pais (NombrePais, NombreContinente, Gentilicio)
VALUES ('Paraguay', 'Sudamérica', 'Paraguayo');

INSERT INTO dbo.Pais (NombrePais, NombreContinente, Gentilicio)
VALUES ('Brasil', 'Sudamérica', 'Brasilero');

INSERT INTO dbo.Pais (NombrePais, NombreContinente, Gentilicio)
VALUES ('Argentina', 'Sudamérica', 'Argentino');

