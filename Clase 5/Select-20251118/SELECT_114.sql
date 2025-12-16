select f.codvendedor,
v.NombreVendedor,
count(*), 
count(distinct nrocuenta),
sum(montonetoiva), 
min(montonetoiva), 
max(montonetoiva), 
avg(montonetoiva)
from factura f join vendedor v on f.codvendedor = v.codvendedor
where year(fechaemision) = 2013
group by f.codvendedor,
v.NombreVendedor
having sum(montonetoiva) > 500000000 
and count(*) > 1000
order by sum(montonetoiva) desc;
