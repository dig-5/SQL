SELECT Cuenta.NroCuenta,
Cuenta.RazonSocial,
dbo.FNCObtieneSaldoCuenta (Cuenta.NroCuenta, 1) AS Saldo
FROM Cuenta
ORDER BY 3 DESC;
