set dateformat dmy

select * from v_Facturas
where fecharendicion between '01/01/2012' and '31/12/2012'
order  by v_facturas.nrofactura;
