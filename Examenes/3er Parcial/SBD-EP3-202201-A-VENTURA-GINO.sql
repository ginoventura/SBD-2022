--------------------------------------------------------------------------------------------------------------------------------------
-- INGENIERIA EN INFORMATICA - SISTEMAS DE BASES DE DATOS - EVALUACIÓN PARCIAL Nº 3 - TEMA A - 23-06-2022
--------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------ALUMNO: VENTURA GINO--------------------------------------------------------

/* -----------------------------------------------------------------------------------------------------------------------------------
   Una entidad financiera requiere la implementación de una base de datos para sistematizar la gestión de créditos.
   La información que necesita registrar es la siguiente:
   - Clientes: registra los clientes que toman créditos y los clientes que son garantes de algún crédito. Se identifican con
               un número único y su nombre también es único.
   - Creditos: registra los créditos otorgados por la entidad. El número de crédito es único y se informa el cliente
               que recibe el crédito.
   - Garantes: registra los garantes del crédito.
   - Cuotas:   registra las cuotas de cada crédito. El número de cuota es único por crédito y se informa la fecha de
               vencimiento y el importe de la misma.
   - Recibos:  registra los comprobantes de pago de cada cliente. El número de recibo es único y se informa el cliente, la
               fecha de pago y el importe pagado. Un recibo puede pagar una o varias cuotas y una cuota puede ser pagada por 
			   uno o varios recibos.
			   NOTA:Tener en cuenta que puede quedar parte del importe del recibo sin aplicar a ninguna cuota, quedando el saldo de 
			   ese recibo disponible para aplicar a alguna cuota en el futuro.
   - Cuotas pagadas (detalle de recibos): Detalla de qué manera un recibo se aplica a una o varias cuotas de créditos. 
               Se indica el recibo, la cuota a la cual se aplica y el importe que se aplica al pago de esa cuota. 
*/

drop table det_recibos
drop table recibos
drop table cuotas
drop table garantes
drop table creditos
drop table clientes
go

create table clientes
(
 nro_cliente		integer		not null,
 nom_cliente		varchar(40) not null,
 primary key (nro_cliente),
 unique (nom_cliente)
)
go

create table creditos
(
 nro_credito		integer		not null,
 nro_cliente		integer		not null,
 primary key (nro_credito),
 foreign key (nro_cliente) references clientes
)
go

create table garantes
(
 nro_credito		integer		not null,
 nro_garante		integer		not null,
 primary key (nro_credito, nro_garante),
 foreign key (nro_garante) references clientes
)
go

create table cuotas
(
 nro_credito		integer			not null,
 nro_cuota			tinyint			not null,
 fecha_vto			date			not null,
 importe			decimal(6,2)	not null,
 primary key (nro_credito, nro_cuota),
 foreign key (nro_credito) references creditos,
 check (importe > 0)
)
go

create table recibos
(
 nro_recibo			integer			not null,
 nro_cliente		integer			not null,
 fecha				date			not null,
 importe			decimal(6,2)	not null,
 primary key (nro_recibo),
 foreign key (nro_cliente) references clientes
)
go

create table det_recibos
(
 nro_recibo			integer			not null,
 nro_credito		integer			not null,
 nro_cuota			tinyint			not null,
 importe			decimal(6,2)	not null,
 primary key (nro_recibo, nro_credito, nro_cuota),
 foreign key (nro_recibo) references recibos,
 foreign key (nro_credito, nro_cuota) references cuotas,
 check (importe > 0)
)
go

insert into clientes (nro_cliente, nom_cliente)
values ( 1, 'Cliente 1'),
       ( 2, 'Cliente 2'),
       ( 3, 'Cliente 3'),
       ( 4, 'Cliente 4'),
       ( 5, 'Cliente 5'),
       (10, 'Garante 10'),
       (20, 'Garante 20'),
       (30, 'Garante 30'),
       (40, 'Garante 40'),
       (50, 'Garante 50')
go

insert into creditos (nro_credito, nro_cliente)
values (101, 1),
       (102, 1),
       (103, 1),
       (201, 2),
       (202, 2),
       (301, 3),
       (401, 4),
       (501, 5)
go

insert into garantes (nro_credito, nro_garante)
values (101, 10),
       (101, 40),

       (102, 10),

       (103, 10),

       (201, 20),
       (201, 30),
       (201, 40),

       (202, 20),

       (301, 30),

       (401, 40),

       (501, 20),
       (501, 50)
go

-- debe parte la cuota de abril (8.00) y la de mayo completa (10.00)
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe)
values (101, 1, '2022-01-10', 10.00),
       (101, 2, '2022-02-10', 10.00),
       (101, 3, '2022-03-10', 10.00),
       (101, 4, '2022-04-10', 10.00),
       (101, 5, '2022-05-10', 10.00)

-- debe la de noviembre completa (100.00)
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe)
values (102, 1, '2022-08-10', 100.00),
       (102, 2, '2022-09-10', 100.00),
       (102, 3, '2022-10-10', 100.00),
       (102, 4, '2022-11-10', 100.00)

