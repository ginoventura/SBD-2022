create procedure dbo.get_prom_aus_alumnos_merge
as
begin
	declare @nro_alumno_m	integer,
			@cod_carrera_m	smallint,
			@fetch_status_m	smallint,
			@nro_alumno_e	integer, 
			@cod_carrera_e  smallint,
			@nota_e			decimal(4,2), 
			@fetch_status_e smallint,
			@cant_ausentes	smallint,
			@suma_notas		decimal(6,2),
			@promedio		decimal(4,2),
			@cant_pres		smallint
	
	declare @resultados table
	(
		nro_alumno		integer			not null,
		cod_carrera		smallint		not null,
		promedio		decimal(4,2)	null,
		cant_ausentes	smallint		not null
	)
	
	declare m insensitive cursor for 
	 select nro_alumno, cod_carrera 
	   from dbo.matriculas 
      order by nro_alumno, cod_carrera

	declare e insensitive cursor for 
     select nro_alumno, cod_carrera, nota_examen
	   from dbo.examenes e
	  order by nro_alumno, cod_carrera, nota_examen
	
	open m
	open e
	
	fetch m into @nro_alumno_m, @cod_carrera_m
	set @fetch_status_m = @@fetch_status
	fetch e into @nro_alumno_e, @cod_carrera_e, @nota_e
	set @fetch_status_e = @@fetch_status

	while @fetch_status_m = 0 -- hay más matrículas?
	begin
		set @cant_ausentes = 0 
		
		if @fetch_status_e = 0 and @nro_alumno_e = @nro_alumno_m and @cod_carrera_e = @cod_carrera_m -- hay exámenes para esa matrícula
		   begin
			  set @suma_notas = 0
			  set @cant_pres = 0
			  while @fetch_status_e = 0 and @nro_alumno_e = @nro_alumno_m and @cod_carrera_e = @cod_carrera_m -- hay más exámenes para esa matrícula
			  begin
   	 	  	     if @nota_e is NULL --es un ausente?
				    begin
				   	   set @cant_ausentes = @cant_ausentes + 1
				    end
				 else
				    begin
					    set @suma_notas = @suma_notas + @nota_e
						set @cant_pres = @cant_pres + 1
					end
    	   	     fetch e into @nro_alumno_e, @cod_carrera_e, @nota_e 
				 set @fetch_status_e = @@fetch_status
			  end
			  set @promedio = case when @cant_pres > 0 then @suma_notas / @cant_pres else null end
		   end
		else
		   begin
		      set @promedio = null
		   end
		
		insert into @resultados (nro_alumno,cod_carrera, promedio, cant_ausentes)
		values(@nro_alumno_m, @cod_carrera_m, @promedio, @cant_ausentes)

		fetch m into @nro_alumno_m, @cod_carrera_m
   	    set @fetch_status_m = @@fetch_status
	
	end
	deallocate e
	deallocate m
	
	select * 
	  from @resultados 
	 order by nro_alumno, cod_carrera
end
go


execute dbo.get_prom_aus_alumnos_merge
go





