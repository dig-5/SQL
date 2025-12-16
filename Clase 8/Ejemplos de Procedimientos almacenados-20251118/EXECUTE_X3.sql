select * from agencia;

alter table transferencia disable trigger all;
alter table transferencia with nocheck add constraint fk_agenciaslida foreign key (codagenciasalida) references agencia;

set dateformat dmy;
declare @valorretorno int, @NroTransferencia int;

execute @valorretorno = INSTransferencia @CodAgenciaSalida = 1,
                                         @CodDepositoSalida = 1,
								         @CodAgenciaEntrada = 2,
                                         @CodDepositoEntrada = 1,
								         @FechaTransferencia = '16/05/2013',
								         @Observacion = 'Transferencia de Prueba',
								         @NroTransferencia = @NroTransferencia output;

select @valorretorno, @NroTransferencia;
