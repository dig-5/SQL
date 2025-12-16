SELECT * FROM Ajuste 
WHERE Estado = 'A'
AND CodTipoAjuste = 4

SELECT * FROM Ajuste 
WHERE Estado = 'C'
ORDER BY nroajuste DESC;

SELECT * FROM DetalleAjuste 
WHERE nroajuste = 1774
and nroarticulo = 27871;

delete FROM DetalleAjuste 
WHERE nroajuste = 1774
and nroarticulo = 27871;

SELECT * FROM AgenciaDepositoArticulo
WHERE CodAgencia = 1
AND CodDeposito = 210
AND Existencia > 0
ORDER BY Existencia DESC;

SELECT * FROM TipoAjuste

EXECUTE INSDetalleAjuste 1774,
						 1,
						 210,
						 27871,
						 2101,
						 0;

EXECUTE INSDetalleAjuste 1677,
						 1,
						 210,
						 27871,
						 2101,
						 0;

EXECUTE INSDetalleAjuste 1774,
						 1,
						 210,
						 27871,
						 1800,
						 0;
