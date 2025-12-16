ALTER  TRIGGER TIUD_DetalleTransferencia ON DetalleTransferencia
FOR INSERT, UPDATE, DELETE

AS

BEGIN

	DECLARE  @vErrNo INT, @vErrMsg VARCHAR(255), @vTipoOperacion CHAR(1);

	BEGIN TRY

-- Determina el Tipo de Operación ejecutada

		IF  EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
			SELECT @vTipoOperacion = 'I'
		ELSE
			IF  EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
				SELECT @vTipoOperacion = 'U'
			ELSE
				IF  NOT EXISTS (SELECT * FROM inserted) 
				AND EXISTS (SELECT * FROM deleted)
					SELECT @vTipoOperacion = 'D'

-- El Estado de Salida de la Transferencia debe ser igual a Abierta

		IF  @vTipoOperacion IN ('I')
		AND EXISTS (SELECT * FROM inserted JOIN Transferencia 
					ON inserted.NroTransferencia = Transferencia.NroTransferencia
					WHERE Transferencia.EstadoSalida <> 'A')
		BEGIN
			SELECT @vErrMsg = '> El Estado de Salida de la Transferencia debe ser A = Abierta ...';
			RAISERROR ('> Error', 16, 1);
		END

		IF  @vTipoOperacion IN ('D', 'U')
		AND EXISTS (SELECT * FROM deleted JOIN Transferencia 
					ON deleted.NroTransferencia = Transferencia.NroTransferencia
					WHERE Transferencia.EstadoSalida <> 'A')
		BEGIN
			SELECT @vErrMsg = '> El Estado de Salida de la Transferencia debe ser A = Abierta ...';
			RAISERROR ('> Error', 16, 1);
		END

-- En los casos de actualizaciones, no se pueden actualizar las columnas NroTransferencia, CodAgencia, CodDeposito y NroArticulo

		IF  @vTipoOperacion = 'U'
		AND (UPDATE (NroTransferencia)
		OR 	 UPDATE (CodAgencia)
		OR 	 UPDATE (CodDeposito)
		OR 	 UPDATE (NroArticulo))
		BEGIN
			SELECT @vErrMsg = '> No se pueden actualizar las columnas NroTransferencia, CodAgencia, CodDeposito y NroArticulo ...';
			RAISERROR ('> Error', 16, 1);
		END

-- En los casos de Inserciones y Actualizaciones, las cantidades a transferir no deben ser superiores a la Existencia en AgenciaDepositoArticulo

		IF  @vTipoOperacion IN ('I', 'U')
		AND EXISTS (SELECT inserted.CodAgencia, 
						   inserted.CodDeposito,
						   inserted.NroArticulo,
						   SUM(inserted.CantidadEmbalada +
						      (inserted.CantidadFraccionada / Articulo.Unidad))
		  			FROM inserted JOIN Articulo 
					ON inserted.NroArticulo = Articulo.NroArticulo
					JOIN AgenciaDepositoArticulo ADA
					ON inserted.CodAgencia = ADA.CodAgencia
					AND inserted.CodDeposito = ADA.CodDeposito
					AND inserted.NroArticulo = ADA.NroArticulo
					GROUP BY inserted.CodAgencia, 
						     inserted.CodDeposito,
						     inserted.NroArticulo
					HAVING SUM(inserted.CantidadEmbalada +
					          (inserted.CantidadFraccionada / Articulo.Unidad)) > 
						   AVG(ADA.Existencia))
		BEGIN
			SELECT @vErrMsg = '> La Cantidad a Transferir es superior a la Existencia del Artículo en la Agencia y Depósito de Salida de la Transferencia ...';
			RAISERROR ('> Error', 16, 1);
		END

-- Actualización de los Costos y Existencias del Artículo en el Detalle de las Transferencias insertadas o actualizadas

		UPDATE DetalleTransferencia SET CMD = Articulo.CMDUltimo,
										CMDPromedio = Articulo.CMDPromedio,
										CODUltimo = Articulo.CODUltimo,
										CODPromedio = Articulo.CODPromedio,
										CostoOficial = Articulo.CostoOfPromedio,
										Unidad = Articulo.Unidad,
										ExistAnterior = ADA.Existencia,
										Cantidad = DT.CantidadEmbalada +
												  (DT.CantidadFraccionada / 
												   Articulo.Unidad)
		FROM DetalleTransferencia DT JOIN inserted 
		ON DT.NroTransferencia = inserted.NroTransferencia
		AND DT.CodAgencia = inserted.CodAgencia
		AND DT.CodDeposito = inserted.CodDeposito
		AND DT.NroArticulo = inserted.NroArticulo
		JOIN Articulo 
		ON DT.NroArticulo = Articulo.NroArticulo
		JOIN AgenciaDepositoArticulo ADA
		ON DT.CodAgencia = inserted.CodAgencia
		AND DT.CodDeposito = inserted.CodDeposito
		AND DT.NroArticulo = inserted.NroArticulo;

-- Suma a la Existencia restando a mesTRansferencia en AgenciaDepositoArticulo cuando se trata de una actualización o eliminaci'on de filas de DetalleTransferencia

		UPDATE AgenciaDepositoArticulo
		SET MesTransferencia = MesTransferencia - 
							   (SELECT SUM(deleted.Cantidad)
							    FROM deleted
								WHERE ADA.CodAgencia = deleted.CodAgencia
								AND ADA.CodDeposito = deleted.CodDeposito
								AND ADA.NroArticulo = deleted.NroArticulo)
		FROM AgenciaDepositoArticulo ADA JOIN deleted
		ON ADA.CodAgencia = deleted.CodAgencia
		AND ADA.CodDeposito = deleted.CodDeposito
		AND ADA.NroArticulo = deleted.NroArticulo;

-- Resta a la Existencia sumando a MesTransferencia en AgenciaDepositoArticulo cuando se trata de una inserció o actualización de filas de DetalleTransferencia

		UPDATE AgenciaDepositoArticulo
		SET MesTransferencia = MesTransferencia +
							   (SELECT SUM(inserted.CantidadEmbalada + 
										  (inserted.CantidadFraccionada /
										   Articulo.Unidad))
							    FROM inserted JOIN Articulo 
								ON inserted.NroArticulo = Articulo.NroArticulo
								WHERE ADA.CodAgencia = inserted.CodAgencia
								AND ADA.CodDeposito = inserted.CodDeposito
								AND ADA.NroArticulo = inserted.NroArticulo)
		FROM AgenciaDepositoArticulo ADA JOIN inserted
		ON ADA.CodAgencia = inserted.CodAgencia
		AND ADA.CodDeposito = inserted.CodDeposito
		AND ADA.NroArticulo = inserted.NroArticulo;

		RETURN;

	END TRY

	BEGIN CATCH

		IF  @vErrMsg IS NULL
			SELECT @vErrMsg = ERROR_MESSAGE();

		RAISERROR (@vErrMsg, 16, 1);

		ROLLBACK TRANSACTION;

	END CATCH

END;
