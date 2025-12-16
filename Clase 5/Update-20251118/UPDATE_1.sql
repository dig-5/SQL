UPDATE dbo.Personal SET CodPaisResidencia = 1,
						CodCiudadResidencia = 2;

UPDATE DBO.Vendedor SET IndiceComision = IndiceComision * 0.5;


UPDATE dbo.Pedido SET CodVendedor = 100
WHERE FechaEmision >= '2013-04-10' 
AND Estado = 'C';

UPDATE dbo.Pedido SET NumeroReparto = NULL,
                      NroCamion = NULL,
					  NroPersonal = NULL
WHERE FechaEmision >= '2013-04-10' 
AND Estado = 'C';
