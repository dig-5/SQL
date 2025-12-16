CREATE VIEW v_Zona_Ciudad (CodCiudad,
						   CodPais,
						   Ciudad,
						   CodZona,
						   CodCiudadZona,
						   Zona,
						   CostoReparto)
AS 
SELECT c.*,
       z.*
FROM Ciudad c JOIN Zona z ON c.CodCiudad = z.CodCiudad;
