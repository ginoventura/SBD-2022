drop table servicios
drop table tipos_herramientas
drop table herramientas
drop table usuarios
drop table licencias
drop table licencias_asignadas
drop table uso
go



create table servicios
(
	cod_servicio		integer		not null,
	nombre_servicio		varchar(40)	not null,
	constraint PK__servicios__END	primary key(cod_servicio)
)
go


insert into servicios(cod_servicio,nombre_servicio)
values  (1,'servicio 1'),
		(2,'servicio 2'),
		(3,'servicio 3'),
		(4,'servicio 4'),
		(5,'servicio 5')
go


create table tipos_herramientas
(
	cod_tipo_herramienta	integer		not null,
	descripcion				varchar(40)	not null,
	constraint PK__tipos_herramientas__END primary key(cod_tipo_herramienta),	
)
go

insert into tipos_herramientas(cod_tipo_herramienta,descripcion)
values  (1,'descripcion 1'),
		(2,'descripcion 2'),
		(3,'descripcion 3'),
		(4,'descripcion 4'),
		(5,'descripcion 5')
go



create table herramientas
(
	cod_tipo_herramienta		integer		not null,
	nro_herramienta				integer		not null,
	cod_servicio				integer		not null,
	cant_licencias_compradas	integer		not null,
	descripcion					varchar(40)	not null,
	
	constraint PK__herramientas__END primary key(nro_herramienta),
	constraint FK__herramientas_servicios__END foreign key(cod_servicio) references servicios,
	constraint FK__herramientas_tipos_herramientas__END foreign key(cod_tipo_herramienta) references tipos_herramientas
)
go



insert into herramientas(nro_herramienta,descripcion,cod_servicio,cant_licencias_compradas,cod_tipo_herramienta)
values  (1,'descripcion 1',1,5,1),
		(2,'descripcion 2',2,5,2),
		(3,'descripcion 3',3,5,3),
		(4,'descripcion 4',4,5,4),
		(5,'descripcion 5',5,5,5)
go



create table usuarios
(
	nro_usuario			integer		not null,
	apellido			varchar(40)	not null,
	nombre				varchar(40)	not null,
	constraint PK__alumnos__END	primary key(nro_usuario)
)
go

insert into usuarios(nro_usuario,apellido,nombre)
values  (1,'apellido 1','nombre 1'),
		(2,'apellido 2','nombre 2'),
		(3,'apellido 3','nombre 3'),
		(4,'apellido 4','nombre 4'),
		(5,'apellido 5','nombre 5')
go


create table licencias_asignadas
(
	cod_licencia		varchar(40)		not null,
	nro_usuario			integer			not null,
	nro_herramienta		integer			not null,
	fecha_hora_inicio	smalldatetime	not null,
	fecha_hora_fin		smalldatetime	not null,
	constraint PK__licencias_asignadas__END primary key(cod_licencia),
	constraint FK__licencias_asignadas_usuarios__END foreign key(nro_usuario) references usuarios,
	constraint FK__licencias_asignadas_herramientas__END foreign key(nro_herramienta) references herramientas
)
go

--set dateformat ymd

insert into licencias_asignadas(cod_licencia,nro_usuario,nro_herramienta,fecha_hora_inicio,fecha_hora_fin)
values  ('A1',1,1,'2020-12-10 10:00:00','2020-12-10 18:00:00'),
		('B2',2,2,'2020-12-10 10:00:00','2020-12-10 18:00:00'),
		('C3',3,3,'2020-12-10 10:00:00','2020-12-10 18:00:00'),
		('D4',4,4,'2020-12-10 10:00:00','2020-12-10 18:00:00'),
		('E5',5,5,'2020-12-10 10:00:00','2020-12-10 18:00:00')
go



create table uso
(
	nro_acceso			integer				not null,
	nro_herramienta		integer				not null,
	fecha_hora_acceso	smalldatetime		not null,
	nro_usuario			integer				not null,
	constraint PK__uso__END primary key (nro_acceso),
	constraint FK__uso_usuarios__END foreign key(nro_usuario) references usuarios,
	constraint FK__uso_herramientas__END foreign key(nro_herramienta) references herramientas
)
go

insert into uso(nro_acceso,nro_herramienta,fecha_hora_acceso,nro_usuario)
values  (1,1,'2020-12-10 11:00:00',1),
		(2,2,'2020-12-10 11:00:00',2),
		(3,3,'2020-12-10 11:00:00',3),
		(4,4,'2020-12-10 11:00:00',4),
		(5,5,'2020-12-10 11:00:00',5)
