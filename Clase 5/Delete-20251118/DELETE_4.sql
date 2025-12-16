--update
--delete
--insert ... select ...

COMPRA
DETALLECOMPRA

select * from Compra;
alter table compra disable trigger all
update Compra set Estado = 'A' where NroCompra >= 2000;
alter table compra enable trigger all

alter table DetalleCompra disable trigger all
delete from DetalleCompra
from DetalleCompra join Compra on DetalleCompra.NroCompra = Compra.NroCompra
where Compra.Estado = 'A';
alter table DetalleCompra enable trigger all

alter table compra disable trigger all

delete from Compra
from Compra left outer join DetalleCompra on Compra.NroCompra = DetalleCompra.NroCompra
where DetalleCompra.NroCompra is null

