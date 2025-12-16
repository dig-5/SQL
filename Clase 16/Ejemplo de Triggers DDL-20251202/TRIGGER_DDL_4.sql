use master

create trigger S_Servidor on all server
for create_database, alter_database, drop_database

as

begin

	raiserror ('> Imposible crear, modificar o eliminar bases de datos...', 16, 1);
	rollback transaction;

end;

create database x;
