UPDATE DetalleCompra 
SET CodRegimen = A.CodRegimen,
Unidad = A.Unidad,
UltimoCMD = A.CMDUltimo,
UltimoCMDPromedio = A.CMDPromedio
FROM DetalleCompra DC JOIN Compra C ON DC.NroCOmpra = C.NroCompra
JOIN Articulo A ON DC.NroArticulo = A.NroArticulo
WHERE C.FechaCambio = '2012-06-20';

