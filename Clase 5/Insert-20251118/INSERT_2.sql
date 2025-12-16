INSERT INTO dbo.Cargo (CodCargo, DescripcionCargo)
VALUES (NEXT VALUE FOR SEQ_Cargo, 'Tesorero'),
	   (NEXT VALUE FOR SEQ_Cargo, 'Depositero'),
	   (NEXT VALUE FOR SEQ_Cargo, 'Gerente de TI'),
	   (NEXT VALUE FOR SEQ_Cargo, 'Programador'),
	   (NEXT VALUE FOR SEQ_Cargo, 'Analista de Requisitos'),
	   (NEXT VALUE FOR SEQ_Cargo, 'Auxiliar Administrativo');

INSERT INTO dbo.Seccion
DEFAULT VALUES;
INSERT INTO dbo.Seccion
DEFAULT VALUES;

INSERT INTO dbo.Ciudad (CodPais, 
						CodCiudad, 
						NombreCiudad)
VALUES (1, 1, 'Asunción'),
       (1, 2, 'Ciudad del Este'),
	   (1, 3, 'Encarnación');

INSERT INTO dbo.Sucursal (CodSucursal,
						  DescripcionSucursal, 
						  CodPais,
						  CodCiudad,
						  NroPersonal)
VALUES (1, 'CASA MATRIZ', 1, 1, NULL);

INSERT INTO dbo.Sucursal (CodSucursal,
						  DescripcionSucursal, 
						  CodPais,
						  CodCiudad,
						  NroPersonal)
VALUES (2, 'SUCURSAL CDE', 1, 2, NULL);

INSERT INTO dbo.Sucursal (CodSucursal,
						  DescripcionSucursal, 
						  CodPais,
						  CodCiudad,
						  NroPersonal)
VALUES (3, 'SUCURSAL ENCARNACIÓN', 1, 3, DEFAULT);

INSERT INTO dbo.Sucursal (CodSucursal,
						  DescripcionSucursal, 
						  CodPais,
						  CodCiudad,
						  NroPersonal)
VALUES (4, 'SUCURSAL PEDRO JUAN CABALLERO', 1, 4, DEFAULT);
