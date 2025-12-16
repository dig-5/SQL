SET DATEFORMAT DMY;

SELECT Vendedor.CodVendedor, Vendedor.NombreVendedor, ExtractoCuenta.* 
FROM dbo.FNCGeneraExtractoCuenta (413501, 413501, '01/01/2005', '31/12/2010') AS ExtractoCuenta
JOIN Cuenta ON ExtractoCuenta.NroCuenta = Cuenta.NroCuenta
JOIN Vendedor ON Cuenta.CodVendedor = Vendedor.CodVendedor
WHERE ExtractoCuenta.CodMoneda = 1 AND ExtractoCuenta.[DEBITOGS] > 1000000
--CASE WHEN ExtractoCuenta.CodMoneda = 1 THEN 1 ELSE 0 END = 1
ORDER BY ExtractoCuenta.NroCuenta, ExtractoCuenta.FechaCambio;

--select * from ctacte where codmoneda = 0;
