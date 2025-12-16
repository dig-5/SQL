-- batches

begin
    a;
	b;
	c;
	d;
end;

--

if  a
    b;

if a
   b
else
   c;

if a
begin
   b
   c
   d
end

if a
begin
   b
   c
   d
end
else
   e;

if a
begin
   b;
   c;
   d;
end
else
begin
   e;
   f;
   g;
   h;
end;

if a
   if b
      if c
	  begin
	     d;
		 e;
		 f;
	  end;

if a
begin
   if b
   begin
      if c
	  begin
	     d;
		 e;
		 f;
	  end;
   end;
end;

if  a
begin
    b;
	if c
	begin
	   d;
	   e;
	end
	else
	   f;
	if g
	   h
	else
	begin
	   i
	   j
	   k
	end
end
else
   l;

--

while a
      b;

--

while a
begin 
     b;
	 c;
	 d;
	 e;
end;

while a
begin
    b;
	c;
	d;
	while e
	begin
	    f;
		g;
		h;
	end;
	i;
	j;
	k;
	l;
end;

-- jhakjshkjahsdljagsldjgalsdhgajhsgdajhsgdahgsdahsdgagdjhgdjhgashgkashdgkasghdajhsgdh

/* jkas;dkahs;dkha;sjkdh;ajkshdjkashdljkahsd
   kjahsdkjahlskdjhaljsdhaksjdkjahsdjkahsdkljhasldjkh
   ashkajshdkjashdlkahsldjhasljdh
*/

select * -- Recupera todas las columnas
from cuenta
where nrocuenta < 10000 /* filtra por el nro, de cuenta de manera
                           a recuperar las cuentas menores a 10.000 
						*/ order by nrocuenta;


begin
    a;
	b;
	c;
	if  d
	    return;
	e;
	f;
end;

--

begin try
      a;
	  b;
	  c;
	  d;
	  e;
end try

begin catch
      f;
	  g;
	  h;
end catch

