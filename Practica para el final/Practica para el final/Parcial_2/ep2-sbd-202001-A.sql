-- INGENIERIA EN INFORMATICA - SISTEMAS DE BASES DE DATOS - EVALUACIÓN PARCIAL Nº 2 - 26-05-2020

/* ---------------------------------------------------------------------------------------------------------------
   La siguiente base de datos da soporte a un sistema de créditos de una compañía financiera.
   Se registra la siguiente información:
   - Clientes: son personas físicas que toman créditos o que son de garantes en créditos tomados por otros clientes
   - Créditos: son los créditos otorgados. Para cada crédito se informa quien es el cliente que lo solicitó y quien
     es el garante.
   - Cuotas: son las cuotas que debe pagar el solicitante del crédito con su fecha de vencimiento, y opcionalmente, 
     información de los intereses cobrados por pagos fuera de término.
   - Recibos: son los comprobantes de pagos de cuotas. Con un recibo se puede cancelar más de una cuota y una cuota 
     puede cancelarse con más de un recibo, es decir que se aceptan pagos parciales de cuotas.
   - Detalle de recibos: permite discriminar los importes pagados indicando como se aplican a cada una de la cuotas.
   --------------------------------------------------------------------------------------------------------------- */

drop table det_recibos
drop table recibos
drop table cuotas
drop table creditos
drop table clientes
go

create table clientes
(
 nro_cliente		integer		not null primary key,
 nom_cliente		varchar(40)	not null unique
)
go

create table creditos
(
 nro_credito			integer			not null primary key,
 nro_cliente			integer			not null references clientes,
 garante				integer			not null references clientes,
 porc_interes_diario	decimal(5,2)	null,
 imp_interes_diario		decimal(7,2)	null,
 check (porc_interes_diario is null     and imp_interes_diario is not null or
        porc_interes_diario is not null and imp_interes_diario is null)
)
go

create table cuotas
(
 nro_credito		integer			not null references creditos,
 nro_cuota			tinyint			not null,
 fecha_vto			date			not null,
 importe			decimal(9,2)	not null check (importe > 0),
 fecha_interes		date			null,
 imp_interes		decimal(9,2)	null,
 primary key (nro_credito, nro_cuota)
)
go

create table recibos
(
 nro_recibo			integer		not null primary key,
 nro_cliente		integer		not null references clientes,
 fecha				date		not null
)
go

create table det_recibos
(
 nro_recibo		integer			not null references recibos,
 nro_credito	integer			not null,
 nro_cuota		tinyint			not null,
 importe		decimal(9,2)	not null check (importe > 0),
 primary key (nro_recibo, nro_credito, nro_cuota),
 foreign key (nro_credito, nro_cuota) references cuotas
)
go


insert into clientes (nro_cliente, nom_cliente)
values (1, 'Cliente 1'),
       (2, 'Cliente 2'),
       (3, 'Cliente 3'),
       (4, 'Cliente 4'),
       (5, 'Cliente 5'),
       (10, 'Garante 10'),
       (20, 'Garante 20'),
       (30, 'Garante 30'),
       (40, 'Garante 40'),
       (50, 'Garante 50')
go

insert into creditos (nro_credito, nro_cliente, garante, porc_interes_diario, imp_interes_diario)
values (101, 1, 10, 0.10, null),
       (102, 1, 10, 1.00, null),
       (103, 1, 10, null, 10.00),
       (201, 2, 20, 0.20, null),
       (202, 2, 20, null, 2.00),
       (301, 3, 30, null, 3.00),
       (401, 4, 40, null, 4.00),
       (501, 5, 50, 0.5, null)
go

-- debe parte la cuota de abril (800.00) y la de mayo completa (1000.00)
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe, fecha_interes, imp_interes)
values (101, 1, '2020-01-10', 1000.00, null, null),
       (101, 2, '2020-02-10', 1000.00, null, null),
       (101, 3, '2020-03-10', 1000.00, null, null),
       (101, 4, '2020-04-10', 1000.00, null, null),
       (101, 5, '2020-05-10', 1000.00, null, null)

-- debe la de noviembre completa (100.00)
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe, fecha_interes, imp_interes)
values (102, 1, '2020-08-10', 10000.00, null, null),
       (102, 2, '2020-09-10', 10000.00, null, null),
       (102, 3, '2020-10-10', 10000.00, null, null),
       (102, 4, '2020-11-10', 10000.00, null, null)

-- no pagó ninguna (ninguna atrasada)
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe, fecha_interes, imp_interes)
values (103, 1, '2020-10-10', 1000.00, null, null),
       (103, 2, '2020-11-10', 1000.00, null, null),
       (103, 3, '2020-12-10', 1000.00, null, null),
       (103, 4, '2021-01-10', 1000.00, null, null)

-- no pagó ninguna (ninguna atrasada)
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe, fecha_interes, imp_interes)
values (201, 1, '2020-11-10', 20000.00, null, null),
       (201, 2, '2020-12-10', 20000.00, null, null),
       (201, 3, '2021-01-10', 20000.00, null, null)

