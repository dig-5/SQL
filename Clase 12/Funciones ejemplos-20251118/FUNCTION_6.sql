create function dbo.FNCObtienSaldoCuentas (@CodEmpresa int,
                                           @NroCuenta char(20),
										   @PeriodoInicial int,
										   @PeriodoFinal int,
										   @CodAgencia smallint = 9999,
										   @CodCentroCosto smallint = 9999,
										   @CodCentroCosto_2 smallint = 9999,
										   @CodMoneda smallint = 1)

returns table

as

return (select da.codempresa, 
               da.periodo,
			   da.nrocuenta,
			   isnull(@CodAgencia, da.codagencia) as codagencia,
			   isnull(@CodCentroCosto, da.CodCentroCosto) as CodCentroCosto,
			   isnull(@CodCentroCosto_2, da.CodCentroCosto_2) as CodCentroCosto_2,
			   isnull(@CodMoneda, da.codmoneda) as CodMoneda,
               sum(da.debitomonedanac - da.creditomonedanac) as Saldo
	    from DetalleAsiento da join Asiento a
	    on da.CodEmpresa = a.CodEmpresa
		and da.Periodo = a.Periodo
		and da.NroAsiento = a.NroAsiento
		where da.CodEmpresa = @CodEmpresa
		and da.Periodo between @PeriodoInicial and @PeriodoFinal
		and a.estado <> 'N'
		and isnull(@NroCuenta, da.NroCuenta) = da.NroCuenta
		and isnull(@CodAgencia, da.codagencia) = da.codagencia
		and isnull(@CodCentroCosto, da.CodCentroCosto) = da.CodCentroCosto
		and isnull(@CodCentroCosto_2, da.CodCentroCosto_2) = da.CodCentroCosto_2
		and isnull(@CodMoneda, da.codmoneda) = da.CodMoneda
        group by da.codempresa, 
                 da.periodo,
			     da.nrocuenta,
			     isnull(@CodAgencia, da.codagencia),
			     isnull(@CodCentroCosto, da.CodCentroCosto),
			     isnull(@CodCentroCosto_2, da.CodCentroCosto_2),
			     isnull(@CodMoneda, da.codmoneda));
