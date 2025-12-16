execute SLCCuentayCliente; 1;

execute SLCCuentayCliente; 2; 

execute SLCCuentayCliente; 2 'R'; 

execute SLCCuentayCliente; 2 'C'; 

execute SLCCuentayCliente; 2 'X'; 

execute SLCCuentayCliente; 2 @TipoOperacion = 'C'; 

declare @TipoOper char(1) = 'C';
execute SLCCuentayCliente; 2 @TipoOperacion = @TipoOper; 

declare @TipoOper char(1) = 'C';
execute SLCCuentayCliente; 2 @TipoOper; 

declare @TipoOper char(1) = 'S';
execute SLCCuentayCliente; 2 @TipoOper; 
