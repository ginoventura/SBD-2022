/*
INGENIERIA INFORM�TICA � SISTEMAS DE BASES DE DATOS � EXAMEN FINAL 19-08-2020 � TEMA 2
Se necesita dise�ar e implementar una base de datos que registre el uso de las diferentes opciones de las aplicaciones implementadas con el fin de obtener informaci�n acerca del uso de cada una.
Se requerir� informaci�n sobre:
-	Tipos de aplicaciones: Ser�n identificadas con un c�digo �nico y una descripci�n. Por ejemplo: Aplicaci�n web, aplicaci�n m�vil, aplicaci�n de escritorio, etc.
-	Aplicaciones: Tendr�n un c�digo identificador, un nombre y el tipo de aplicaci�n
-	Opciones: Son las opciones programadas en las aplicaciones. Se identifican con un n�mero �nico y tienen una descripci�n. Las opciones se habilitan para una o varias aplicaciones.
-	Usuarios: Son los usuarios de las aplicaciones. Tendr�n un n�mero interno �nico, apellido y nombre
-	Sesiones: Se registran las sesiones iniciadas por cada usuario en cada aplicaci�n. Se identificar� con un valor hexadecimal �nico de 32 caracteres y tendr� la siguiente informaci�n: fecha y hora de inicio de sesi�n, fecha y hora de cierre de la sesi�n, fecha y hora del �ltimo acceso, usuario y aplicaci�n en la que se inicia la sesi�n.
-	Accesos: Registra los accesos a las diferentes opciones de las aplicaciones. Se identifican con un n�mero �nico de acceso por sesi�n, se registra la fecha y hora del acceso a la opci�n y la opci�n accedida.
Se solicita: 
1.	Dise�ar un modelo l�gico de datos para el problema (20)
2.	Implementar la base de datos (5)
3.	Controlar que la opci�n accedida corresponda a la aplicaci�n de la sesi�n desde la cual se accede y que la fecha-hora de acceso est� dentro del rango activo de la sesi�n. (20)
4.	Programar un procedimiento almacenado que muestre para el �ltimo a�o (anterior al actual) el mes en el que m�s veces se accedi� cada opci�n y el total de veces que se accedi� en ese mes. Calcular y mostrar tambi�n, para esa opci�n, la aplicaci�n a trav�s de la cual m�s veces se accedi� en ese mes y la cantidad de veces que se accedi� en ese mes desde esa aplicaci�n. Ordenar por total descendente, cantidad descendente y opci�n ascendente. (55)

Ejemplo de resultado:

OPCI�N		MES	TOTAL	APLICACI�N	CANTIDAD
Opci�n nn	12			2543		Aplicaci�n XX	1412
Opci�n tt	3			1254		Aplicaci�n YY	533
Opci�n pp	6			854			Aplicaci�n ZZ	412
Opci�n aa	8			233			Aplicaci�n VV	127
*/

drop table accesos
drop table sesiones
drop table opciones_aplicaciones
drop table aplicaciones
drop table usuarios
drop table opciones
drop table tipos_aplicaciones
go

create table tipos_aplicaciones (
	codigo_tipo_aplicacion			int			not null,
	descripcion_tipo				varchar(50) not null,

	primary key(codigo_tipo_aplicacion)
)
go

create table opciones (
	codigo_opcion					int			not null,
	descripcion_opcion				varchar(50)	not null,

	primary key(codigo_opcion)
)
go

create table usuarios (
	numero_usuario					int			not null,
	apellido_usuario				varchar(50)	not null,
	nombre_usuario					varchar(50) not null,

	primary key(numero_usuario)
)
go

create table aplicaciones (
	codigo_aplicacion				int			not null,
	codigo_tipo_aplicacion			int			not null,
	nombre_aplicacion				varchar(50) not null,

	primary key(codigo_aplicacion),
	foreign key(codigo_tipo_aplicacion)	references tipos_aplicaciones(codigo_tipo_aplicacion)
)
go

create table opciones_aplicaciones (
	codigo_aplicacion				int			not null,
	codigo_opcion					int			not null,

	primary key(codigo_aplicacion, codigo_opcion),
	foreign key(codigo_aplicacion) references aplicaciones(codigo_aplicacion),
	foreign key(codigo_opcion) references opciones(codigo_opcion)
)
go

