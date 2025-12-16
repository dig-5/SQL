create function dbo.ObtieneInscripcionCurso (@FechaInicio datetime,
					     @FecchaFin datetime)

returns table

return (select i.InscripcionNro,
			   i.PersonaNro,
			   i.PersonaFactura,
			   i.FechaIncripcion,
			   i.SedeNro,
			   i.CajeroNro,
			   i.FacturaNro,
			   i.Estado,
			   ic.AlumnoNro,
			   ic.CursoNro,
			   ic.EsquemaNro,
			   'Inscripción sin Beca ni Descuento' as TipoInscripcion,
			   null as BecaNro,
			   null as PorcentajeDescuento,
			   null as MotivoDescuento,
			   null as FechaVigencia,
			   null as FechaAutorizacion
         from inscripcion i join inscripcioncurso ic
		 on i.inscripcionnro = ic.inscripcionnro
		 where i.fechaincripcion between @FechaInicio and @FecchaFin
		 and i.inscripcionnro not in (select inscripcionnro from inscripcioncursobeca)
		 and  i.inscripcionnro not in (select inscripcionnro from inscripciocursodescuento)

		union all

		select i.InscripcionNro,
			   i.PersonaNro,
			   i.PersonaFactura,
			   i.FechaIncripcion,
			   i.SedeNro,
			   i.CajeroNro,
			   i.FacturaNro,
			   i.Estado,
			   ic.AlumnoNro,
			   ic.CursoNro,
			   ic.EsquemaNro,
			   'Inscripción con Beca y sin Descuento',
			   icb.becanro as BecaNro,
			   null as PorcentajeDescuento,
			   null as MotivoDescuento,
			   null as FechaVigencia,
			   null as FechaAutorizacion
         from inscripcion i join inscripcioncurso ic
		 on i.inscripcionnro = ic.inscripcionnro
		 join inscripcioncursobeca icb 
		 on i.inscripcionnro = icb.inscripcionnro
		 where i.fechaincripcion between @FechaInicio and @FecchaFin

		union all

		select i.InscripcionNro,
			   i.PersonaNro,
			   i.PersonaFactura,
			   i.FechaIncripcion,
			   i.SedeNro,
			   i.CajeroNro,
			   i.FacturaNro,
			   i.Estado,
			   ic.AlumnoNro,
			   ic.CursoNro,
			   ic.EsquemaNro,
			   'Inscripción sin Beca y con Descuento',
			   null as BecaNro,
			   icd.PorcentajeDescuento as PorcentajeDescuento,
			   icd.MotivoDescuento as MotivoDescuento,
			   icd.FechaVigencia as FechaVigencia,
			   icd.FechaAutorizacion as FechaAutorizacion
         from inscripcion i join inscripcioncurso ic
		 on i.inscripcionnro = ic.inscripcionnro
		 join inscripciocursodescuento icd
		 on i.inscripcionnro = icd.inscripcionnro
		 where i.fechaincripcion between @FechaInicio and @FecchaFin

		);
