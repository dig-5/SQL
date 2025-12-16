select getdate();

select year(getdate()) * 100 + month(getdate()) as periodo;

select * from factura
where year(fecharendicion) * 100 + month(fecharendicion) = 
      year(getdate()) * 100 + month(getdate());

update factura set fecharendicion = getdate()
where year(fecharendicion) * 100 + month(fecharendicion) = 
      year(getdate()) * 100 + month(getdate());

set dateformat dmy;
select dbo.FNCPeriodoAnhoMes(fecharendicion) as periodo,
factura.* from factura
where dbo.FNCPeriodoAnhoMes(fecharendicion) >= dbo.FNCPeriodoAnhoMes('31/01/2011')
order by dbo.FNCPeriodoAnhoMes(fecharendicion);
