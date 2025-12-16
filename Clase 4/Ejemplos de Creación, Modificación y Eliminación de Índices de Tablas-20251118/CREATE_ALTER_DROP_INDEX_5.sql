alter index IDX_Articulo_ListaPrecio
on LIstaPrecioArticulo
disable;

alter index all
on ListaPrecioArticulo
disable;

alter index all
on ListaPrecioArticulo
rebuild;

alter index IDX_Articulo_ListaPrecio
on ListaPrecioArticulo
rebuild;

alter index IDX_Articulo_ListaPrecio 
on ListaPrecioArticulo 
rebuild 
with (pad_index = off,
      fillfactor = 75,
      sort_in_tempdb = off,
	  STATISTICS_NORECOMPUTE = on,
	  ALLOW_ROW_LOCKS = off,
	  ALLOW_PAGE_LOCKS = off,
	  MAXDOP = 4);

alter index IDX_Articulo_ListaPrecio 
on ListaPrecioArticulo 
set (ALLOW_PAGE_LOCKS = on);

alter index IDX_Articulo_ListaPrecio 
on ListaPrecioArticulo 
reorganize;

drop index ListaPrecioArticulo.IDX_Articulo_ListaPrecio;
