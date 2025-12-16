select top 10 * from detalleasiento
order by codempresa, periodo desc, nroasiento desc;

select * from asiento 
where codempresa = 1 and periodo = 201304 and nroasiento = 233;
set dateformat dmy;
update asiento set fechaasiento = '09/04/2013'
where codempresa = 1 and periodo = 201304 and nroasiento = 232;

alter table asiento disable trigger all

update asiento set estado = 'N'
where codempresa = 1 and periodo = 201304 and nroasiento = 232;

alter table detalleasiento disable trigger all;
alter table cuentamonedahistorico disable trigger all;
alter table detalleasiento enable trigger tida_detalleasiento;
select * from cuentacontable where codempresa =  1 and nrocuenta = '301';
select * from cotizacioncontable where FechaCotizacion = '06/06/2013';


insert into detalleasiento
values (1, --CodEmpresa  
        201304, --Periodo
		232, --NroAsiento  
		4, --NroMovimiento 
		'30106', --NroCuenta            
		9999, --CodAgencia 
		9999, --CodCentroCosto 
		9999, --CodCentroCosto_2 
		1, --CodMoneda 
		5001, --CodTipoComprobante 
		null, --TipoIVA 
		null, --TipoImpuestoRenta 
		'Asiento de Prueba', --DescripcionAsiento
		'10010000001', --NroComprobante      
		0, --DebitoMonedaNac       
		0, --CreditoMonedaNac      
		1250000, --DebitoMoneda          
		0, --CreditoMoneda         
		0, --MontoCambioMoneda     
		0 --MontoCambioBase
		);


