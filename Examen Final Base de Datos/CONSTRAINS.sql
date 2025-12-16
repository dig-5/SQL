USE COLOCAR_SU_BASE_DE_DATOS

--PAIS
ALTER TABLE Pais ADD
    CONSTRAINT PK_Pais PRIMARY KEY (PaisCod),
    CONSTRAINT UQ_Pais_Nombre UNIQUE (Nombre),
    CONSTRAINT UQ_Pais_Gentilicio UNIQUE (Gentilicio);
GO

--CIUDAD
ALTER TABLE Ciudad ADD
    CONSTRAINT PK_Ciudad PRIMARY KEY (CiudadCod),
    CONSTRAINT UQ_Ciudad_Denominacion UNIQUE (Denominacion),
    CONSTRAINT FK_Ciudad_Pais FOREIGN KEY (PaisCod) REFERENCES Pais(PaisCod);
GO

--HOTEL
ALTER TABLE Hotel ADD
    CONSTRAINT PK_Hotel PRIMARY KEY (HotelNro),
    CONSTRAINT UQ_Hotel_Denominacion UNIQUE (Denominacion),
    CONSTRAINT FK_Hotel_Ciudad FOREIGN KEY (CiudadCod) REFERENCES Ciudad(CiudadCod);
GO

--PISO
ALTER TABLE Piso ADD
    CONSTRAINT PK_Piso PRIMARY KEY (HotelNro, PisoNro),
    CONSTRAINT FK_Piso_Hotel FOREIGN KEY (HotelNro) REFERENCES Hotel(HotelNro);
GO

--CATEGORIA
ALTER TABLE Categoria ADD
    CONSTRAINT PK_Categoria PRIMARY KEY (CategoriaCod),
    CONSTRAINT UQ_Categoria_Descripcion UNIQUE (Descripcion);
GO

--TEMPORADA
ALTER TABLE Temporada ADD
    CONSTRAINT PK_Temporada PRIMARY KEY (TemporadaCod),
    CONSTRAINT FK_Temporada_Pais FOREIGN KEY (PaisCod) REFERENCES Pais(PaisCod);
GO

--CLIENTE
ALTER TABLE Cliente ADD
    CONSTRAINT PK_Cliente PRIMARY KEY (ClienteNro),
    CONSTRAINT FK_Cliente_Pais FOREIGN KEY (PaisCod)REFERENCES Pais(PaisCod);
GO

--HUESPED
ALTER TABLE Huesped ADD
    CONSTRAINT PK_Huesped PRIMARY KEY (HuespedNro),
    CONSTRAINT FK_Huesped_Pais FOREIGN KEY (PaisCod)REFERENCES Pais(PaisCod),
    CONSTRAINT FK_Huesped_Ciudad FOREIGN KEY (CiudadCod)REFERENCES Ciudad(CiudadCod),
    CONSTRAINT FK_Huesped_Cliente FOREIGN KEY (ClienteNro) REFERENCES Cliente(ClienteNro),
    CONSTRAINT CK_Huesped_EstadoCivil CHECK (  EstadoCivil IN ('CAS','SOL','VIU','DIV','SEP')
    );
GO

--HABITACION
ALTER TABLE Habitacion ADD
    CONSTRAINT PK_Habitacion PRIMARY KEY (HotelNro, PisoNro, HabitacionNro),
    CONSTRAINT UQ_Habitacion_Interno UNIQUE (InternoNro),
    CONSTRAINT FK_Habitacion_Hotel FOREIGN KEY (HotelNro)REFERENCES Hotel(HotelNro),
    CONSTRAINT FK_Habitacion_Piso FOREIGN KEY (HotelNro, PisoNro) REFERENCES Piso(HotelNro, PisoNro),
    CONSTRAINT FK_Habitacion_Categoria FOREIGN KEY (CategoriaCod) REFERENCES Categoria(CategoriaCod);
GO

