SELECT * FROM Compra, Proveedor
WHERE Compra.CodProveedor = Proveedor.CodProveedor
ORDER BY Compra.NroCompra;

SELECT * FROM Compra, Proveedor, Agencia
WHERE Compra.CodProveedor = Proveedor.CodProveedor
AND Compra.CodAgencia = Agencia.CodAgencia
ORDER BY Compra.CodAgencia, Compra.NroCompra;

SELECT * FROM Compra, Proveedor, Agencia, AgenciaDeposito
WHERE Compra.CodProveedor = Proveedor.CodProveedor
AND Compra.CodAgencia = Agencia.CodAgencia
AND Compra.CodAgencia = AgenciaDeposito.CodAgencia
AND Compra.CodDeposito = AgenciaDeposito.CodDeposito
ORDER BY Compra.CodAgencia, Compra.NroCompra;

SELECT * 
FROM Compra C, Proveedor P, Agencia A, AgenciaDeposito AD
WHERE C.CodProveedor = P.CodProveedor
AND C.CodAgencia = A.CodAgencia
AND C.CodAgencia = AD.CodAgencia
AND C.CodDeposito = AD.CodDeposito
ORDER BY C.CodAgencia, C.NroCompra;

SELECT * 
FROM Compra AS C, Proveedor AS P, Agencia AS A, AgenciaDeposito AS AD
WHERE C.CodProveedor = P.CodProveedor
AND C.CodAgencia = A.CodAgencia
AND C.CodAgencia = AD.CodAgencia
AND C.CodDeposito = AD.CodDeposito
ORDER BY C.CodAgencia, C.NroCompra;

SELECT NroCompra, 
C.FechaCambio, 
C.CodProveedor, 
P.RazonSocial, 
P.RUC,
C.CodAgencia, 
A.DescripcionAgencia, 
C.CodDeposito, 
AD.DescripcionDeposito
FROM Compra AS C, 
Proveedor AS P, 
Agencia AS A, 
AgenciaDeposito AS AD
WHERE C.CodProveedor = P.CodProveedor
AND C.CodAgencia = A.CodAgencia
AND C.CodAgencia = AD.CodAgencia
AND C.CodDeposito = AD.CodDeposito
ORDER BY C.CodAgencia, C.NroCompra;
