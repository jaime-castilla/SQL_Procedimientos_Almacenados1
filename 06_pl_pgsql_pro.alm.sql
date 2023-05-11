--Crear dos tablas la de cuentas con id, saldo, la otra de movimientos con id, tipo de movimiento y -->
-->monto. Realizar un pa que: inserte en la tabla de movimientos y actualice el saldo en una transacción.
create table cuentas(
id_cuentas serial not null,
saldo numeric,
constraint pk_cuentas primary key (id_cuentas)
);
create table movimientos(
id_movimientos serial,
tipo_movimiento varchar(60),
monto_mov numeric,
constraint pk_movimientos primary key (id_movimientos)
);

insert into cuentas (id_cuentas, saldo) values (1, 6000.00);

select * from cuentas;

create or replace procedure realizar_transferencia(
   in cuenta_origen integer,
   in tipo_operacion character varying(60),
   in dinero numeric)
   
as $$
begin
   if tipo_operacion = 'ingreso' then
   
      update cuentas set saldo = saldo + dinero where cuentas = cuenta_origen;  
	  
   elsif tipo_operacion = 'retirar' then
      if (select saldo from cuentas where cuenta = cuenta_origen) < dinero then
         rollback;
         raise exception 'No hay suficiente dinero en la cuenta';
	  
	  else 
	     update cuentas set saldo = saldo - dinero where cuentas = cuenta_origen;
	  end if;
   end if;
   
   insert into movimientos (id_movimientos, tipo_movimiento, monto_mov) values (1, tipo_operacion, dinero);
   commit;
	   
end $$ language plpgsql;

call realizar_transferencia('retirar', 3000.00);
select * from cuentas;
select * from movimientos;

     

