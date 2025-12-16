ALTER TRIGGER TINSERT_CtaCte ON CtaCte FOR INSERT

AS

BEGIN

	DECLARE @ErrMSg VARCHAR(255);

	BEGIN TRY

-- Verifica la consistencia de los Importes de Débitos y Créditos

	IF  EXISTS (SELECT * FROM inserted JOIN Concepto 
					ON inserted.CodConcepto = Concepto.CodConcepto
				WHERE Concepto.PositivooNegativo = 1
				AND (inserted.Credito <> 0
				 OR inserted.Debito <= 0))
	BEGIN
		SELECT @ErrMSg = '> Importes de Débito Incorrecto ...';
		RAISERROR ('Error', 16, 1);
	END;
--
	IF  EXISTS (SELECT * FROM inserted JOIN Concepto 
					ON inserted.CodConcepto = Concepto.CodConcepto
				WHERE Concepto.PositivooNegativo = -1
				AND (inserted.Debito <> 0
				 OR inserted.Credito <= 0))
	BEGIN
		SELECT @ErrMSg = '> Importes de Crédito Incorrecto ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Las filas de Débitos no deben apuntar a otras filas de la misma tabla CtaCte

	IF  EXISTS (SELECT * FROM inserted JOIN Concepto 
					ON inserted.CodConcepto = Concepto.CodConcepto
				WHERE Concepto.PositivooNegativo = 1
				AND inserted.NroCtaCteRelacionada IS NOT NULL)
	BEGIN
		SELECT @ErrMSg = '> Débitos no deben apuntar a otras filas de CtaCte ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Las filas de Créditos que apuntan a otras filas de Ctacte, deben apuntar a Débitos

	IF  EXISTS (SELECT * FROM inserted 
				  JOIN Concepto ConceptoCredito
					ON inserted.CodConcepto = ConceptoCredito.CodConcepto
				  JOIN CtaCte 
				    ON inserted.NroCtaCteRelacionada = CtaCte.NroCtaCte 
				  JOIN Concepto ConceptoDebito
					ON CtaCte.CodConcepto = ConceptoDebito.CodConcepto
				WHERE ConceptoCredito.PositivooNegativo = -1
				AND ConceptoDebito.PositivooNegativo = -1)
	BEGIN
		SELECT @ErrMSg = '> Créditos no deben apuntar a otras filas de Créditos en CtaCte ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Las filas de créditos que apuntan a débitos no deben superar en importe a la deuda del débito al que apuntan

	IF  EXISTS (SELECT CtaCte.NroCtaCte, 
					   AVG(CtaCte.Debito - CtaCte.Credito)
				  FROM inserted 
				  JOIN Concepto ConceptoCredito
					ON inserted.CodConcepto = ConceptoCredito.CodConcepto
				  JOIN CtaCte 
				    ON inserted.NroCtaCteRelacionada = CtaCte.NroCtaCte 
				  JOIN Concepto ConceptoDebito
					ON CtaCte.CodConcepto = ConceptoDebito.CodConcepto
				WHERE ConceptoCredito.PositivooNegativo = -1
				AND ConceptoDebito.PositivooNegativo = 1
				GROUP BY CtaCte.NroCtaCte
				HAVING SUM(inserted.Credito) > AVG(CtaCte.Debito - CtaCte.Credito))
	BEGIN
		SELECT @ErrMSg = '> Los importes de Créditos superan al saldo del Débito al que apuntan ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Actualiza las filas de los Débitos apuntados por los Créditos

	UPDATE CtaCte SET Credito = CtaCte.Credito + 
	(SELECT SUM(inserted.Credito) 
	 FROM inserted
	 WHERE inserted.NroCtaCteRelacionada = CtaCte.NroCtaCte)
	FROM CtaCte 
	JOIN inserted 
	ON CtaCte.NroCtaCte = inserted.NroCtaCteRelacionada;

-- Actualiza los saldos en Cuenta

	UPDATE Cuenta SET TotalDebitosGS = TotalDebitosGS + 
	(SELECT SUM(inserted.Debito)
	 FROM inserted
	 WHERE inserted.CodMoneda = 1
	 AND inserted.Debito > 0
	 AND inserted.NroCuenta = Cuenta.NroCuenta)
	FROM Cuenta JOIN inserted ON Cuenta.NroCuenta = inserted.NroCuenta
	WHERE inserted.CodMoneda = 1
	AND inserted.Debito > 0;
--
	UPDATE Cuenta SET TotalCreditosGS = TotalCreditosGS + 
	(SELECT SUM(inserted.Credito)
	 FROM inserted
	 WHERE inserted.CodMoneda = 1
	 AND inserted.Credito > 0
	 AND inserted.NroCuenta = Cuenta.NroCuenta)
	FROM Cuenta JOIN inserted ON Cuenta.NroCuenta = inserted.NroCuenta
	WHERE inserted.CodMoneda = 1
	AND inserted.Credito > 0;
--
	UPDATE Cuenta SET TotalDebitosDL = TotalDebitosDL + 
	(SELECT SUM(inserted.Debito)
	 FROM inserted
	 WHERE inserted.CodMoneda = 0
	 AND inserted.Debito > 0
	 AND inserted.NroCuenta = Cuenta.NroCuenta)
	FROM Cuenta JOIN inserted ON Cuenta.NroCuenta = inserted.NroCuenta
	WHERE inserted.CodMoneda = 0
	AND inserted.Debito > 0;
--
	UPDATE Cuenta SET TotalCreditosDL = TotalCreditosDL + 
	(SELECT SUM(inserted.Credito)
	 FROM inserted
	 WHERE inserted.CodMoneda = 0
	 AND inserted.Credito > 0
	 AND inserted.NroCuenta = Cuenta.NroCuenta)
	FROM Cuenta JOIN inserted ON Cuenta.NroCuenta = inserted.NroCuenta
	WHERE inserted.CodMoneda = 0
	AND inserted.Credito > 0;

	RETURN;

	END TRY

	BEGIN CATCH

		IF  @ErrMsg IS NULL
			SELECT @ErrMsg = ERROR_MESSAGE ();

		RAISERROR (@ErrMsg, 16, 1);

		ROLLBACK TRANSACTION;

	END CATCH

END;
