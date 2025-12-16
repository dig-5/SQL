alter trigger tida_DetalleAsiento on DetalleAsiento for insert

as

begin

    declare @verrno int, @verrmsg varchar(255);

	begin try

-- Verifica que el asiento de los detalles insertados tenga estado = 'A'

	if  exists (select * from inserted 
	                      join asiento 
	                        on inserted.CodEmpresa = Asiento.CodEmpresa
						   and inserted.Periodo = Asiento.Periodo
						   and inserted.NroAsiento = Asiento.NroAsiento
	             where Asiento.Estado <> 'A')
	begin
	    select @verrno = 50000,
		       @verrmsg = '> Asientos con Estado no Abierto ...';
		raiserror (@verrmsg, 16, 1);
	end;

-- Verifica que la Cuenta Contable sea Asentable

	if  exists (select * from inserted 
	                      join CuentaContable
	                        on inserted.CodEmpresa = CuentaContable.CodEmpresa
						   and inserted.NroCuenta = CuentaContable.NroCuenta
	             where CuentaContable.Asentable <> 'S')
	begin
	    select @verrno = 50001,
		       @verrmsg = '> Cuenta Contable No Asentable ...';
		raiserror (@verrmsg, 16, 1);
	end;

-- Verifica la existencia de la Cotización Contable por medio de CodEmpresa, CodMoneda, FechaAsiento 

	if  exists (select * from inserted 
	                      join asiento 
	                        on inserted.CodEmpresa = Asiento.CodEmpresa
						   and inserted.Periodo = Asiento.Periodo
						   and inserted.NroAsiento = Asiento.NroAsiento
	             where inserted.CodEmpresa not in 
				 (select CodEmpresa from CotizacionContable
				   where inserted.CodEmpresa = CotizacionContable.CodEmpresa
				     and inserted.CodMoneda = CotizacionContable.CodMoneda
					 and Asiento.FechaAsiento = CotizacionContable.FechaCotizacion))
	begin
	    select @verrno = 50002,
		       @verrmsg = '> No existe Cotización Contable ...';
		raiserror (@verrmsg, 16, 1);
	end;

-- Verifica que el código de tipo de comprobante y el número de comprobante no se repitan en diversos asientos
/*
	if  exists (select *
				  from detalleasiento join inserted
				    on detalleasiento.CodTipoComprobante = inserted.CodTipoComprobante
				   and detalleasiento.NroComprobante = inserted.NroComprobante
				 where DetalleAsiento.CodEmpresa 
				    in (select CodEmpresa from DetalleAsiento da
				         where da.CodEmpresa = DetalleAsiento.CodEmpresa
						   and da.Periodo = DetalleAsiento.Periodo
						   and da.NroAsiento = DetalleAsiento.NroAsiento
						   and da.CodTipoComprobante = detalleasiento.CodTipoComprobante
				           and da.NroComprobante = detalleasiento.NroComprobante
                           and (da.CodEmpresa <> inserted.CodEmpresa
						    or  da.Periodo <> inserted.Periodo
                            or  da.NroAsiento <> inserted.NroAsiento))
*/

	if  exists (select detalleasiento.CodTipoComprobante,
	                   detalleasiento.NroComprobante
				  from detalleasiento join inserted
				    on detalleasiento.CodTipoComprobante = inserted.CodTipoComprobante
				   and detalleasiento.NroComprobante = inserted.NroComprobante
				 group by detalleasiento.CodTipoComprobante,
	                      detalleasiento.NroComprobante
				having count(distinct convert(varchar(5), detalleasiento.CodEmpresa ) + ' ' +
				                      convert(varchar(10), detalleasiento.Periodo) + ' ' +
									  convert(varchar(10), detalleasiento.NroAsiento)) > 1) 
	begin
	    select @verrno = 50003,
		       @verrmsg = '> Código de Tipo de Comprobante y Nro. de Comprobante repetidos ...';
		raiserror (@verrmsg, 16, 1);
	end;

-- Verifica que las columnas DebitoMonedaNac y CreditoMonedaNac tengan valores iguales a cero

	if  exists (select *
				  from inserted
				  where DebitoMonedaNac <> 0
				     or CreditoMonedaNac <> 0) 
	begin
	    select @verrno = 50004,
		       @verrmsg = '> Débitos y Créditos en Moneda Nacional debe ser iguales a cero  ...';
		raiserror (@verrmsg, 16, 1);
	end;

