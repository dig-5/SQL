set dateformat dmy
select f.codvendedor,
f.NroFactura, 
f.CodAgencia, 
f.NroCuenta as Cuenta,
C.razonsocial, 
f.FechaRendicion,
f.montonetoiva
from Factura f join Cuenta c on f.NroCuenta = c.NroCuenta
where f.FechaRendicion between '01/01/2010' and '05/01/2010'
order by f.codvendedor, f.NroCuenta, f.NroFactura
compute sum(f.montonetoiva) by f.codvendedor, f.NroCuenta, f.NroFactura
compute sum(f.montonetoiva) by f.codvendedor, f.NroCuenta
compute sum(f.montonetoiva) by f.codvendedor
compute sum(f.montonetoiva);
