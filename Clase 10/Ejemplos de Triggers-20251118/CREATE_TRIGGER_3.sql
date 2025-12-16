create trigger TIUD_Asiento_InsteadOf on Asiento instead of insert, update, delete

as

begin

	if  exists (select * from inserted) and not exists (select * from deleted)
	begin
	    select 'INSERT...';

		select * from inserted;

		insert into AuditoriaAsiento
		select next value for SEQ_AUDITORIAASIENTO, 
		       *, 'I', suser_sname(), getdate (), host_name ()
		from inserted; 

		insert into Asiento
		select *
		from inserted; 

	end;

	if  exists (select * from inserted) and exists (select * from deleted)
	begin
	    select 'UPDATE...';

		select * from deleted;

		select * from inserted;

		insert into AuditoriaAsiento
		select next value for SEQ_AUDITORIAASIENTO, 
		       *, 'UB', suser_sname(), getdate (), host_name ()
		from deleted; 

		insert into AuditoriaAsiento
		select next value for SEQ_AUDITORIAASIENTO, 
		       *, 'UA', suser_sname(), getdate (), host_name ()
		from inserted; 

	end;

	if  not exists (select * from inserted) and exists (select * from deleted)
	begin
	    select 'DELETE...';

		select * from deleted;

		insert into AuditoriaAsiento
		select next value for SEQ_AUDITORIAASIENTO, 
		       *, 'D', suser_sname(), getdate (), host_name ()
		from deleted; 

	end;

end;
