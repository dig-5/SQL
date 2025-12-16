select * from agenciadeposito

update AgenciaDeposito 
set DesDeposito = REPLACE (DesDeposito, 'vencidos', 'por vencer')

update AgenciaDeposito 
set DesDeposito = REPLACE (DesDeposito, 'de por', 'por')

update AgenciaDeposito 
set DesDeposito = REPLACE (DesDeposito, 'Depósito', 'Depósito de Mercaderías'),
    NroDeposito = NroDeposito * 10

update AgenciaDeposito 
set DesDeposito = REPLACE (DesDeposito, 'Depósito', 'Depósito de Mercaderías'),
    NroDeposito = NroDeposito * 10
where NroAgencia = 6;

update AgenciaDeposito 
set DesDeposito = REPLACE (DesDeposito, 'Depósito', 'Depósito de Mercaderías'),
    NroDeposito = NroDeposito * 10
where not NroAgencia = 1;

update AgenciaDeposito 
set DesDeposito = REPLACE (DesDeposito, 'Depósito', 'Depósito de Mercaderías'),
    NroDeposito = NroDeposito * 10
where NroAgencia = 6 or NroAgencia = 7;

select * from AgenciaDeposito

update Agencia set DirAgencia = null;
update Agencia set DirAgencia = DEFAULT;
