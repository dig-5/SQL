set dateformat dmy
select COUNT (*) as cantidadfacturas,
       COUNT (distinct Factura.NroCuenta) as CantidadClientes,
       COUNT (distinct vendedor.CodVendedor) as CantidadClientes,
       sum(Factura.MontoNetoIVA) as MontoVentaNeta,
       MIN(Factura.MontoNetoIVA) as MontoMinimo,
       MAX(Factura.MontoNetoIVA) as MontoMaximo,
       avg(Factura.MontoNetoIVA) as MontoPromedio
from Factura join Cuenta on Factura.NroCuenta = Cuenta.NroCuenta
			 join Vendedor on Cuenta.CodVendedor = Vendedor.CodVendedor 
			              and Factura.CodVendedor = Vendedor.CodVendedor
where Factura.fecharendicion between '01/01/2010' and '31/12/2010';

set dateformat dmy
select Factura.CodVendedor,
       Vendedor.NombreVendedor,
       GETDATE(),
       1, 
       COUNT (*) as cantidadfacturas,
       COUNT (distinct Factura.NroCuenta) as CantidadClientes,
       sum(Factura.MontoNetoIVA) as MontoVentaNeta,
       MIN(Factura.MontoNetoIVA) as MontoMinimo,
       MAX(Factura.MontoNetoIVA) as MontoMaximo,
       avg(Factura.MontoNetoIVA) as MontoPromedio
from Factura join Vendedor on Factura.CodVendedor = Vendedor.CodVendedor 
                          and Factura.fecharendicion between '01/01/2010' and '31/12/2010'
group by Factura.CodVendedor, Vendedor.NombreVendedor
--order by COUNT (distinct Factura.NroCuenta) desc;
--order by 6 desc;
order by CantidadClientes desc;
