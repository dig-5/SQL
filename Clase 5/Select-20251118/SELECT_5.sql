set dateformat dmy
select Factura.CodVendedor,
       Vendedor.NombreVendedor,
       year(factura.fecharendicion) * 100 + month (factura.fecharendicion) as Periodo,
       GETDATE(),
       1, 
       COUNT (*) as cantidadfacturas,
       COUNT (distinct Factura.NroCuenta) as CantidadClientes,
       sum(Factura.MontoNetoIVA) as MontoVentaNeta,
       MIN(Factura.MontoNetoIVA) as MontoMinimo,
       MAX(Factura.MontoNetoIVA) as MontoMaximo,
       avg(Factura.MontoNetoIVA) as MontoPromedio
from Factura, Vendedor
where Factura.CodVendedor = Vendedor.CodVendedor
and Factura.fecharendicion between '01/01/2013' and '31/12/2013'
group by Factura.CodVendedor, Vendedor.NombreVendedor,
         year(factura.fecharendicion) * 100 + month (factura.fecharendicion)
order by Factura.CodVendedor, year(factura.fecharendicion) * 100 + month (factura.fecharendicion);
