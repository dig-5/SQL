USE [Comercial]
GO

/****** Object:  DdlTrigger [DDL_Datamex]    Script Date: 15/12/2012 02:59:44 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


alter trigger [DDL_Datamex] on database

for ddl_database_level_events

as

begin

declare @xml xml;

select @xml = eventdata();

insert into dbo.ddl_log (MomentoAuditoria, Usuario, EstacionTrabajo, Evento)
select getdate(), suser_sname(), host_name(), @xml;


end;


GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

ENABLE TRIGGER [DDL_Datamex] ON DATABASE
GO


