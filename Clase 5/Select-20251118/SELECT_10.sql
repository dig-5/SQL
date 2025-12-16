set dateformat dmy;
select *
from factura f, cuenta c, vendedor v
where f.nrocuenta = c.nrocuenta
and f.codvendedor = v.codvendedor
and f.fechaemision between '01/01/2013 00:00' and '31/12/2013 23:59:59'
order by f.fechaemision, f.nrocuenta;

select f.nrofactura, 
f.nrocuenta, 
c.razonsocial, 
c.codigoruc, 
f.codvendedor, 
v.nombrevendedor, 
f.fechaemision, 
f.montonetoiva
from factura f, cuenta c, vendedor v
where f.nrocuenta = c.nrocuenta
and f.codvendedor = v.codvendedor
and f.fechaemision between '01/01/2013 00:00' and '31/12/2013 23:59:59'
order by f.fechaemision, f.nrocuenta;