create table sesiones (
	codigo_sesion					char(32)	not null,
	numero_usuario					int			not null,
	codigo_aplicacion				int			not null,
	fecha_hora_inicio				datetime	null,
	fecha_hora_cierre				datetime	null,
	fecha_hora_ultacceso			datetime	null,

	primary key(codigo_sesion),
	foreign key(numero_usuario)	references usuarios(numero_usuario),
	foreign key(codigo_aplicacion) references aplicaciones(codigo_aplicacion)
)
go

create table accesos (
	codigo_acceso					int			not null,
	codigo_sesion					char(32)	not null,
	codigo_opcion					int			not null,
	fecha_hora_acesso				datetime	not null,

	primary key(codigo_acceso, codigo_sesion),
	foreign key(codigo_sesion) references sesiones(codigo_sesion),
	foreign key(codigo_opcion) references opciones(codigo_opcion)
)
go

insert into tipos_aplicaciones(codigo_tipo_aplicacion, descripcion_tipo)
	values	(1, 'Descripcion 1'),
			(2, 'Descripcion 2'),
			(3, 'Descripcion 3'),
			(4, 'Descripcion 4'),
			(5, 'Descripcion 5')
go

insert into aplicaciones(codigo_aplicacion, nombre_aplicacion, codigo_tipo_aplicacion)
	values	(1, 'Nombre 1', 1),
			(2, 'Nombre 2', 2),
			(3, 'Nombre 3', 3),
			(4, 'Nombre 4', 4),
			(5, 'Nombre 5', 5)
go

insert into usuarios(numero_usuario, apellido_usuario, nombre_usuario)
	values	(1, 'Apellido 1', 'Nombre 1'),
			(2, 'Apellido 2', 'Nombre 2'),
			(3, 'Apellido 3', 'Nombre 3'),
			(4, 'Apellido 4', 'Nombre 4'),
			(5, 'Apellido 5', 'Nombre 5')
go

insert into opciones(codigo_opcion, descripcion_opcion)
	values	(1, 'Descripcion 1'),
			(2, 'Descripcion 2'),
			(3, 'Descripcion 3'),
			(4, 'Descripcion 4'),
			(5, 'Descripcion 5')
go

insert into opciones_aplicaciones(codigo_aplicacion, codigo_opcion)
	values	(1, 1),
			(2, 2),
			(3, 3),
			(4, 4),
			(5, 5)
go

set dateformat ymd

insert into sesiones(codigo_sesion, fecha_hora_inicio, fecha_hora_cierre, fecha_hora_ultacceso, numero_usuario, codigo_aplicacion)
	values	('A1', '2020-01-01 10:00:00', '2020-01-07 10:00:00', '2020-01-07 10:00:00', 1, 1),
			('B2', '2020-02-01 10:00:00', '2020-02-07 10:00:00', '2020-02-07 10:00:00', 2, 2),
			('C3', '2020-03-01 10:00:00', '2020-03-07 10:00:00', '2020-03-07 10:00:00', 3, 3),
			('D4', '2020-04-01 10:00:00', '2020-04-07 10:00:00', '2020-04-07 10:00:00', 4, 4),
			('E5', '2020-05-01 10:00:00', '2020-05-07 10:00:00', '2020-05-07 10:00:00', 5, 5),
			('F6', '2020-02-01 10:00:00', '2020-02-07 10:00:00', '2020-02-07 10:00:00', 2, 2),
			('G7', '2020-03-01 10:00:00', '2020-03-07 10:00:00', '2020-03-07 10:00:00', 3, 3),
			('H8', '2020-04-01 10:00:00', '2020-04-07 10:00:00', '2020-04-07 10:00:00', 4, 4),
			('J9', '2020-02-01 10:00:00', '2020-02-07 10:00:00', '2020-02-07 10:00:00', 2, 2),
			('K10', '2020-03-01 10:00:00', '2020-03-07 10:00:00', '2020-03-07 10:00:00', 3, 3),
			('L11', '2020-04-01 10:00:00', '2020-04-07 10:00:00', '2020-04-07 10:00:00', 4, 4)
go

insert into accesos(codigo_acceso, codigo_sesion, fecha_hora_acesso, codigo_opcion)
	values	(1, 'A1', '2020-01-07 10:00:00', 1),
			(2, 'B2', '2020-02-07 10:00:00', 2),
			(3, 'C3', '2020-03-07 10:00:00', 3),
			(4, 'D4', '2020-04-07 10:00:00', 4),
			(5, 'E5', '2020-05-07 10:00:00', 5),
			(6, 'F6', '2020-02-07 10:00:00', 2),
			(7, 'G7', '2020-03-07 10:00:00', 3),
			(8, 'H8', '2020-04-07 10:00:00', 4),
			(9, 'J9', '2020-04-07 10:00:00', 4),
			(10, 'K10', '2020-02-07 10:00:00', 2),
			(11, 'L11', '2020-03-07 10:00:00', 3)
