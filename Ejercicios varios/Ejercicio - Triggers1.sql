alter table dbo.carreras add 
nota_minima			tinyint		not null constraint DF__carreras__nota_minima__0__END default 0,
nota_maxima			tinyint		null
go

select * from carreras

update c
   set nota_maxima = 10
  from dbo.carreras c
go

alter table dbo.carreras
drop constraint DF__carreras__nota_minima__0__END
go

alter table dbo.carreras
alter column nota_maxima tinyint not null
go

alter table dbo.carreras add
constraint CK__carreras__notas__END check (nota_maxima > nota_minima and nota_aprob_examen_final between nota_minima and nota_maxima)
go

sp_help carreras

-- REGLA DE INTEGRIDAD: la nota de los ex�menes finales debe estar dentro de los l�mites de la escala usada o ser nula

-- Paso 1: consulta de filas que no cumplen con la regla de integridad

select *
  from dbo.examenes e
       join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera
 where e.nota_examen not between c.nota_minima and c.nota_maxima

-- Paso 2: determinar tablas y operaciones que afectan la regla de integridad

------------------------------------------------------------------------------
-- TABLA     |    INSERT 	 |	  DELETE     |	  UPDATE                     |
------------------------------------------------------------------------------
-- examenes  |   controlar   |     ---       |  mod. nota    --> controlar   |
--           |               |               |  mod. carrera --> controlar   |
------------------------------------------------------------------------------
-- carreras  |     ---       |     ---       |  mod. nota min --> controlar  |
--           |               |               |  mod. nota max --> controlar  |
------------------------------------------------------------------------------

-- Se deber�n crear los siguientes triggers:
   -- insert examenes
   -- update examenes
   -- update carreras

-- Paso 3: programar los triggers

create trigger ti_ri_examenes
on examenes
for insert
as
begin
   if exists (select *
                from inserted e
                     join dbo.carreras c
	                   on e.cod_carrera = c.cod_carrera
                    where e.nota_examen not between c.nota_minima and c.nota_maxima)
      begin
	     raiserror('La nota est� fuera de rango',16,1)
		 rollback
	  end
end
go

create trigger tu_ri_examenes
on examenes
for update
as
begin
   if exists (select *
                from inserted e
                     join dbo.carreras c
	                   on e.cod_carrera = c.cod_carrera
                    where e.nota_examen not between c.nota_minima and c.nota_maxima)
      begin
	     raiserror('La nota est� fuera de rango',16,1)
		 rollback
	  end
end
go

create trigger tu_ri_carreras
on carreras
for update
as
begin
   if exists (select *
                from examenes e
                     join inserted c
	                   on e.cod_carrera = c.cod_carrera
                    where e.nota_examen not between c.nota_minima and c.nota_maxima)
      begin
	     raiserror('La escala modificada deja notas de ex�menes fuera de rango',16,1)
		 rollback
	  end
end
go

-- Paso 4: Luego de implementar los triggers controlar si la base de datos cumple 
--         con la regla de integridad a trav�s de la consulta del paso 1 y corregir 
--         los datos si fuera necesario.
