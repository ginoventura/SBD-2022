CREATE OR ALTER PROCEDURE get_promedios (
@nro_alumno_sol		integer,
@cod_carrera_sol	smallint = null,
@promedio_salida	decimal(4,2) = null		output,
@cant_rendidos_sal	tinyint		 = null		output
)
AS
BEGIN
	select @promedio_salida, @cant_rendidos_sal
	
	declare cm cursor for 
		select m.nro_alumno, a.nom_alumno, m.cod_carrera, c.nom_carrera, avg(e.nota_examen), count(e.nota_examen)
			from matriculas m
				join alumnos a
					on m.nro_alumno = a.nro_alumno
				join carreras c
					on m.cod_carrera = c.cod_carrera
				join examenes e
					on m.nro_alumno = e.nro_alumno
				   and m.cod_carrera = e.cod_carrera
			where m.nro_alumno = @nro_alumno_sol
				and (									--para mostrar lo especificado o si no, mostrar todo
					m.cod_carrera = @cod_carrera_sol
					or 
					@cod_carrera_sol is null
					)
			group by m.nro_alumno, a.nom_alumno, m.cod_carrera, c.nom_carrera
		order by nom_carrera, nom_alumno

	declare @nro_alumno		integer,
			@cod_carrera	smallint,
			@nom_alumno		varchar(40),
			@nom_carrera	varchar(40),
			@promedio		decimal(4,2),
			@cant_rendidos	tinyint

	declare @matriculas table 
	(
	nro_alumno		integer,
	nom_alumno		varchar(40),
	cod_carrera		smallint,
	nom_carrera		varchar(40),
	promedio		decimal(4,2),
	cant_rendidos	tinyint
	)

	open cm

fetch cm into @nro_alumno, @nom_alumno, @cod_carrera, @nom_carrera, @promedio, @cant_rendidos	
while @@FETCH_STATUS = 0	
	begin 
		insert into @matriculas (nro_alumno, cod_carrera, nom_alumno, nom_carrera, promedio, cant_rendidos)
		select @nro_alumno, @cod_carrera, @nom_alumno, @nom_carrera, @promedio, @cant_rendidos
		fetch cm into @nro_alumno, @cod_carrera, @nom_alumno, @nom_carrera, @promedio, @cant_rendidos
	end

	deallocate cm

	--select * 
	--	from @matriculas

	select @promedio_salida = promedio,
		   @cant_rendidos_sal = cant_rendidos
END
go

execute get_promedios @nro_alumno_sol = 1, @cod_carrera_sol = null