set dateformat dmy
declare @nrodeajuste int,
        @valorretorno int;

execute @valorretorno = INSAjuste 1000, '12345', '06/11/2012', 'A', 1, @nrodeajuste output

select @nrodeajuste, @valorretorno;

--@CodTipoAjuste smallint = 1,
--@NroComprobante char(15),
--@FechaAjuste datetime,
--@Estado char(1) = 'A',
--@CodEmpresa int = 1,
--@NroAjuste int output=

set dateformat dmy
declare @nrodeajuste int,
        @valorretorno int;

execute @valorretorno = INSAjuste @NroComprobante = '12345', 
                                  @FechaAjuste = '06/11/2012', 
                                  @NroAjuste = @nrodeajuste output

select @nrodeajuste, @valorretorno;

select * from ajuste where NroAjuste = 4000;
select * from tipoajuste where codtipoAjuste = 1000;

set dateformat dmy
declare @nrodeajuste int,
        @valorretorno int;

execute @valorretorno = INSAjuste @Estado = 'A',
                                  @NroComprobante = '12345', 
                                  @FechaAjuste = '06/11/2012',
                                  @CodEmpresa = 1,
                                  @CodTipoAjuste = 2,
                                  @NroAjuste = @nrodeajuste output

select @nrodeajuste, @valorretorno;
