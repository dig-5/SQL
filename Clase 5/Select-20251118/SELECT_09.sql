SELECT NroCompra, 
C.FechaCambio, 
C.CodProveedor, 
P.RazonSocial, 
P.RUC,
C.CodAgencia, 
C.CodDeposito
FROM Proveedor AS P LEFT OUTER JOIN Compra AS C ON P.CodProveedor = C.CodProveedor
ORDER BY C.NroCompra;

SELECT NroCompra, 
C.FechaCambio, 
C.CodProveedor, 
P.RazonSocial, 
P.RUC,
C.CodAgencia, 
C.CodDeposito
FROM Compra AS C RIGHT OUTER JOIN Proveedor AS P ON C.CodProveedor = P.CodProveedor
ORDER BY C.NroCompra;

SELECT NroCompra, 
C.FechaCambio, 
P.CodProveedor, 
P.RazonSocial, 
P.RUC,
C.CodAgencia, 
C.CodDeposito
FROM Proveedor AS P LEFT OUTER JOIN Compra AS C ON P.CodProveedor = C.CodProveedor
WHERE C.Nrocompra IS NULL
ORDER BY C.NroCompra;

SELECT NroCompra, 
C.FechaCambio, 
C.CodProveedor, 
P.RazonSocial, 
P.RUC,
C.CodAgencia, 
C.CodDeposito
FROM Proveedor AS P FULL OUTER JOIN Compra AS C ON P.CodProveedor = C.CodProveedor
ORDER BY C.NroCompra;


