CREATE NONCLUSTERED INDEX IDX_RegistroMarcacion_Personal
ON dbo.RegistroMarcacion (NroPersonal)
INCLUDE (CodTurno, FechaIngreso, HoraIngreso, Tiempo, Estado)
WHERE NroPersonal >= 1 AND NroPersonal <= 20000
WITH (PAD_INDEX = ON,
      FILLFACTOR = 70,
      SORT_IN_TEMPDB = ON,
	  STATISTICS_NORECOMPUTE = ON,
      ALLOW_ROW_LOCKS = ON,
      ALLOW_PAGE_LOCKS = ON,
	  MAXDOP = 4);

CREATE CLUSTERED INDEX IDX_RegistroMarcacion_Personal
ON dbo.RegistroMarcacion (NroPersonal)
WITH (PAD_INDEX = ON,
      FILLFACTOR = 70,
      DROP_EXISTING = ON,
	  SORT_IN_TEMPDB = ON,
	  STATISTICS_NORECOMPUTE = ON,
      ALLOW_ROW_LOCKS = ON,
      ALLOW_PAGE_LOCKS = ON,
	  MAXDOP = 4);