--TARIFA
ALTER TABLE Tarifa ADD
    CONSTRAINT PK_Tarifa PRIMARY KEY (CategoriaCod, TemporadaCod),
    CONSTRAINT FK_Tarifa_Categoria FOREIGN KEY (CategoriaCod) REFERENCES Categoria(CategoriaCod),
    CONSTRAINT FK_Tarifa_Temporada FOREIGN KEY (TemporadaCod)REFERENCES Temporada(TemporadaCod);
GO

--HABITACIONHISTORICO
ALTER TABLE HabitacionHistorico ADD
    CONSTRAINT PK_HabitacionHistorico PRIMARY KEY (HotelNro, PisoNro, HabitacionNro, Fecha),
    CONSTRAINT FK_HabHist_Habitacion FOREIGN KEY (HotelNro, PisoNro, HabitacionNro) REFERENCES Habitacion(HotelNro, PisoNro, HabitacionNro),
    CONSTRAINT FK_HabHist_Categoria FOREIGN KEY (CategoriaCod) REFERENCES Categoria(CategoriaCod);
GO

--HOSPEDAJE
ALTER TABLE Hospedaje ADD
    CONSTRAINT PK_Hospedaje PRIMARY KEY (HospedajeNro),
    CONSTRAINT FK_Hospedaje_Huesped FOREIGN KEY (HuespedNro)  REFERENCES Huesped(HuespedNro),
    CONSTRAINT FK_Hospedaje_Hotel FOREIGN KEY (HotelNro) REFERENCES Hotel(HotelNro),
    CONSTRAINT FK_Hospedaje_Habitacion FOREIGN KEY (HotelNro, PisoNro, HabitacionNro)REFERENCES Habitacion(HotelNro, PisoNro, HabitacionNro),
    CONSTRAINT FK_Hospedaje_Cliente FOREIGN KEY (ClienteNro)REFERENCES Cliente(ClienteNro),
    CONSTRAINT FK_Hospedaje_Temporada FOREIGN KEY (TemporadaCod)REFERENCES Temporada(TemporadaCod);
GO

--HOSPEDAJEHISTORICO
ALTER TABLE HospedajeHistorico ADD
    CONSTRAINT PK_HospedajeHistorico PRIMARY KEY (HospedajeNro, HotelNro, PisoNro, HabitacionNro, FechaHora),
    CONSTRAINT FK_HospHist_Hospedaje FOREIGN KEY (HospedajeNro)REFERENCES Hospedaje(HospedajeNro),
    CONSTRAINT FK_HospHist_Habitacion FOREIGN KEY (HotelNro, PisoNro, HabitacionNro)REFERENCES Habitacion(HotelNro, PisoNro, HabitacionNro);
GO

--ACOMPANANTE --ERROR
ALTER TABLE Acompanante ADD
    CONSTRAINT PK_Acompanante PRIMARY KEY (HospedajeNro, HuespedNro),
    CONSTRAINT FK_Acomp_Hospedaje FOREIGN KEY (HospedajeNro) REFERENCES Hospedaje(HospedajeNro),
    CONSTRAINT FK_Acomp_Huesped FOREIGN KEY (HuespedNro) REFERENCES Huesped(HuespedNro);
GO


--RESERVACION
ALTER TABLE Reservacion ADD
    CONSTRAINT PK_Reservacion PRIMARY KEY (HotelNro, PisoNro, HabitacionNro, FechaInicio, FechaFin),
    CONSTRAINT FK_Reservacion_Habitacion FOREIGN KEY (HotelNro, PisoNro, HabitacionNro)REFERENCES Habitacion(HotelNro, PisoNro, HabitacionNro),
    CONSTRAINT FK_Reservacion_Huesped FOREIGN KEY (HuespedNro)REFERENCES Huesped(HuespedNro),
    CONSTRAINT FK_Reservacion_Hospedaje FOREIGN KEY (HospedajeNro)REFERENCES Hospedaje(HospedajeNro);
GO

--LLAMADA
ALTER TABLE Llamada ADD
    CONSTRAINT PK_Llamada PRIMARY KEY (HospedajeNro, TiempoInicio, TiempoFin),
    CONSTRAINT FK_Llamada_Hospedaje FOREIGN KEY (HospedajeNro)REFERENCES Hospedaje(HospedajeNro);
