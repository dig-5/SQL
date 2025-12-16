ALTER INDEX ALL ON dbo.Personal
DISABLE;

ALTER INDEX PK_Personal ON dbo.Personal
DISABLE;

ALTER INDEX UQ_Apellido_Nombre ON dbo.Personal
DISABLE;

ALTER INDEX UQ_Apellido_Nombre ON dbo.Personal
REBUILD;

ALTER INDEX UQ_Apellido_Nombre ON dbo.Personal
REBUILD;

ALTER INDEX IDX_TipoDocumento_NroDocumento
ON dbo.Personal
DISABLE;

ALTER INDEX IDX_Cargo
ON dbo.Personal
DISABLE;

ALTER INDEX IDX_Cargo
ON dbo.Personal
REBUILD;

ALTER INDEX IDX_TipoDocumento_NroDocumento
ON dbo.Personal
REBUILD
WITH (PAD_INDEX = ON,
      FILLFACTOR = 75,
      SORT_IN_TEMPDB = ON,
	  STATISTICS_NORECOMPUTE = OFF,
      ALLOW_ROW_LOCKS = ON,
	  ALLOW_PAGE_LOCKS = ON);

ALTER INDEX IDX_TipoDocumento_NroDocumento
ON dbo.Personal
REORGANIZE;

ALTER INDEX ALL
ON dbo.Personal
REORGANIZE;

ALTER INDEX IDX_TipoDocumento_NroDocumento
ON dbo.Personal
SET (STATISTICS_NORECOMPUTE = OFF,
     ALLOW_ROW_LOCKS = ON,
	 ALLOW_PAGE_LOCKS = ON);

ALTER INDEX ALL
ON dbo.Personal
SET (STATISTICS_NORECOMPUTE = OFF,
     ALLOW_ROW_LOCKS = ON,
	 ALLOW_PAGE_LOCKS = ON);

	  