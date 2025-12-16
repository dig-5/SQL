SET DATEFORMAT DMY;

SELECT A.NroArticulo,
A.DescripcionArticulo,
ExtractoArticulo.*
FROM Articulo A JOIN dbo.FNCGeneraExtractoArticulo (18755,
													1,
													10,
													'01/01/2011',
													'31/12/2011') AS ExtractoArticulo
ON A.NroArticulo = ExtractoArticulo.NroArticulo
--WHERE A.nroArticulo = 15009;