-- Verifica que si DebitoMoneda es mayor cero, CreditoMOneda sea igual a cero y vice-versa

	if  exists (select *
				  from inserted
				  where (DebitoMoneda = 0 and CreditoMoneda = 0)
				     or (DebitoMoneda > 0 and CreditoMoneda > 0)) 
	begin
	    select @verrno = 50005,
		       @verrmsg = '> Si el Débito es mayor a cero, entonces el Crédito debe ser igual a cero y vice-versa ...';
		raiserror (@verrmsg, 16, 1);
	end;

-- Actualiza la Cotización de la Moneda de los detalles de asientos y calcula los Débitos y Créditos en Moneda Nacional

    update detalleasiento set montocambiomoneda = CotizacionContable.MontoCambio,
	                          DebitoMonedaNac = DetalleAsiento.DebitoMoneda * CotizacionContable.MontoCambio,
	                          CreditoMonedaNac = DetalleAsiento.CreditoMoneda * CotizacionContable.MontoCambio
	from detalleasiento join Asiento on detalleasiento.CodEmpresa = Asiento.CodEmpresa
	                                and detalleasiento.Periodo = Asiento.Periodo
									and detalleasiento.NroAsiento = Asiento.NroAsiento
	join CotizacionContable on detalleasiento.CodEmpresa = CotizacionContable.CodEmpresa
				           and detalleasiento.CodMoneda = CotizacionContable.CodMoneda
					       and Asiento.FechaAsiento = CotizacionContable.FechaCotizacion
    join inserted on detalleasiento.CodEmpresa = inserted.CodEmpresa
                 and detalleasiento.Periodo = inserted.Periodo
				 and detalleasiento.NroAsiento = inserted.NroAsiento
				 and detalleasiento.NroMovimiento = inserted.NroMovimiento;

-- Inserta las filas inexistentes en CuentaMonedaHistorico

    insert into CuentaMonedaHistorico
	select distinct inserted.codempresa,
	                inserted.codagencia,
					inserted.codcentrocosto,
					inserted.codcentrocosto_2,
					inserted.codmoneda,
					inserted.nrocuenta,
					inserted.periodo,
					0, 0, 0, 0
    from inserted
	where not exists (select * from CuentaMonedaHistorico
	                   where CuentaMonedaHistorico.CodEmpresa = inserted.CodEmpresa
					     and CuentaMonedaHistorico.CodAgencia = inserted.CodAgencia
					     and CuentaMonedaHistorico.CodCentroCosto = inserted.CodCentroCosto
					     and CuentaMonedaHistorico.CodCentroCosto_2 = inserted.CodCentroCosto_2
					     and CuentaMonedaHistorico.CodMoneda = inserted.CodMoneda
					     and CuentaMonedaHistorico.NroCuenta = inserted.NroCuenta
					     and CuentaMonedaHistorico.Periodo = inserted.Periodo);

