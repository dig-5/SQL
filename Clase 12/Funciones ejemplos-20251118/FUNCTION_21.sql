ALTER FUNCTION dbo.FNCGeneraExtractoCuenta (@NroCuentaDesde INT,
											 @NroCuentaHasta INT,
											 @FechaDesde DATETIME,
											 @FechaHasta DATETIME)

RETURNS TABLE

AS

RETURN (SELECT Cuenta.NroCuenta,
			   Cuenta.RazonSocial,
			   Cuenta.CodigoRUC,
			   CtaCte.CodAgencia,
			   CtaCte.FechaCambio,
			   CASE WHEN Concepto.PositivooNegativo = 1 THEN CtaCte.FechaVencimientoValor ELSE CtaCte.FechaCambio END AS FechaVencimiento,
			   CtaCte.CodMoneda,
			   CtaCte.CambioMonto,
			   CtaCte.NroFactura,
			   CtaCte.NroComprobante,
			   CtaCte.CodConcepto,
			   Concepto.Descripcion,
			   CtaCte.Concepto,
			   CASE WHEN CtaCte.CodMoneda = 1 AND Concepto.PositivooNegativo = 1 THEN CtaCte.Debito ELSE 0 END AS [DEBITOGS],
			   CASE WHEN CtaCte.CodMoneda = 1 AND Concepto.PositivooNegativo = -1 THEN CtaCte.Credito ELSE 0 END AS [CREDITOGS],
			   CASE WHEN CtaCte.CodMoneda = 0 AND Concepto.PositivooNegativo = 1 THEN CtaCte.Debito ELSE 0 END AS [DEBITOUS$],
			   CASE WHEN CtaCte.CodMoneda = 0 AND Concepto.PositivooNegativo = -1 THEN CtaCte.Credito ELSE 0 END AS [CREDITOUS$]
		FROM CtaCte JOIN Cuenta ON CtaCte.NroCuenta = Cuenta.NroCuenta
					JOIN Concepto ON CtaCte.CodConcepto = Concepto.CodConcepto
		WHERE CtaCte.NroCuenta BETWEEN @NroCuentaDesde AND @NroCuentaHasta
		AND CtaCte.FechaCambio BETWEEN @FechaDesde AND @FechaHasta
	   );
