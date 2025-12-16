CREATE TABLE [dbo].[AuditoriaAsiento](
    [ID] bigint not null PRIMARY KEY,
	[CodEmpresa] [int] NOT NULL,
	[Periodo] [int] NOT NULL,
	[NroAsiento] [int] NOT NULL,
	[FechaAsiento] [datetime] NOT NULL,
	[AsientoRenumerado] [int] NULL,
	[NroEmision] [char](15) NULL,
	[TotalDebito] [money] NULL,
	[TotalCredito] [money] NULL,
	[Estado] [char](1) NOT NULL,
	[CodEmpresaOrigen] [int] NOT NULL,
	[Id_Opr_Ing] [varchar](20) NULL,
	[Fechor_Ing] [datetime] NULL,
	[Id_Opr_Mod] [varchar](20) NULL,
	[Fechor_Mod] [datetime] NULL,
	[Id_Opr_Aut] [varchar](20) NULL,
	[Fechor_Aut] [datetime] NULL,
	[TipoOperacion] varchar(2) NOT NULL,
	[Usuario] varchar(255) NOT NULL,
    [Momento] datetime NOT NULL,
	[Equipo] varchar(255) NOT NULL)

CREATE SEQUENCE SEQ_AUDITORIAASIENTO
AS BIGINT
START WITH 1
INCREMENT BY 1
NO CYCLE;

select *, 
' ' as TipoOperacion,
suser_sname() as Usuario, 
getdate () as Momento, 
host_name () as EstacionTrabajo 
into AuditoriaAsiento
from asiento 
where codempresa = 99;

select * from auditoriaasiento;

alter table AuditoriaAsiento
add ID_AuditoriaAsiento bigint not null identity (1, 1) primary key;

alter table asiento disable trigger all;
alter table asiento enable trigger TIUD_Asiento;
