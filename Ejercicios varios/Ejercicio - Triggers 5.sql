alter table carreras add
 cant_materias	tinyint		not null constraint DF__carreras__cant_materias__0__END  default 0
go

select * from carreras

-- DATO REDUNDANTE: cant_materias
-----------------------------------------------------------------------------------------------------
-- 1. Determinar el valor que tiene la columna redundante
-----------------------------------------------------------------------------------------------------
select c.cod_carrera, c.nom_carrera, count(*) cant_materias
  from dbo.carreras c
       join dbo.materias m
	     on c.cod_carrera = m.cod_carrera
  group by c.cod_carrera, c.nom_carrera

-----------------------------------------------------------------------------------------------------
-- 2. Determinar qué triggers tengo que programar
-----------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- tabla						insert						delete						update
-------------------------------------------------------------------------------------------------------------------
-- carreras						SI							NO							SI
-------------------------------------------------------------------------------------------------------------------
-- materias						SI							SI							SI (se modifica cod_carrera)
-------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-- 3. Programar los triggers
-----------------------------------------------------------------------------------------------------
CREATE TRIGGER dbo.ti_ri_materias
ON dbo.materias
FOR insert
AS
BEGIN

   update c
      set cant_materias = cant_materias + (select count(*)
	                                         from inserted i1
                                            where c.cod_carrera = i1.cod_carrera)
     from dbo.carreras c
    where exists (select *
	                from inserted i
	               where c.cod_carrera = i.cod_carrera)

/*
   update c
      set cant_materias = (select count(*)
	                         from materias m
                            where c.cod_carrera = m.cod_carrera)
     from dbo.carreras c
    where exists (select *
	                from inserted i
	               where c.cod_carrera = i.cod_carrera)
*/

END
GO

CREATE TRIGGER dbo.td_ri_materias
ON dbo.materias
FOR delete
AS
BEGIN

   update c
      set cant_materias = cant_materias - (select count(*)
	                                         from deleted d1
                                            where c.cod_carrera = d1.cod_carrera)
     from dbo.carreras c
    where exists (select *
	                from deleted d
	               where c.cod_carrera = d.cod_carrera)

/*
   update c
      set cant_materias = (select count(*)
	                         from materias m
                            where c.cod_carrera = m.cod_carrera)
     from dbo.carreras c
    where exists (select *
	                from deleted d
	               where c.cod_carrera = d.cod_carrera)
*/

END
GO

CREATE TRIGGER dbo.tu_ri_materias
ON dbo.materias
FOR update
AS
BEGIN

   if update (cod_carrera)
      BEGIN
         RAISERROR('El código de la carrera no se puede modificar', 16, 1)
		 ROLLBACK
		 RETURN
	  END

/*
   update c
      set cant_materias = cant_materias + (select count(*)
	                                         from inserted i1
                                            where c.cod_carrera = i1.cod_carrera)
     from dbo.carreras c
    where exists (select *
	                from inserted i
	               where c.cod_carrera = i.cod_carrera)

   update c
      set cant_materias = cant_materias - (select count(*)
	                                         from deleted d1
                                            where c.cod_carrera = d1.cod_carrera)
     from dbo.carreras c
    where exists (select *
	                from deleted d
	               where c.cod_carrera = d.cod_carrera)
*/

/*
   update c
      set cant_materias = cant_materias + (select count(*)
	                                         from inserted i1
                                            where c.cod_carrera = i1.cod_carrera)
										- (select count(*)
	                                         from deleted d1
                                            where c.cod_carrera = d1.cod_carrera)
     from dbo.carreras c
    where exists (
	              select *
	                from inserted i
	               where c.cod_carrera = i.cod_carrera)
				  or
                  (select *
	                 from deleted d
	                where c.cod_carrera = d.cod_carrera)
				 )

*/

END
GO

CREATE TRIGGER dbo.ti_ri_carreras
ON dbo.carreras
FOR insert
AS
BEGIN

   update c
      set cant_materias = 0
     from dbo.carreras c
          join inserted i
            on c.cod_carrera = i.cod_carrera
	where c.cant_materias != 0

END
GO

CREATE TRIGGER dbo.tu_ri_carreras
ON dbo.carreras
FOR update
AS
BEGIN

   update c
      set cant_materias = (select count(*)
	                         from materias m
                            where c.cod_carrera = m.cod_carrera)
     from dbo.carreras c
          join inserted i
            on c.cod_carrera = i.cod_carrera
    where c.cant_materias != (select count(*)
  	                            from materias m
                               where c.cod_carrera = m.cod_carrera)

END
GO

-----------------------------------------------------------------------------------------------------
-- 4. Programar la adecuación de los datos a la nueva regla de integridad
-----------------------------------------------------------------------------------------------------

update c
   set cant_materias = 23
  from dbo.carreras c
 where cod_carrera = 1

select *
  from dbo.carreras c

   update c
      set cant_materias = (select count(*)
	                         from materias m
                            where c.cod_carrera = m.cod_carrera)
     from dbo.carreras c
 
 
-----------------------------------------------------------------------------------------------------
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa, trabajo_final)
values (1, '11', 'MATERIA 1-11', 5, 'N', 0)

delete m 
  from materias m
 where m.cod_carrera = 1
   and m.cod_materia = '11'

update m
   set trabajo_final = 1
  from materias m
 where m.cod_carrera = 1
   and m.cod_materia = '9'

update m
   set trabajo_final = 0
  from materias m
 where m.cod_carrera = 1
   and m.cod_materia = '10'

insert into carreras (cod_carrera, nom_carrera, nota_aprob_examen_final, nota_minima, nota_maxima)
values (4,	'CARRERA 4', 4,	0,	10)

insert into carreras (cod_carrera, nom_carrera, nota_aprob_examen_final, nota_minima, nota_maxima, cant_materias)
values (5,	'CARRERA 5', 4,	0,	10, 5)

select *
  from carreras c
 
   
