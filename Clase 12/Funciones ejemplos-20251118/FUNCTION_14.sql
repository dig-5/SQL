alter function dbo.FNCGeneraMovimientosStock (@nroarticulo int,
                                               @codagencia smallint,
                                               @coddeposito smallint,
                                               @fechainicio date,
                                               @fechafin date)

returns table

as

return (select 'Compra' as TipoOperacion,
               compra.nrocompra as NroComprobante,
               compra.fechacambio as Fecha,
               detallecompra.codagencia,
               detallecompra.coddeposito,
               detallecompra.nroarticulo,
               detallecompra.costooficial,
               detallecompra.cantidadembalada,
               detallecompra.cantidadfraccionada
        from compra join detallecompra
        on compra.nrocompra = detallecompra.nrocompra
        where compra.fechacambio between @fechainicio and @fechafin
        and detallecompra.nroarticulo = @nroarticulo
        and detallecompra.codagencia = @codagencia
        and detallecompra.coddeposito = @coddeposito
 /*       
        union all
        
        select 'Factura' as TipoOperacion,
               factura.nrofactura,
               factura.fechaemision as Fecha,
               detallefactura.codagencia,
               detallefactura.coddeposito,
               detallefactura.nroarticulo,
               detallefactura.costooficial,
               detallefactura.cantidadembalada,
               detallefactura.cantidadfraccionada
        from factura join detallefactura
        on factura.nrofactura = detallefactura.nrofactura
        where factura.fechaemision between @fechainicio and @fechafin
        and detallefactura.nroarticulo = @nroarticulo
        and detallefactura.codagencia = @codagencia
        and detallefactura.coddeposito = @coddeposito
        
        union all
        
        select 'Devolución' as TipoOperacion,
               devolucion.nrodevolucion,
               devolucion.fechacambio as Fecha,
               detalledevolucion.codagencia,
               detalledevolucion.coddeposito,
               detalledevolucion.nroarticulo,
               detalledevolucion.costooficial,
               detalledevolucion.cantidadembalada,
               detalledevolucion.cantidadfraccionada
        from devolucion join detalledevolucion
        on devolucion.nrodevolucion = detalledevolucion.nrodevolucion
        where devolucion.fechacambio between @fechainicio and @fechafin
        and detalledevolucion.nroarticulo = @nroarticulo
        and detalledevolucion.codagencia = @codagencia
        and detalledevolucion.coddeposito = @coddeposito

        union all
        
        select 'Transferencia' as TipoOperacion,
               transferencia.nrotransferencia,
               transferencia.fechatransferencia as Fecha,
               detalletransferencia.codagencia,
               detalletransferencia.coddeposito,
               detalletransferencia.nroarticulo,
               detalletransferencia.costooficial,
               detalletransferencia.cantidadembalada,
               detalletransferencia.cantidadfraccionada
        from transferencia join detalletransferencia
        on transferencia.nrotransferencia = detalletransferencia.nrotransferencia
        where transferencia.fechatransferencia between @fechainicio and @fechafin
        and detalletransferencia.nroarticulo = @nroarticulo
        and detalletransferencia.codagencia = @codagencia
        and detalletransferencia.coddeposito = @coddeposito
*/	   
	   );
	   