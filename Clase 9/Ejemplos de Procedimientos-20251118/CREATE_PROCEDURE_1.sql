create procedure SLCCuentayCliente; 1

as

begin

	select * from Cliente join Cuenta 
			   on Cliente.CodCliente = Cuenta.CodCliente
    order by Cuenta.NroCuenta;
    
end;
