--DROP PROCEDURE INSDetalleAjuste 

ALTER PROCEDURE INSDetalleAjuste @NroAjuste INT,
								  @CodAgencia SMALLINT = 1,
								  @CodDeposito SMALLINT = 1,
								  @NroArticulo INT,
								  @CantidadEmbalada INT,
								  @CantidadFraccionada INT

AS

BEGIN
--
	DECLARE @Unidad INT,
			@Cantidad FLOAT,
			@ErrNo INT,
			@ErrMsg VARCHAR(255)
--
	BEGIN TRY
--
	BEGIN TRANSACTION
--
	IF  NOT EXISTS (SELECT * FROM Ajuste 
					 WHERE NroAjuste = @NroAjuste
					 AND Estado = 'A')
	BEGIN
		SELECT @ErrMsg = '> Ajuste Inexistente o No Abierto ...';
		RAISERROR ('Error', 16, 1);
	END;
--
	IF  EXISTS (SELECT * FROM AgenciaDepositoArticulo ADA JOIN Articulo A
						   ON ADA.NroArticulo = A.NroArticulo
				 WHERE ADA.CodAgencia = @CodAgencia
				 AND ADA.CodDeposito = @CodDeposito
				 AND ADA.NroArticulo = @NroArticulo
				 AND ADA.Existencia < (@CantidadEmbalada + (@CantidadFraccionada / A.Unidad)))

	AND EXISTS (SELECT * FROM Ajuste A JOIN TipoAjuste TA ON A.CodTipoAjuste = TA.CodTipoAjuste
				WHERE A.NroAjuste = @NroAjuste
				AND TA.PositivooNegativo = -1)
	BEGIN
		SELECT @ErrMsg = '> Cantidad a Ajustar mayor a Existencia en AgenciaDepositoArticulo ...';
		RAISERROR ('Error', 16, 1);
	END;

-- Inserta la fila en DetalleAjuste

	INSERT INTO DetalleAjuste (NroAjuste,
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
	SELECT @NroAjuste,
		   @CodAgencia,
		   @CodDeposito,
		   @NroArticulo,
		   A.CMDUltimo,
		   A.CMDPromedio,
		   A.CODUltimo,
		   A.CODPromedio,
		   A.CostoOfUltimo,
		   A.Unidad,
		   ADA.Existencia,
		   @CantidadEmbalada,
		   @CantidadFraccionada,
		   (@CantidadEmbalada + (@CantidadFraccionada / A.Unidad))
	FROM AgenciaDepositoArticulo ADA JOIN Articulo A
	  ON ADA.NroArticulo = A.NroArticulo
	WHERE ADA.CodAgencia = @CodAgencia
	AND ADA.CodDeposito = @CodDeposito
	AND ADA.NroArticulo = @NroArticulo;

-- Actualiza la existencia en AgenciaDepositoArticulo

	UPDATE AgenciaDepositoArticulo 
	SET MesAjuste = ADA.MesAjuste + ((@CantidadEmbalada + (@CantidadFraccionada / A.Unidad)) * 
									(SELECT PositivooNegativo
									 FROM Ajuste A JOIN TipoAjuste TA 
									 ON A.CodTipoAjuste = TA.CodTipoAjuste
									 WHERE A.NroAjuste = @NroAjuste))
	FROM AgenciaDepositoArticulo ADA JOIN Articulo A
	ON ADA.NroArticulo = A.NroArticulo
	WHERE ADA.CodAgencia = @CodAgencia
	AND ADA.CodDeposito = @CodDeposito
	AND ADA.NroArticulo = @NroArticulo;

	COMMIT TRANSACTION;
	
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