GO

--LIQUIDACION
ALTER TABLE Liquidacion ADD
    CONSTRAINT PK_Liquidacion PRIMARY KEY (HospedajeNro, DetalleNro),
    CONSTRAINT FK_Liquidacion_Hospedaje FOREIGN KEY (HospedajeNro)REFERENCES Hospedaje(HospedajeNro);
GO

--TIPOCOMPONENTE
ALTER TABLE TipoComponente ADD
    CONSTRAINT PK_TipoComponente PRIMARY KEY (TipoCompCod);
GO

--COMPONENTE
ALTER TABLE Componente ADD
    CONSTRAINT PK_Componente PRIMARY KEY (ComponenteNro),
    CONSTRAINT FK_Componente_TipoComponente FOREIGN KEY (TipoCompCod) REFERENCES TipoComponente(TipoCompCod),
    CONSTRAINT FK_Componente_Habitacion FOREIGN KEY (HotelNro, PisoNro, HabitacionNro)REFERENCES Habitacion(HotelNro, PisoNro, HabitacionNro);
GO

--TIPOALIMENTO
ALTER TABLE TipoAlimento ADD
    CONSTRAINT PK_TipoAlimento PRIMARY KEY (TipoAlimentoCod);
GO

--ALIMENTO
ALTER TABLE Alimento ADD
    CONSTRAINT PK_Alimento PRIMARY KEY (AlimentoNro),
    CONSTRAINT UQ_Alimento_Descripcion UNIQUE (Descripcion),
    CONSTRAINT FK_Alimento_TipoAlimento FOREIGN KEY (TipoAlimentoCod) REFERENCES TipoAlimento(TipoAlimentoCod);
GO

--INGREDIENTE
ALTER TABLE Ingrediente ADD
    CONSTRAINT PK_Ingrediente PRIMARY KEY (AlimentoNro, IngredienteNro),
    CONSTRAINT FK_Ingrediente_Alimento FOREIGN KEY (AlimentoNro) REFERENCES Alimento(AlimentoNro),
    CONSTRAINT FK_Ingrediente_Ingrediente FOREIGN KEY (IngredienteNro)REFERENCES Alimento(AlimentoNro);
GO

--HOTELALIMENTO
ALTER TABLE HotelAlimento ADD
    CONSTRAINT PK_HotelAlimento PRIMARY KEY (HotelNro, AlimentoNro),
    CONSTRAINT FK_HotelAlimento_Hotel FOREIGN KEY (HotelNro)REFERENCES Hotel(HotelNro),
    CONSTRAINT FK_HotelAlimento_Alimento FOREIGN KEY (AlimentoNro)  REFERENCES Alimento(AlimentoNro);
GO

--DEPOSITO --ERR
ALTER TABLE Deposito ADD
    CONSTRAINT PK_Deposito PRIMARY KEY (HotelNro, PisoNro, DepositoNro),
    CONSTRAINT UQ_Deposito_Descripcion UNIQUE (Descripcion),
    CONSTRAINT FK_Deposito_Piso FOREIGN KEY (HotelNro, PisoNro) REFERENCES Piso(HotelNro, PisoNro);
GO

--DEPOSITOALIMENTO
ALTER TABLE DepositoAlimento ADD
    CONSTRAINT PK_DepositoAlimento PRIMARY KEY (HotelNro, PisoNro, DepositoNro, AlimentoNro),
    CONSTRAINT FK_DepAlim_Deposito FOREIGN KEY (HotelNro, PisoNro, DepositoNro)  REFERENCES Deposito(HotelNro, PisoNro, DepositoNro),
    CONSTRAINT FK_DepAlim_Alimento FOREIGN KEY (AlimentoNro) REFERENCES Alimento(AlimentoNro);
GO

--CONSUMO -EERRR
ALTER TABLE Consumo ADD
    CONSTRAINT PK_Consumo PRIMARY KEY (ConsumoNro),
    CONSTRAINT FK_Consumo_Hospedaje FOREIGN KEY (HospedajeNro) REFERENCES Hospedaje(HospedajeNro),
    CONSTRAINT FK_Consumo_Deposito FOREIGN KEY (HotelNro, PisoNro, DepositoNro)REFERENCES Deposito(HotelNro, PisoNro, DepositoNro),
    CONSTRAINT CK_Consumo_Estado CHECK (Estado IN ('A','C','N'));
