select * from personal;
select * from agencia;

select * 
from personal, agencia
order by nropersonal;

select * 
from personal cross join agencia
order by nropersonal;

select *
from compra, proveedor;

select count(*) from compra;
select count(*) from proveedor;
