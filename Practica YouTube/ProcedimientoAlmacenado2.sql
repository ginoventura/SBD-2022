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
 insert into empleados values('22333333','Luis','Lopez',300,0,'Contaduria');
 insert into empleados values ('22444444','Marta','Perez',500,1,'Sistemas');
 insert into empleados values('22555555','Susana','Garcia',400,2,'Secretaria');
 insert into empleados values('22666666','Jose Maria','Morales',400,3,'Secretaria');

 if object_id('pa_empleados_sueldo') is not null
  drop procedure pa_empleados_sueldo;

select * from empleados

--4) Cree un procedimiento almacenado llamado "pa_empleados_sueldo" que seleccione 
--los nombres, apellidos y sueldos de los empleados que tengan un sueldo superior o
--igual al enviado como parámetro.

create procedure pa_empleados_sueldo
	@sueldodato		decimal(6,2)
	as
		select e.nombre, e.apellido, e.sueldo
		from empleados e
		where e.sueldo >= @sueldodato
go

select * from empleados
exec pa_empleados_sueldo @sueldodato = 350

--5) Ejecute el procedimiento creado anteriormente con distintos valores:
 exec pa_empleados_sueldo 400;
 exec pa_empleados_sueldo 500;

--6) Ejecute el procedimiento almacenado "pa_empleados_sueldo" sin parámetros.
 exec pa_empleados_sueldo

 --7) Elimine el procedimiento almacenado "pa_empleados_actualizar_sueldo" si existe:
 if object_id('pa_empleados_actualizar_sueldo') is not null
  drop procedure pa_empleados_actualizar_sueldo;

--8- Cree un procedimiento almacenado llamado "pa_empleados_actualizar_sueldo" que 
--actualice los sueldos iguales al enviado como primer parámetro con el valor enviado 
--como segundo parámetro.
create procedure pa_empleados_actualizar_sueldo
	@sueldoanterior		decimal(6,2),
	@sueldonuevo		decimal(6,2)
	as
		update empleados set sueldo = @sueldonuevo
			where sueldo = @sueldoanterior
go

--9) Ejecute el procedimiento creado anteriormente y verifique si se ha ejecutado 
--correctamente exec pa_empleados_actualizar_sueldo 300,350;
select * from empleados
exec pa_empleados_actualizar_sueldo 300, 700
select * from empleados

--10) Ejecute el procedimiento almacenado "pa_empleados_actualizar_sueldo" enviando en 
--primer lugar el parámetro @sueldonuevo y en segundo lugar @sueldoanterior (parámetros por 
--nombre).
exec pa_empleados_actualizar_sueldo @sueldonuevo = 250, @sueldoanterior = 400
select * from empleados

--13- Elimine el procedimiento almacenado "pa_sueldototal", si existe:
 if object_id('pa_sueldototal') is not null
  drop procedure pa_sueldototal;

--14- Cree un procedimiento llamado "pa_sueldototal" que reciba el documento de un empleado 
--y muestre su nombre, apellido y el sueldo total (resultado de la suma del sueldo y salario 
--por hijo, que es de $200 si el sueldo es menor a $500 y $100, si el sueldo es mayor o 
--igual a $500). Coloque como valor por defecto para el parámetro el patrón "%".
create procedure pa_sueldototal
	@documento char(8)='%'
	as
		select e.nombre, e.apellido, sueldototal =
		case 
			when e.sueldo <= 500 then e.sueldo+(cantidadhijos*200)
			else e.sueldo+(cantidadhijos*100)
		end
			from empleados e
	 where documento like @documento;
go

--15- Ejecute el procedimiento anterior enviando diferentes valores:
 exec pa_sueldototal '22333333';
 exec pa_sueldototal '22444444';
 exec pa_sueldototal '22666666';