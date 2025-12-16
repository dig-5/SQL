create function dbo.FNCPeriodoAnhoMes (@Fecha datetime)

returns int

as

begin

    declare @Periodo int;

-- Obtiene el Período medido en Año y Mes

    select @Periodo = year(@Fecha) * 100 + month(@Fecha);

	return @Periodo;

end;
