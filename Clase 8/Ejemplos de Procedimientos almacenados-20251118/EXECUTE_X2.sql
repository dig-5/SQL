set dateformat dmy;
declare @valorretorno int, @NroTransferencia int;

execute @valorretorno = INSTransferencia 1,
                                         1,
								         2,
                                         1,
								         '16/05/2013',
								         1,
								         1,
								         'Transferencia de Prueba',
								         @NroTransferencia output;

select @valorretorno, @NroTransferencia;


