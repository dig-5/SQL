SET DATEFORMAT DMY;

SELECT Articulo.NroArticulo,
Articulo.DescripcionArticulo,
dbo.FNCObtieneCantidadVendida (-1, -1, Articulo.NroArticulo, '01/01/2012', '31/12/2012') AS CantidadVendida
FROM Articulo
ORDER BY 3 DESC;
