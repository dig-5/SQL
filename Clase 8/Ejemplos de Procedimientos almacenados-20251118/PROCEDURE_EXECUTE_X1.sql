DROP PROCEDURE SLCCuenta
GO

CREATE PROCEDURE SLCCuenta; 1

AS

BEGIN

	SELECT * 
	FROM Cuenta JOIN Cliente 
	ON Cuenta.CodCliente = Cliente.CodCliente
	ORDER BY Cuenta.NroCuenta;

END;

CREATE PROCEDURE SLCCuenta; 2

AS

BEGIN

	SELECT * 
	FROM Cuenta JOIN Cliente 
	ON Cuenta.CodCliente = Cliente.CodCliente
	ORDER BY Cuenta.RazonSocial;

END;

EXECUTE SLCCuenta; 1;
EXECUTE SLCCuenta; 2;
