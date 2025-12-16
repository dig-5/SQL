alter procedure INSAjuste @CodTipoAjuste smallint = 1,
                           @NroComprobante char(15),
                           @FechaAjuste datetime,
                           @Estado char(1) = 'A',
                           @CodEmpresa int = 1,
                           @NroAjuste int output
                   
as

begin

	declare @errno int, @errmsg varchar(256);

	begin try
	
		begin transaction
	
-- Verifica que exista el Tipo de Ajusre

		if  not exists (select * from TipoAjuste where CodTipoAjuste = @CodTipoAjuste)
--		if  (select COUNT(*) from TipoAjuste where CodTipoAjuste = @CodTipoAjuste) = 0
		begin
			select @errno = 50001, @errmsg = '> Tipo de Ajuste Inexistente ...';
			raiserror (50001, 16, 1);
		end;

-- Verifica que el estado sea igual a 'A' o 'C' o 'N'

		if  @Estado not in ('A', 'C', 'N')
		begin
			select @errno = 50002, @errmsg = '> Estado del Ajuste con valor erróneo ...';
			raiserror (50002, 16, 1);
		end;

-- Inserta la fila en Ajuste

		insert into Ajuste (CodTipoAjuste, NroComprobante, FechaAjuste, Estado, CodEmpresa)
		select @CodTipoAjuste,
               @NroComprobante,
               @FechaAjuste,
               @Estado,
               @CodEmpresa;

		select @NroAjuste = @@IDENTITY;
		
		commit transaction;
	
		return 0;

	end try
	
	begin catch
	
		if  @errno is null 
		begin
			select @errno = ERROR_NUMBER(),
				   @errmsg = ERROR_MESSAGE();
		end;
		
		raiserror @errno @errmsg;

		rollback transaction
		
		return 1;
	
	end catch

end;
	