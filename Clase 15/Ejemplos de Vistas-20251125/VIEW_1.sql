--Vistas

create view DatosSistema (FechaHoraSistema, EstacionTrabajo, Usuario, NombreAplicacion)
as 
select getdate(), HOST_NAME(), SUSER_NAME(), APP_NAME();

select * from DatosSistema;


create view v_Facturas (NroFactura, NroPedido, NroCuenta, CodVendedor,
						IndiceComision, CodDivision, CodAgencia, CodDeposito,
						CodMoneda, FechaCambio, CambioMonto, FechaEmision,
						FechaRendicion, CondicPagoEmision, CondicPagoRendicion,
						PorcDescuento, PorcDescCanal, PorcDescDeposito,
						TipoFactura, TipoPrecio, NumeroReparto, NroCamion, NroPersonal,
						IncluyeRecargo, NroArticulo,
						CMD, CMDPromedio, CODUltimo, CODPromedio, CostoOficial, PMD,
						Unidad, PorcFraccionado, PorcDescEscala, CodRegimen,
						PorcentajeRegimen, CantidadEmbalada, CantidadFraccionada,
						Cantidad, ExistAnterior, PrecioMoneda, PrecioNeto, MontoTotal,
						MontoIVA, MontoNetoIva, MontoCostoVentaCMD, MontoCostoVentaCMDPromedio,
						MontoCostoVentaOfi, MontoContribucionBruta, MontoContribucionNeta,
						MontoComision, MontoInteres, MontoDescuento, MontoRecargo,
						RazonSocial, NombreCuenta, DireccionCuenta, CodRamo, CodZona, CodCobrador, 
						CodigoRuc, DescripcionArticulo, CodMarca, CodLinea, CodTipo, CodProveedor)
as 
select F.NroFactura, F.NroPedido, F.NroCuenta, F.CodVendedor,
	   F.IndiceComision, F.CodDivision, F.CodAgencia, F.CodDeposito,
	   F.CodMoneda, F.FechaCambio, F.CambioMonto, F.FechaEmision,
	   F.FechaRendicion, F.CondicPagoEmision, F.CondicPagoRendicion,
	   F.PorcDescuento, F.PorcDescCanal, F.PorcDescDeposito,
	   F.TipoFactura, F.TipoPrecio, F.NumeroReparto, F.NroCamion, F.NroPersonal,
	   F.IncluyeRecargo, DF.NroArticulo,
	   DF.CMD, DF.CMDPromedio, DF.CODUltimo, DF.CODPromedio, DF.CostoOficial, DF.PMD,
	   DF.Unidad, DF.PorcFraccionado, DF.PorcDescEscala, DF.CodRegimen,
	   DF.PorcentajeRegimen, DF.CantidadEmbalada, DF.CantidadFraccionada,
	   DF.Cantidad, DF.ExistAnterior, DF.PrecioMoneda, DF.PrecioNeto, DF.MontoTotal,
	   DF.MontoIVA, DF.MontoNetoIva, DF.MontoCostoVentaCMD, DF.MontoCostoVentaCMDPromedio,
	   DF.MontoCostoVentaOfi, DF.MontoContribucionBruta, DF.MontoContribucionNeta,
	   DF.MontoComision, DF.MontoInteres, DF.MontoDescuento, DF.MontoRecargo,
	   C.RazonSocial, C.NombreCuenta, C.DireccionCuenta, C.CodRamo, C.CodZona, C.CodCobrador, 
	   C.CodigoRuc, A.DescripcionArticulo, A.CodMarca, A.CodLinea, A.CodTipo, A.CodProveedor
from Factura F join DetalleFactura DF on F.NroFactura = DF.NroFactura
join Cuenta C on F.NroCuenta = C.NroCuenta
join Articulo A on DF.NroArticulo = A.NroArticulo;
