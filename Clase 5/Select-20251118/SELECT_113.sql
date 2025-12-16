select f.codvendedor,
v.NombreVendedor,
year(fechaemision) * 100 + month(fechaemision),
count(*), 
count(distinct nrocuenta),
sum(montonetoiva), 
min(montonetoiva), 
max(montonetoiva), 
avg(montonetoiva)
from factura f join vendedor v on f.codvendedor = v.codvendedor
where year(fechaemision) = 2013
group by f.codvendedor,
v.NombreVendedor,
year(fechaemision) * 100 + month(fechaemision)
order by f.codvendedor,
year(fechaemision) * 100 + month(fechaemision);

