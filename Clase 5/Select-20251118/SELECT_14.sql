set dateformat dmy;
select f.nrofactura, 
f.nrocuenta, 
v.codvendedor, 
v.nombrevendedor, 
f.fechaemision, 
f.montonetoiva
from vendedor v left outer join factura f on v.codvendedor = f.codvendedor
and f.fechaemision between '01/01/2013 00:00' and '31/12/2013 23:59:59'
where f.nrofactura is null
order by f.fechaemision, f.nrocuenta;