go

select * from accesos
select * from sesiones
select * from aplicaciones
select * from usuarios
select * from opciones
select * from opciones_aplicaciones
select * from tipos_aplicaciones
go

-- EJERCICIO 3) Controlar que la opci�n accedida corresponda a la aplicaci�n de la sesi�n desde la cual se accede y 
-- que la fecha-hora de acceso est� dentro del rango activo de la sesi�n. (20)
--------------------------------------------------------------------------------------------------------------------
-- REGLA DE INTEGRIDAD: La opcion accedida debe corresponder a la aplicacion de la sesion y la fecha-hora de acceso
-- debe estar en el rango activo de la sesion.
--------------------------------------------------------------------------------------------------------------------

-- Consulta para determinar las filas que no cumplen con la R.I.

select * 
	from accesos a
		join sesiones s
			on a.codigo_sesion = s.codigo_sesion
		join opciones_aplicaciones opapp
			on s.codigo_aplicacion = opapp.codigo_aplicacion
	where a.codigo_opcion != opapp.codigo_aplicacion
	  or a.fecha_hora_acesso not between s.fecha_hora_inicio and s.fecha_hora_cierre

--------------------------------------------------------------------------------------------------------------------
	
-- Inserts para probar la consulta de la R.I.
insert into sesiones(codigo_sesion, fecha_hora_inicio, fecha_hora_cierre, fecha_hora_ultacceso, numero_usuario, codigo_aplicacion)
	values	('F6', '2020-01-01 10:00:00', '2020-01-07 10:00:00', '2020-01-07 10:00:00', 1, 1)

insert into sesiones(codigo_sesion, fecha_hora_inicio, fecha_hora_cierre, fecha_hora_ultacceso, numero_usuario, codigo_aplicacion)
	values	('G7', '2020-01-01 10:00:00', '2020-01-07 10:00:00', '2020-01-07 10:00:00', 1, 1)

insert into accesos(codigo_acceso, codigo_sesion, fecha_hora_acesso, codigo_opcion)
	values	(1, 'F6', '2020-01-07 10:00:00', 3)

insert into accesos(codigo_acceso, codigo_sesion, fecha_hora_acesso, codigo_opcion)
	values	(1, 'G7', '2022-01-07 10:00:00', 1)

--------------------------------------------------------------------------------------------------------------------
-- REGLA DE INTEGRIDAD: La opcion accedida debe corresponder a la aplicacion de la sesion y la fecha-hora de acceso
-- debe estar en el rango activo de la sesion.
--------------------------------------------------------------------------------------------------------------------
--		TABLA								INSERT				   DELETE					UPDATE
--------------------------------------------------------------------------------------------------------------------
-- ACCESOS								      SI					 NO						  SI
--------------------------------------------------------------------------------------------------------------------
-- SESIONES									  NO					 NO						  SI
--------------------------------------------------------------------------------------------------------------------
-- OPCIONES_AP							      NO					 SI						  NO
--------------------------------------------------------------------------------------------------------------------
-- Insert en accesos: si inserto un acceso, se debe controlar la regla de integridad.
-- Delete en accesos: si se elimina un acceso, no afecta la RI, por que algo que no existe no deja de 
-- cumplir una regla de control.
-- Update en accesos: si se actualiza un acceso se debe controlar que el codigo de opcion siga siendo 
-- el correcto y la fecha_hora de acceso tambien.
--------------------------------------------------------------------------------------------------------------------
-- Insert en sesiones: si se inserta una sesion, no pasa nada por que todavia no va a tener accesos asociados.
-- Delete en sesiones: no deja de cumplir una regla de control algo que no existe.
-- Update en sesiones: si se actualiza una sesion, se debe controlar que no se modifiquen las fechas_horas de inicio 
-- por una fecha_hora mayor y la fecha_hora de cierre de sesion por una fecha_hora menor ya que podria haber accesos 
-- a aplicaciones que dejen de cumplir la R.I. Por otro lado, no se debe permitir modificar el codigo de aplicacion
-- ya que tendriamos problemas con los accesos a las opciones.
--------------------------------------------------------------------------------------------------------------------
-- Insert en opciones_app: si inserto una opcion nueva, todavia no tendria ningun acceso registrado.
-- Delete en opciones_app: si borro una opcion, generaria incosistencia si tiene un acceso registrado.
-- Update en opciones_app: si se intenta actualizar un codigo_opcion o el codigo_aplicacion y tiene acceso registrado, 
-- la FK no lo permite 
-- Update para probar la FK: update opciones_aplicaciones set codigo_aplicacion = 50 where codigo_opcion = 5
-- Delete para probar la FK: delete from opciones_aplicaciones where codigo_opcion = 5
--------------------------------------------------------------------------------------------------------------------

