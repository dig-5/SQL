alter function dbo.FNCObtienSaldoCuenta (@CodEmpresa int,
                                         @NroCuenta char(20),
					 @PeriodoInicial int,
					 @PeriodoFinal int,
					 @CodAgencia smallint = 9999,
					 @CodCentroCosto smallint = 9999,
					 @CodCentroCosto_2 smallint = 9999,
					 @CodMoneda smallint = 1)

returns money

as

begin

    declare @Saldo money;

-- Obtiene el Saldo de la Cuenta a partir de los Asientos no anulados

    select @Saldo = sum(da.debitomonedanac - da.creditomonedanac)
	from DetalleAsiento da join Asiento a
	on da.CodEmpresa = a.CodEmpresa
	and da.Periodo = a.Periodo
	and da.NroAsiento = a.NroAsiento
	where da.CodEmpresa = @CodEmpresa
	and da.Periodo between @PeriodoInicial and @PeriodoFinal
	and da.NroCuenta = @NroCuenta
	and a.estado <> 'N'
	and isnull(@CodAgencia, da.codagencia) = da.codagencia
	and isnull(@CodCentroCosto, da.CodCentroCosto) = da.CodCentroCosto
	and isnull(@CodCentroCosto_2, da.CodCentroCosto_2) = da.CodCentroCosto_2
	and isnull(@CodMoneda, da.codmoneda) = da.CodMoneda;

	return @Saldo;

end;
