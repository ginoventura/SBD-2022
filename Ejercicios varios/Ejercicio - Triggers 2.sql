alter table carreras 
add cant_mat_obligatorias	tinyint	 not null	constraint DF__carreras__cant_mat_obligatorias__0__END default 0
go

-- ASEGURAR CONSISTENCIA: entre cant_mat_obligatorias y las materias obligatorias registradas

-- 1. programar una consulta que devuelva para cada carrera la cantidad de materias obligatorias

select cod_carrera, count(*)
  from dbo.materias m 
 where m.optativa = 'N'
 group by cod_carrera

-- Paso 2: determinar tablas y operaciones que afectan la regla de integridad

/*
------------------------------------------------------------------------------
   TABLA     |    INSERT 	 |	  DELETE      |	  UPDATE                     |
------------------------------------------------------------------------------
   materias    si se inserta	si se elimina     optativa    --> controlar
               una materia      una materia       cod_carrera --> controlar
			   obligatoria      obligatoria
			   --> controlar    --> controlar
------------------------------------------------------------------------------
-- insert sobre materias
-- delete sobre materias
-- update sobre materias
*/

-- 3. Crear los triggers

create trigger ti_pa_materias
on dbo.materias
for insert
as
begin
/*
   -- contando todas
   update c
      set cant_mat_obligatorias = (select count(*)
                                     from dbo.materias m 
		                            where c.cod_carrera = m.cod_carrera
                                      and m.optativa = 'N')
	 from dbo.carreras c
	      join inserted i
	        on c.cod_carrera = i.cod_carrera
*/
/*
	 from dbo.carreras c
    where exists (select *
	                from inserted i
	               where c.cod_carrera = i.cod_carrera)*/

   -- sumando las nuevas 
   update c
      set cant_mat_obligatorias = c.cant_mat_obligatorias
	                              +
								  (select count(*)
                                     from inserted m
		                            where c.cod_carrera = m.cod_carrera
                                      and m.optativa = 'N')
	 from dbo.carreras c
	      join inserted i
	        on c.cod_carrera = i.cod_carrera

end
go

create trigger td_pa_materias
on dbo.materias
for delete
as
begin
/*
   -- contando todas
   update c
      set cant_mat_obligatorias = (select count(*)
                                     from dbo.materias m 
		                            where c.cod_carrera = m.cod_carrera
                                      and m.optativa = 'N')
	 from dbo.carreras c
	      join deleted d
	        on c.cod_carrera = d.cod_carrera
*/

/*
	 from dbo.carreras c
    where exists (select *
	                from deleted d
	               where c.cod_carrera = d.cod_carrera)*/

   -- restando las eliminadas
   update c
      set cant_mat_obligatorias = c.cant_mat_obligatorias
	                              -
								  (select count(*)
                                     from deleted m
		                            where c.cod_carrera = m.cod_carrera
                                      and m.optativa = 'N')
	 from dbo.carreras c
	      join deleted d
	        on c.cod_carrera = d.cod_carrera

end
go

create trigger tu_pa_materias
on dbo.materias
for update
as
begin
   if update(cod_carrera) or update(cod_materia)
      begin
	     raiserror('No se puede modificar el identificador de la materia',16,1)
		 rollback
		 return
	  end

   -- sumando las nuevas 
   update c
      set cant_mat_obligatorias = c.cant_mat_obligatorias
	                              +
								  (select count(*)
                                     from inserted m
		                            where c.cod_carrera = m.cod_carrera
                                      and m.optativa = 'N')
	 from dbo.carreras c
	      join inserted i
	        on c.cod_carrera = i.cod_carrera

   -- restando las eliminadas
   update c
      set cant_mat_obligatorias = c.cant_mat_obligatorias
	                              -
								  (select count(*)
                                     from deleted m
		                            where c.cod_carrera = m.cod_carrera
                                      and m.optativa = 'N')
	 from dbo.carreras c
	      join deleted d
	        on c.cod_carrera = d.cod_carrera

end
go

-- 4. Después de implementar los triggers --> actualizar la tabla carreras con los datos consistentes.

   update c
      set cant_mat_obligatorias = (select count(*)
                                     from dbo.materias m 
		                            where c.cod_carrera = m.cod_carrera
                                      and m.optativa = 'N')
	 from dbo.carreras c

select *
  from carreras

-- pruebas:
---------------------------------------------------------------------------------------------------------------------------
insert into materias
values (1, 6, 'MATERIA 1-6', 5, 'N'),
       (1, 7, 'MATERIA 1-7', 5, 'S')

delete m
--select *
  from dbo.materias m
 where m.cod_carrera = 1
   and m.cod_materia = 7

delete m
--select *
  from dbo.materias m
 where m.cod_carrera = 1
   and m.cod_materia = 6

update m
   set optativa = 'N'
--select *
  from materias m
 where cod_carrera > 1
   and optativa = 'S'

insert into materias
values (1, 6, 'MATERIA 1-6', 5, 'N'),
       (1, 7, 'MATERIA 1-7', 5, 'S')

update m
   set cod_carrera = 2
--select *
  from materias m
 where cod_carrera = 1
   and cod_materia = 6

select * from carreras
select * from materias

create trigger ti_pa_materias
on dbo.materias
for insert
as
begin
   update c
      set cant_mat_obligatorias = c.cant_mat_obligatorias
	                              +
								  (select count(*)
                                     from inserted m
		                            where c.cod_carrera = m.cod_carrera
                                      and m.optativa = 'N')
	 from dbo.carreras c
	      join inserted i
	        on c.cod_carrera = i.cod_carrera

end
go

select *
  from inserted i
       join deleted d
	     on i.cod_carrera = d.cod_carrera
		and i.cod_materia = d.cod_materia

