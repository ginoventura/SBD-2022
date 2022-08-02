/*
alter table dbo.matriculas 
add egresado char(1) not null default 'N' check(egresado in ('S','N'))
*/
-- 1. Programar una consulta que devuelva la información que necesitamos almacenar

select m.*,
       case when not exists (select *
                               from dbo.materias ma
							  where m.cod_carrera = ma.cod_carrera
							    and ma.optativa = 'N'
								and not exists (select *
								                  from dbo.examenes e
												 where ma.cod_carrera = e.cod_carrera
												   and ma.cod_materia = e.cod_materia
												   and m.nro_alumno   = e.nro_alumno
												   and c.nota_aprob_examen_final <= e.nota_examen))
            then 'S'
			else 'N'
	   end 
  from dbo.matriculas m
       join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
go

-- 2. Determinar las tablas y las operaciones de actualización involucradas

-----------------------------------------------------------------------------------
-- TABLA			INSERT					DELETE				UPDATE
-----------------------------------------------------------------------------------
-- matriculas		*Asegurar valor N		--					*Control
-----------------------------------------------------------------------------------
-- carreras			--						--					*Propagar/controlar
-----------------------------------------------------------------------------------
-- materias			*Propagar/controlar		--					*Propagar/controlar
-----------------------------------------------------------------------------------
-- examenes			*Propagar				*Propagar			*Propagar
-----------------------------------------------------------------------------------

-- 3. Programar triggers

create trigger ti_pa_matriculas
on dbo.matriculas
for insert
as
begin
   if exists (select *
                from inserted i
			   where i.egresado = 'S')
	  begin
	     raiserror ('El ingresante no puede ser egresado', 16, 1)
		 rollback
		 return
	  end   
end
go

insert into dbo.matriculas (nro_alumno, cod_carrera, año_ingreso, egresado)
values (6, 1, 2000, 'S')

create trigger ti_pa_examenes
on dbo.examenes
for insert
as
begin
   update m
      set egresado = case when not exists (select *
                                             from dbo.materias ma
					              	   	    where m.cod_carrera = ma.cod_carrera
							                  and ma.optativa = 'N'
								              and not exists (select *
								                                from dbo.examenes e
								           	 	               where ma.cod_carrera = e.cod_carrera
												                 and ma.cod_materia = e.cod_materia
												                 and m.nro_alumno   = e.nro_alumno
												                 and c.nota_aprob_examen_final <= e.nota_examen))
                          then 'S'
		 	              else 'N'
	                 end 
     from dbo.matriculas m
          join dbo.carreras c
	        on m.cod_carrera = c.cod_carrera
          join inserted i
		    on m.nro_alumno  = i.nro_alumno
		   and m.cod_carrera = i.cod_carrera
		   and c.nota_aprob_examen_final <= i.nota_examen
		  join dbo.materias ma1
		    on i.cod_carrera = ma1.cod_carrera
		   and i.cod_materia = ma1.cod_materia
		   and ma1.optativa  = 'N'
end
go
/*
     from dbo.matriculas m
          join dbo.carreras c
	        on m.cod_carrera = c.cod_carrera
    where exists (select *
	                from inserted i
		                 join dbo.materias ma1
		                   on i.cod_carrera = ma1.cod_carrera
		                  and i.cod_materia = ma1.cod_materia
		                  and ma1.optativa  = 'N'
		           where m.nro_alumno  = i.nro_alumno
				     and m.cod_carrera = i.cod_carrera
		             and c.nota_aprob_examen_final <= i.nota_examen)
*/

create trigger td_pa_examenes
on dbo.examenes
for delete
as
begin
   update m
      set egresado = 'N' 
     from dbo.matriculas m
          join dbo.carreras c
	        on m.cod_carrera = c.cod_carrera
          join deleted d
		    on m.nro_alumno  = d.nro_alumno
		   and m.cod_carrera = d.cod_carrera
		   and c.nota_aprob_examen_final <= d.nota_examen
		  join dbo.materias ma1
		    on i.cod_carrera = ma1.cod_carrera
		   and i.cod_materia = ma1.cod_materia
		   and ma1.optativa  = 'N'
    where m.egresado = 'S'
end
go

