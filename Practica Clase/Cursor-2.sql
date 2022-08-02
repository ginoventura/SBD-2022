/*------------------EJEMPLO DEL CURSOR-----------------*/
-- Mostrar nro_alumno, nom_alumno, cod_carrera, nom_carrera y promedio de los alumnos 
-- que ingresaron en 1995 y tienen promedio >= 7 y han rendido mas de 20 examenes finales
-- (no considerar los ausentes)

declare cm cursor for
	select m.nro_alumno, a.nom_alumno, m.cod_carrera, c.nom_carrera
		from dbo.matriculas m
			join dbo.alumnos a
				on m.nro_alumno = a.nro_alumno
			join dbo.carreras c
				on m.cod_carrera = c.cod_carrera
		where m.año_ingreso = 1995
order by nom_carrera, nom_alumno

declare @nro_alumno		integer,
		@nom_alumno		varchar(40),
		@cod_carrera	smallint,
		@nom_carrera	varchar(40),
		@promedio		decimal(4,2),
		@cant_rendidos	tinyint

declare @matriculas table (
		nro_alumno		integer,
		nom_alumno		varchar(40),
		cod_carrera		smallint,		
		nom_carrera		varchar(40),
		promedio		decimal(4,2),
		cant_rendidos	tinyint
)

open cm 
	fetch cm into  @nro_alumno, @nom_alumno, @cod_carrera, @nom_carrera, @promedio, @cant_rendidos
	while @@FETCH_STATUS = 0
		begin
			--PROCESAR REGISTRO DEL CURSOR
			-- Para cada registro de matriculas que lei, voy a obtener el promedio y la cant de examenes rendidos
			select @promedio = avg(e.nota_examen), @cant_rendidos = count(e.nota_examen)
				from dbo.examenes e
			where e.nro_alumno = @nro_alumno
			  and e.cod_carrera = @cod_carrera

			 if @promedio >= 7 and @cant_rendidos > 3
				begin
			insert into @matriculas (nro_alumno, cod_carrera, nom_alumno, nom_carrera, promedio, cant_rendidos)
			select @nro_alumno, @cod_carrera, @nom_alumno, @nom_carrera, @promedio, @cant_rendidos
				end

			fetch cm into @nro_alumno, @nom_alumno, @cod_carrera, @nom_carrera
		end

close cm
deallocate cm

	select * 
		from @matriculas