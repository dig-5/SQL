create index IDX_Articulo on Articulo (DesArticulo)
include (NroArticulo, NroProveedor, NroMarca, NroTipoArticulo, NroTipoImpuesto);

create index IDX_Articulo on Articulo (DesArticulo)
with (drop_existing = on);

create index IDX_Articulo on Articulo (DesArticulo, NroArticulo)
with (drop_existing = on);
