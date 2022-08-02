-- PASOS BASICOS PARA USAR UN CURSOR:
-- 1) Declarar el cursor
declare cur cursor
	for select * from dbo.usuarios

-- 2) Abrir el cursor
open cur

-- 3) Navegar por la consulta
fetch next from cur

-- 4) Cerrar el cursor
close cur

-- 5) Liberar de memoria el cursor
deallocate cur

-- PASOS PARA USAR UN CURSOR CON VARIABLES:
-- 1) Declarar las variables necesarias
declare @codigo		int,
		@apellido	varchar(50),
		@nombre		varchar(50)

-- 2) Declarar el cursor junto con la sentencia con la que va ser utilizado
declare cursorUsuario cursor
	for select codigo_usuario, apellido_usuario, nombre_usuario 
			from usuarios
	open cursorUsuario

-- 3) Cargar los datos del cursor a las variables credas
	fetch cursorUsuario into @codigo, @apellido, @nombre

-- 4) Mientras haya datos, va a continuar avanzando y modificando
	while (@@FETCH_STATUS = 0)
		begin
			update usuarios
			set nombre_usuario = @nombre + '-Modificado'
			fetch cursorUsuario into @codigo, @apellido, @nombre
		end
	close cursorUsuarios
deallocate cursorUsuarios
go

select * from usuarios