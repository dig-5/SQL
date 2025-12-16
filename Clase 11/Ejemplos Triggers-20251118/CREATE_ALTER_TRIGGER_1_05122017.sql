CREATE TRIGGER TI_DetalleTransferenciaStockSalida ON DetalleTransferenciaStockSalida AFTER INSERT

AS

BEGIN

	DECLARE @errmsg VARCHAR (255);

	BEGIN TRY

-- La transferencia debe estar activo (1)

	IF  EXISTS (SELECT * FROM inserted i JOIN transferenciastock ts
				ON i.idtransferenciastock = ts.id
				WHERE ts.activo <> 1)
	BEGIN
		SELECT @errmsg = '> Transferencia inactiva ...';
		RAISERROR ('> ERROR', 16, 1);
	END;

-- La transferencia debe estar con estadosalida = 0 

	IF  EXISTS (SELECT * FROM inserted i JOIN transferenciastock ts
				ON i.idtransferenciastock = ts.id
				WHERE ts.estadosalida <> 0)
	BEGIN
		SELECT @errmsg = '> Transferencia con estado de salida cerrada ...';
		RAISERROR ('> ERROR', 16, 1);
	END;

-- La combinación de empresa, depósito, contenedor, lote de artículo y artículo debe existir en stock

	IF  EXISTS (SELECT * FROM inserted i JOIN articuloembalaje ae ON i.idarticuloembalaje = ae.id
				WHERE NOT EXISTS (SELECT * FROM stock s
								  WHERE s.idempresa = i.idempresa
								  AND s.iddeposito = i.iddeposito
								  AND (s.idcontenedor = i.idcontenedor OR (i.idcontenedor IS NULL AND s.idcontenedor IS NULL))
								  AND (s.idlotearticulo = i.idlotearticulo OR (i.idlotearticulo IS NULL AND s.idlotearticulo IS NULL))
								  AND s.idarticulo = ae.idarticulo))
	BEGIN
		SELECT @errmsg = '> Fila inexistente en stock ...';
		RAISERROR ('> ERROR', 16, 1);
	END;

-- La existencia total en tock debe ser mayor o igual a la cantidad a transferir
/*
	IF  EXISTS (SELECT i.idempresa, 
					   i.iddeposito, 
					   i.idcontenedor, 
					   i.idlotearticulo, 
					   ae.idarticulo
				FROM inserted i JOIN articuloembalaje ae ON i.idarticuloembalaje = ae.id
								JOIN stock s ON s.idempresa = i.idempresa
											AND s.iddeposito = i.iddeposito
											AND (s.idcontenedor = i.idcontenedor OR (i.idcontenedor IS NULL AND s.idcontenedor IS NULL))
											AND (s.idlotearticulo = i.idlotearticulo OR (i.idlotearticulo IS NULL AND s.idlotearticulo IS NULL))
											AND s.idarticulo = ae.idarticulo
				GROUP BY i.idempresa, 
					     i.iddeposito, 
					     i.idcontenedor, 
					     i.idlotearticulo, 
					     ae.idarticulo
				HAVING SUM(i.cantidad) > AVG(s.totalexistencia))
*/
	IF  EXISTS (SELECT i.idempresa, 
					   i.iddeposito, 
					   i.idcontenedor, 
					   i.idlotearticulo, 
					   ae.idarticulo,
					   s.totalexistencia
				FROM inserted i JOIN articuloembalaje ae ON i.idarticuloembalaje = ae.id
								JOIN stock s ON s.idempresa = i.idempresa
											AND s.iddeposito = i.iddeposito
											AND (s.idcontenedor = i.idcontenedor OR (i.idcontenedor IS NULL AND s.idcontenedor IS NULL))
											AND (s.idlotearticulo = i.idlotearticulo OR (i.idlotearticulo IS NULL AND s.idlotearticulo IS NULL))
											AND s.idarticulo = ae.idarticulo
				GROUP BY i.idempresa, 
					     i.iddeposito, 
					     i.idcontenedor, 
					     i.idlotearticulo, 
					     ae.idarticulo,
						 s.totalexistencia
				HAVING SUM(i.cantidad) > s.totalexistencia)
	BEGIN
		SELECT @errmsg = '> Existencia en stock menor a cantidad a transferir ...';
		RAISERROR ('> ERROR', 16, 1);
	END;

