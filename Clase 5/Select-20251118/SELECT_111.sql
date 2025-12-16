select max(fechacambio), min(fechacambio) from compra;

select count(*), 
count(distinct nrocuenta),
sum(montonetoiva), 
min(montonetoiva), 
max(montonetoiva), 
avg(montonetoiva)
from factura
where year(fechaemision) = 2013;
