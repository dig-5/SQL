CREATE TRIGGER TIUD_Transferencia ON Transferencia FOR INSERT, UPDATE, DELETE

AS

BEGIN
--
	DECLARE @ErrNo INT,
			@ErrMsg VARCHAR(255),
			@TipoOperacion CHAR(1);
--
	BEGIN TRY

	IF  EXISTS (SELECT * FROM Inserted) AND NOT EXISTS (SELECT * FROM Deleted)
		SELECT @TipoOperacion = 'I'
	ELSE
		IF  EXISTS (SELECT * FROM Inserted) AND EXISTS (SELECT * FROM Deleted)
			SELECT @TipoOperacion = 'U'
		ELSE
			SELECT @TipoOperacion = 'D';

-- Validaciones para las inserciones
		
	IF  @TipoOperacion = 'I'
	BEGIN

-- Agencias y Depósitos

		IF  EXISTS (SELECT * FROM Inserted I 
					WHERE CodAgenciaSalida = CodAgenciaEntrada
					AND CodDepositoSalida = CodDepositoEntrada)
		BEGIN
			SELECT @ErrMsg = '> Agencias y Depósitos erróneos...';
			RAISERROR ('Error', 16, 1);
		END;

-- Estados de Salida y Entrada

		IF  EXISTS (SELECT * FROM Inserted I 
					WHERE EstadoSalida <> 0
					OR EstadoEntrada <> 0)
		BEGIN
			SELECT @ErrMsg = '> Estados de Salida y Entrada erróneos...';
			RAISERROR ('Error', 16, 1);
		END;

	END;

-- Validaciones para las eliminaciones
		
	IF  @TipoOperacion = 'D'
	BEGIN

-- Estados de Salida y Entrada

		IF  EXISTS (SELECT * FROM Deleted D 
					WHERE EstadoSalida <> 0
					OR EstadoEntrada <> 0)
		BEGIN
			SELECT @ErrMsg = '> Estados de Salida y Entrada erróneos...';
			RAISERROR ('Error', 16, 1);
		END;

	END;

-- Validaciones para las actualizaciones
		
	IF  @TipoOperacion = 'U'
	BEGIN

-- Con el estado de salida en 1 no se puden actualizar columnas de transferencia

		IF  EXISTS (SELECT * FROM Deleted D
					WHERE EstadoSalida = 1)
		AND (UPDATE (CodAgenciaSalida) -- Será verdadero cuando se haya ejecutado UPDATE Transferencia SET CodAgenciaSalida = ...
		OR   UPDATE (CodDepositoSalida)
		OR   UPDATE (CodAgenciaEntrada)
		OR   UPDATE (CodDepositoEntrada)
		OR   UPDATE (FechaTransferencia))
		BEGIN
			SELECT @ErrMsg = '> Con Estado de Salida cerrada no se pueden modificar datos en las transferencias ...';
			RAISERROR ('Error', 16, 1);
		END;

-- Si se actualiza el estado de salida, sólo se puede actualizar de 0 a 1

		IF  UPDATE (EstadoSalida)
		AND EXISTS (SELECT * FROM Deleted D JOIN Inserted I ON I.NroTransferencia = D.NroTransferencia
					WHERE D.EstadoSalida = 1
					OR (D.EstadoSalida = 0 AND I.EstadoSalida = 0))
-- Otras solución factible D.EstadoSalida <> 0 OR I.EstadoSalida <> 1
		BEGIN
			SELECT @ErrMsg = '> El Estado de Salida sólo se puede modificar de 0 a 1 ...';
			RAISERROR ('Error', 16, 1);
		END;

-- Si se actualiza el estado de entrada, sólo se puede actualizar de 0 a 1

		IF  UPDATE (EstadoEntrada)
		AND EXISTS (SELECT * FROM Deleted D JOIN Inserted I ON I.NroTransferencia = D.NroTransferencia
					WHERE D.EstadoEntrada = 1
					OR (D.EstadoEntrada = 0 AND I.EstadoEntrada = 0))