-- Actualiza CuentaMonedaHistorico sumando los Débitos y Créditos

	update CuentaMonedaHistorico set 
	DebitoMonedaNac = CuentaMonedaHistorico.DebitoMonedaNac + 
	                 (select sum(detalleasiento.DebitoMonedaNac)
					    from DetalleAsiento
					   where CuentaMonedaHistorico.CodEmpresa = detalleasiento.CodEmpresa
	                     and CuentaMonedaHistorico.CodAgencia = detalleasiento.CodAgencia
						 and CuentaMonedaHistorico.CodCentroCosto = detalleasiento.CodCentroCosto
						 and CuentaMonedaHistorico.CodCentroCosto_2 = detalleasiento.CodCentroCosto_2
						 and CuentaMonedaHistorico.CodMoneda = detalleasiento.CodMoneda
						 and CuentaMonedaHistorico.NroCuenta = detalleasiento.NroCuenta
						 and CuentaMonedaHistorico.Periodo = detalleasiento.Periodo
                         and detalleasiento.CodEmpresa = inserted.CodEmpresa
						 and detalleasiento.Periodo = inserted.Periodo
						 and detalleasiento.NroAsiento = inserted.NroAsiento
						 and detalleasiento.NroMovimiento = inserted.NroMovimiento),

	CreditoMonedaNac = CuentaMonedaHistorico.CreditoMonedaNac + 	                
	                  (select sum(detalleasiento.CreditoMonedaNac)
					    from DetalleAsiento
					   where CuentaMonedaHistorico.CodEmpresa = detalleasiento.CodEmpresa
	                     and CuentaMonedaHistorico.CodAgencia = detalleasiento.CodAgencia
						 and CuentaMonedaHistorico.CodCentroCosto = detalleasiento.CodCentroCosto
						 and CuentaMonedaHistorico.CodCentroCosto_2 = detalleasiento.CodCentroCosto_2
						 and CuentaMonedaHistorico.CodMoneda = detalleasiento.CodMoneda
						 and CuentaMonedaHistorico.NroCuenta = detalleasiento.NroCuenta
						 and CuentaMonedaHistorico.Periodo = detalleasiento.Periodo
                         and detalleasiento.CodEmpresa = inserted.CodEmpresa
						 and detalleasiento.Periodo = inserted.Periodo
						 and detalleasiento.NroAsiento = inserted.NroAsiento
						 and detalleasiento.NroMovimiento = inserted.NroMovimiento),

	DebitoMoneda = CuentaMonedaHistorico.DebitoMoneda + 
	                  (select sum(detalleasiento.DebitoMoneda)
					    from DetalleAsiento
					   where CuentaMonedaHistorico.CodEmpresa = detalleasiento.CodEmpresa
	                     and CuentaMonedaHistorico.CodAgencia = detalleasiento.CodAgencia
						 and CuentaMonedaHistorico.CodCentroCosto = detalleasiento.CodCentroCosto
						 and CuentaMonedaHistorico.CodCentroCosto_2 = detalleasiento.CodCentroCosto_2
						 and CuentaMonedaHistorico.CodMoneda = detalleasiento.CodMoneda
						 and CuentaMonedaHistorico.NroCuenta = detalleasiento.NroCuenta
						 and CuentaMonedaHistorico.Periodo = detalleasiento.Periodo
                         and detalleasiento.CodEmpresa = inserted.CodEmpresa
						 and detalleasiento.Periodo = inserted.Periodo
						 and detalleasiento.NroAsiento = inserted.NroAsiento
						 and detalleasiento.NroMovimiento = inserted.NroMovimiento),

	CreditoMoneda = CuentaMonedaHistorico.CreditoMoneda +  
	                  (select sum(detalleasiento.CreditoMoneda)
					    from DetalleAsiento
					   where CuentaMonedaHistorico.CodEmpresa = detalleasiento.CodEmpresa
	                     and CuentaMonedaHistorico.CodAgencia = detalleasiento.CodAgencia
						 and CuentaMonedaHistorico.CodCentroCosto = detalleasiento.CodCentroCosto
						 and CuentaMonedaHistorico.CodCentroCosto_2 = detalleasiento.CodCentroCosto_2
						 and CuentaMonedaHistorico.CodMoneda = detalleasiento.CodMoneda
						 and CuentaMonedaHistorico.NroCuenta = detalleasiento.NroCuenta
						 and CuentaMonedaHistorico.Periodo = detalleasiento.Periodo
                         and detalleasiento.CodEmpresa = inserted.CodEmpresa
						 and detalleasiento.Periodo = inserted.Periodo
						 and detalleasiento.NroAsiento = inserted.NroAsiento
						 and detalleasiento.NroMovimiento = inserted.NroMovimiento)
    from CuentaMonedaHistorico 
	join detalleasiento 
	on CuentaMonedaHistorico.CodEmpresa = detalleasiento.CodEmpresa
	and CuentaMonedaHistorico.CodAgencia = detalleasiento.CodAgencia
	and CuentaMonedaHistorico.CodCentroCosto = detalleasiento.CodCentroCosto
    and CuentaMonedaHistorico.CodCentroCosto_2 = detalleasiento.CodCentroCosto_2
	and CuentaMonedaHistorico.CodMoneda = detalleasiento.CodMoneda
	and CuentaMonedaHistorico.NroCuenta = detalleasiento.NroCuenta
	and CuentaMonedaHistorico.Periodo = detalleasiento.Periodo
    join inserted 
	on detalleasiento.CodEmpresa = inserted.CodEmpresa
    and detalleasiento.Periodo = inserted.Periodo
	and detalleasiento.NroAsiento = inserted.NroAsiento
	and detalleasiento.NroMovimiento = inserted.NroMovimiento;

    return;

	end try

	begin catch

	    if  @verrno is null
		    select @verrno = ERROR_NUMBER(),
			       @verrmsg = ERROR_MESSAGE();

		raiserror (@verrmsg, 16, 1);

		rollback transaction;

	end catch

end;
