CREATE TRIGGER TI_DetalleTransferencia ON DetalleTransferencia FOR INSERT

AS

BEGIN
--
	DECLARE @ErrNo INT,
			@ErrMsg VARCHAR(255);
--
	BEGIN TRY

-- Validaciones para las inserciones
	
-- El Estado de Salida de las trasferencias debe ser igual a cero

	IF  EXISTS (SELECT * FROM Inserted I JOIN Transferencia T 
										   ON I.NroTransferencia = T.NroTransferencia
				WHERE T.EstadoSalida <> 0)
	BEGIN
		SELECT @ErrMsg = '> Estado de Salida de las transferencias deben ser iguales a 1 ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Agencias y Depósitos deben ser iguales entre la cabecera y el detalle

	IF  EXISTS (SELECT * FROM Inserted I JOIN Transferencia T 
										   ON I.NroTransferencia = T.NroTransferencia
				WHERE T.CodAgenciaSalida <> I.CodAgencia
				OR T.CodDepositoSalida <> I.CodDeposito)
	BEGIN
		SELECT @ErrMsg = '> Agencias y Depósitos erróneos...';
		RAISERROR ('Error', 16, 1);
	END;

-- La cantidad de salida de los detalles no deben ser superiores a la existencia en Stock

	IF  EXISTS (SELECT I.CodAgencia, I.CodDeposito, I.NroArticulo, I.NroLote
				FROM Inserted I JOIN Stock S
				ON S.CodAgencia = I.CodAgencia
				AND S.CodDeposito = I.CodDeposito
				AND S.NroArticulo = I.NroArticulo
				AND S.NroLote = I.NroLote
				GROUP BY I.CodAgencia, I.CodDeposito, I.NroArticulo, I.NroLote
				HAVING SUM(I.Cantidad) > AVG(S.Existencia))
	BEGIN
		SELECT @ErrMsg = '> La cantidad de los detalles de transferencia insertadas supera a la existencia en stock ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Actualización en detalle transferencia de los costos del artículo

	UPDATE DetalleTransferencia SET CostoDolares = A.CostoDolares,
									CostoGuaranies = A.CostoGuaranies
	FROM DetalleTransferencia DT JOIN Articulo A ON DT.NroArticulo = A.NroArticulo
	JOIN Inserted I ON DT.NroTransferencia = I.NroTransferencia
				   AND DT.CodAgencia = I.CodAgencia
				   AND DT.CodDeposito = I.CodDeposito
				   AND DT.NroArticulo = I.NroArticulo
				   AND DT.NroLote = I.Nrolote

-- Actualización de los totales de transferencias de salida y existencia en Stock

	UPDATE Stock 
	SET TotalTranferenciasSalida = 
		TotalTranferenciasSalida + 
		(SELECT SUM(I.Cantidad) FROM Inserted I
		 WHERE S.CodAgencia = I.CodAgencia
		 AND S.CodDeposito = I.CodDeposito
		 AND S.NroArticulo = I.NroArticulo
		 AND S.NroLote = I.NroLote),

		Existencia = Existencia -  
		(SELECT SUM(I.Cantidad) FROM Inserted I
		 WHERE S.CodAgencia = I.CodAgencia
		 AND S.CodDeposito = I.CodDeposito
		 AND S.NroArticulo = I.NroArticulo
		 AND S.NroLote = I.NroLote)

	FROM Stock S JOIN Inserted I ON S.CodAgencia = I.CodAgencia
							    AND S.CodDeposito = I.CodDeposito
							    AND S.NroArticulo = I.NroArticulo
							    AND S.NroLote = I.NroLote;

-- Genera los datos de auditoría

	INSERT INTO AuditoriaDetalleTransferencia
	SELECT NEXT VALUE FOR SEQ_AuditoriaDetalleTransferencia,
		   SUSER_SNAME(),
		   GETDATE(),
		   HOST_NAME(),
		   Inserted.*
	FROM Inserted I;

	RETURN;
	
	END TRY
	
	BEGIN CATCH
	
		IF  @ErrMsg IS NULL 
		BEGIN
			SELECT @ErrMsg = ERROR_MESSAGE ();
		END;

		RAISERROR (@ErrMsg, 16, 1);

		ROLLBACK TRANSACTION;
	
	END CATCH

END;
