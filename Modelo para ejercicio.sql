
drop table
drop table
drop table
drop table
drop table
drop table

create table  (


	primary key()
)
go

create table  (


	primary key(),
	unique()
)
go

create table  (


	primary key(),
	foreign key() references  (),
	check ( in ('S', 'N'))
)
go

insert into 
values (, , , ,)
go

insert into
values (, , , , )
go

select * from 
select * from 
select * from 
select * from 
select * from 
go

-- EJERCICIO )
--------------------------------------------------------------------------------------------
-- REGLA DE INTEGRIDAD: 
--------------------------------------------------------------------------------------------
--       TABLA			 |       INSERT	     |		 DELETE		 | 		UPDATE  
--------------------------------------------------------------------------------------------
-- 	
--------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------
-- Insert en :
-- Delete en :
-- Update en :
--------------------------------------------------------------------------------------------
-- Insert en :
-- Delete en :
-- Update en :
--------------------------------------------------------------------------------------------
-- Insert en :
-- Delete en :
-- Update en :
--------------------------------------------------------------------------------------------

-- Trigger insert en :
if OBJECT_ID('tri_in_') is not null
	drop trigger tri_in_
go

create or alter trigger tri_in
on 
for insert
	as
	begin
		if exists()
		begin
			raiserror('', 16, 1)
			rollback
		end
	end
go

-- Trigger update en :
if OBJECT_ID('tri_up_') is not null
	drop trigger tri_up_
go

create or alter trigger tri_up
on 
for update
	as
	begin
		if update() or update ()
		begin
			raiserror('', 16, 1)
		end
	end
go

-- Trigger insert/update en :
if OBJECT_ID('tri_inup_') is not null
	drop trigger tri_inup_

create or alter trigger tri_inup_
on 
for insert, update
	as
	begin
		if exists()
		begin
			raiserror('', 16, 1)
			rollback
		end
	end
go

--------------------------------------------------------------------------------------------
-- EJERCICIO )

create or alter procedure procedimiento
-- Variables ingresadas
(

)
as
	begin
		select * 
			from
	end

exec procedimiento
