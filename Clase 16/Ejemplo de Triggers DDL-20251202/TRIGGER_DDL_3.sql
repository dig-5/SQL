create trigger T_Comercial on database
for create_table, alter_table, drop_table

as

begin

	raiserror ('> Imposible crear, modificar o eliminar tablas...', 16, 1);
	rollback transaction;

end;

alter trigger T_Comercial  on database
for DDL_TABLE_EVENTS

as

begin

	raiserror ('> Imposible crear, modificar o eliminar tablas...', 16, 1);
	rollback transaction;

end;

alter trigger T_Comercial  on database
for DDL_TABLE_EVENTS, DDL_INDEX_EVENTS

as

begin

	raiserror ('> Imposible crear, modificar o eliminar tablas...', 16, 1);
	rollback transaction;

end;

alter trigger T_Comercial on database
for alter_table, drop_table

as

begin

	raiserror ('> Imposible modificar o eliminar tablas...', 16, 1);
	rollback transaction;

end;
