CREATE UNIQUE NONCLUSTERED INDEX IDX_TipoDocumento_NroDocumento 
ON dbo.Personal (CodTipoDocumento ASC, NroDocumento ASC);


DROP INDEX dbo.Personal.IDX_TipoDocumento_NroDocumento;

CREATE UNIQUE CLUSTERED INDEX IDX_TipoDocumento_NroDocumento 
ON dbo.Personal (CodTipoDocumento ASC, NroDocumento ASC);


CREATE NONCLUSTERED INDEX IDX_Cargo
ON dbo.Personal (CodCargo DESC);

