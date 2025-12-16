ALTER TRIGGER TIUD_Ajuste ON Ajuste FOR INSERT, UPDATE, DELETE

AS

BEGIN

	DECLARE @ErrMSg VARCHAR(255);

	BEGIN TRY

-- Realiza las validaciones en caso de inserciones

	IF  EXISTS (SELECT * FROM Inserted)
	AND NOT EXISTS (SELECT * FROM Deleted)
	BEGIN

-- El Nro de OT no debe recibir ningún valor al insertar la fila de Ajuste

		IF  EXISTS (SELECT * FROM Inserted
					WHERE NroOT IS NOT NULL)
		BEGIN
			SELECT @ErrMSg = '> El Nro. de Orden de Trabajo siempre debe recibir nulos en la inserción del Ajuste ...';
			RAISERROR ('Error', 16, 1);
		END;

-- El Estado de las filas insertadas debe ser 'A' - Abierto

		IF  EXISTS (SELECT * FROM Inserted
					WHERE Estado <> 'A')
		BEGIN
			SELECT @ErrMSg = '> El único Estado posible en la inserción de Ajustes es ''A'' - Abierto ...';
			RAISERROR ('Error', 16, 1);
		END;
	END;

-- Realiza las validaciones en caso de eliminaciones

	IF  NOT EXISTS (SELECT * FROM Inserted)
	AND EXISTS (SELECT * FROM Deleted)
	BEGIN

-- Verifica que no se puedan eliminar filas con Estado 'N' - Anulado o 'C' - Cerrado

		IF  EXISTS (SELECT * FROM Deleted
					WHERE Estado <> 'A')
		BEGIN
			SELECT @ErrMSg = '> No se pueden eliminar Ajustes Anulados o Cerrados ...';
			RAISERROR ('Error', 16, 1);
		END;
	END;

-- Realiza las validaciones en caso de actualizaciones

	IF  EXISTS (SELECT * FROM Inserted)
	AND EXISTS (SELECT * FROM Deleted)
	BEGIN

-- Verifica que no se puedan actualizar filas de Ajustes que ya estaban cerradas o anuladas

		IF  EXISTS (SELECT * FROM Deleted
					WHERE Estado <> 'A')
		BEGIN
			SELECT @ErrMSg = '> No se pueden actualizar Ajustes Anulados o Cerrados ...';
			RAISERROR ('Error', 16, 1);
		END;

-- Verifica que si se actualizan Ajustes Abiertos y se actualiza la columna Estado, el mismo se actualice de 'A' - Abierto a 'C' - Cerrado o 'N' - Anulado

		IF  UPDATE (Estado)
		AND EXISTS (SELECT * FROM Inserted 
					WHERE Inserted.Estado NOT IN ('C', 'N'))
		BEGIN
			SELECT @ErrMSg = '> Si se Actualiza el Estado de un Ajuste, debe ser de Abierto a Anulado o de Abierto a Cerrado ...';
			RAISERROR ('Error', 16, 1);
		END;

-- Verifica que si se actualiza el Código de Empresa o el Número de Asiento o el Período, siempre las filas actualizadas tengan Estado = 'C' 

		IF  (UPDATE(CodEmpresa)
		OR   UPDATE(Periodo)
		OR   UPDATE(NroAsiento))
		AND EXISTS (SELECT * FROM Inserted
					WHERE Estado <> 'C')
		BEGIN
			SELECT @ErrMSg = '> Sólo pueden actualizarse datos del Asiento cuando el Ajuste acaba de Actualizarse a Cerrado ...';
			RAISERROR ('Error', 16, 1);
		END;
	END;

	RETURN;

	END TRY

	BEGIN CATCH

		IF  @ErrMsg IS NULL
			SELECT @ErrMsg = ERROR_MESSAGE();

		RAISERROR (@ErrMsg, 16, 1);

		ROLLBACK TRANSACTION;

	END CATCH

END;
