select * 
from Cuenta, Vendedor

select * from Cuenta, Vendedor
where Cuenta.CodVendedor = Vendedor.CodVendedor
order by NroCuenta;

select * from Cuenta as C, Vendedor as V
where C.CodVendedor = V.CodVendedor
order by C.NroCuenta;

select * from Cuenta as C, Vendedor as V
where C.CodVendedor = V.CodVendedor
order by C.NroCuenta;

select C.NroCuenta, 
C.RazonSocial, 
C.ApellidoCuenta, 
C.CodigoRuc,
v.CodVendedor, 
v.NombreVendedor
from Cuenta as C, Vendedor as V
where C.CodVendedor = V.CodVendedor
order by C.NroCuenta;

select C.NroCuenta, 
C.RazonSocial, 
C.ApellidoCuenta, 
C.CodigoRuc,
c.totaldebitosgs - C.totalcreditosgs as SaldoenGuaranies,
c.TotalDebitosDL - C.TotalCreditosDL as SaldoenDolares,
v.CodVendedor, 
v.NombreVendedor
from Cuenta as C, Vendedor as V
where C.CodVendedor = V.CodVendedor
order by C.NroCuenta;