-- Actualización de las filas de detalletransferenciastocksalida con costos obtenidos de Stock

	UPDATE detalletransferenciastocksalida 
	SET existenciaanterior = s.totalexistencia,
		costogestionultimo = s.costogestionultimo,
		costogestionpromedio = s.costogestionpromedio,
		costogestionfifo = s.costogestionfifo,
		costogestionlifo = s.costogestionlifo,
		costogestionnifo = s.costogestionnifo,
		costoultimo = s.costoultimo,
		costopromedio = s.costopromedio,
		costofifo = s.costofifo,
		costolifo = s.costolifo,
		costonifo = s.costonifo
	FROM detalletransferenciastocksalida dtss 
	JOIN inserted i ON dtss.id = i.id
	JOIN articuloembalaje ae ON i.idarticuloembalaje = ae.id
	JOIN stock s ON s.idempresa = i.idempresa
				AND s.iddeposito = i.iddeposito
				AND (s.idcontenedor = i.idcontenedor OR (i.idcontenedor IS NULL AND s.idcontenedor IS NULL))
				AND (s.idlotearticulo = i.idlotearticulo OR (i.idlotearticulo IS NULL AND s.idlotearticulo IS NULL))
				AND s.idarticulo = ae.idarticulo;

-- Actualiza la existencia en stock

	UPDATE stock SET totaltransferenciasalida = totaltransferenciasalida + i.cantidad,
					 totalexistencia = totalexistencia - i.cantidad
	FROM stock s JOIN
	(SELECT i.idempresa, 
	        i.iddeposito, 
			i.idcontenedor, 
			i.idlotearticulo, 
			ae.idarticulo, 
			SUM(i.cantidad) AS cantidad
	 FROM inserted i JOIN articuloembalaje ae ON i.idarticuloembalaje = ae.id
	 GROUP BY i.idempresa, 
	          i.iddeposito, 
			  i.idcontenedor, 
			  i.idlotearticulo, 
			  ae.idarticulo) AS i
	ON s.idempresa = i.idempresa
	AND s.iddeposito = i.iddeposito
	AND (s.idcontenedor = i.idcontenedor OR (i.idcontenedor IS NULL AND s.idcontenedor IS NULL))
	AND (s.idlotearticulo = i.idlotearticulo OR (i.idlotearticulo IS NULL AND s.idlotearticulo IS NULL))
	AND s.idarticulo = i.idarticulo;

	UPDATE stock SET 
	totaltransferenciasalida = totaltransferenciasalida + 
	(SELECT SUM(i.cantidad) FROM inserted i
	 WHERE i.idarticuloembalaje = ae.id
	 AND s.idempresa = i.idempresa
	 AND s.iddeposito = i.iddeposito
	 AND (s.idcontenedor = i.idcontenedor OR (i.idcontenedor IS NULL AND s.idcontenedor IS NULL))
	 AND (s.idlotearticulo = i.idlotearticulo OR (i.idlotearticulo IS NULL AND s.idlotearticulo IS NULL))
	 AND s.idarticulo = ae.idarticulo),

	totalexistencia = totalexistencia - 	
	(SELECT SUM(i.cantidad) FROM inserted i
	 WHERE i.idarticuloembalaje = ae.id
	 AND s.idempresa = i.idempresa
	 AND s.iddeposito = i.iddeposito
	 AND (s.idcontenedor = i.idcontenedor OR (i.idcontenedor IS NULL AND s.idcontenedor IS NULL))
	 AND (s.idlotearticulo = i.idlotearticulo OR (i.idlotearticulo IS NULL AND s.idlotearticulo IS NULL))
	 AND s.idarticulo = ae.idarticulo)

	FROM inserted i JOIN articuloembalaje ae ON i.idarticuloembalaje = ae.id
	JOIN stock s ON s.idempresa = i.idempresa
				AND s.iddeposito = i.iddeposito
				AND (s.idcontenedor = i.idcontenedor OR (i.idcontenedor IS NULL AND s.idcontenedor IS NULL))
				AND (s.idlotearticulo = i.idlotearticulo OR (i.idlotearticulo IS NULL AND s.idlotearticulo IS NULL))
				AND s.idarticulo = ae.idarticulo;

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