-- no pagó ninguna
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe)
values (103, 1, '2022-10-10', 1000.00),
       (103, 2, '2022-11-10', 1000.00),
       (103, 3, '2022-12-10', 1000.00),
       (103, 4, '2023-01-10', 1000.00)

-- no pagó ninguna
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe)
values (201, 1, '2022-11-10', 200.00),
       (201, 2, '2022-12-10', 200.00),
       (201, 3, '2023-01-10', 200.00)

-- debe parte de la de octubre (175.00) y todas las restantes
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe)
values (301, 1, '2022-10-10', 300.00),
       (301, 2, '2022-11-10', 300.00),
       (301, 3, '2022-12-10', 300.00)

-- pago todo
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe)
values (401, 1, '2022-06-10', 400.00),
       (401, 2, '2022-07-10', 400.00),
       (401, 3, '2022-08-10', 400.00)

-- debe la de octubre 
insert into cuotas (nro_credito, nro_cuota, fecha_vto, importe)
values (501, 1, '2022-08-10', 500.00),
       (501, 2, '2022-09-10', 500.00),
       (501, 3, '2022-10-10', 500.00)
go

insert into recibos (nro_recibo, nro_cliente, fecha, importe)
values (10101, 1, '2022-01-10', 10.00),
       (10102, 1, '2022-02-10', 10.00),
       (10134, 1, '2022-04-10', 12.00)
go

insert into recibos (nro_recibo, nro_cliente, fecha, importe)
values (10201, 1, '2022-08-07', 150.00),
       (10211, 1, '2022-08-10', 200.00),
       (10202, 1, '2022-09-10', 100.00),
       (10203, 1, '2022-10-10', 100.00)
go

insert into recibos (nro_recibo, nro_cliente, fecha, importe)
values (30101, 3, '2022-10-10', 100.00),
       (30111, 3, '2022-10-15',  25.00)
go

insert into recibos (nro_recibo, nro_cliente, fecha, importe)
values (40101, 4, '2022-06-09', 400.00),
       (40102, 4, '2022-07-05', 400.00),
       (40103, 4, '2022-08-02', 400.00)
go

