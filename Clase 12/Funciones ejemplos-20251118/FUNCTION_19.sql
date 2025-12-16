ALTER FUNCTION dbo.FNCObtieneSaldoCuenta (@NroCuenta INT,
										   @CodMoneda SMALLINT = 1)

RETURNS MONEY

AS

BEGIN

	DECLARE @Saldo MONEY;

-- Calcula el Saldo de la Cuenta en la Moneda recibida como parámetro

	SELECT @Saldo = ISNULL(SUM(CASE WHEN CtaCte.CodConcepto BETWEEN 1 AND 9 THEN CtaCte.Debito
							        ELSE CtaCte.Credito * -1
						       END), 0)
	FROM CtaCte
	WHERE NroCuenta = @NroCuenta
	AND CodMoneda = @CodMoneda;

	RETURN @Saldo;

END;