go



--3. Controlar que el usuario que accede a una herramienta lo haga dentro del período de vigencia de su licencia 



select *
	from uso u
		join licencias_asignadas l
			on u.nro_usuario = l.nro_usuario
			and u.nro_herramienta = l.nro_herramienta
  where (u.fecha_hora_acceso < l.fecha_hora_inicio or u.fecha_hora_acceso > fecha_hora_fin)
go
  


  
--			TABLAS						INSERT						DELETE						UPDATE
-----------------------------------------------------------------------------------------------------------------------------
--			uso							controlar					-----						controlar
-----------------------------------------------------------------------------------------------------------------------------
--			licencias_asignadas			-----						-----						controlar
-----------------------------------------------------------------------------------------------------------------------------




create or alter trigger ti_ri_uso
on uso
for insert
as
begin
	if exists(select *
				from uso u
					join licencias_asignadas l
						on u.nro_usuario = l.nro_usuario
						and u.nro_herramienta = l.nro_herramienta
			  where (u.fecha_hora_acceso < l.fecha_hora_inicio or u.fecha_hora_acceso > fecha_hora_fin))
	begin
		raiserror('Los datos ingresados causan incosistencia',16,1)
		rollback
	end
end
go



create or alter trigger tu_ri_uso
on uso
for update
as
begin
	if UPDATE(nro_herramienta)
	begin
		raiserror('No se puede modificar el numero de herramienta',16,1)
		rollback
	end

	if UPDATE(fecha_hora_acceso)
	begin
		if exists(select *
					from inserted u
						join licencias_asignadas l
							on u.nro_usuario = l.nro_usuario
							and u.nro_herramienta = l.nro_herramienta
				  where (u.fecha_hora_acceso < l.fecha_hora_inicio or u.fecha_hora_acceso > fecha_hora_fin))
		begin
			 raiserror ('Los datos modificados causan inconsistencia', 16, 1)
			 rollback
		end
	end
end
go



create or alter trigger tu_ri_licencias_asignadas
on licencias_asignadas
for update
as
begin
	if UPDATE(fecha_hora_inicio) or UPDATE(fecha_hora_fin) or UPDATE(nro_herramienta)
	begin

		if exists(select *
					from uso u
						join inserted l
							on u.nro_usuario = l.nro_usuario
							and u.nro_herramienta = l.nro_herramienta
				  where (u.fecha_hora_acceso < l.fecha_hora_inicio or u.fecha_hora_acceso > fecha_hora_fin))
		begin
			 raiserror ('Los datos modificados causan inconsistencia', 16, 1)
			 rollback
		end
	end
end
go







/*

4.	Programar un procedimiento almacenado que solicite un nro. de servicio y muestre para el último año
	(anterior al actual) el mes en el que más veces se accedió a cada herramienta del servicio y el total
	de veces que se accedió en ese mes. Ordenar por total descendente, cantidad descendente y opción ascendente

*/





create or alter procedure get_info
(
	@nro_servicio		integer
)
as
begin

	declare	@nro_herramienta		integer,
			@mes					integer,
			@total_veces			integer

	declare @resultados table
		(
				nro_herramienta			integer,
				mes						integer,
				total_veces				integer
		)


	declare cur cursor for 
		select h.nro_herramienta, MONTH(u.fecha_hora_acceso)as mes,COUNT(*) as total_veces
			from uso u
				join herramientas h
					on u.nro_herramienta = h.nro_herramienta
		  where YEAR(u.fecha_hora_acceso) = YEAR(GETDATE())
		  and h.cod_servicio = @nro_servicio
		  group by h.nro_herramienta,MONTH(u.fecha_hora_acceso)

	open cur
	fetch cur into @nro_herramienta,@mes,@total_veces
	while @@FETCH_STATUS = 0
	begin

		insert into @resultados(nro_herramienta,mes,total_veces)
		values(@nro_herramienta,@mes,@total_veces)


		fetch cur into @nro_herramienta,@mes,@total_veces		

	end

	select nro_herramienta,mes,total_veces
		from @resultados 
	  group by nro_herramienta,mes,total_veces
	  order by total_veces desc, nro_herramienta asc

close cur
deallocate cur

end
go



execute get_info @nro_servicio = 1
go
