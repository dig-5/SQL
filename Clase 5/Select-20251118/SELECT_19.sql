--Reunionesa Externas
--LEFT OUTER JOIN
--RIGHT OUTER JOIN
--FULL OUTER JOIN

set dateformat dmy
select * 
from Vendedor V left outer join Factura F on V.CodVendedor = F.CodVendedor
                                         and F.FechaRendicion between '01/01/2009' and '31/12/2009'
order by V.CodVendedor;

set dateformat dmy
select * 
from Vendedor V left outer join Factura F on V.CodVendedor = F.CodVendedor
                                         and F.FechaRendicion between '01/01/2009' and '31/12/2009'
where f.NroFactura is null
order by V.CodVendedor;

set dateformat dmy
select * 
from Vendedor V left outer join Factura F on V.CodVendedor = F.CodVendedor
where F.FechaRendicion between '01/01/2009' and '31/12/2009'
order by V.CodVendedor;

select * 
from Vendedor V left outer join Factura F on V.CodVendedor = F.CodVendedor
                                         and F.FechaRendicion between '01/01/2009' and '31/12/2009'
where v.CodAgencia = 1
order by V.CodVendedor;

set dateformat dmy
select * 
from Factura F right outer join Vendedor V on V.CodVendedor = F.CodVendedor
                                         and F.FechaRendicion between '01/01/2009' and '31/12/2009'
order by V.CodVendedor;

select * from Pedido
where CodVendedor is null

update Pedido set CodVendedor = null where nrofactura is null;
alter table pedido alter column codvendedor int null;

select * from Pedido join Vendedor on Pedido.CodVendedor = Vendedor.CodVendedor
select * from Pedido left outer join Vendedor on Pedido.CodVendedor = Vendedor.CodVendedor
select * from Pedido right outer join Vendedor on Pedido.CodVendedor = Vendedor.CodVendedor
select * from Pedido full outer join Vendedor on Pedido.CodVendedor = Vendedor.CodVendedor

select * from Pedido right outer join Vendedor on Pedido.CodVendedor = Vendedor.CodVendedor
where Pedido.NroPedido is null
order by Vendedor.CodVendedor;

select Vendedor.* from Pedido right outer join Vendedor on Pedido.CodVendedor = Vendedor.CodVendedor 
where Pedido.NroPedido is null
order by Vendedor.CodVendedor;

select Vendedor.* from Pedido join Vendedor on Pedido.CodVendedor = Vendedor.CodVendedor 
--where Pedido.NroPedido is null
order by Vendedor.CodVendedor;
