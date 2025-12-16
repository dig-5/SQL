CREATE PROCEDURE SLCValoresVenta @FechaInicio DATE,
								 @FechaFin DATE,
								 @MontoNetoVenta MONEY OUTPUT,
								 @CantidadFacturas INT OUTPUT,
								 @CantidadClientes INT OUTPUT

AS

BEGIN

	IF  NOT EXISTS (SELECT * FROM Factura
					 WHERE FechaRendicion BETWEEN @FechaInicio AND @FechaFin)
	BEGIN
		RETURN 1;
	END
	ELSE
	BEGIN
		SELECT @MontoNetoVenta = SUM(Factura.MontoNetoIVA),
			   @CantidadFacturas = COUNT(*),
			   @CantidadClientes = COUNT(DISTINCT Factura.NroCuenta)
		FROM Factura
		WHERE FechaRendicion BETWEEN @FechaInicio AND @FechaFin;

		RETURN 0;
	END;

END;