insert into recibos (nro_recibo, nro_cliente, fecha, importe)
values (50101, 5, '2022-08-10', 500.00),
       (50102, 5, '2022-09-10', 500.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (10101, 101, 1, 10.00),
       (10102, 101, 2, 10.00),
       (10134, 101, 3, 10.00),
       (10134, 101, 4,  2.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (10201, 102, 1, 40.00),
       (10211, 102, 1, 60.00),
       (10211, 102, 2, 100.00),
       (10201, 102, 3, 100.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (30101, 301, 1, 100.00),
       (30111, 301, 1, 25.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (40101, 401, 1, 400.00),
       (40102, 401, 2, 400.00),
       (40103, 401, 3, 400.00)
go

insert into det_recibos (nro_recibo, nro_credito, nro_cuota, importe)
values (50101, 501, 1, 500.00),
       (50102, 501, 2, 500.00)
go

select * from det_recibos
select * from recibos
select * from cuotas
select * from creditos
select * from clientes
select * from garantes

/* Desarrollar los siguientes ejercicios:

1. Programar todos los triggers necesarios para asegurar la siguiente regla de integridad: 

   "Ningún garante puede ser el cliente del mismo crédito"

   Para responder este punto deberá presentar lo siguiente:

   a. Consulta (select) de registros con problemas (10)

   b. Tablas, operaciones afectadas y acciones a programar presentadas en el siguiente formato: (10)

   	tabla			insert					delete					update
	------------------------------------------------------------------------------------------------------
	xxxxxxx			acción					acción					acción			
	------------------------------------------------------------------------------------------------------
	yyyyyyy			acción					acción					acción			
	------------------------------------------------------------------------------------------------------

   d. Programar triggers (30)*/

-- A)
--REGLA DE INTEGRIDAD: un garante no puede ser el cliente del mismo credito.
	select cr.nro_credito, cr.nro_cliente, g.nro_garante
		from creditos cr 
		join clientes c
		on cr.nro_cliente = c.nro_cliente
		join garantes g
		on cr.nro_credito = g.nro_credito
	where cr.nro_cliente = g.nro_garante
go

/*-- B)
--REGLA DE INTEGRIDAD: un garante no puede ser el cliente del mismo credito.
  ---------------------------------------------------------------------------------
   tabla			insert					delete					update
  ---------------------------------------------------------------------------------
  clientes			  NO					  NO					  NO 
  ---------------------------------------------------------------------------------
  garantes		      SI			          NO(FK)				  SI
  ---------------------------------------------------------------------------------
  creditos		      NO					  NO					  SI
  ---------------------------------------------------------------------------------
-- Insert en clientes: si inserto un cliente, no pasa nada por que no afecta la RI 
-- Delete en clientes: si borro un cliente, no afecta la RI
-- Update en clientes: si actualizo un cliente, no afecta la RI
-----------------------------------------------------------------------------------
-- Insert en garantes: si inserto un garante, este no debe ser igual al cliente del
-- credito
-- Delete en garantes: no deja de cumplir una regla de control algo que no existe.
-- Si el garante esta asociado a un credito, la FK no va a permitir borrarlo
-- Update en garantes: si se actualiza un garante, debemos evaluar si el nuevo 
garante no es el mismo que el cliente.
-----------------------------------------------------------------------------------
-- Insert en creditos: si inserto un credito, todavia no tiene garantes registrados
-- Delete en creditos: si borro un credito, no deja de cumplir una regla de control 
-- algo que no existe
-- Update en creditos: si se actualiza un credito, se debe comprobar que el cliente
-- no sea el mismo que el garante.
*/

-- C) Programar triggers 

-- Trigger insert-update en garantes:
if OBJECT_ID('tri_in_garantes') is not null
	drop trigger tri_in_garantes
go

create or alter trigger tri_inup_garantes
	on garantes
		for insert, update
		as
		begin
			if exists (select *
							from creditos cr 
								join clientes c
									on cr.nro_cliente = c.nro_cliente
								join inserted i
									on cr.nro_credito = i.nro_credito
							where cr.nro_cliente = i.nro_garante)
			begin
				raiserror('El garante no puede ser cliente del mismo credito', 16,1)
				rollback
				return
			end
		end
	go

-- Trigger update en creditos:
if object_id('tri_up_creditos') is not null
  drop trigger tri_up_creditos;
go

create or alter trigger tri_up_creditos
	on creditos
		for update
		as
		begin
			if exists (select *
							from inserted i
								join clientes c
									on i.nro_cliente = c.nro_cliente
								join garantes g
									on g.nro_credito = i.nro_credito
							where i.nro_cliente = g.nro_garante)
			begin
				raiserror('El garante no puede ser cliente del mismo credito', 16,1)
				rollback
				return
			end
		end
	go

insert into clientes(nro_cliente, nom_cliente)
values(6, 'Gino Ventura')

insert into creditos(nro_credito, nro_cliente)
values(601, 6)

insert into garantes(nro_credito, nro_garante)
values(601, 5)

update garantes set nro_garante=6
	where nro_credito = 601

update creditos set nro_cliente = 5
	where nro_credito = 601

--create or alter trigger tri_up_clientes
--on clientes
--for update
--as
--begin
--   if update(nro_cliente)
--      begin
--	     raiserror ('No se permite modificar el nro_cliente', 16, 1)
--		 rollback
--		 return


--	  end
--go

--create trigger tri_up_creditos
--on creditos
--for update
--as
--begin
--   if update(nro_credito) or update(nro_cliente)
--      begin
--	     raiserror ('No se permite modificar el nro_credito ni el nro_cliente', 16, 1)
--		 rollback
--		 return
--	  end
--go


--Consultas solo para ver los datos de las tablas 
select * from clientes
select * from creditos
select * from garantes
select * from recibos
select * from det_recibos
select * from cuotas
go

/*2. Programar el siguiente procedimiento almacenado (50):

   El procedimiento recibe los siguientes argumentos:

   - nro_cliente
   - fecha

   y debe devolver como resultado las cuotas de todos los créditos en los cuales ese cliente esté registrado como
   garante y que tengan saldo > 0. 
   El resultado debe mostrarse ordenado por número de crédito y número de cuota.
   La cuota estará vencida si la fecha de vencimiento es anterior a la fecha informada. Si está vencida se debe 
   mostrar 'Vencida'. Sino, 'A vencer'.
   El saldo de una cuota se calcula restando al importe de la misma la suma de pagos aplicados a dicha cuota  
   (considerar que puede haber cuotas sin pagos):

   nro_cliente	nro_credito	   nro_cuota	 fecha_vto    estado	importe_cuota		saldo_cuota
		xxxxx		xxxxxxx	     xxxx		xx/xx/xxxx	 Vencida		xxxx.xx			xxxx.xx
		xxxxx  		xxxxxxx	     xxxx		xx/xx/xxxx	 A vencer		xxxx.xx			xxxx.xx
		xxxxx  		xxxxxxx	     xxxx		xx/xx/xxxx	 A vencer		xxxx.xx			xxxx.xx
		xxxxx  		xxxxxxx	     xxxx		xx/xx/xxxx	 Vencida		xxxx.xx			xxxx.xx

*/

--Ejercicio 2)
if object_id('pa_clientegarante') is not null
  drop procedure pa_clientegarante
  go

create or alter procedure pa_clientegarante
	@nro_cliente		integer,
	@fecha				date
	as
	begin
		
		select @nro_cliente as nro_cliente, c.nro_credito, c.nro_cuota, c.fecha_vto, c.importe,
		estado = 
			case
				when @fecha < c.fecha_vto then 'A vencer'
				when @fecha > c.fecha_vto then 'Vencida'
			end
			from cuotas c
			join garantes g
				on c.nro_credito = g.nro_credito
			where g.nro_garante = @nro_cliente
			order by g.nro_credito, c.nro_cuota
	end
go

exec pa_clientegarante @nro_cliente = 10, @fecha = '2022-05-01'
go


