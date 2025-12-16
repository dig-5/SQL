alter procedure SLCCuentayCliente; 2 @TipoOPeracion char(1) = 'N'

as

begin

    if  @TipoOPeracion = 'N'
		select * from Cliente join Cuenta 
				   on Cliente.CodCliente = Cuenta.CodCliente
		order by Cuenta.NroCuenta
	else
        if  @TipoOPeracion = 'R'
			select * from Cliente join Cuenta 
					   on Cliente.CodCliente = Cuenta.CodCliente
			order by Cuenta.RazonSocial
	    else
			if  @TipoOPeracion = 'C'
				select * from Cliente join Cuenta 
						   on Cliente.CodCliente = Cuenta.CodCliente
				order by Cuenta.NombreCuenta
			else
				if  @TipoOPeracion = 'S'
					select * from Cliente join Cuenta 
							   on Cliente.CodCliente = Cuenta.CodCliente
					order by Cliente.SaldoGuaranies desc
				else
				    raiserror 50001 '> Tipo de Operación errónea ...';
    
end;