-- Trigger insert en accesos
if OBJECT_ID('tri_in_accesos') is not null
	drop trigger tri_in_accesos
go

create or alter trigger tri_inup_accesos
	on accesos
		for insert
		as
		begin
			if exists(select * 
						from inserted a
							join sesiones s
								on a.codigo_sesion = s.codigo_sesion
							join opciones_aplicaciones opapp
								on s.codigo_aplicacion = opapp.codigo_aplicacion
						where a.codigo_opcion != opapp.codigo_aplicacion
						  or a.fecha_hora_acesso not between s.fecha_hora_inicio and s.fecha_hora_cierre)
			begin
				raiserror('Los datos ingresados no son correctos.', 16, 1)					
				rollback
				return
			end
		end
	go

-- Trigger update para accesos
if OBJECT_ID('tri_up_accesos') is not null
	drop trigger tri_up_accesos
go

create or alter trigger tri_up_accesos
	on accesos
		for update
		as
		begin
		if update(codigo_sesion)
			begin 
				raiserror('No se puede modificar el codigo de la sesion.', 16, 1)
				rollback
			end
		if update(codigo_opcion) or update(fecha_hora_acceso)
			begin 
				if exists(select * 
							from inserted a
								join sesiones s
									on a.codigo_sesion = s.codigo_sesion
								join opciones_aplicaciones opapp
									on s.codigo_aplicacion = opapp.codigo_aplicacion
							where a.codigo_opcion != opapp.codigo_aplicacion
							  or a.fecha_hora_acesso not between s.fecha_hora_inicio and s.fecha_hora_cierre)
					begin
						raiserror('Los datos actualizados son incorrectos', 16, 1)
						rollback
						return
					end
			end
		end
	go

-- Trigger update en sesiones
if OBJECT_ID('tri_up_sesiones') is not null
	drop trigger tri_up_sesiones
go

create or alter trigger tri_up_sesiones
	on sesiones
	for update
	as 
	begin
		if update(fecha_hora_inicio)
			if (select fecha_hora_inicio from inserted) > (select fecha_hora_inicio from deleted)
			begin 
				raiserror('La fecha_hora de inicio de la sesion no se puede actualizar por una fecha_hora mayor', 16, 1)
				rollback
			end
		if update(fecha_hora_cierre)
			if (select fecha_hora_cierre from inserted) < (select fecha_hora_cierre from deleted)
			begin
				raiserror('La fecha_hora de cierre de la sesi�n no se puede actualizar por una fecha_hora menor', 16, 1)
				rollback
			end
	end
go

-- Trigger delete en opciones_apps
if OBJECT_ID('tri_del_opciones_app') is not null
	drop trigger tri_del_opciones_app
go

create or alter trigger tri_del_opciones_app
	on opciones_aplicaciones
	for delete
	as 
	begin
		if exists(select * 
					from accesos a
						join sesiones s
							on a.codigo_sesion = s.codigo_sesion
						join deleted opapp
							on s.codigo_aplicacion = opapp.codigo_aplicacion
					where a.codigo_opcion != opapp.codigo_aplicacion
					  or a.fecha_hora_acesso not between s.fecha_hora_inicio and s.fecha_hora_cierre)
			begin
			raiserror('No se pueden eliminar estos datos.', 16, 1)
			rollback
			end
	end
go

-----------------------------------------------------------------------------------------------------------------------
-- EJERCICIO 4) Programar un procedimiento almacenado que muestre para el �ltimo a�o (anterior al actual) el mes en el 
-- que m�s veces se accedi� cada opci�n y el total de veces que se accedi� en ese mes. Calcular y mostrar tambi�n, para 
-- esa opci�n, la aplicaci�n a trav�s de la cual m�s veces se accedi� en ese mes y la cantidad de veces que se accedi� en 
-- ese mes desde esa aplicaci�n. Ordenar por total descendente, cantidad descendente y opci�n ascendente. (55)
/* Ejemplo de resultado:
-----------------------------------------------------------------------------------------------------------------------
-- OPCI�N		MES			TOTAL			APLICACI�N				CANTIDAD
-- Opci�n nn	12			2543			Aplicaci�n XX			1412
-- Opci�n tt	3			1254			Aplicaci�n YY			533
-- Opci�n pp	6			854				Aplicaci�n ZZ			412
-- Opci�n aa	8			233				Aplicaci�n VV			127 */
-----------------------------------------------------------------------------------------------------------------------

