EXECUTE SLCCuentaXOrden @NroCuenta = NULL,
                        @TipoOrden = 'N';

EXECUTE SLCCuentaXOrden @NroCuenta = NULL,
                        @TipoOrden = 'R';

EXECUTE SLCCuentaXOrden NULL, 'R';

EXECUTE SLCCuentaXOrden;

EXECUTE SLCCuentaXOrden @TipoOrden = 'R',
						@NroCuenta = NULL;

EXECUTE SLCCuentaXOrden @TipoOrden = 'R';

