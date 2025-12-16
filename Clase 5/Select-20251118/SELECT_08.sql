SELECT NroCompra, 
C.FechaCambio, 
C.CodProveedor, 
P.RazonSocial, 
P.RUC,
C.CodAgencia, 
A.DescripcionAgencia, 
C.CodDeposito, 
AD.DescripcionDeposito
FROM Compra AS C INNER JOIN Proveedor AS P ON C.CodProveedor = P.CodProveedor
				 INNER JOIN Agencia AS A ON C.CodAgencia = A.CodAgencia
				 INNER JOIN AgenciaDeposito AS AD ON A.CodAgencia = AD.CodAgencia
												 AND C.CodDeposito = AD.CodDeposito
ORDER BY C.CodAgencia, C.NroCompra;
