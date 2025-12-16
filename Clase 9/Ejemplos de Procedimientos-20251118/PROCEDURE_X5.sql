CREATE PROCEDURE PRCGeneraContrato @NroCliente INT,
								   @FechaFirma DATETIME,
								   @CantidadCuotas INT,
								   @MontoContrato MONEY,
								   @NroContratoRenovado INT,
								   @NroContrato INT OUTPUT

AS

BEGIN

	DECLARE @ErrNo INT, @ErrMsg VARCHAR(255),
			@NroCuota INT, @MontoCuota MONEY, @FechaVencimiento DATETIME;

	BEGIN TRY

	BEGIN TRANSACTION

-- Validación de la deuda del Cliente

	IF  EXISTS (SELECT * FROM Contrato C JOIN ContratoCuota CC ON C.NroContrato = CC.NroContrato
			    WHERE C.NroCliente = @NroCliente
				AND CC.FechaVencimiento < GETDATE()
				AND CC.MontoCobrado < CC.MOntoCuota)
	BEGIN
		SELECT @ErrMsg = '> Cliente con Deuda Vencida Impaga pendiente ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Validación del Contrato Renovado

	IF  @NroContratoRenovado IS NOT NULL
	AND EXISTS (SELECT * FROM Contrato
				WHERE NroContrato = @NroContratoRenovado
				AND NroCliente <> @NroCliente)
	BEGIN
		SELECT @ErrMsg = '> Cliente con Contrato Renovado erróneo ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Insertar la fila de contrato 

	SELECT @NroContrato = NEXT VALUE FOR SEQ_CONTRATO;

	INSERT INTO Contrato
	SELECT @NroContrato,
		   @NroCliente,
		   @FechaFirma,
		   @CantidadCuotas,
		   @MontoContrato,
		   'A',
		   @NroContratoRenovado;

-- Insertar las filas de ContratoCuota

	SELECT @NroCuota = 1,
		   @MontoCuota = ROUND(@MontoContrato / @CantidadCuotas, 0),
		   @FechaVencimiento = DATEADD(DAY, 30, @FechaFirma);

	WHILE @NroCuota <= @CantidadCuotas
	BEGIN
		IF  @NroCuota = 1
			SELECT @MontoCuota = @MontoContrato - (ROUND(@MontoContrato / @CantidadCuotas, 0) * (@CantidadCuotas - 1))
		ELSE
		    SELECT @MontoCuota = ROUND(@MontoContrato / @CantidadCuotas, 0);
				
		INSERT INTO ContratoCuota
		SELECT @NroContrato,
			   @NroCuota,
			   @FechaVencimiento,
			   @MontoCuota,
			   0;

		SELECT @NroCuota = @NroCuota + 1,
   		       @FechaVencimiento = DATEADD(DAY, 30, @FechaVencimiento);
	END;

	COMMIT TRANSACTION;

	RETURN 0;

	END TRY

	BEGIN CATCH

		IF  @ErrMsg IS NULL
		BEGIN
			SELECT @ErrMsg = ERROR_MESSAGE();
		END;

		RAISERROR (@ErrMsg, 16, 1);

		ROLLBACK TRANSACTION;

		RETURN 1;

	END CATCH

END;
