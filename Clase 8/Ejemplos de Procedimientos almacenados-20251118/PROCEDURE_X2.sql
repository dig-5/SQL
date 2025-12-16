create procedure SLCVentaxMoneda;2 @vFechaInicio date,
                                   @vFechaFin date,
								   @vTipoConsulta char(1) = 'P'

as

begin

	set dateformat dmy;

	if  @vTipoConsulta = 'P' 
    begin
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
		order by venta.codmoneda, porcentaje desc
	end
	else
	begin
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
		order by porcentaje desc, venta.codmoneda;
	end;

end;
