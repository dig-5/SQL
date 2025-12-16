set dateformat dmy
select Articulo.NroArticulo, Articulo.DescripcionArticulo,
       FNCGeneraMovimientosStock.*
from articulo join dbo.FNCGeneraMovimientosStockMSTV (99139,
                                                  1,
                                                  10,
                                                  '01/01/2012',
                                                  '31/12/2012')
                  as FNCGeneraMovimientosStock
on Articulo.NroArticulo = FNCGeneraMovimientosStock.NroArticulo
where Articulo.NroArticulo = 99139
--order by FNCGeneraMovimientosStock.fecha, FNCGeneraMovimientosStock.tipooperacion, FNCGeneraMovimientosStock.nrocomprobante;
