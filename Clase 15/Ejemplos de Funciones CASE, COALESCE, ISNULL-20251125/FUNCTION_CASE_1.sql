
select persona.*, alumno.*,
       case when dbo.GetEstadoAlumno (alumno.AlumnoNro, getdate()) = 'S' then 'Alumno Habilitado'
	        when dbo.GetEstadoAlumno (alumno.AlumnoNro, getdate()) = 'N' then 'Alumno No Habilitado'
			else 'Alumno con Estado Indefinido'
	   end as EstadoAlumno
from alumno join persona on alumno.AlumnoNro = persona.PersonaNro
order by Alumno.AlumnoNro;

select persona.*, alumno.*
from alumno join persona on alumno.AlumnoNro = persona.PersonaNro
where dbo.GetEstadoAlumno (alumno.AlumnoNro, getdate()) = 'N' 
order by Alumno.AlumnoNro;
