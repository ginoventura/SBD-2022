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


create or alter procedure vencimientos
(
	@fecha		date
)
as
begin

	/*select *
		from cuotas c
	where ABS(DATEDIFF(DD, c.fecha_vto, GETDATE())) > 90
	  and c.fecha_vto < GETDATE()
	  and c.importe > isnull((select SUM(dr.importe)
						from det_recibos dr
						where c.nro_credito = dr.nro_credito
						  and c.nro_cuota = dr.nro_cuota), 0)*/

	declare		@nro_credito	int,
				@nro_cuota		tinyint,
				@fecha_vto		date,
				@importe		decimal(9, 2)

	declare cur cursor for
	select c.nro_credito, c.nro_cuota, c.fecha_vto, c.importe
		from cuotas c
	where ABS(DATEDIFF(DD, c.fecha_vto, @fecha)) > 90
	  and c.fecha_vto < @fecha
	  and c.importe > isnull((select SUM(dr.importe)
						from det_recibos dr
						where c.nro_credito = dr.nro_credito
						  and c.nro_cuota = dr.nro_cuota), 0)

	/*select *
		from cuotas c
			join select * from det_recibos dr
				on dr.nro_credito = c.nro_credito
				and	dr.nro_cuota = c.nro_cuota*/

	open cur
	fetch cur into @nro_credito, @nro_cuota, @fecha_vto, @importe

	while @@FETCH_STATUS = 0
	begin
		update c
			set tratamiento_judicial = 'S'
			from creditos c
			where c.nro_credito = @nro_credito

		fetch cur into @nro_credito, @nro_cuota, @fecha_vto, @importe
	end

	close cur
	deallocate cur


end

execute vencimientos @fecha = '02-07-2020'

select *
	from creditos c





--Resolución
select *
	from det_recibos dr
		join creditos c
			on dr.nro_credito = c.nro_credito
				join recibos r
					on r.nro_recibo = dr.nro_recibo
	where r.nro_cliente != c.nro_cliente

---------------------------------------------------------------------------------------------------------------------------------
--tablas							insert							delete							update
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
--det_recibos						controlar nro cliente			----							Controlar
--									igual al de creditos.
--									Porque recibos no va a
--									estar vacío.
---------------------------------------------------------------------------------------------------------------------------------
--creditos							----							----							nro_cliente: no permitir
---------------------------------------------------------------------------------------------------------------------------------
--recibos							----							----							nro_cliente: no permitir
---------------------------------------------------------------------------------------------------------------------------------

create trigger ti_det_recibos
on det_recibos
for	insert
as
begin
	if exists(select *
				from inserted dr
					join creditos c
						on dr.nro_credito = c.nro_credito
							join recibos r
								on r.nro_recibo = dr.nro_recibo
				where r.nro_cliente != c.nro_cliente)
	begin
		raiserror('El número de cliente del recibo no es igual al de créditos', 16, 1)
		rollback
	end
end
go

create trigger tu_det_recibos
on det_recibos
for	update
as
begin
	if exists(select *
				from inserted dr
					join creditos c
						on dr.nro_credito = c.nro_credito
							join recibos r
								on r.nro_recibo = dr.nro_recibo
				where r.nro_cliente != c.nro_cliente)
	begin
		raiserror('El número de cliente del recibo no es igual al de créditos', 16, 1)
		rollback
	end
end
go

create trigger tu_creditos
on creditos
for	update
as
begin
	if update(nro_cliente)
	begin
		raiserror('No se puede cambiar el número de cliente.', 16, 1)
		rollback
	end
end
go

create trigger tu_recibos
on recibos
for	update
as
begin
	if update(nro_cliente)
	begin
		raiserror('No se puede cambiar el número de cliente.', 16, 1)
		rollback
	end
end
go




---------------------------------------------------------------------------------------------------------------------------------
--Respuestas Butros:


select * 
	from det_recibos
		join recibos
			on recibos.nro_recibo = det_recibos.nro_recibo
				join cuotas
					on cuotas.nro_credito = det_recibos.nro_credito
						and cuotas.nro_cuota = det_recibos.nro_cuota
							join creditos
								on creditos.nro_credito = cuotas.nro_credito
									and creditos.nro_cliente != recibos.nro_cliente

/* ********************************************************************* */
-- NO ES NECESARIO EL USO DE LA TABLA CUOTAS - DIRECTAMENTE JOIN ENTRE DET_RECIBOS Y CRÉDITOS
/* ********************************************************************* */

