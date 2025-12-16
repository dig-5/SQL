
-- trigger sobre Contrato


declare @nrocontrato int, 
        @fechavencimiento datetime, 
		@importeprima money,
		@cantidadcuotas int,
		@nrocuota int;

declare cursorcontrato cursor 
for select inserted.nrocontrato, 
           inserted.fechafirma, 
		   inserted.importeprima,
		   planseguro.cantidadcuotas
    from inserted join planseguro on inserted.nroplan = planseguro.nroplan;

open cursorcontrato;

fetch next from cursorcontrato into @nrocontrato, 
									@fechavencimiento, 
									@importeprima,
									@cantidadcuotas;

while @@fetch_status = 0
begin

	select @nrocuota = 1,
		   @importeprima = @importeprima / @cantidadcuotas,
		   @fechavencimiento = dateadd(day, 30, @fechavencimiento);

    while @nrocuota <= @cantidadcuotas
	begin 
		insert into contratocuota
		values (@nrocontrato, @nrocuota, @fechavencimiento, @importeprima);

		select @nrocuota = @nrocuota + 1,
			   @fechavencimiento = dateadd(day, 30, @fechavencimiento);

	end;

	fetch next from cursorcontrato into @nrocontrato, 
										@fechavencimiento, 
										@importeprima,
										@cantidadcuotas;
end;

deallocate cursorcontrato;


Contrato							
NroContrato	NroAsegurado	NroPlan	NroPromotor	NroContrato	FechaFirma	FechaVencto	ImportePrima
				Renovado			
PK	FK	FK	FK	FK, ND	NN	NN	NN
Int	Int	Int	Int	Int	Datetime	Datetime	Money
							
ContratoAsegurado			ContratoCuota				
NroContrato	NroAsegurado		NroContrato	NroCuota	FechaVencto	ImporteCuota	
PK	+		PK	+			
FK	FK		FK				
Int	Int		Int	Int	Datetime	Money	
							
Médico							
NroMédico	Nombres	Apellidos	Dirección	Teléfono	RUC		
PK	NN	NN	NN				
Int	Varchar 50	Varchar 50	Varchar 40	Varchar 15	Varchar 15		
							
PlanSeguro					PlanSeguroTipoServicio		
NroPlan	CantidadCuotas	ImportePrima	NroPlanPiloto		NroPlan	CodTipoServicio	PorcCobertura
PK			FK		PK	+	NN
Int	Int	Money	Int		FK	FK	
					Int	Int	Float

