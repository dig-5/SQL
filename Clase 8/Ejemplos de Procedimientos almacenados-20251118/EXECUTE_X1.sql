set dateformat dmy;
execute SLCVentaxMoneda '01/01/2013', '31/01/2013';

set dateformat dmy;
execute SLCVentaxMoneda;2 '01/01/2013', '31/01/2013', 'X';

set dateformat dmy;
execute SLCVentaxMoneda;2 @vtipoconsulta = 'P', 
                          @vfechafin = '31/01/2013', 
						  @vfechainicio = '01/01/2013';

set dateformat dmy;
declare @vfechaini date = '01/01/2013',
        @vfechafin date = '31/01/2013';

execute SLCVentaxMoneda @vfechaini, @vfechafin;
					  