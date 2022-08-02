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
values (30101, 3, '2020-01-03'),
       (30111, 3, '2020-02-13')
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
       (10134, 101, 4, 200.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (10201, 102, 1, 4000.00),
       (10211, 102, 1, 6000.00),
       (10211, 102, 2, 10000.00),
       (10202, 102, 3, 10000.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (30101, 301, 1, 10000.00),
       (30111, 301, 1, 2500.00)
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
   1. Se debe implementar una regla de integridad que controle que el total de pagos asociados a cada cuota no 
      sea mayor que el importe de la cuota.
	  Para esto deberá:
	  a. Programar una consulta que devuelva cuales son las cuotas que tienen un total de pagos mayor al importe 
	     de la cuota
	  b. Elaborar una tabla de análisis de operaciones que determine los triggers requeridos para controlar esa RI
	  c. Programar dichos triggers


*/ 


select c.nro_credito, c.nro_cuota, SUM(dr.importe) pagado, c.importe
	from det_recibos dr
		join cuotas c
			on c.nro_credito = dr.nro_credito
		   and c.nro_cuota   = dr.nro_cuota
group by c.nro_credito, c.nro_cuota, c.importe
having(SUM(dr.importe)) > c.importe

---------------------------------------------------------------------------------------------------------------------------------
--tablas								insert								delete								update
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
--det_recibos							controlar							----								controlar
---------------------------------------------------------------------------------------------------------------------------------
--cuotas								nada porque no tiene pagos			FK no permite						no permitir
---------------------------------------------------------------------------------------------------------------------------------
create or alter trigger ti_det_recibos
on det_recibos
for insert
as
begin
	if exists (select c.nro_credito, c.nro_cuota, SUM(dr.importe) pagado, c.importe
				from inserted dr
					join cuotas c
						on c.nro_credito = dr.nro_credito
					   and c.nro_cuota   = dr.nro_cuota
			group by c.nro_credito, c.nro_cuota, c.importe
			having(SUM(dr.importe)) > c.importe)
	begin
		raiserror('El total de pagos de la cuota es mayor que su importe.', 16, 1)
		rollback
	end
end

create or alter trigger tu_det_recibos
on det_recibos
for update
as
begin
	if exists(select c.nro_credito, c.nro_cuota, SUM(dr.importe) pagado, c.importe
				from inserted dr
					join cuotas c
						on c.nro_credito = dr.nro_credito
					   and c.nro_cuota   = dr.nro_cuota
			group by c.nro_credito, c.nro_cuota, c.importe
			having(SUM(dr.importe)) > c.importe)
	begin
		raiserror('El total de pagos de la cuota es mayor que su importe.', 16, 1)
		rollback
	end
end

create or alter trigger tu_cuotas
on cuotas
for update
as
begin
	if UPDATE(importe)
	begin
		raiserror('No se puede modificar el importe de la cuota.', 16, 1)
		rollback
	end
end
















	

--SELECT dr.nro_credito,dr.nro_cuota,dr.importe FROM det_recibos dr order by dr.nro_credito,dr.nro_cuota 


------------------------------------------------------------------EJERCICIO1---------------------------------------------------------------------

--PASO1
select c.nro_credito,c.nro_cuota,c.importe,SUM(dr.importe) AS SUMA 
	from cuotas c
		join det_recibos dr
		on c.nro_credito = dr.nro_credito
		and c.nro_cuota = dr.nro_cuota
	group by c.nro_credito,c.nro_cuota,c.importe
	having sum (dr.importe) > c.importe


--PASO2
---------------------------------------------------------------------------------------------------------------
--TABLA						INSERT						DELETE						UPDATE
---------------------------------------------------------------------------------------------------------------
--CUOTAS				    ----                         ----                      rechazar cambios
---------------------------------------------------------------------------------------------------------------
--DET_RECIBOS				controlar					----					    controlar
---------------------------------------------------------------------------------------------------------------

/*EXPLICACION: EN CUOTAS, si inserto una nueva, es porque no existia, por lo tanto no tiene pagos asociados, Si borro una que tiene pagos hechos, las foraneas no me dejarian, y si no tiene 
pagos asociados, no se viola la integridad debido a que la suma de pagos es 0. En cuotas vamos a considerar que rechaze el cambio de claves primarias y la alteracion del importe
EN DET_RECIBOS, si inserto, tengo q controlar cuanto pago. La eliminacion de un detalle no rompe la integridad porque en todo caso estaria sacando pagos, y si cambio por ej el importe de 
un detalle con un update, tengo q controlar que ese importe nuevo no pase el total de la cuota asociada, Y si cambio datos como la cuota o el credito, estaria sumandole pagos a otra cuota de otro 
credito por lo tanto, tambien controlo
*/


CREATE OR ALTER TRIGGER tri_i_Upd_cuotas
ON cuotas
FOR UPDATE
AS
BEGIN
		if update(importe)
		begin
			raiserror('ERROR!!! No esta permitido modificar el importe de la cuota',16,1)
			rollback
			return
		end

		if update(nro_credito) or update(nro_cuota)
		begin
			raiserror('ERROR!!! No esta permitido modificar la clave primaria',16,1)
			rollback
			return
		end

END
GO

CREATE OR ALTER TRIGGER tri_i_Ins_Det_Recibos
ON det_recibos
FOR INSERT
AS
BEGIN
	IF EXISTS(select c.nro_credito,c.nro_cuota,c.importe,SUM(dr.importe) AS SUMA 
					from cuotas c
						join det_recibos dr
						on c.nro_credito = dr.nro_credito
						and c.nro_cuota = dr.nro_cuota
				group by c.nro_credito,c.nro_cuota,c.importe
				having sum (dr.importe) > c.importe  )
	begin 
		raiserror('ERROR!!! El monto supera el importe total de la cuota',16,1)
		rollback
	end
END
GO



CREATE OR ALTER TRIGGER tri_i_Upd_Det_Recibos
ON det_recibos
FOR UPDATE
AS
BEGIN
	IF EXISTS(select c.nro_credito,c.nro_cuota,c.importe,SUM(dr.importe) AS SUMA 
					from cuotas c
						join det_recibos dr
						on c.nro_credito = dr.nro_credito
						and c.nro_cuota = dr.nro_cuota
				group by c.nro_credito,c.nro_cuota,c.importe
				having sum (dr.importe) > c.importe  )
	begin
		raiserror('ERROR!!! El monto supera el importe total de la cuota',16,1)
		rollback
	end
END
GO


------------------------------------------------------------------EJERCICIO2---------------------------------------------------------------------



/*   2. Programar un procedimiento almacenado que seleccione todas las cuotas vencidas a una fecha determinada y que no 
      tengan ningún pago asociado, calcule el interés a cobrar y actualice esta información en la tabla cuotas.

	  El procedimiento recibe como argumento la fecha a la cual se determinará si la cuota está vencida o no. Las 
	  cuotas se considerarán vencidas si tienen una fecha de vencimiento menor a la fecha ingresada.

	  El cálculo del interés se realizará de dos maneras posibles dependiendo de si en la tabla créditos se informó
	  porcentaje de interés diario o importe de interés diario:

	  - Si se informó "porc_interes_diario", entonces el cálculo es el siguiente: importe de interés = importe de la cuota * porc_interes_diario * diferencia en días entre la fecha ingresada y la de vencimiento / 100.00
	  
	  - Si se informó "imp_interes_diario", entonces el cálculo es el siguiente:  importe de interés = importe de la cuota * imp_interes_diario * diferencia en días entre la fecha ingresada y la de vencimiento
	  
	  donde la "diferencia en días entre la fecha ingresada y la de vencimiento" se puede calcular con la función datediff()
	  
	  Una vez obtenido el importe del interes, se debe actualizar la fila de la tabla cuotas:
	  - imp_interes = importe de interés calculado
	  - fecha_interes = fecha ingresada como argumento

      NOTA: Una posible lógica para la solución podría ser la de crear un cursor con todas las cuotas vencidas y sin pagos, 
	  y luego para cada fila de ese cursor, calcular el interés y actualizar.*/

create or alter procedure interes
(
	@fecha	date
)
as
begin
/*select *
	from cuotas c
		join creditos cr
			on c.nro_credito = cr.nro_credito
	where c.fecha_vto < getdate()
	  and not exists (select *
						from det_recibos dr
					  where dr.nro_credito = c.nro_credito
					    and dr.nro_cuota   = c.nro_cuota)*/

	declare		@nro_credito			int,
				@nro_cuota				tinyint,
				@fecha_vto				date,
				@importe				decimal(9, 2),

				@porc_interes_diario	decimal(5, 2),
				@imp_interes_diario		decimal(7, 2),

				@importe_interes		decimal(9, 2),
				@nro_credito_proc		int,
				@nro_cuota_proc			tinyint



	declare cur cursor for
	select c.nro_credito, c.nro_cuota, c.fecha_vto, c.importe, cr.porc_interes_diario, cr.imp_interes_diario
	from cuotas c
		join creditos cr
			on c.nro_credito = cr.nro_credito
	where c.fecha_vto < @fecha
	  and not exists (select *
						from det_recibos dr
					  where dr.nro_credito = c.nro_credito
					    and dr.nro_cuota   = c.nro_cuota)

	open cur
		fetch cur into @nro_credito, @nro_cuota, @fecha_vto, @importe,
					   @porc_interes_diario, @imp_interes_diario

		while @@FETCH_STATUS = 0
		begin
			set @nro_credito_proc = @nro_credito
			set @nro_cuota_proc = @nro_cuota
			set @importe_interes = 0.00

			/*while @@FETCH_STATUS = 0 and @nro_credito_proc = @nro_credito and @nro_cuota_proc = @nro_cuota
			begin
				if @porc_interes_diario is not null
				begin
					set @importe_interes = @importe * @porc_interes_diario * DATEDIFF(DD, @fecha, @fecha_vto) / 100
				end

				if @imp_interes_diario is not null
				begin
					set @importe_interes = @importe * @imp_interes_diario * DATEDIFF(DD, @fecha, @fecha_vto)
				end

				update cuotas
					set fecha_interes = @fecha, imp_interes = @importe_interes
					where nro_credito = @nro_credito_proc and nro_cuota = @nro_cuota_proc

				fetch cur into @nro_credito, @nro_cuota, @fecha_vto, @importe,
							   @porc_interes_diario, @imp_interes_diario
			end*/

			if @porc_interes_diario is not null
				begin
					set @importe_interes = @importe * @porc_interes_diario * ABS(DATEDIFF(DD, @fecha, @fecha_vto)) / 100
				end

			if @imp_interes_diario is not null
			begin
				set @importe_interes = @importe * @imp_interes_diario * ABS(DATEDIFF(DD, @fecha, @fecha_vto))
			end

			update cuotas
					set fecha_interes = @fecha, imp_interes = @importe_interes
					where nro_credito = @nro_credito_proc and nro_cuota = @nro_cuota_proc
			
			fetch cur into @nro_credito, @nro_cuota, @fecha_vto, @importe,
							   @porc_interes_diario, @imp_interes_diario

		end
	close cur
	deallocate cur
end
go

execute interes @fecha = '01-07-2020'
go

update cuotas
	set fecha_interes = NULL, imp_interes = NULL;
go

insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe, fecha_interes, imp_interes)
values (101, 6, '2020-06-10', 1000.00, NULL, NULL)
go

select *
	from cuotas c
		join creditos cr
			on c.nro_credito = cr.nro_credito
	where c.fecha_vto < getdate()
	  and not exists (select *
						from det_recibos dr
					  where dr.nro_credito = c.nro_credito
					    and dr.nro_cuota   = c.nro_cuota)
go












CREATE OR ALTER PROCEDURE calcular_intereses
(
@fecha_ingresada  date
)
AS
BEGIN


declare e cursor for
SELECT c.nro_credito,c.nro_cuota,c.fecha_vto,cr.imp_interes_diario,cr.porc_interes_diario,c.importe
	FROM cuotas c
	JOIN creditos cr
	on c.nro_credito=cr.nro_credito
	where c.fecha_vto < @fecha_ingresada
	and not exists (select* from det_recibos dr
						WHERE dr.nro_credito=c.nro_credito
						and dr.nro_cuota=c.nro_cuota)


	declare @calculos table
	(
		nro_credito		integer,
		nro_cuota		tinyint,
		importe         varchar
	)
	
	
	declare @nro_credito		integer,
			@nro_cuota			tinyint,
			@fecha_vto			date,
			@imp_interes_diario decimal(7,2),
			@porc_interes_diario decimal(5,2),
			@importe			decimal(9,2),		

			@nro_credito_proc         integer,
			@nro_cuota_proc           tinyint,
			@imp_interes_diario_proc  decimal(7,2),
			@porc_interes_diario_proc decimal(5,2),
			@importe_interes_A		   decimal(7,2),
			@importe_interes_B		   decimal(5,2)

	open e
	fetch e into @nro_credito,@nro_cuota,@fecha_vto,@imp_interes_diario,@porc_interes_diario,@importe
	--tratamiento de todo el conjunto 
	while @@fetch_status = 0
	begin

			set @nro_credito_proc=@nro_credito
			set @nro_cuota_proc	 =@nro_cuota
			set @imp_interes_diario_proc=@imp_interes_diario
			set @porc_interes_diario_proc=@porc_interes_diario
			set @importe_interes_A=0
			


			--tratamiento de cada subconjunto
			while @@fetch_status = 0 and @nro_credito =@nro_credito_proc and @nro_cuota=@nro_cuota_proc
			begin
			--procesamiento

				if @imp_interes_diario_proc is not null
				begin
					set @importe_interes_A = @importe*@imp_interes_diario_proc* DATEDIFF(dd, @fecha_ingresada,@fecha_vto)/100.00
				end
				
				if @porc_interes_diario_proc is not null
				begin
					set @importe_interes_A = @importe*@porc_interes_diario_proc* DATEDIFF(dd,@fecha_ingresada,@fecha_vto )
				end

			--lectura nuevo registro
			fetch e into @nro_credito,@nro_cuota,@fecha_vto,@imp_interes_diario,@porc_interes_diario,@importe
			end

			insert into @calculos(nro_credito,nro_cuota,importe)
			values (@nro_credito_proc,@nro_cuota_proc,convert(varchar,@importe_interes_A)+'$')

			
	end
	close e
	deallocate e

	SELECT* from @calculos

END
GO



execute calcular_intereses @fecha_ingresada= '2020-07-01'
								
/*COMENTARIO, PROFE NO ME DIO EL TIEMPO PARA ACTUALZIAR LOS DATOS, LOS MOSTRE EN UNA TABLA TEMPORAL, DISCULPE*/
			
			


