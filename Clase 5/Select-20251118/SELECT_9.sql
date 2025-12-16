set dateformat dmy
select Factura.CodVendedor,
       year(factura.fecharendicion) * 100 + month (factura.fecharendicion) as Periodo,
       sum(Factura.MontoNetoIVA) as MontoVentaNeta,
       COUNT(*)
from Factura, Vendedor
where Factura.CodVendedor = Vendedor.CodVendedor
and Factura.fecharendicion between '01/01/2013' and '31/12/2013'
group by Factura.CodVendedor, 
         year(factura.fecharendicion) * 100 + month (factura.fecharendicion)
with rollup
order by Factura.CodVendedor, year(factura.fecharendicion) * 100 + month (factura.fecharendicion);

set dateformat dmy
select Factura.CodVendedor,
       year(factura.fecharendicion) * 100 + month (factura.fecharendicion) as Periodo,
       sum(Factura.MontoNetoIVA) as MontoVentaNeta,
       COUNT(*)
from Factura, Vendedor
where Factura.CodVendedor = Vendedor.CodVendedor
and Factura.fecharendicion between '01/01/2013' and '31/12/2013'
group by Factura.CodVendedor, 
         year(factura.fecharendicion) * 100 + month (factura.fecharendicion)
with cube
order by Factura.CodVendedor, year(factura.fecharendicion) * 100 + month (factura.fecharendicion);
