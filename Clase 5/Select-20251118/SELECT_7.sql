set dateformat dmy
select Factura.CodVendedor,
       Vendedor.NombreVendedor,
       COUNT (*) as cantidadfacturas,
       COUNT (distinct Factura.NroCuenta) as CantidadClientes,
       sum(Factura.MontoNetoIVA) as MontoVentaNeta
from Factura, Vendedor
where Factura.CodVendedor = Vendedor.CodVendedor
and Factura.fecharendicion between '01/01/2013' and '31/12/2013'
group by all Factura.CodVendedor, Vendedor.NombreVendedor
order by Factura.CodVendedor;
