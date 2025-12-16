create procedure SLCVentaxMoneda @vFechaInicio date,
                                @vFechaFin date

as

begin

	set dateformat dmy;

	select cuenta.nrocuenta,
	cuenta.razonsocial,
	venta.CodMoneda,
	venta.MontoVenta,
	ventaxmoneda.MontoVentaxMoneda,
	venta.MontoVenta / ventaxmoneda.MontoVentaxMoneda * 100 as porcentaje
	from cuenta as cuenta
	join (select nrocuenta, 
				 codmoneda,
				 sum(montonetoiva) as MontoVenta
			from factura 
		   where fecharendicion between @vFechaInicio and @vFechaFin 
		   group by nrocuenta, 
					codmoneda) as venta
	on cuenta.NroCuenta = venta.NroCuenta
	join (select codmoneda,
				 sum(montonetoiva) as MontoVentaxMoneda
			from factura 
		   where fecharendicion between @vFechaInicio and @vFechaFin 
		   group by codmoneda) as ventaxmoneda
	on venta.CodMoneda = ventaxmoneda.CodMoneda
	order by venta.codmoneda, porcentaje desc;

end;
