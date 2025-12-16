CREATE TRIGGER TD_DetalleTransferenciaStockSalida ON DetalleTransferenciaStockSalida AFTER DELETE

AS

BEGIN

	DECLARE @errmsg VARCHAR (255);

	BEGIN TRY

-- La transferencia debe estar con estadosalida = 0 

	IF  EXISTS (SELECT * FROM deleted d JOIN transferenciastock ts
				ON d.idtransferenciastock = ts.id
				WHERE ts.estadosalida <> 0)
	BEGIN
		SELECT @errmsg = '> Transferencia con estado de salida cerrada ...';
		RAISERROR ('> ERROR', 16, 1);
	END;

-- Actualiza la existencia en stock

	UPDATE stock SET totaltransferenciasalida = totaltransferenciasalida - d.cantidad,
					 totalexistencia = totalexistencia + d.cantidad
	FROM stock s JOIN
	(SELECT d.idempresa, 
	        d.iddeposito, 
			d.idcontenedor, 
			d.idlotearticulo, 
			ae.idarticulo, 
			SUM(d.cantidad) AS cantidad
	 FROM deleted d JOIN articuloembalaje ae ON d.idarticuloembalaje = ae.id
	 GROUP BY d.idempresa, 
	          d.iddeposito, 
			  d.idcontenedor, 
			  d.idlotearticulo, 
			  ae.idarticulo) AS d
	ON s.idempresa = d.idempresa
	AND s.iddeposito = d.iddeposito
	AND (s.idcontenedor = d.idcontenedor OR (d.idcontenedor IS NULL AND s.idcontenedor IS NULL))
	AND (s.idlotearticulo = d.idlotearticulo OR (d.idlotearticulo IS NULL AND s.idlotearticulo IS NULL))
	AND s.idarticulo = d.idarticulo;
/*
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
*/
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