create trigger tu_pa_examenes
on dbo.examenes
for update
as
begin
   if update(nro_alumno) or update(cod_carrera) or update(cod_materia)
      begin
	     raiserror ('No se puede modificar el alumno, la carrera ni la materia. Elimine el examen y vuelva a registrarlo', 16, 1)
		 rollback
		 return
	  end

   update m
      set egresado = case when not exists (select *
                                             from dbo.materias ma
					              	   	    where m.cod_carrera = ma.cod_carrera
							                  and ma.optativa = 'N'
								              and not exists (select *
								                                from dbo.examenes e
								           	 	               where ma.cod_carrera = e.cod_carrera
												                 and ma.cod_materia = e.cod_materia
												                 and m.nro_alumno   = e.nro_alumno
												                 and c.nota_aprob_examen_final <= e.nota_examen))
                          then 'S'
		 	              else 'N'
	                 end 
     from dbo.matriculas m
          join dbo.carreras c
	        on m.cod_carrera = c.cod_carrera
          join inserted i
		    on m.nro_alumno  = i.nro_alumno
		   and m.cod_carrera = i.cod_carrera
		   and c.nota_aprob_examen_final <= i.nota_examen
		  join dbo.materias ma1
		    on i.cod_carrera = ma1.cod_carrera
		   and i.cod_materia = ma1.cod_materia
		   and ma1.optativa  = 'N'
end
go

create trigger tiu_pa_examenes
on dbo.examenes
for insert, update
as
begin
   if exists (select *
                from deleted d)
      and 
      (update(nro_alumno) or update(cod_carrera) or update(cod_materia))
      begin
	     raiserror ('No se puede modificar el alumno, la carrera ni la materia. Elimine el examen y vuelva a registrarlo', 16, 1)
		 rollback
		 return
	  end
   
   update m
      set egresado = case when not exists (select *
                                             from dbo.materias ma
					              	   	    where m.cod_carrera = ma.cod_carrera
							                  and ma.optativa = 'N'
								              and not exists (select *
								                                from dbo.examenes e
								           	 	               where ma.cod_carrera = e.cod_carrera
												                 and ma.cod_materia = e.cod_materia
												                 and m.nro_alumno   = e.nro_alumno
												                 and c.nota_aprob_examen_final <= e.nota_examen))
                          then 'S'
		 	              else 'N'
	                 end 
     from dbo.matriculas m
          join dbo.carreras c
	        on m.cod_carrera = c.cod_carrera
          join inserted i
		    on m.nro_alumno  = i.nro_alumno
		   and m.cod_carrera = i.cod_carrera
		   and c.nota_aprob_examen_final <= i.nota_examen
		  join dbo.materias ma1
		    on i.cod_carrera = ma1.cod_carrera
		   and i.cod_materia = ma1.cod_materia
		   and ma1.optativa  = 'N'
end
go

create trigger tu_pa_matriculas
on dbo.matriculas
for update
as
begin
   update m
      set egresado = case when not exists (select *
                                             from dbo.materias ma
					              	   	    where m.cod_carrera = ma.cod_carrera
							                  and ma.optativa = 'N'
								              and not exists (select *
								                                from dbo.examenes e
								           	 	               where ma.cod_carrera = e.cod_carrera
												                 and ma.cod_materia = e.cod_materia
												                 and m.nro_alumno   = e.nro_alumno
												                 and c.nota_aprob_examen_final <= e.nota_examen))
                          then 'S'
		 	              else 'N'
	                 end 
     from dbo.matriculas m
          join dbo.carreras c
	        on m.cod_carrera = c.cod_carrera
          join inserted i
		    on m.nro_alumno  = i.nro_alumno
		   and m.cod_carrera = i.cod_carrera
    where m.egresado != case when not exists (select *
                                             from dbo.materias ma
					              	   	    where m.cod_carrera = ma.cod_carrera
							                  and ma.optativa = 'N'
								              and not exists (select *
								                                from dbo.examenes e
								           	 	               where ma.cod_carrera = e.cod_carrera
												                 and ma.cod_materia = e.cod_materia
												                 and m.nro_alumno   = e.nro_alumno
												                 and c.nota_aprob_examen_final <= e.nota_examen))
                             then 'S'
		 	                 else 'N'
	                    end
end
go

