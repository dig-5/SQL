select * from Cuenta inner join Vendedor 
on Cuenta.CodVendedor = Vendedor.CodVendedor
order by NroCuenta;

select * 
from Cuenta as C join Vendedor as V
on C.CodVendedor = V.CodVendedor
order by C.NroCuenta;

select C.NroCuenta, 
C.RazonSocial, 
C.ApellidoCuenta, 
C.CodigoRuc,
v.CodVendedor, 
v.NombreVendedor
from Cuenta as C join Vendedor as V
on C.CodVendedor = V.CodVendedor
order by C.NroCuenta;

select C.NroCuenta, 
C.RazonSocial, 
C.ApellidoCuenta, 
C.CodigoRuc,
c.totaldebitosgs - C.totalcreditosgs as SaldoenGuaranies,
c.TotalDebitosDL - C.TotalCreditosDL as SaldoenDolares,
v.CodVendedor, 
v.NombreVendedor
from Cuenta as C join Vendedor as V
on C.CodVendedor = V.CodVendedor
order by C.NroCuenta;
