create function dbo.FNCObtieneSaldoCuenta (@NroCuenta int,
					   @CodMoneda smallint = 1,
					   @FechaSaldo date = null)

returns money

as

begin

	declare @Saldo money;
	
	select @Saldo = sum(case when ctacte.codconcepto between 1 and 9 then ctacte.debito
	                         when ctacte.codconcepto not between 1 and 9 then ctacte.credito * -1
	                     end)
	from ctacte
	where ctacte.nrocuenta = @nrocuenta
	and ctacte.codmoneda = @codmoneda
	and ctacte.fechacambio <= isnull(@fechasaldo, ctacte.fechacambio);

	return @saldo;

end;
