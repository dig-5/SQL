create procedure PRCDetalleAjuste @TipoOPeracion char(1) = 'I',
                                  @NroAjuste int,
                                  @CodAgencia smallint,
                                  @Coddeposito int,
                                  @NroArticulo int,
                                  @CantidadEmbalada int,
                                  @CantidadFraccionada int

as

begin

	declare @errno int, @errmsg varchar(256);

	begin try
	
		begin transaction
	
		if  @TipoOPeracion = 'D'
		    delete from DetalleAjuste
		    where NroAjuste = @NroAjuste
		    and CodAgencia = @CodAgencia
		    and CodDeposito = @Coddeposito
		    and NroArticulo = @NroArticulo
		else
			if  @TipoOPeracion = 'S'
				select * from DetalleAjuste
				where NroAjuste = @NroAjuste
				and CodAgencia = @CodAgencia
				and CodDeposito = @Coddeposito
				and NroArticulo = @NroArticulo
			else
				if  @TipoOPeracion = 'U'
					update DetalleAjuste set CantidadEmbalada = @CantidadEmbalada,
											 CantidadFraccionada = @CantidadFraccionada
					where NroAjuste = @NroAjuste
					and CodAgencia = @CodAgencia
					and CodDeposito = @Coddeposito
					and NroArticulo = @NroArticulo
				else
					if  @TipoOPeracion = 'I'
						insert into DetalleAjuste (NroAjuste,
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
						select @NroAjuste,
							   @CodAgencia,
							   @Coddeposito,
							   @NroArticulo,
							   Articulo.CMDUltimo,
							   Articulo.CMDPromedio,
							   Articulo.CODUltimo,
							   Articulo.CODPromedio,
							   Articulo.CostoOfPromedio,
							   Articulo.Unidad,
							   AgenciaDepositoArticulo.Existencia,
							   @CantidadEmbalada,
							   @CantidadFraccionada,
							   @CantidadEmbalada + @CantidadFraccionada / Articulo.Unidad
						from Articulo join AgenciaDepositoArticulo
						on Articulo.NroArticulo = AgenciaDepositoArticulo.NroArticulo
						where Articulo.NroArticulo = @NroArticulo
						and AgenciaDepositoArticulo.NroArticulo = @NroArticulo
						and AgenciaDepositoArticulo.CodAgencia = @CodAgencia
						and AgenciaDepositoArticulo.CodDeposito = @Coddeposito;

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

                                  