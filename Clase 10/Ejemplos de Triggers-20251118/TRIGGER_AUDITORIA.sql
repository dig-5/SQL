CREATE TRIGGER TIUD_CtaCte ON CtaCte FOR INSERT, UPDATE, DELETE

AS

BEGIN

	DECLARE @TipoOperacion CHAR(1), 
			@ErrMsg VARCHAR(255);

	BEGIN TRY

-- Determina el Tipo de Operación (INSERT, UPDATE, DELETE) ejecutado

	IF  EXISTS (SELECT * FROM INSERTED)
	AND NOT EXISTS (SELECT * FROM DELETED)
		SELECT @TipoOperacion = 'I'
	ELSE
		IF  EXISTS (SELECT * FROM INSERTED)
		AND EXISTS (SELECT * FROM DELETED)
			SELECT @TipoOperacion = 'U'
		ELSE
			SELECT @TipoOperacion = 'D';

-- Inserta la fila en AuditoriaTablas

	IF  @TipoOperacion = 'I'
		INSERT INTO AuditoriaTablas (NombreTabla,
									 TipoOperacion,
									 Actual,
									 Anterior)
		SELECT 'CtaCte',
			   @TipoOperacion,
               (SELECT * FROM inserted FOR XML AUTO, ROOT, ELEMENTS),
			   NULL
	ELSE
		IF  @TipoOperacion = 'U'
			INSERT INTO AuditoriaTablas (NombreTabla,
										 TipoOperacion,
										 Actual,
										 Anterior)
			SELECT 'CtaCte',
				   @TipoOperacion,
				   (SELECT * FROM inserted FOR XML AUTO, ROOT, ELEMENTS),
				   (SELECT * FROM deleted FOR XML AUTO, ROOT, ELEMENTS)
		ELSE
			INSERT INTO AuditoriaTablas (NombreTabla,
										 TipoOperacion,
										 Actual,
										 Anterior)
			SELECT 'CtaCte',
				   @TipoOperacion,
				   NULL,
				   (SELECT * FROM deleted FOR XML AUTO, ROOT, ELEMENTS);

	RETURN;
	
	END TRY

	BEGIN CATCH

		SELECT @ErrMsg = ERROR_MESSAGE ();

		RAISERROR (@ErrMsg, 16, 1);

		ROLLBACK TRANSACTION;

	END CATCH

END;
