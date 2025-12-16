ALTER PROCEDURE SLCCuentaXOrden_1 @NroCuenta INT = NULL,
                                   @TipoOrden char(1) = 'N'

AS

BEGIN

	SELECT * 
	FROM Cuenta JOIN Cliente 
	ON Cuenta.CodCliente = Cliente.CodCliente
	WHERE Cuenta.NroCuenta = ISNULL(@NroCuenta, Cuenta.NroCuenta)
	ORDER BY CASE WHEN @TipoOrden = 'N' THEN CONVERT(VARCHAR(20), Cuenta.NroCuenta)
				  ELSE Cuenta.RazonSocial
			 END;

END;
