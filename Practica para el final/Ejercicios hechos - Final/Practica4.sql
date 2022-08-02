-- INGENIERIA EN INFORMATICA - SISTEMAS DE BASES DE DATOS - EVALUACIÓN PARCIAL Nº 3 - 26-06-2020

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
 tratamiento_judicial	char(1)			not null default 'N',
 check (porc_interes_diario is null     and imp_interes_diario is not null or
        porc_interes_diario is not null and imp_interes_diario is null),
 check (tratamiento_judicial in ('S','N'))
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

insert into creditos (nro_credito, nro_cliente, garante, porc_interes_diario, imp_interes_diario, tratamiento_judicial)
values (101, 1, 10, 0.10, null,  'N'),
       (102, 1, 10, 1.00, null,  'N'),
       (103, 1, 10, null, 10.00, 'N'),
       (201, 2, 20, 0.20, null,  'N'),
       (202, 2, 20, null, 2.00,  'N'),
       (301, 3, 30, null, 3.00,  'N'),
       (401, 4, 40, null, 4.00,  'N'),
       (501, 5, 50, 0.5, null,   'N')
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


/*
EJERCICIOS:
   1. Se debe implementar una regla de integridad que controle que el cliente registrado en el recibo sea el mismo que
      el cliente de los créditos pagados por ese recibo.
	  Para esto deberá:
	  a. Programar una consulta que devuelva cuales son los detalles de recibos que cancelan cuotas de otros clientes
	  b. Elaborar una tabla de análisis de operaciones que determine los triggers requeridos para controlar esa RI
	  c. Programar dichos triggers

   2. Programar un procedimiento almacenado que seleccione todos créditos con cuotas vencidas por más de 90 días y no 
      pagadas completamente y marque el crédito con tratamiento_judicial = 'S'.

	  El procedimiento recibe como argumento la fecha con la cual se determinará la cantidad de días que tiene de vencida cada cuota.
	  Las cuotas consideradas serán aquellas en que la fecha de vencimiento es menor a la fecha ingresada y la diferencia
	  entre esas fechas es mayor a 90 días.

	  Para calcular la cantidad de días que tiene vencida una cuota puede usar la función datediff().

*/

select * from det_recibos
select * from recibos
select * from creditos
select * from cuotas
select * from clientes
go

-- EJERCICIO 1.A) 
----------------------------------------------------------------------------------------------------------
-- REGLA DE INTEGRIDAD: cliente registrado en el recibo debe ser el mismo cliente registrado en el credito
----------------------------------------------------------------------------------------------------------
-- nro_cliente from recibos debe ser el mismo nro_cliente from creditos y nro_credito from det_recibos 
-- debe ser igual que el del creditos

select r.nro_recibo, r.nro_cliente, dr.nro_credito
	from recibos r
		join det_recibos dr
			on r.nro_recibo = dr.nro_recibo
		join creditos c
			on dr.nro_credito = c.nro_credito
	where r.nro_cliente != c.nro_cliente
go

-- EJERCICIO 1.B) 
----------------------------------------------------------------------------------------------------------
-- REGLA DE INTEGRIDAD: Cliente registrado en el recibo debe ser el mismo cliente registrado en el credito
----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--  tabla			insert					delete					update
  ---------------------------------------------------------------------------------
-- RECIBOS			  NO					  NO					  SI
  ---------------------------------------------------------------------------------
-- DET_RECIBOS		  SI					  NO					  SI
  ---------------------------------------------------------------------------------
-- CREDITOS			  NO					  NO					  SI
  ---------------------------------------------------------------------------------
-- Insert en recibos: si inserto un recibo, no se debe controlar por que todavia no
-- se sabe que credito va a pagar ese cliente con ese recibo.
-- Delete en recibos: si borro un recibo, no deja de cumplir una regla de control 
-- algo que no existe.
-- Update en recibos: no se debería poder cambiar datos de un recibo ya emitido.
-----------------------------------------------------------------------------------
-- Insert en det_recibos: si inserto un det_recibos, se debe controlar que el cliente
-- que paga el recibo, es el mismo cliente registrado del credito que paga ese recibo.
-- Delete en det_recibos: no deja de cumplir una regla de control algo que no existe.
-- Update en det_recibos: si se actualiza un det_recibo, se debe controlar que el 
-- cliente que paga el recibo, es el mismo del credito que paga el recibo.
-----------------------------------------------------------------------------------
-- Insert en creditos: si inserto un credito, todavia no tiene recibos registrados.
-- Delete en creditos: si borro una credito, no deja de cumplir una regla de control 
-- algo que no existe.
-- Update en creditos: si se actualiza un credito, se debe controlar que no se actualice
-- el nro_cliente ya que si tiene recibos registrados, podria ser que afecte la RI.
------------------------------------------------------------------------------------------------------

