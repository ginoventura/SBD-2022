/*------------------USO DEL CURSOR-----------------*/
--drop table #matriculas
--go

-- 1er Paso: Declarar el cursor y el conjunto de datos para ese cursor
declare cm cursor for
select m.nro_alumno, m.cod_carrera, m.año_ingreso	--Conjunto de datos con el cual se construye el cursor
	from dbo.matriculas m
order by m.cod_carrera
-- El cursor se arma con el resultado de esa consulta
------------------------------------------------------------------------------------

-- 2do Paso: Declarar las variables
declare @nro_alumno		integer,
		@cod_carrera	smallint,
		@año_ingreso	smallint

create table #matriculas (		--Tabla temporal local
	nro_alumno			integer,
	cod_carrera			smallint,
	año_ingreso			smallint
)
-- Tabla local:	# una vez que se termino de ejcutar el proceso, se elimina automaticamente
-- Tabla global: ## se eliminan cuando cierro la sesion, cuando me desconecto.

declare @matriculas table(		--Variable tabla
	nro_alumno			integer,
	cod_carrera			smallint,
	año_ingreso			smallint
)

------------------------------------------------------------------------------------
-- 3er Paso: Abrir el cursor
open cm		--Se ejecuta la consulta y ya esta disponible para el uso.

-- 4to Paso: Leer un registro
fetch cm into @nro_alumno, @cod_carrera, @año_ingreso	-- Almacena los valores de las columnas del primer registro en tres variables

-- 5to Paso: Procesar el registro y luego leer el proximo, hasta que se terminen los registros
while @@FETCH_STATUS = 0	--Variable global que se pueden consultar, cuyos valores son generados por el dbms
-- Mientras la lectura de un cursor sea correcta, almaceno los datos en las 3 variables.
	begin 
		-- PROCESAR EL REGISTRO DEL CURSOR
		insert into #matriculas (nro_alumno, cod_carrera, año_ingreso)	--Tabla temporal
		--insert into @matriculas (nro_alumno, cod_carrera, año_ingreso)  Variable tabla
		select @nro_alumno, @cod_carrera, @año_ingreso --Cada vez que entramos a este ciclo, ejecutamos un select, entonces sale como resultado todas las veces
		fetch cm into @nro_alumno, @cod_carrera, @año_ingreso	--Es para modificar el valor de la fetchstatus
	end
go

--6to Paso: Cerrar el cursor
close cm

-- 7mo Paso: Eliminarlo de la memoria
deallocate cm 
------------------------------------------------------------------------------------

-- 8vo Paso: Mostrar la tabla temporal (si tenemos)
select *
	from #matriculas


/*------------------EJEMPLO DEL CURSOR-----------------*/
-- Mostrar nro_alumno, nom_alumno, cod_carrera, nom_carrera y promedio de los alumnos 
-- que ingresaron en 1995 y tienen promedio >= 7 y han rendido mas de 20 examenes finales
-- (no considerar los ausentes)

declare cm cursor for
	select m.nro_alumno, a.nom_alumno, m.cod_carrera, avg(e.nota_examen), count(e.nota_examen)
		from dbo.matriculas m
			join dbo.alumnos a
				on m.nro_alumno = a.nro_alumno
			join dbo.carreras c
				on m.cod_carrera = c.cod_carrera
			join dbo.examenes e
				on m.nro_alumno = e.nro_alumno
			   and m.cod_carrera = e.cod_carrera
		where m.año_ingreso = 1995
	group by m.nro_alumno, a.nom_alumno, m.cod_carrera, c.nom_carrera
having avg(e.nota_examen) >= 7
   and count(e.nota_examen) > 3
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
			insert into @matriculas (nro_alumno, nom_alumno, cod_carrera, nom_carrera, promedio, cant_rendidos)
			select @nro_alumno, @nom_alumno, @cod_carrera, @nom_carrera, @promedio, @cant_rendidos
			fetch cm into @nro_alumno, @nom_alumno, @cod_carrera, @nom_carrera, @promedio, @cant_rendidos
		end

close cm
deallocate cm

	select * 
		from @matriculas