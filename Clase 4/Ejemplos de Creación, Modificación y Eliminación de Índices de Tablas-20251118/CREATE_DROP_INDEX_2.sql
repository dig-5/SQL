CREATE CLUSTERED INDEX IDX_RegistroMarcacion_Personal
ON dbo.RegistroMarcacion (NroPersonal);

DROP INDEX dbo.RegistroMarcacion.IDX_RegistroMarcacion_Personal;

DROP INDEX dbo.RegistroMarcacion.PK_RegistroMarcacion;

CREATE NONCLUSTERED INDEX IDX_RegistroMarcacion_Personal
ON dbo.RegistroMarcacion (NroPersonal)
WHERE NroPersonal >= 1 AND NroPersonal <= 20000;

CREATE UNIQUE NONCLUSTERED INDEX IDX_RegistroMarcacion_Personal
ON dbo.RegistroMarcacion (NroPersonal)
WHERE NroPersonal >= 1 AND NroPersonal <= 20000;

CREATE NONCLUSTERED INDEX IDX_RegistroMarcacion_Personal
ON dbo.RegistroMarcacion (NroPersonal)
WHERE NroPersonal >= 1 AND NroPersonal <= 20000;

CREATE NONCLUSTERED INDEX IDX_RegistroMarcacion_Personal
ON dbo.RegistroMarcacion (NroPersonal)
INCLUDE (CodTurno, FechaIngreso, HoraIngreso, Tiempo, Estado)
WHERE NroPersonal >= 1 AND NroPersonal <= 20000;

 