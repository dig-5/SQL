set dateformat dmy
select Factura.CodVendedor,
       Vendedor.NombreVendedor,
       year(factura.fecharendicion) * 100 + month (factura.fecharendicion) as Periodo
from Factura, Vendedor
where Factura.CodVendedor = Vendedor.CodVendedor
and Factura.fecharendicion between '01/01/2010' and '31/12/2010'
group by year(factura.fecharendicion) * 100 + month (factura.fecharendicion), Factura.CodVendedor, Vendedor.NombreVendedor
order by Factura.CodVendedor, year(factura.fecharendicion) * 100 + month (factura.fecharendicion);

set dateformat dmy
select distinct Factura.CodVendedor,
			    Vendedor.NombreVendedor,
			    year(factura.fecharendicion) * 100 + month (factura.fecharendicion) as Periodo
from Factura, Vendedor
where Factura.CodVendedor = Vendedor.CodVendedor
and Factura.fecharendicion between '01/01/2010' and '31/12/2010'
order by Factura.CodVendedor, year(factura.fecharendicion) * 100 + month (factura.fecharendicion);
