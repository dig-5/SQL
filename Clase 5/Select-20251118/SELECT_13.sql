set dateformat dmy;

select f.nrofactura, 
f.nrocuenta, 
v.codvendedor, 
v.nombrevendedor, 
f.fechaemision, 
f.montonetoiva
from vendedor v left outer join factura f on v.codvendedor = f.codvendedor
and f.fechaemision between '01/01/2013 00:00' and '31/12/2013 23:59:59'
order by f.fechaemision, f.nrocuenta;

set dateformat dmy;

select f.nrofactura, 
f.nrocuenta, 
v.codvendedor, 
v.nombrevendedor, 
f.fechaemision, 
f.montonetoiva
from factura f right outer join vendedor v on f.codvendedor = v.codvendedor
and f.fechaemision between '01/01/2013 00:00' and '31/12/2013 23:59:59'
order by f.fechaemision, f.nrocuenta;


select *
from zona left outer join cuenta on zona.codzona = cuenta.codzona
where cuenta.codzona is null
order by zona.codzona;

select *
from zona full outer join cuenta on zona.codzona = cuenta.codzona
--where cuenta.codzona is null
order by zona.codzona;