GO

--DETALLECONSUMO
ALTER TABLE DetalleConsumo ADD
    CONSTRAINT PK_DetalleConsumo PRIMARY KEY (ConsumoNro, AlimentoNro),
    CONSTRAINT FK_DetCons_Consumo FOREIGN KEY (ConsumoNro)REFERENCES Consumo(ConsumoNro),
    CONSTRAINT FK_DetCons_Alimento FOREIGN KEY (AlimentoNro)REFERENCES Alimento(AlimentoNro);
GO

--PROVEEDOR
ALTER TABLE Proveedor ADD
    CONSTRAINT PK_Proveedor PRIMARY KEY (ProveedorNro);
GO

--COMPRA
ALTER TABLE Compra ADD
    CONSTRAINT PK_Compra PRIMARY KEY (CompraNro),
    CONSTRAINT FK_Compra_Proveedor FOREIGN KEY (ProveedorNro) REFERENCES Proveedor(ProveedorNro),
    CONSTRAINT FK_Compra_Deposito FOREIGN KEY (HotelNro, PisoNro, DepositoNro)REFERENCES Deposito(HotelNro, PisoNro, DepositoNro),
    CONSTRAINT CK_Compra_Estado CHECK (Estado IN ('A','C','N'));
GO

--DETALLECOMPRA
ALTER TABLE DetalleCompra ADD
    CONSTRAINT PK_DetalleCompra PRIMARY KEY (CompraNro, AlimentoNro),
    CONSTRAINT FK_DetCompra_Compra FOREIGN KEY (CompraNro)REFERENCES Compra(CompraNro),
    CONSTRAINT FK_DetCompra_Alimento FOREIGN KEY (AlimentoNro)REFERENCES Alimento(AlimentoNro);
GO

--TRANSFERENCIA
ALTER TABLE Transferencia ADD
    CONSTRAINT PK_Transferencia PRIMARY KEY (TransferenciaNro),
    CONSTRAINT FK_Transf_DepositoOrigen FOREIGN KEY (HotelNroOrigen, PisoNroOrigen, DepositoNroOrigen)REFERENCES Deposito(HotelNro, PisoNro, DepositoNro),
    CONSTRAINT FK_Transf_DepositoDestino FOREIGN KEY (HotelNroDestino, PisoNroDestino, DepositoNroDestino) REFERENCES Deposito(HotelNro, PisoNro, DepositoNro),
    CONSTRAINT CK_Transferencia_Estado CHECK (Estado IN ('A','C','N'));
GO

--DETALLETRANSFERENCIA
ALTER TABLE DetalleTransferencia ADD
    CONSTRAINT PK_DetalleTransferencia PRIMARY KEY (TransferenciaNro, AlimentoNro),
    CONSTRAINT FK_DetTrans_Transferencia FOREIGN KEY (TransferenciaNro) REFERENCES Transferencia(TransferenciaNro),
    CONSTRAINT FK_DetTrans_Alimento FOREIGN KEY (AlimentoNro) REFERENCES Alimento(AlimentoNro);
GO

--PERSONAL
ALTER TABLE Personal ADD
    CONSTRAINT PK_Personal PRIMARY KEY (PersonalNro),
    CONSTRAINT FK_Personal_Jefe FOREIGN KEY (JefeNro) REFERENCES Personal(PersonalNro),
    CONSTRAINT FK_Personal_Hotel FOREIGN KEY (HotelNro)REFERENCES Hotel(HotelNro);
GO

--PERSONALHORARIO
ALTER TABLE PersonalHorario ADD
    CONSTRAINT PK_PersonalHorario PRIMARY KEY (PersonalNro, DiaSemana),
    CONSTRAINT FK_PersHor_Personal FOREIGN KEY (PersonalNro)REFERENCES Personal(PersonalNro);
GO

