select distinct fechacambio from Pedido order by FechaCambio;

alter table DetallePedido disable trigger all

update DetallePedido
set CMD = Articulo.CMDUltimo,
    CMDPromedio = Articulo.CMDPromedio,
	CODUltimo = Articulo.CODUltimo,
	CODPromedio = Articulo.CODPromedio,
	CostoOficial = Articulo.CostoOfPromedio,
	codregimen = Articulo.CodRegimen,
	PorcentajeRegimen = Regimen.PorcentajeIVA,
	IndiceComision = AgenciaDepositoArticulo.IndiceComision
from DetallePedido join Articulo on DetallePedido.NroArticulo = Articulo.NroArticulo
                   join Regimen on Articulo.CodRegimen = Regimen.CodRegimen
                   join AgenciaDepositoArticulo on DetallePedido.CodAgencia = AgenciaDepositoArticulo.CodAgencia
                                               and DetallePedido.CodDeposito = AgenciaDepositoArticulo.CodDeposito
                                               and DetallePedido.NroArticulo = AgenciaDepositoArticulo.NroArticulo;

set dateformat dmy
update DetallePedido
set CMD = Articulo.CMDUltimo,
    CMDPromedio = Articulo.CMDPromedio,
	CODUltimo = Articulo.CODUltimo,
	CODPromedio = Articulo.CODPromedio,
	CostoOficial = Articulo.CostoOfPromedio,
	codregimen = Articulo.CodRegimen,
	PorcentajeRegimen = Regimen.PorcentajeIVA,
	IndiceComision = AgenciaDepositoArticulo.IndiceComision
from DetallePedido join Articulo on DetallePedido.NroArticulo = Articulo.NroArticulo
                   join Regimen on Articulo.CodRegimen = Regimen.CodRegimen
                   join AgenciaDepositoArticulo on DetallePedido.CodAgencia = AgenciaDepositoArticulo.CodAgencia
                                               and DetallePedido.CodDeposito = AgenciaDepositoArticulo.CodDeposito
                                               and DetallePedido.NroArticulo = AgenciaDepositoArticulo.NroArticulo
					join Pedido on DetallePedido.NroPedido = Pedido.NroPedido
where FechaCambio between '27/01/2010' and '31/01/2010';