-------------------------------------------------------------------------------------------------------------------------------------
--tablas					insert								delete							update
---------------------------------------------------------------------------------------------------------------------------------------
--creditos					----								-----							Controlar
----------------------------------------------------------------------------------------------------------------------------------------
--cuotas					----								------							Controlar
---------------------------------------------------------------------------------------------------------------------------------------
--recibos					----								-----							Controlar
----------------------------------------------------------------------------------------------------------------------------------------
--det_recibos				Controlar							-----							Controlar
------------------------------------------------------------------------------------------------------------------------------------

/* ********************************************************************* */
-- SI SE MODIFICA EL NÚMERO DE CRÉDITO DE LA TABLA CUOTAS NO HAY QUE HACER NADA PORQUE O NO ESTARÁ PERMITIDO PORQUE TIENE DET_RECIBOS O NO TIENE DET_RECIBOS
/* ********************************************************************* */


create trigger tu_ri_creditos
on creditos
for update
as
begin

	if ( update(nro_credito))
	begin
		raiserror('No puede modificar el numero de crédito', 16, 1)
		rollback
	end

	if (update(nro_cliente))
	begin
		raiserror('No puede modificar el numero de cliente', 16, 1)
		rollback
	end
end
go

/* ********************************************************************* */
-- NO ES NECESARIO CONTROLAR EL CAMBIO DEL NRO_CREDITO
/* ********************************************************************* */

/*Probando

--Insertamos un credito nuevo, que no este relacionado con la tabla cuotas ni clientes, para que no salte la FK
insert into creditos (nro_credito, nro_cliente, garante, porc_interes_diario, imp_interes_diario, tratamiento_judicial)
values (1, 1, 10, 0.10, null,  'N')
go

--Probamos el trigger
update c
set nro_credito = 2
--select *
	from creditos c
		where c.nro_credito = 1

update c
set nro_cliente = 2
--select *
	from creditos c
		where c.nro_credito = 1
*/




create trigger tu_ri_cuotas
on cuotas
for update
as
begin

--Realmente este trigger no es necesario, porque salta antes la FK

	if (update(nro_credito))
	begin
		raiserror('No puede modificar el numero de crédito', 16, 1)
		rollback
	end
	
	if (update(nro_cuota))
	begin
		raiserror('No puede modificar el numero de cuota', 16, 1)
		rollback
	end
end
go

/* ********************************************************************* */
-- LOS CONTROLES NO TIENEN QUE VER CON LA RI PLANTEADA
/* ********************************************************************* */


create trigger tu_ri_recibos
on recibos
for update
as
begin

	if (update(nro_recibo))
	begin
		raiserror('No puede modificar el numero de recibo', 16, 1)
		rollback
	end

	if (update(nro_cliente))
	begin
		raiserror('No puede modificar el numero de cliente', 16, 1)
		rollback
	end
end
go

/* ********************************************************************* */
-- NO ES NECESARIO CONTROLAR QUE NO SE MODIFIQUE EL NRO_RECIBO
/* ********************************************************************* */

create trigger ti_ri_det_recibos
on det_recibos
for insert
as
begin
	if exists (select * 
					from inserted
						join recibos
							on recibos.nro_recibo = inserted.nro_recibo
								join cuotas
									on cuotas.nro_credito = inserted.nro_credito
										and cuotas.nro_cuota = inserted.nro_cuota
											join creditos
												on creditos.nro_credito = cuotas.nro_credito
													and creditos.nro_cliente != recibos.nro_cliente)
	begin
		raiserror('El cliente registrado en el recibo no es el mismo que el cliente de los créditos pagados por ese recibo',16,1)
		rollback
	end
end
go

/* ********************************************************************* */
-- NO ES NECESARIO EL USO DE LA TABLA CUOTAS - DIRECTAMENTE JOIN ENTRE INSERTED Y CRÉDITOS
/* ********************************************************************* */

create trigger tu_ri_det_recibos
on det_recibos
for update
as
begin
	if (update(importe))
	begin
		return
	end

	if exists (select * 
					from inserted
						join recibos
							on recibos.nro_recibo = inserted.nro_recibo
								join cuotas
									on cuotas.nro_credito = inserted.nro_credito
										and cuotas.nro_cuota = inserted.nro_cuota
											join creditos
												on creditos.nro_credito = cuotas.nro_credito
													and creditos.nro_cliente != recibos.nro_cliente)
	begin
		raiserror('El cliente registrado en el recibo no es el mismo que el cliente de los créditos pagados por ese recibo',16,1)
		rollback
	end
