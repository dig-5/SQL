set dateformat dmy;

select f.nrofactura, 
f.nrocuenta, 
c.razonsocial, 
c.codigoruc,
v.codvendedor, 
v.nombrevendedor, 
f.fechaemision, 
f.montonetoiva
from factura f inner join cuenta c on f.nrocuenta = c.nrocuenta
right outer join vendedor v on f.codvendedor = v.codvendedor
                           and f.fechaemision between '01/01/2013 00:00' and '31/12/2013 23:59:59'
order by f.fechaemision, f.nrocuenta;

