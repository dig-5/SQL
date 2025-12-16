ALTER PROCEDURE PRCCierraTrasferencia @NroTransferencia INT

AS 

BEGIN

	DECLARE @ErrNo INT, @ErrMsg VARCHAR(255),
			@CodAgenciaEntrada SMALLINT, @CodDepositoEntrada SMALLINT;

	BEGIN TRY

	BEGIN TRANSACTION

-- Se valida que la Transferencia exista en su cabecera

	IF  NOT EXISTS (SELECT * FROM Transferencia
					WHERE NroTransferencia = @NroTransferencia)
	BEGIN
		SELECT @ErrMsg = '> Transferencia Inexistente ...';
		RAISERROR ('Error', 16, 1);
	END;

-- La Transferencia debe tener estado de entrada Abierta = 'A'

	IF  EXISTS (SELECT * FROM Transferencia
				WHERE NroTransferencia = @NroTransferencia
				AND EstadoEntrada <> 'A')
	BEGIN
		SELECT @ErrMsg = '> Transferencia con Estado de Entrada Erróneo ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Se Obtiene la Agencia y el Depósito de Entrada de la Transferencia

	SELECT @CodAgenciaEntrada = CodAgenciaEntrada,
		   @CoddepositoEntrada = CodDepositoEntrada
	FROM Transferencia
	WHERE NroTransferencia = @NroTransferencia;

-- Actualiza las filas de AgenciaDepositoArticulo a partir del Detalle de la Transferencia, siempre que las mismas coincidan

	UPDATE AgenciaDepositoArticulo 
	SET MesTransferencia = MesTransferencia + DetalleTransferencia.Cantidad
	FROM AgenciaDepositoArticulo JOIN DetalleTransferencia
	ON AgenciaDepositoArticulo.NroArticulo = DetalleTransferencia.NroArticulo
	AND AgenciaDepositoArticulo.CodAgencia = @CodAgenciaEntrada
	AND AgenciaDepositoArticulo.CodDeposito = @CodDepositoEntrada
	WHERE DetalleTransferencia.NroTransferencia = @NroTransferencia;

-- Inserta las filas en AgenciaDepositoArticulo a partir del Detalle de la Transferencia, siempre que las mismas no coincidan

	INSERT INTO AgenciaDepositoArticulo 
	SELECT @CodAgenciaEntrada,
		   @CodDepositoEntrada,
		   DetalleTransferencia.NroArticulo,
		   0,
		   0,
		   0,
		   DetalleTransferencia.Cantidad,
		   0,
		   0,
		   0,
		   0,
		   0,
		   0	
	FROM DetalleTransferencia
	WHERE DetalleTransferencia.NroTransferencia = @NroTransferencia
	AND NOT EXISTS (SELECT * FROM AgenciaDepositoArticulo 
					WHERE AgenciaDepositoArticulo.NroArticulo = DetalleTransferencia.NroArticulo
					AND AgenciaDepositoArticulo.CodAgencia = @CodAgenciaEntrada
					AND AgenciaDepositoArticulo.CodDeposito = @CodDepositoEntrada);

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

