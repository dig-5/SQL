ALTER TABLE AgenciaDepositoArticulo
DISABLE TRIGGER ALL;

DISABLE TRIGGER ALL ON AgenciaDepositoArticulo;

ALTER TABLE AgenciaDepositoArticulo
ENABLE TRIGGER ALL;

ENABLE TRIGGER ALL ON AgenciaDepositoArticulo;

ALTER TABLE AgenciaDepositoArticulo
DISABLE TRIGGER [tD_AgenciaDepositoArticulo], [tI_AgenciaDepositoArticulo];

DISABLE TRIGGER [tD_AgenciaDepositoArticulo], [tI_AgenciaDepositoArticulo] ON AgenciaDepositoArticulo;

ALTER TABLE AgenciaDepositoArticulo
ENABLE TRIGGER [tD_AgenciaDepositoArticulo], [tI_AgenciaDepositoArticulo];

ENABLE TRIGGER [tD_AgenciaDepositoArticulo], [tI_AgenciaDepositoArticulo] ON AgenciaDepositoArticulo;