-- Otras solución factible D.EstadoEntrada <> 0 OR I.EstadoEntrada <> 1
		BEGIN
			SELECT @ErrMsg = '> El Estado de Entrada sólo se puede modificar de 0 a 1 ...';
			RAISERROR ('Error', 16, 1);
		END;

-- Actualizaciones

-- Inserción de las filas inexistentes en Stock

		INSERT INTO Stock  (CodAgencia,
							CodDeposito,
							NroArticulo,
							NroLote,
							TotalCompras,
							TotalVentas,
							TotalDevoluciones,
							TotalTransferenciasSalida,
							TotalTranferenciasEntrada,
							TotalAjustesPositivos,
							TotalAjustesNegativos,
							Existencia,
							Estado)
		SELECT I.CodAgenciaEntrada,
		I.CodDepositoEntrada,
		DT.NroArticulo,
		DT.NroLote,
		0, 0, 0, 0, 0, 0, 0, 0, 
		1
		FROM Inserted I JOIN Deleted D ON I.NroTransferencia = D.NroTransferencia
		JOIN DetalleTransferencia DT ON DT.NroTransferencia = I.NroTransferencia
		WHERE D.EstadoEntrada = 0 AND I.EstadoEntrada = 1
		AND NOT EXISTS (SELECT * FROM Stock S
		WHERE S.CodAgencia = I.CodAgenciaEntrada
		AND S.CodDeposito = I.CodDepositoEntrada
		AND S.NroArticulo = DT.NroArticulo
		AND S.NroLote = DT.NroLote);

-- Inserción de las filas de detalletransferencia a detalletransferenciaentrada, siempre que el estado de entrada cambie de 0 a 1

		INSERT INTO DetalleTransferenciaEntrada (NroTransferencia,
												 CodAgenciaEntrada,
												 CodDepositoEntrada,
												 NroArticulo,
												 NroLote,
												 Cantidad)
		SELECT  I.NroTransferencia,
				I.CodAgenciaEntrada,
				I.CodDepositoEntrada,
				DT.NroArticulo,
				DT.NroLote,
				DT.Cantidad
		FROM Inserted I JOIN Deleted D ON I.NroTransferencia = D.NroTransferencia
		JOIN DetalleTransferencia DT ON DT.NroTransferencia = I.NroTransferencia
		WHERE D.EstadoEntrada = 0 AND I.EstadoEntrada = 1;

-- Actualización de los totales de transferencias de entrada y existencia en Stock

		UPDATE Stock 
		SET TotalTranferenciasEntrada = 
			TotalTranferenciasEntrada + 
			(SELECT SUM(DTE.Cantidad) FROM DetalleTransferenciaEntrada DTE
			 WHERE I.NroTransferencia = DTE.NroTransferencia
			 AND S.CodAgencia = DTE.CodAgenciaEntrada
			 AND S.CodDeposito = DTE.CodDepositoEntrada
			 AND S.NroArticulo = DTE.NroArticulo
			 AND S.NroLote = DTE.NroLote),

			Existencia = Existencia + 
			(SELECT SUM(DTE.Cantidad) FROM DetalleTransferenciaEntrada DTE
			 WHERE I.NroTransferencia = DTE.NroTransferencia
			 AND S.CodAgencia = DTE.CodAgenciaEntrada
			 AND S.CodDeposito = DTE.CodDepositoEntrada
			 AND S.NroArticulo = DTE.NroArticulo
			 AND S.NroLote = DTE.NroLote)

		FROM Inserted I JOIN Deleted D ON I.NroTransferencia = D.NroTransferencia
		JOIN DetalleTransferenciaEntrada DTE ON DTE.NroTransferencia = I.NroTransferencia
		JOIN Stock S ON S.CodAgencia = DTE.CodAgenciaEntrada
					AND S.CodDeposito = DTE.CodDepositoEntrada
					AND S.NroArticulo = DTE.NroArticulo
					AND S.NroLote = DTE.NroLote
		WHERE D.EstadoEntrada = 0 AND I.EstadoEntrada = 1;

	END;

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
