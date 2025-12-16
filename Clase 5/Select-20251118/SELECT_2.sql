select nroagencia "Código de Agencia",
NroDeposito "Código de Depósito",
desdeposito as "Descripción del Depósito" 
from AgenciaDeposito

select * from MonedaCotizacion

select NroMoneda "Nro. de Moneda",
 Fechacotizacion Fecha ,
montocambiovendedor / montocambiocomprador as Porcentaje,
 GETDATE() "Fecha/Hora del Sistema" ,
null as "Columna con Valor Nulo"
from MonedaCotizacion;

select host_name() as "Nombre PC",
getdate() as "Fecha/Hora del Sistema",
suser_sname() as "Nombre de Usuario";

select * from MonedaCotizacion
order by MontoCambioVendedor desc, FechaCotizacion;

select top 2 * from MonedaCotizacion;

select top 60 percent * from MonedaCotizacion;

select all nromoneda, MontoCambioComprador, MontoCambioVendedor
from MonedaCotizacion;

select all top 2 nromoneda, MontoCambioComprador, MontoCambioVendedor
from MonedaCotizacion;

select all nromoneda
from MonedaCotizacion;

select distinct nromoneda
from MonedaCotizacion;

select all nromoneda, MontoCambioComprador, MontoCambioVendedor
from MonedaCotizacion;

select distinct nromoneda, MontoCambioComprador, MontoCambioVendedor
from MonedaCotizacion;

select distinct nromoneda, MontoCambioComprador, MontoCambioVendedor
from MonedaCotizacion
order by nromoneda, MontoCambioVendedor desc;
