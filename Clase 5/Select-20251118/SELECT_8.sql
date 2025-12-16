set dateformat dmy
select Factura.CodVendedor,
       Vendedor.NombreVendedor,
       COUNT (*) as cantidadfacturas,
       COUNT (distinct Factura.NroCuenta) as CantidadClientes,
       SUM(Factura.MontoNetoIVA) as MontoVentaNeta
from Factura, Vendedor
where Factura.CodVendedor = Vendedor.CodVendedor
and Factura.fecharendicion between '01/01/2013' and '31/12/2013'
group by Factura.CodVendedor, Vendedor.NombreVendedor
having COUNT (distinct Factura.NroCuenta) >= 200
and sum(Factura.MontoNetoIVA) > 1000000000
order by CantidadClientes desc;

