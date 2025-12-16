Funciones Agregadas
- count (expresión)
- count (distinct expresión)
- count (*)
- sum (expresión)
- min (expresión)
- max (expresión)
- avg (expresión)

set dateformat dmy
select COUNT (*) as cantidadfacturas,
       COUNT (distinct nrocuenta) as CantidadClientes,
       sum(montonetoiva) as MontoVentaNeta,
       MIN(montonetoiva) as MontoMinimo,
       MAX(montonetoiva) as MontoMaximo,
       avg(montonetoiva) as MontoPromedio
from Factura
where fecharendicion between '01/01/2013' and '31/12/2013';

set dateformat dmy
select COUNT (*) as cantidadfacturas,
       COUNT (distinct nrocuenta) as CantidadClientes,
       sum(montonetoiva + montoiva) as MontoVentaNeta,
       MIN(montonetoiva + montoiva) as MontoMinimo,
       MAX(montonetoiva + montoiva) as MontoMaximo,
       avg(montonetoiva + montoiva) as MontoPromedio
from Factura
where fecharendicion between '01/01/2013' and '31/12/2013';

set dateformat dmy
select COUNT (*) as cantidadfacturas,
       COUNT (distinct Factura.NroCuenta) as CantidadClientes,
       COUNT (distinct vendedor.CodVendedor) as CantidadVendedores,
       sum(Factura.MontoNetoIVA) as MontoVentaNeta,
       MIN(Factura.MontoNetoIVA) as MontoMinimo,
       MAX(Factura.MontoNetoIVA) as MontoMaximo,
       avg(Factura.MontoNetoIVA) as MontoPromedio
from Factura, Vendedor, Cuenta
where Factura.NroCuenta = Cuenta.NroCuenta
and Cuenta.CodVendedor = Vendedor.CodVendedor
and Factura.fecharendicion between '01/01/2013' and '31/12/2013';

set dateformat dmy
select factura.codmoneda,
       moneda.descripcionmoneda,
	   getdate(),
       COUNT (*) as cantidadfacturas,
       COUNT (distinct nrocuenta) as CantidadClientes,
       sum(montonetoiva) as MontoVentaNeta,
       MIN(montonetoiva) as MontoMinimo,
       MAX(montonetoiva) as MontoMaximo,
       avg(montonetoiva) as MontoPromedio
from Factura join moneda on factura.codmoneda = moneda.codmoneda
where fecharendicion between '01/01/2013' and '31/12/2013'
group by factura.codmoneda,
         moneda.descripcionmoneda;
       

set dateformat dmy
select factura.codvendedor,
       vendedor.nombrevendedor,
       factura.codmoneda,
       moneda.descripcionmoneda,
	   getdate(),
       COUNT (*) as cantidadfacturas,
       COUNT (distinct nrocuenta) as CantidadClientes,
       sum(montonetoiva) as MontoVentaNeta
from Factura join moneda on factura.codmoneda = moneda.codmoneda
             join vendedor on factura.codvendedor = vendedor.codvendedor
where fecharendicion between '01/01/2013' and '31/12/2013'
group by factura.codvendedor,
         vendedor.nombrevendedor,
         factura.codmoneda,
         moneda.descripcionmoneda
order by factura.codvendedor,
         factura.codmoneda;

set dateformat dmy
select factura.codvendedor,
       vendedor.nombrevendedor,
       factura.codmoneda,
       moneda.descripcionmoneda,
	   getdate(),
       COUNT (*) as cantidadfacturas,
       COUNT (distinct nrocuenta) as CantidadClientes,
       sum(montonetoiva) as MontoVentaNeta
from Factura join moneda on factura.codmoneda = moneda.codmoneda
             join vendedor on factura.codvendedor = vendedor.codvendedor
where fecharendicion between '01/01/2013' and '31/12/2013'
group by factura.codvendedor,
         vendedor.nombrevendedor,
         factura.codmoneda,
         moneda.descripcionmoneda
order by factura.codmoneda asc,
--         sum(montonetoiva) desc;
--         MontoVentaNeta desc;
         8 desc;

set dateformat dmy
select factura.codvendedor,
       vendedor.nombrevendedor,
       factura.codmoneda,
       moneda.descripcionmoneda
from Factura join moneda on factura.codmoneda = moneda.codmoneda
             join vendedor on factura.codvendedor = vendedor.codvendedor
where fecharendicion between '01/01/2013' and '31/12/2013'
group by factura.codvendedor,
         vendedor.nombrevendedor,
         factura.codmoneda,
         moneda.descripcionmoneda
order by factura.codmoneda asc,
         factura.codvendedor asc;

set dateformat dmy
select distinct 
       factura.codvendedor,
       vendedor.nombrevendedor,
       factura.codmoneda,
       moneda.descripcionmoneda
from Factura join moneda on factura.codmoneda = moneda.codmoneda
             join vendedor on factura.codvendedor = vendedor.codvendedor
where fecharendicion between '01/01/2013' and '31/12/2013'
order by factura.codmoneda asc,
         factura.codvendedor asc;

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
from Factura, Vendedor
where Factura.CodVendedor = Vendedor.CodVendedor
and Factura.fecharendicion between '01/01/2010' and '31/12/2010'
group by Factura.CodVendedor, Vendedor.NombreVendedor
--order by COUNT (distinct Factura.NroCuenta) desc;
--order by 6 desc;
order by CantidadClientes desc;

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
from Factura, Vendedor
where Factura.CodVendedor = Vendedor.CodVendedor
and Factura.fecharendicion between '01/01/2013' and '31/12/2013'
group by Factura.CodVendedor, Vendedor.NombreVendedor
--order by COUNT (distinct Factura.NroCuenta) desc;
--order by 6 desc;
order by CantidadClientes desc;
