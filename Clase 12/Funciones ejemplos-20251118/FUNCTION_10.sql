create function dbo.GetEstadoAlumno (@NroAlumno int,
									 @FechaExamen datetime)

returns char(1)

as

begin

	declare @estado char(1) = 'S';

-- Verifica si el Alumno tiene cuotas pendientes de cobro en base a la fecha de vencimiento 

	if  exists (select * from inscripcioncurso ic 
	            join inscripcioncursocuota icc
				on ic.inscripcionnro = icc.InscripcionNro
				where ic.AlumnoNro = @NroAlumno
				and icc.FechaVencimiento <= @FechaExamen
				and icc.ImporteCuota > icc.ImporteCobrado)
	begin
		select @estado = 'N';
	end;

	return @estado;

end;
