CREATE PROCEDURE PRCDetalleTransferencia @NroTransferencia INT,
										 @NroArticulo INT,
										 @CantidadEmbalada INT,
										 @CantidadFraccionada INT,
										 @TipoOperacion CHAR(1) = 'I'

AS 

BEGIN

	DECLARE @ErrNo INT, @ErrMsg VARCHAR(255),
			@CodAgencia SMALLINT, @CodDeposito SMALLINT,
			@Unidad INT, @Cantidad FLOAT;

	BEGIN TRY

	BEGIN TRANSACTION

-- Se valida que la Transferencia exista en su cabecera

	IF  NOT EXISTS (SELECT * FROM Transferencia
					WHERE NroTransferencia = @NroTransferencia)
	BEGIN
		SELECT @ErrMsg = '> Transferencia Inexistente ...';
		RAISERROR ('Error', 16, 1);
	END;

-- La Transferencia debe tener estado de salida Abierta = 'A'

	IF  EXISTS (SELECT * FROM Transferencia
				WHERE NroTransferencia = @NroTransferencia
				AND EstadoSalida <> 'A')
	BEGIN
		SELECT @ErrMsg = '> Transferencia con Estado de Salida Erróneo ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Se Obtiene la Agencia y el Depósito de Salida de la Transferencia

	SELECT @CodAgencia = CodAgenciaSalida,
		   @Coddeposito = CodDepositoSalida
	FROM Transferencia
	WHERE NroTransferencia = @NroTransferencia;

-- En las Inserciones se verifica que la fila a insertar no se duplique

	IF  @TipoOperacion = 'I'
	AND EXISTS (SELECT * FROM DetalleTransferencia
				WHERE NroTransferencia = @NroTransferencia
				AND CodAgencia = @CodAgencia
				AND CodDeposito = @CodDeposito
				AND NroArticulo = @NroArticulo)
	BEGIN
		SELECT @ErrMsg = '> Imposible duplicar fila del Detalle de la Transferencia ...';
		RAISERROR ('Error', 16, 1);
	END;


-- En las Inserciones y Actualizaciones, no se puede transferir una cantidad superior a la existencia

-- Calcula la Cantidad de la Transferencia

	SELECT @Cantidad = (@CantidadEmbalada + (@CantidadFraccionada / Articulo.Unidad)) 
	FROM Articulo
	WHERE NroArticulo = @NroArticulo;

	IF  @TipoOPeracion = 'I'
	AND EXISTS (SELECT * FROM AgenciaDepositoArticulo 
				WHERE CodAgencia = @CodAgencia
				AND CodDeposito = @CodDeposito
				AND NroArticulo = @NroArticulo
				AND Existencia < @Cantidad)
	BEGIN
		SELECT @ErrMsg = '> La Cantidad a Transferir es mayor a la existencia del Artículo ...';
		RAISERROR ('Error', 16, 1);
	END;

	IF  @TipoOPeracion = 'U'
	AND EXISTS (SELECT * FROM AgenciaDepositoArticulo JOIN DetalleTransferencia
						   ON AgenciaDepositoArticulo.NroArticulo = DetalleTransferencia.NroArticulo
						  AND AgenciaDepositoArticulo.CodAgencia = DetalleTransferencia.CodAgencia
						  AND AgenciaDepositoArticulo.CodDeposito = DetalleTransferencia.CodDeposito
				WHERE DetalleTransferencia.NroTransferencia = @NroTransferencia
				AND DetalleTransferencia.NroArticulo = @NroArticulo
				AND DetalleTransferencia.CodAgencia = @CodAgencia
				AND DetalleTransferencia.CodDeposito = @CodDeposito
				AND (AgenciaDepositoArticulo.Existencia + DetalleTransferencia.Cantidad) < @Cantidad)
	BEGIN
		SELECT @ErrMsg = '> La Cantidad a Transferir es mayor a la existencia del Artículo ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Inserta la fila correspondiente al Detalle de la Transferencia

	IF  @TipoOperacion = 'I'
	BEGIN
		INSERT INTO DetalleTransferencia (NroTransferencia,
										  CodAgencia,
										  CodDeposito,
										  NroArticulo,
										  CMD,
										  CMDPromedio,
										  CODUltimo,
										  CODPromedio,
										  CostoOficial,
										  Unidad,
										  ExistAnterior,
										  CantidadEmbalada,
										  CantidadFraccionada,
										  Cantidad)
		SELECT @NroTransferencia,
			   @CodAgencia,
			   @CodDeposito,
			   @NroArticulo,
			   Articulo.CMDUltimo,
			   Articulo.CMDPromedio,
			   Articulo.CODUltimo,
			   Articulo.CODPromedio,
			   Articulo.CostoOfPromedio,
			   Articulo.Unidad,
			   AgenciaDepositoArticulo.Existencia,
			   @CantidadEmbalada,
			   @CantidadFraccionada,
			   @Cantidad
		FROM Articulo JOIN AgenciaDepositoArticulo 
		ON Articulo.NroArticulo = AgenciaDepositoArticulo.NroArticulo
		WHERE Articulo.NroArticulo = @NroArticulo
		AND AgenciaDepositoArticulo.NroArticulo = @NroArticulo
		AND AgenciaDepositoArticulo.CodAgencia = @CodAgencia
		AND AgenciaDepositoArticulo.CodDeposito = @CodDeposito;
	END;

