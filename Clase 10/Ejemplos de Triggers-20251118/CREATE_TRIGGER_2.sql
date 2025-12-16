create trigger TIUD_Asiento_InsteadOf on Asiento instead of insert, update, delete

as

begin

	if  exists (select * from inserted) and not exists (select * from deleted)
	begin
	    select 'INSERT...';

		select * from inserted;

		insert into AuditoriaAsiento
		select *, 'I', suser_sname(), getdate (), host_name ()
		from inserted; 

	end;

	if  exists (select * from inserted) and exists (select * from deleted)
	begin
	    select 'UPDATE...';

		select * from deleted;

		select * from inserted;

		insert into AuditoriaAsiento
		select *, 'U', suser_sname(), getdate (), host_name ()
		from deleted; 

		insert into AuditoriaAsiento
		select *, 'U', suser_sname(), getdate (), host_name ()
		from inserted; 

	end;

	if  not exists (select * from inserted) and exists (select * from deleted)
	begin
	    select 'DELETE...';

		select * from deleted;

		insert into AuditoriaAsiento
		select *, 'D', suser_sname(), getdate (), host_name ()
		from deleted; 

	end;

end;
