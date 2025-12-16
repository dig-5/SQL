set dateformat dmy
select Articulo.NroArticulo, Articulo.DescripcionArticulo,
       FNCGeneraMovimientosStock.*
from articulo join dbo.FNCGeneraMovimientosStock (99139,
                                                  1,
                                                  10,
                                                  '01/01/2012',
                                                  '31/12/2012')
                  as FNCGeneraMovimientosStock
on Articulo.NroArticulo = FNCGeneraMovimientosStock.NroArticulo
where Articulo.NroArticulo = 99139
and FNCGeneraMovimientosStock.TipoOperacion = 'Compra'
order by FNCGeneraMovimientosStock.fecha, FNCGeneraMovimientosStock.tipooperacion, FNCGeneraMovimientosStock.nrocomprobante;

select * from detallecompra 
order by nroarticulo desc


select * from DetalleCompra order by NroArticulo desc