-- EJERCICIO 1.C) 
-- Trigger update en recibos:
if OBJECT_ID('tri_up_recibos') is not null
	drop trigger tri_up_recibos 
go

create or alter trigger tri_up_recibos
	on recibos
		for update
		as 
		begin 
			if update(nro_recibo) or update(nro_cliente) or update(fecha)
			begin
				raiserror('No se puede actualizar los datos de un recibo', 16, 1)
				rollback transaction
			end
		end
go

-- Trigger insert y update en det_recibos:
if OBJECT_ID('tri_inup_det_recibos') is not null
	drop trigger tri_inup_det_recibos 
go

create or alter trigger tri_inup_det_recibos
	on det_recibos
		for insert, update
		as
		begin 
			if exists(select r.nro_recibo, r.nro_cliente, dr.nro_credito
						from recibos r
							join inserted dr
								on r.nro_recibo = dr.nro_recibo
							join creditos c
								on dr.nro_credito = c.nro_credito
						where r.nro_cliente != c.nro_cliente)
			begin
				raiserror('El número de cliente del recibo debe ser igual al número del cliente del credito', 16, 1)
				rollback
			end
		end
go

-- Trigger update en creditos:
if OBJECT_ID('tri_up_creditos') is not null
	drop trigger tri_up_creditos 
go

create or alter trigger tri_up_creditos
	on creditos
		for update
		as 
		begin
			if update(nro_cliente)
			begin
			raiserror('No se puede actualizar el numero de cliente de un credito', 16, 1)
			rollback
		end
	end
go

-- EJERCICIO 2) Programar un procedimiento almacenado que seleccione todos créditos con cuotas vencidas por más de 90 días y no 
-- pagadas completamente y marque el crédito con tratamiento_judicial = 'S'.
-- El procedimiento recibe como argumento la fecha con la cual se determinará la cantidad de días que tiene de vencida cada cuota.
-- Las cuotas consideradas serán aquellas en que la fecha de vencimiento es menor a la fecha ingresada y la diferencia
-- entre esas fechas es mayor a 90 días.

-- Para calcular la cantidad de días que tiene vencida una cuota puede usar la función datediff().

if OBJECT_ID(pa_vencimiento) is not null
	drop procedure pa_vencimiento
go

create or alter procedure pa_vencimiento
(
	@fecha			date
)
	as 
	begin

	declare		@nro_credito	int,
				@nro_cuota		tinyint,
				@fecha_vto		date,
				@importe		decimal(9, 2)

	declare cur cursor for
	select c.nro_credito, c.nro_cuota, c.fecha_vto, c.importe
		from recibos r
			join det_recibos dr
				on r.nro_recibo = dr.nro_recibo
			join cuotas c
				on dr.nro_cuota = c.nro_cuota
			   and dr.nro_credito = c.nro_credito
		where DATEDIFF(day, c.fecha_vto, @fecha) > 90
		  and c.fecha_vto < @fecha
		  and c.importe > isnull((select SUM(dr.importe)		--Consulta para saber las cuotas que no fueron pagadas completamente
									from det_recibos dr
										where c.nro_credito = dr.nro_credito
										  and c.nro_cuota = dr.nro_cuota), 0)

		open cur 
		fetch cur into @nro_credito, @nro_cuota, @fecha_vto, @importe

		while @@FETCH_STATUS = 0
		begin 
			update cr set tratamiento_judicial = 'S'
				from creditos cr
				where cr.nro_credito = @nro_credito

		fetch cur into @nro_credito, @nro_cuota, @fecha_vto, @importe
	end

	close cur
	deallocate cur
end
go 

execute pa_vencimiento @fecha = '02-07-2020'

select *
	from creditos 