--Una empresa almacena los datos de sus empleados en una tabla llamada "empleados".
--1- Eliminamos la tabla, si existe y la creamos:
 if object_id('empleados') is not null
  drop table empleados;

 create table empleados(
  documento char(8),
  nombre varchar(20),
  apellido varchar(20),
  sueldo decimal(6,2),
  cantidadhijos tinyint,
  seccion varchar(20),
  primary key(documento)
 );

 insert into empleados values('22222222','Juan','Perez',300,2,'Contaduria');
 insert into empleados values('22333333','Luis','Lopez',350,0,'Contaduria');
 insert into empleados values ('22444444','Marta','Perez',500,1,'Sistemas');
 insert into empleados values('22555555','Susana','Garcia',null,2,'Secretaria');
 insert into empleados values('22666666','Jose Maria','Morales',460,3,'Secretaria');
 insert into empleados values('22777777','Andres','Perez',580,3,'Sistemas');
 insert into empleados values('22888888','Laura','Garcia',400,3,'Secretaria');

 if object_id('pa_seccion') is not null
	drop procedure pa_seccion

--4) Cree un procedimiento almacenado llamado "pa_seccion" al cual le enviamos el 
--nombre de una sección y que nos retorne el promedio de sueldos de todos los 
--empleados de esa sección y el valor mayor de sueldo (de esa sección)
create procedure pa_seccion
	@nombreseccion		varchar(20)='%',
	@promediosueldos	decimal(6,2) output,
	@sueldomayor		decimal(6,2) output
	as
		select @promediosueldos = AVG(sueldo)
		from empleados
		where seccion like @nombreseccion
		select @sueldomayor = MAX(sueldo)
		from empleados
		where seccion like @nombreseccion
go

select * from empleados
declare @ps decimal(6,2), @sm decimal(6,2)
exec pa_seccion 'Secretaria', @ps output, @sm output
select @ps as sueldopromedio, @sm as sueldomayor
go

--6- Ejecute el procedimiento "pa_seccion" sin pasar valor para el parámetro "sección".
--Luego muestre los valores devueltos por el procedimiento. Calcula sobre todos los 
--registros porque toma el valor por defecto.
declare @ps decimal(6,2), @sm decimal(6,2)
exec pa_seccion default, @ps output, @sm output
select @ps as sueldopromedio, @sm as sueldomayor
go

--7- Elimine el procedimiento almacenado "pa_sueldototal", si existe y cree un 
--procedimiento con ese nombre que reciba el documento de un empleado y retorne el 
--sueldo total, resultado de la suma del sueldo y salario por hijo, que es $200 si el 
--sueldo es menor a $500 y $100 si es mayor o igual.
if OBJECT_ID('pa_sueldototal') is not null
	drop proc pa_sueldototal
go

create procedure pa_sueldototal
	@documento				char(8),
	@sueldototal			decimal(6,2) output
	as
	select @sueldototal =
	case 
		when e.sueldo >= 500 then e.sueldo+(cantidadhijos*100)
		when e.sueldo < 500 then e.sueldo+(cantidadhijos*200)
	end
	from empleados e
	where documento like @documento
go

declare @st decimal(6,2)
exec pa_sueldototal '22777777', @st output
select @st as sueldototal;
go