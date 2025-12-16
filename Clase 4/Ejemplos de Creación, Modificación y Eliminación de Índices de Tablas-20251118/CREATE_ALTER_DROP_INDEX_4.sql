create index IDX_Articulo_ListaPrecio on ListaPrecioArticulo (NroArticulo)
with (pad_index = on,
      fillfactor = 50,
      sort_in_tempdb = on,
	  STATISTICS_NORECOMPUTE = OFF,
	  ONLINE = ON, 
	  ALLOW_ROW_LOCKS = ON,
	  ALLOW_PAGE_LOCKS = ON,
	  MAXDOP = 2);
	  