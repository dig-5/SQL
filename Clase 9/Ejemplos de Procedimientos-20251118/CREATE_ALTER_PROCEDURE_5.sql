--DROP PROCEDURE PRCInsDetalleTransferenciaStockSalida

ALTER PROCEDURE PRCInsDetalleTransferenciaStockSalida
@idempresa BIGINT = 1,
@nrotransferencia INT,
@iddeposito BIGINT,
@idcontenedor BIGINT = NULL,
@idlotearticulo BIGINT = NULL,
@nroarticulo INT,
@cantidadembalada INT,
@cantidadfraccionada INT,
@envasesycajones BIT = 0,
@iddetalletransferenciastocksalida BIGINT OUTPUT

AS

BEGIN

	DECLARE @errmsg VARCHAR (255),
			@cantidadxembalaje FLOAT,
			@cantidad FLOAT,
			@idtransferenciastock BIGINT,
			@idarticuloembalaje BIGINT,
			@idarticulo BIGINT

	BEGIN TRY

	BEGIN TRANSACTION;

-- La transferencia de stock debe existir

	SELECT @idtransferenciastock = id
	FROM transferenciastock
	WHERE idempresa = @idempresa
	AND nrotransferencia = @nrotransferencia;

	IF  @idtransferenciastock IS NULL
	BEGIN
		SELECT @errmsg = '> Transferencia inexistente ...';
		RAISERROR ('> ERROR', 16, 1);
	END;

/*
	IF  NOT EXISTS (SELECT *
					FROM transferenciastock
					WHERE idempresa = @idempresa
					AND nrotransferencia = @nrotransferencia)
*/

-- La transferencia debe estar con estado = 0 y activo = 1

	IF  EXISTS (SELECT *
				FROM transferenciastock
				WHERE id = @idtransferenciastock
				AND (estadosalida <> 0 OR activo <> 1))
	BEGIN
		SELECT @errmsg = '> Transferencia con estado de salida cerrada o inactivo ...';
		RAISERROR ('> ERROR', 16, 1);
	END;

-- La combinación de empresa, depósito, contenedor, lote de artículo y artículo debe existir en stock

	SELECT @idarticuloembalaje = ae.id,
		   @cantidadxembalaje = ae.cantidadxembalaje,
		   @idarticulo = a.id
	FROM articulo a JOIN articuloembalaje ae
	ON ae.idarticulo = a.id
	WHERE a.idempresa = @idempresa
	AND a.nroarticulo = @nroarticulo;

	SELECT @idarticuloembalaje, @cantidadxembalaje, @idarticulo;

	IF  NOT EXISTS (SELECT * FROM stock
					WHERE idempresa = @idempresa
					AND iddeposito = @iddeposito
					AND (idcontenedor = @idcontenedor OR idcontenedor IS NULL)
					AND (idlotearticulo = @idlotearticulo OR idlotearticulo IS NULL)
--					AND idcontenedor = ISNULL(@idcontenedor, idcontenedor)
--					AND idlotearticulo = ISNULL(@idlotearticulo, idlotearticulo) 
					AND idarticulo = @idarticulo)
	BEGIN
		SELECT @errmsg = '> Fila inexistente en stock ...';
		RAISERROR ('> ERROR', 16, 1);
	END;

-- La existencia total en tock debe ser mayor o igual a la cantidad a transferir

	SELECT @cantidad = @cantidadembalada + (@cantidadfraccionada / @cantidadxembalaje);

	IF  EXISTS (SELECT * FROM stock
				WHERE idempresa = @idempresa
				AND iddeposito = @iddeposito
				AND (idcontenedor = @idcontenedor OR idcontenedor IS NULL)
				AND (idlotearticulo = @idlotearticulo OR idlotearticulo IS NULL)
				AND idarticulo = @idarticulo
				AND totalexistencia < @cantidad)
	BEGIN
		SELECT @errmsg = '> Existencia en stock menor a cantidad a transferir ...';
		RAISERROR ('> ERROR', 16, 1);
	END;

-- Inserción de la fila correspondiente en detalletransferenciastocksalida

	SELECT @iddetalletransferenciastocksalida = NEXT VALUE FOR SEQ_detalletransferenciastocksalida;

	INSERT INTO detalletransferenciastocksalida 
	SELECT @iddetalletransferenciastocksalida,
		   @idempresa,
		   @idtransferenciastock,
		   @iddeposito,
		   @idcontenedor,
		   @idlotearticulo,
		   @idarticuloembalaje,
		   @cantidadxembalaje,
		   s.totalexistencia,
		   s.costogestionultimo,
		   s.costogestionpromedio,
		   s.costogestionfifo,
		   s.costogestionlifo,
		   s.costogestionnifo,
		   s.costoultimo,
		   s.costopromedio,
		   s.costofifo,
		   s.costolifo,
		   s.costonifo,
		   @cantidad,
		   @cantidadembalada,
		   @cantidadfraccionada,
		   @envasesycajones,
		   1,
		   GETDATE()
	FROM stock s
	WHERE s.idempresa = @idempresa
	AND s.iddeposito = @iddeposito
	AND (idcontenedor = @idcontenedor OR idcontenedor IS NULL)
	AND (idlotearticulo = @idlotearticulo OR idlotearticulo IS NULL)
	AND s.idarticulo = @idarticulo;

-- Actualiza la existencia en stock

	UPDATE stock SET totaltransferenciasalida = totaltransferenciasalida + @cantidad,
					 totalexistencia = totalexistencia - @cantidad
	WHERE idempresa = @idempresa
	AND iddeposito = @iddeposito
	AND (idcontenedor = @idcontenedor OR idcontenedor IS NULL)
	AND (idlotearticulo = @idlotearticulo OR idlotearticulo IS NULL)
	AND idarticulo = @idarticulo;

	COMMIT TRANSACTION;

	RETURN;

	END TRY

	BEGIN CATCH

		IF  @errmsg IS NULL
			SELECT @errmsg = ERROR_MESSAGE ();

		RAISERROR (@errmsg, 16, 1);

		ROLLBACK TRANSACTION;

	END CATCH

END;
