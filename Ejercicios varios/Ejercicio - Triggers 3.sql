alter table materias add
 trabajo_final	bit		not null constraint DF__materias__trabajo_final__0__END  default 0
go
select * from materias m

-- REGLA DE INTEGRIDAD: Cada carrera debe tener una y solo una materia que es un trabajo final
-----------------------------------------------------------------------------------------------------
-- 1. Determinar filas que no cumplen con la regla de integridad
-----------------------------------------------------------------------------------------------------
select m.cod_carrera, count(case when trabajo_final = 1 then 1 else null end)
  from dbo.materias m
  group by m.cod_carrera
 having count(case when trabajo_final = 1 then 1 else null end) != 1

-----------------------------------------------------------------------------------------------------
-- 2. Determinar qué triggers tengo que programar
-----------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- tabla						insert						delete						update
-------------------------------------------------------------------------------------------------------------------
-- materias						SI							SI (si se elimina el TF)	SI
-------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-- 3. Programar los triggers
-----------------------------------------------------------------------------------------------------
CREATE TRIGGER dbo.ti_ri_materias
ON dbo.materias
FOR insert
AS
BEGIN
   IF EXISTS (select m.cod_carrera
                from materias m
			   where exists (select *
			                   from inserted i
							  where m.cod_carrera = i.cod_carrera)
               group by m.cod_carrera
              having count(case when trabajo_final = 1 then 1 else null end) != 1)
      BEGIN
         RAISERROR('La carrera solo puede tener uno y solo un trabajo final', 16, 1)
		 ROLLBACK
		 RETURN
	  END
/*
   IF EXISTS (select m.cod_carrera
                from materias m
				     join inserted i
					   on m.cod_carrera = i.cod_carrera
               group by m.cod_carrera
              having count(distinct case when trabajo_final = 1 then m.cod_materia else null end) != 1)
      BEGIN
         RAISERROR('La carrera solo puede tener uno y solo un trabajo final', 16, 1)
		 ROLLBACK
		 RETURN
	  END
*/
END
GO

CREATE TRIGGER dbo.tu_ri_materias
ON dbo.materias
FOR update
AS
BEGIN
/*
   -- SI ESTAMOS SEGUROS QUE NO SE PUEDE MODIFICAR MÁS DE UNA FILA POR OPERACIÓN UPDATE
   IF @@rowcount > 1
      BEGIN
         RAISERROR('No se pueden actualizar más de una fila a la vez', 16, 1)
		 ROLLBACK
		 RETURN
	  END

   IF update(cod_carrera)
      BEGIN
         RAISERROR('No se puede modificar la carrera de la materia', 16, 1)
		 ROLLBACK
		 RETURN
	  END

   IF update (carrera)
      and 
	  (
	   exists (select *
                 from deleted d
		 	    where trabajo_final = 1)
	   or
	   exists (select *
                 from inserted i
		 	    where trabajo_final = 1)
	  )
      BEGIN
         RAISERROR('No se puede modificar la carrera de la materia si es un trabajo final o pasa a ser un trabajo final', 16, 1)
		 ROLLBACK
		 RETURN
	  END

   IF update(trabajo_final)
      BEGIN
         RAISERROR('La carrera solo puede tener uno y solo un trabajo final', 16, 1)
		 ROLLBACK
		 RETURN
	  END
*/

   IF EXISTS (select m.cod_carrera
                from materias m
			   where (
			          exists (select *
			                    from inserted i
						  	   where m.cod_carrera = i.cod_carrera)
					  or
					  exists (select *
			                    from deleted d
							   where m.cod_carrera = d.cod_carrera)
                     )
			   group by m.cod_carrera
              having count(case when trabajo_final = 1 then 1 else null end) != 1)
      BEGIN
         RAISERROR('La carrera solo puede tener uno y solo un trabajo final', 16, 1)
		 ROLLBACK
		 RETURN
	  END

END
GO

CREATE TRIGGER dbo.td_ri_materias
ON dbo.materias
FOR delete
AS
BEGIN
   IF EXISTS (select m.cod_carrera
                from materias m
			   where exists (select *
			                   from deleted d
							  where m.cod_carrera   = d.cod_carrera
							    and d.trabajo_final = 1)
               group by m.cod_carrera
              having count(case when trabajo_final = 1 then 1 else null end) != 1)
      BEGIN
         RAISERROR('La carrera solo puede tener uno y solo un trabajo final', 16, 1)
		 ROLLBACK
		 RETURN
	  END

END
GO

CREATE TRIGGER dbo.tiud_ri_materias
ON dbo.materias
FOR insert, update, delete
AS
BEGIN

   IF EXISTS (select m.cod_carrera
                from materias m
			   where (
			          exists (select *
			                    from inserted i
						  	   where m.cod_carrera = i.cod_carrera)
					  or
					  exists (select *
			                    from deleted d
							   where m.cod_carrera = d.cod_carrera)
                     )
			   group by m.cod_carrera
              having count(case when trabajo_final = 1 then 1 else null end) != 1)
      BEGIN
         RAISERROR('La carrera solo puede tener uno y solo un trabajo final', 16, 1)
		 ROLLBACK
		 RETURN
	  END

END
GO


-----------------------------------------------------------------------------------------------------
-- 4. Programar la adecuación de los datos a la nueva regla de integridad
-----------------------------------------------------------------------------------------------------
select *
  from dbo.carreras

select *
  from dbo.materias m
 order by cod_carrera, convert(tinyint, cod_materia)

update m  
   set trabajo_final = 1
--select *
  from dbo.materias m
 where m.nom_materia in ('MATERIA 1-10','MATERIA 2-5','MATERIA 3-5')
 


-----------------------------------------------------------------------------------------------------
insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa, trabajo_final)
values (1, '11', 'MATERIA 1-11', 5, 'N', 1)

delete m 
  from materias m
 where m.cod_carrera = 1
   and m.cod_materia = '10'

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



