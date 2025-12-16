INSERT INTO dbo.Personal
(NroPersonal,
 Nombre,
 Apellido,
 Domicilio,
 Telefono,
 CodPaisNacimiento,
 CodCiudadNacimiento,
 CodPaisResidencia,
 CodCiudadResidencia,
 CodTipoDocumento,
 NroDocumento,
 FechaNacimiento,
 CodCargo,
 CodSeccion,
 CodSucursal,
 FechaIngreso,
 FechaSalida,
 NroJefe,
 SalarioActual)
VALUES  (1,
		 'Juan Alberto',
		 'Benítez Pérez',
		 'Asunción',
		 '021-520365',
		 1,
		 3,
		 1,
		 1,
		 1,
		 '4532789',
		 '1978/02/01',
		 200,
		 1,
		 1,
		 '2013/12/12',
		 NULL,
		 NULL,
		 12000000);

DELETE FROM DBO.Personal;

ALTER TABLE dbo.Personal
CHECK CONSTRAINT ALL;