-- debe parte de la de mayo (17500.00) (atrasada) y todas las restantes
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe, fecha_interes, imp_interes)
values (301, 1, '2020-05-10', 30000.00, null, null),
       (301, 2, '2020-06-10', 30000.00, null, null),
       (301, 3, '2020-07-10', 30000.00, null, null)

-- pago todo
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe, fecha_interes, imp_interes)
values (401, 1, '2019-06-10', 40000.00, null, null),
       (401, 2, '2019-07-10', 40000.00, null, null),
       (401, 3, '2019-08-10', 40000.00, null, null)

-- debe la de octubre (atrasada)
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe, fecha_interes, imp_interes)
values (501, 1, '2019-08-10', 50000.00, null, null),
       (501, 2, '2019-09-10', 50000.00, null, null),
       (501, 3, '2019-10-10', 50000.00, null, null)

insert into recibos (nro_recibo, nro_cliente, fecha)
values (10101, 1, '2020-01-05'),
       (10102, 1, '2020-02-22'),
       (10134, 1, '2020-03-16')
go

insert into recibos (nro_recibo, nro_cliente, fecha)
values (10201, 1, '2020-02-01'),
       (10211, 1, '2020-03-12'),
       (10202, 1, '2020-04-20')
go

insert into recibos (nro_recibo, nro_cliente, fecha)
values (30101, 1, '2020-01-03')
go

insert into recibos (nro_recibo, nro_cliente, fecha)
values (40101, 4, '2020-03-18'),
       (40102, 4, '2020-04-05'),
       (40103, 4, '2020-05-02')
go

insert into recibos (nro_recibo, nro_cliente, fecha)
values (50101, 5, '2020-03-10'),
       (50102, 5, '2020-04-10')
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (10101, 101, 1, 1000.00),
       (10102, 101, 2, 1000.00),
       (10134, 101, 3, 1000.00),
       (10134, 101, 4, 1000.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (10201, 102, 1, 10000.00),
       (10211, 102, 2, 10000.00),
       (10202, 102, 3, 10000.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (30101, 301, 1, 30000.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (40101, 401, 1, 40000.00),
       (40102, 401, 2, 40000.00),
       (40103, 401, 3, 40000.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (50101, 501, 1, 50000.00),
       (50102, 501, 2, 50000.00)
go

select * from det_recibos
select * from recibos
select * from cuotas
select * from creditos
select * from clientes
go

/*
EJERCICIOS:
   a. Ha surgido un nuevo requerimiento en el sistema de créditos: "Ya no se permite el pago parcial de las cuotas. Los recibos pueden 
      cancelar una o más cuotas completas. Cada cuota solo podrá ser cancelada con un único recibo. 
      Debe elaborar un script para cambiar la base de datos con las operaciones necesarias para dar soporte al nuevo requerimiento. 
	  Esto puede implicar: eliminar, modificar o crear tablas o columnas.
	  NOTA: NO MODIFIQUE EL SCRIPT ORIGINAL!. Debe programar un nuevo script para cambiar la base de datos. Tenga en cuenta que el orden 
	  de las operaciones puede ser crítico. Por ejemplo, no se puede eliminar una columna si tiene una regla de integridad. Primero deberá
	  eliminar la regla de integridad.

   b. Suponga que los pagos registrados al momento en la base de datos pagan cuotas completas y que, por lo tanto, estos pagos 
	  pueden ser migrados sin problemas.
      Debe migrar los datos actuales de pagos de cuotas a la nueva estructura.
	  NOTA1: La migración no debe basarse en operaciones fijas (que usan constantes con los datos actuales), sino que debe estar programada 
	  para ejecutarse ante cualquier contenido de las tablas.
	  NOTA2: La migración puede requerir mezclar las operaciones del script programado en el punto a y el del punto b para no perder 
	  información.

   c. Utilizando la base de datos "con los cambios implementados", programar una consulta que muestre todos créditos que tienen cuotas 
      vencidas y no pagadas (recuerde que en la nueva estructura los pagos son completos - no hay pagos parciales) 
	  Datos a mostrar: (nro_credito, total_cuotas, saldo_vencido_cuotas)
*/ 

--a

alter table cuotas 
add nro_recibo		integer		null
go

alter table cuotas 
add foreign key (nro_recibo) references recibos
go

--migrar datos

drop table det_recibos
go



--b

alter table cuotas 
add nro_recibo		integer		null
go

alter table cuotas 
add foreign key (nro_recibo) references recibos
go

update c
	set c.nro_recibo = dr.nro_recibo
	--select c.*,dr.nro_recibo,dr.importe
		from cuotas c	
			join det_recibos dr
				on c.nro_credito = dr.nro_credito
				and c.nro_cuota = dr.nro_cuota



select * from cuotas
select * from recibos
select * from det_recibos



--c

select c.nro_credito,
	   count(*) as total_cuotas, 
	   sum(c.importe) as saldo_vencido_cuotas
	from cuotas c
  where c.fecha_vto < convert(date,dateadd(dd,90,getdate()))
  and c.nro_recibo is null
  group by c.nro_credito






















