alter trigger T_DDL_Table_View on database

for ddl_table_view_events

as

begin

	declare @xml xml;

	select @xml = eventdata();

	if USER_NAME() <> 'dbo'
	begin
		raiserror ('> Imposible crear, modificar o eliminar tablas y vistas...', 16, 1);
		rollback transaction;
	end;

	select 'Tipo de Evento: ' + @xml.value('(/EVENT_INSTANCE/EventType)[1]','nvarchar(max)') +
	       ' Comando SQL : ' + @xml.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)');

end
