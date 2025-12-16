insert into agenciadeposito (NroAgencia, 
							 NroDeposito, 
							 DesDeposito)
values (6, 1, 'Depósito Central'),
       (6, 2, 'Depósito de Averiados'),
       (6, 3, 'Depósito de Vencidos'),
       (7, 1, 'Depósito de Central CDE'),
       (7, 2, 'Depósito de Averiados CDE'),
       (7, 3, 'Depósito de Vencidos CDE'),
       (8, 1, 'Depósito de Central CO'),
       (8, 2, 'Depósito de Averiados CO');

select * from AgenciaDeposito;

insert into agenciadeposito (NroAgencia, 
							 NroDeposito, 
							 DesDeposito)
default values;
