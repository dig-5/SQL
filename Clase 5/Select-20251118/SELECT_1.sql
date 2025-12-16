select * from cuenta;

select nrocuenta, 
razonsocial, 
nombrecuenta, 
codigoruc, 
codvendedor
from cuenta;

select *
from cuenta
where CodVendedor = 10;

select nrocuenta, 
razonsocial, 
nombrecuenta, 
codigoruc, 
codvendedor
from cuenta
where CodVendedor = 10 and CodZona is not null;

select nrocuenta as "Nro.Cuenta", 
razonsocial  "Razón Social" ,
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR"
from cuenta
where CodVendedor = 10 and CodZona is not null;

select nrocuenta as "Nro.Cuenta", 
razonsocial "Razón Social" , 
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR",
TotalDebitosGS - TotalCreditosGS as "Saldo Guaraníes",
GETDATE() as "Fecha Sistema"
from cuenta
where CodVendedor = 10 and CodZona is not null;

select nrocuenta as "Nro.Cuenta", 
 razonsocial "Razón Social" , 
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR",
TotalDebitosGS - TotalCreditosGS as "Saldo Guaraníes",
GETDATE() as "Fecha Sistema"
from cuenta
where CodVendedor = 10 and CodZona is not null
order by CodigoRuc, razonsocial;

select nrocuenta as "Nro.Cuenta", 
razonsocial "Razón Social"  , 
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR",
TotalDebitosGS - TotalCreditosGS as "Saldo Guaraníes",
GETDATE() as "Fecha Sistema"
from cuenta
where CodVendedor = 10 and CodZona is not null
order by CodigoRuc desc, razonsocial;

select nrocuenta as "Nro.Cuenta", 
razonsocial "Razón Social" , 
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR",
TotalDebitosGS - TotalCreditosGS as "Saldo Guaraníes",
GETDATE() as "Fecha Sistema"
from cuenta
where CodVendedor = 10 and CodZona is not null
order by RUC desc, "Razón Social";

select nrocuenta as "Nro.Cuenta", 
razonsocial "Razón Social" , 
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR",
TotalDebitosGS - TotalCreditosGS as "Saldo Guaraníes",
GETDATE() as "Fecha Sistema"
from cuenta
where CodVendedor = 10 and CodZona is not null
order by 4 desc, 2;

select nrocuenta as "Nro.Cuenta", 
razonsocial "Razón Social" , 
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR",
TotalDebitosGS - TotalCreditosGS as "Saldo Guaraníes",
GETDATE() as "Fecha Sistema"
from cuenta
where CodVendedor = 10 and CodZona is not null
order by TotalDebitosGS - TotalCreditosGS desc;

select top 50 nrocuenta as "Nro.Cuenta", 
razonsocial "Razón Social" , 
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR",
TotalDebitosGS - TotalCreditosGS as "Saldo Guaraníes",
GETDATE() as "Fecha Sistema"
from cuenta
where CodVendedor = 10 and CodZona is not null
order by TotalDebitosGS - TotalCreditosGS desc;

select top 20 percent nrocuenta as "Nro.Cuenta", 
razonsocial "Razón Social" , 
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR",
TotalDebitosGS - TotalCreditosGS as "Saldo Guaraníes",
GETDATE() as "Fecha Sistema"
from cuenta
where CodVendedor = 10 and CodZona is not null
order by TotalDebitosGS - TotalCreditosGS desc;

select all nrocuenta as "Nro.Cuenta", 
razonsocial "Razón Social" , 
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR",
TotalDebitosGS - TotalCreditosGS as "Saldo Guaraníes",
GETDATE() as "Fecha Sistema"
from cuenta
where CodVendedor = 10 and CodZona is not null
order by TotalDebitosGS - TotalCreditosGS desc;

select distinct nrocuenta as "Nro.Cuenta", 
razonsocial "Razón Social" , 
nombrecuenta "Nombre Cuenta", 
codigoruc RUC, 
codvendedor "COD VENDEDOR",
TotalDebitosGS - TotalCreditosGS as "Saldo Guaraníes",
GETDATE() as "Fecha Sistema"
from cuenta
where CodVendedor = 10 and CodZona is not null
order by TotalDebitosGS - TotalCreditosGS desc;

select distinct codvendedor from cuenta

select distinct codvendedor, CodZona from cuenta
order by codvendedor, CodZona