create or alter procedure procedimiento
	as 
	begin

	-- 1) Variables que se utilizan en el cursor: (datos que se piden)
	declare @opcion					int,
			@mes					int,
			@veces					int,
			@cod_aplicacion			int,
			@cantidad_aplicacion	int

	-- 2) Tabla para almacenar los resultados
	declare @resultados	table (
		opcion						int, 
		mes							int,
		veces						int,
		aplicacion					int,
		cantidad_aplicacion			int
	)

	-- 3) Declarar el cursor
	declare cur cursor for

	-- 4) Realizar consulta para el cursor
	select a.codigo_opcion, DATEPART(MM, a.fecha_hora_acesso), COUNT(*)
		from accesos a
	group by a.codigo_opcion, a.fecha_hora_acesso

	-- 5) Abrir el cursor para las variables que se obtienen del select de arriba
	open cur
	fetch cur into @opcion, @mes, @veces

	while @@FETCH_STATUS = 0
	begin

	-- 6) Insertamos los datos en la tabla de @resultados
	insert into @resultados(opcion, mes, veces)
	values(@opcion, @mes, @veces)

	-- 7) Declaramos otro cursor para los otros dos datos que faltan
	declare curs cursor for

	-- 8) Relizar consulta para el segundo cursor y los otros datos faltantes(aplicacion y cant_aplicacion)
	select s.codigo_aplicacion, COUNT(*) 
		from accesos a 
			join sesiones s
				on a.codigo_sesion = s.codigo_sesion
		where DATEPART(MM, a.fecha_hora_acesso) = @mes		--donde el mes de la aplicacion sea el mismo al mes ya en la tabla resultados
		  and a.codigo_opcion = @opcion						--y la aplicacion haya accedido a esa opcion
	group by s.codigo_aplicacion, a.codigo_opcion

	-- 9) Abrimos el segundo cursor 
	open curs

	while @@FETCH_STATUS = 0
	begin 
	
	-- 10) Navegamos por la consulta actualizando el valor de la cantidad_aplicacion
		fetch curs into @cod_aplicacion, @cantidad_aplicacion
		update r
			set aplicacion = @cod_aplicacion,
			    cantidad_aplicacion = @cantidad_aplicacion	
		from @resultados r
		where @opcion = opcion
	    and isnull(cantidad_aplicacion,0) < @cantidad_aplicacion
	end

	-- 11) Cerramos el segundo cursor y lo liberamos de memoria
	close curs
	deallocate curs

	-- 12) Recorrer el cursor 
	fetch cur into @opcion, @mes, @veces

	end

	-- 13) Seleccionar los datos de la tabla de resultados
	select opcion as OPCI�N, mes as MES, max(veces) as TOTAL_MES, aplicacion as APLICACI�N, MAX(cantidad_aplicacion) as TOTAL_APP 
		from @resultados
	group by opcion, mes, aplicacion
	order by TOTAL_MES desc, TOTAL_APP desc, opcion asc 

	close cur
	deallocate cur
end
go

execute procedimiento

-----------------------------------------------------------------------------------------------------------------------------------
-- Intento de solucion sin cursor
-----------------------------------------------------------------------------------------------------------------------------------
	-- Seleccionar y contar el uso de las opciones por mes
	select a.codigo_opcion as OPCI�N, DATENAME(MM, a.fecha_hora_acesso) as MES, COUNT(*) as TOTAL 
		from accesos a
		group by a.codigo_opcion, a.fecha_hora_acesso
go
union
	-- Seleccionar y contar el acceso de cada aplicacion por mes a cada opcion
	select ap.nombre_aplicacion as APLICACI�N, DATENAME(MM, a.fecha_hora_acesso) as MES, COUNT(*) as CANTIDAD_APLICACI�N
		from accesos a
			join sesiones s
				on a.codigo_sesion = s.codigo_sesion
			join aplicaciones ap
				on s.codigo_aplicacion = ap.codigo_aplicacion
		group by ap.nombre_aplicacion, a.fecha_hora_acesso
		order by ap.nombre_aplicacion desc
go

			