create trigger ti_pa_materias
on dbo.materias
for insert
as
begin

   if exists (select *
                from inserted i
				     join dbo.matriculas m
					   on i.cod_carrera = m.cod_carrera
					  and m.egresado    = 'S'
			   where i.optativa = 'N')
	  begin
	     raiserror ('No se puede agregar una materia obligatoria cuando ya hay egresados en la carrera', 16, 1)
		 rollback
		 return
	  end   

end
go

create trigger tu_pa_materias
on dbo.materias
for update
as
begin
   if update(cod_carrera) or update(cod_materia)
	  begin
	     raiserror ('No se puede modificar el identificador de la materia', 16, 1)
		 rollback
		 return
	  end   

   if exists (select *
                from inserted i
				     join deleted d
					   on i.cod_carrera = d.cod_carrera
					  and i.cod_materia = d.cod_materia
				     join dbo.matriculas m
					   on i.cod_carrera = m.cod_carrera
					  and m.egresado    = 'S'
			   where i.optativa = 'N'
			     and d.optativa = 'S')
	  begin
	     raiserror ('No se puede hacer obligatoria una materia optativa cuando ya hay egresados en la carrera', 16, 1)
		 rollback
		 return
	  end   

   if exists (select *
                from inserted i
				     join deleted d
					   on i.cod_carrera = d.cod_carrera
					  and i.cod_materia = d.cod_materia
			   where i.optativa = 'S'
			     and d.optativa = 'N')
	  begin
         update m
            set egresado = case when not exists (select *
                                                   from dbo.materias ma
      					              	   	    where m.cod_carrera = ma.cod_carrera
      							                  and ma.optativa = 'N'
      								              and not exists (select *
      								                                from dbo.examenes e
      								           	 	               where ma.cod_carrera = e.cod_carrera
      												                 and ma.cod_materia = e.cod_materia
      												                 and m.nro_alumno   = e.nro_alumno
      												                 and c.nota_aprob_examen_final <= e.nota_examen))
                                then 'S'
      		 	                else 'N'
      	                   end 
           from dbo.matriculas m
                join dbo.carreras c
      	          on m.cod_carrera = c.cod_carrera
                join inserted i
      		      on m.cod_carrera = i.cod_carrera
			     and i.optativa    = 'S'
				join deleted d
				  on i.cod_carrera = d.cod_carrera
				 and i.cod_materia = d.cod_materia
			     and d.optativa    = 'N'
          where m.egresado = 'N'

	  end   

end
go

create trigger tu_pa_carreras
on dbo.carreras
for update
as
begin
   if update(cod_carrera)
	  begin
	     raiserror ('No se puede modificar el identificador de la carrera', 16, 1)
		 rollback
		 return
	  end   

   if exists (select *
                from inserted i
				     join deleted d
					   on i.cod_carrera = d.cod_carrera
				     join dbo.matriculas m
					   on i.cod_carrera = m.cod_carrera
					  and m.egresado    = 'S'
			   where i.nota_aprob_examen_final > d.nota_aprob_examen_final)
	  begin
	     raiserror ('No se puede subir la nota de aprobación de las materias cuando ya hay egresados en la carrera', 16, 1)
		 rollback
		 return
	  end   

   if exists (select *
                from inserted i
				     join deleted d
					   on i.cod_carrera = d.cod_carrera
			   where i.nota_aprob_examen_final < d.nota_aprob_examen_final)
	  begin
         update m
            set egresado = case when not exists (select *
                                                   from dbo.materias ma
      					              	   	    where m.cod_carrera = ma.cod_carrera
      							                  and ma.optativa = 'N'
      								              and not exists (select *
      								                                from dbo.examenes e
      								           	 	               where ma.cod_carrera = e.cod_carrera
      												                 and ma.cod_materia = e.cod_materia
      												                 and m.nro_alumno   = e.nro_alumno
      												                 and c.nota_aprob_examen_final <= e.nota_examen))
                                then 'S'
      		 	                else 'N'
      	                   end 
           from dbo.matriculas m
                join dbo.carreras c
      	          on m.cod_carrera = c.cod_carrera
                join inserted i
      		      on m.cod_carrera = i.cod_carrera
				join deleted d
				  on i.cod_carrera = d.cod_carrera
          where m.egresado = 'N'
		    and i.nota_aprob_examen_final < d.nota_aprob_examen_final

	  end   

end
go

-- 4. Compilar los triggers 
-- 5. Corregir la base de datos (para hacerla consistente)
 