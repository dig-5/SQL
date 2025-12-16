create clustered index IDX_NroArticulo_Stock on Stock (NroArticulo)


create nonclustered index IDX_ProveedorLote_Stock on Stock (NroProveedor, NroLote)


create unique nonclustered index IDX_FechasVigencia on ListaPrecio (FechaInicioVigencia asc, FechaFinVigencia asc)


create index IDX_Articulo on Articulo (DesArticulo)
include (NroArticulo, NroProveedor, NroMarca, NroTipoArticulo, NroTipoImpuesto);