-- Actualiza la existencia, sumando a MesTransferencia cuando se trata de una Actualización o de la Eliminación de una fila del detalle

	IF  @TipoOperacion IN ('U', 'D')
	BEGIN
		UPDATE AgenciaDepositoArticulo 
		SET MesTransferencia = MesTransferencia + DetalleTransferencia.Cantidad
		FROM AgenciaDepositoArticulo JOIN DetalleTransferencia
		ON AgenciaDepositoArticulo.NroArticulo = DetalleTransferencia.NroArticulo
		AND AgenciaDepositoArticulo.CodAgencia = DetalleTransferencia.CodAgencia
		AND AgenciaDepositoArticulo.CodDeposito = DetalleTransferencia.CodDeposito
		WHERE DetalleTransferencia.NroTransferencia = @NroTransferencia
		AND DetalleTransferencia.NroArticulo = @NroArticulo
		AND DetalleTransferencia.CodAgencia = @CodAgencia
		AND DetalleTransferencia.CodDeposito = @CodDeposito;
	END;

-- Actualiza la fila de Detalle de Transferencia

	IF  @TipoOperacion = 'U'
	BEGIN
		UPDATE DetalleTransferencia
		SET CantidadEmbalada = @CantidadEmbalada,
			CantidadFraccionada = @CantidadFraccionada,
			Cantidad = @Cantidad
		FROM DetalleTransferencia
		WHERE DetalleTransferencia.NroTransferencia = @NroTransferencia
		AND DetalleTransferencia.NroArticulo = @NroArticulo
		AND DetalleTransferencia.CodAgencia = @CodAgencia
		AND DetalleTransferencia.CodDeposito = @CodDeposito;
	END;

-- Actualiza la existencia, restando a MesTransferencia cuando se trata de una Actualización o de una inserción de una fila del detalle

	IF  @TipoOperacion IN ('U', 'I')
	BEGIN
		UPDATE AgenciaDepositoArticulo 
		SET MesTransferencia = MesTransferencia - @Cantidad
		WHERE AgenciaDepositoArticulo.NroArticulo = @NroArticulo
		AND AgenciaDepositoArticulo.CodAgencia = @CodAgencia
		AND AgenciaDepositoArticulo.CodDeposito = @CodDeposito;
	END;

-- Elimina la fila del Detalle de la Transferencia

	IF  @TipoOperacion = 'D'
	BEGIN
		DELETE FROM DetalleTransferencia
		WHERE DetalleTransferencia.NroTransferencia = @NroTransferencia
		AND DetalleTransferencia.NroArticulo = @NroArticulo
		AND DetalleTransferencia.CodAgencia = @CodAgencia
		AND DetalleTransferencia.CodDeposito = @CodDeposito;
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

