alter procedure INSTransferencia @CodAgenciaSalida smallint,
                                  @CodDepositoSalida smallint,
								  @CodAgenciaEntrada smallint,
                                  @CodDepositoEntrada smallint,
								  @FechaTransferencia date,
								  @NroPersonal smallint = 1,
								  @NroCamion smallint = 1,
								  @Observacion varchar(255),
								  @NroTransferencia int output

as

begin

	begin try

	begin transaction

--Inserta la fila en Transferencia

		insert into Transferencia (CodAgenciaSalida,
								   CodDepositoSalida,
								   CodAgenciaEntrada,
								   CodDepositoEntrada,
								   FechaTransferencia,
								   NroPersonal,
								   NroCamion,
								   EstadoSalida,
								   EstadoEntrada,
								   EmiteNotaEnvio,
								   Id_Opr_Ing,
								   Observacion)
		select @CodAgenciaSalida,
			   @CodDepositoSalida,
			   @CodAgenciaEntrada,
			   @CodDepositoEntrada,
			   @FechaTransferencia,
			   @NroPersonal,
			   @NroCamion,
			   'A',
			   'A',
			   'S',
			   SUSER_SNAME(),
			   @Observacion;

-- Obtiene el Nro. de Transferencia

		select @NroTransferencia = SCOPE_IDENTITY();

	commit transaction;

    return 1;

end try

begin catch

    declare @errno int, @errmsg varchar(255);

	select @errno = ERROR_NUMBER(), @errmsg = ERROR_MESSAGE();
	
	select @errno, @errmsg;
	
	rollback transaction; 

	return -1;

end catch

end;
