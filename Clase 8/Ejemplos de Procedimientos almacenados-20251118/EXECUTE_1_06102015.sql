DECLARE @ValorRetorno INT;

EXECUTE @ValorRetorno = PRCDetalleTRansferencia 107000,
												27871,
												1000,
												0,
												'I';

SELECT @ValorRetorno;

DECLARE @ValorRetorno INT;

EXECUTE @ValorRetorno = PRCDetalleTRansferencia 106549,
												27871,
												1000,
												0,
												'I';

SELECT @ValorRetorno;

DECLARE @ValorRetorno INT;

EXECUTE @ValorRetorno = PRCDetalleTRansferencia 106480,
												24312,
												1000,
												0,
												'I';

SELECT @ValorRetorno;

DECLARE @ValorRetorno INT;

EXECUTE @ValorRetorno = PRCDetalleTRansferencia 106480,
												27871,
												13000,
												0,
												'I';

SELECT @ValorRetorno;

DECLARE @ValorRetorno INT;

EXECUTE @ValorRetorno = PRCDetalleTRansferencia 106480,
												27871,
												1000,
												0,
												'I';

SELECT @ValorRetorno;

DECLARE @ValorRetorno INT;

EXECUTE @ValorRetorno = PRCDetalleTRansferencia 106480,
												27871,
												500,
												0,
												'U';

SELECT @ValorRetorno;


DECLARE @ValorRetorno INT;

EXECUTE @ValorRetorno = PRCDetalleTRansferencia 106480,
												27871,
												0,
												0,
												'D';

SELECT @ValorRetorno;

alter table detalletransferencia disable trigger all;