end
go

/* ********************************************************************* */
-- NO ES NECESARIO EL USO DE LA TABLA CUOTAS - DIRECTAMENTE JOIN ENTRE INSERTED Y CRÉDITOS
/* ********************************************************************* */

/* ********************************************************************* */
-- PUNTOS: 40
/* ********************************************************************* */


/*
 2. Programar un procedimiento almacenado que seleccione todos créditos con cuotas vencidas por más de 90 días y no 
      pagadas completamente y marque el crédito con tratamiento_judicial = 'S'.

	  El procedimiento recibe como argumento la fecha con la cual se determinará la cantidad de días que tiene de vencida cada cuota.
	  Las cuotas consideradas serán aquellas en que la fecha de vencimiento es menor a la fecha ingresada y la diferencia
	  entre esas fechas es mayor a 90 días.

	  Para calcular la cantidad de días que tiene vencida una cuota puede usar la función datediff().
*/


create or alter procedure dbo.cuotas_vencidas
   (
        @fecha    date
   )
   as
   begin
        --Variables que vamos a usar con el cursor:
        declare    @nro_credito            integer

        declare cur cursor for

        select DISTINCT(d.nro_credito)
            from det_recibos d
				   join cuotas c
						on c.nro_credito = d.nro_credito and c.nro_cuota = d.nro_cuota
							join (select sumaC.nro_credito, (sumaC.sumaC - sumaD.sumaD) as Saldo
										from (select d.nro_credito, SUM(d.importe) as sumaD
													from det_recibos d
													group by d.nro_credito) as sumaD
														join (select c.nro_credito, SUM(c.importe) as sumaC
																	from cuotas c
																	group by c.nro_credito) sumaC
															on sumaD.nro_credito = sumaC.nro_credito) as cuenta
								on cuenta.nro_credito = d.nro_credito
			where c.fecha_vto < @fecha and datediff(day, c.fecha_vto,@fecha) > 90
					and (cuenta.Saldo)> 0

/* ********************************************************************* */
-- NO CONTEMPLA CUOTAS QUE NO TENGAN NINGÚN PAGO
-- NO ES NECESARIO EL USO DET_RECIBOS EN LA CONSULTA PRINCIPAL (INCLUSO ES PERJUDICIAL PORQUE LIMITA A LAS CUOTAS CON PAGOS)
/* ********************************************************************* */

        open cur
        fetch cur into @nro_credito
        while @@fetch_status = 0
        begin
			update c
				set tratamiento_judicial = 'S'
			
			--select *
				from creditos c
					where nro_credito = @nro_credito

			fetch cur into @nro_credito
            
        end
		
	select * from creditos
        close cur
        deallocate cur
   end
   go

/* ********************************************************************* */
-- NO ES NECESARIO MOSTRAR TODOS LOS CRÉDITOS
/* ********************************************************************* */

--Probando

select * from creditos

--Tabla antes:

/*

nro_credito		nro_cliente		garante		porc_interes_diario		imp_interes_diario		tratamiento_judicial
1					1				10				0.10					NULL					N
101					1				10				0.10					NULL					N
102					1				10				1.00					NULL					N
103					1				10				NULL					10.00					N
201					2				20				0.20					NULL					N
202					2				20				NULL					2.00					N
301					3				30				NULL					3.00					N
401					4				40				NULL					4.00					N
501					5				50				0.50					NULL					N

*/


execute cuotas_vencidas @fecha = '2020-06-26'

select * from cuotas

/*
Tabla despues:

nro_credito		nro_cliente		garante		porc_interes_diario		imp_interes_diario		tratamiento_judicial
1					1				10				0.10					NULL					N
101					1				10				0.10					NULL					S
102					1				10				1.00					NULL					N
103					1				10				NULL					10.00					N
201					2				20				0.20					NULL					N
202					2				20				NULL					2.00					N
301					3				30				NULL					3.00					N
401					4				40				NULL					4.00					N
501					5				50				0.50					NULL					S		

*/

/* ********************************************************************* */
-- PUNTOS: 45
/* ********************************************************************* */

-- PUNTAJE TOTAL: 85
