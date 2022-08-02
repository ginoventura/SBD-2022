-- EJEMPLO 1)

drop function dbo.funcion_de_promedio

create function funcion_de_promedio 
(	
	--Parametros de entrada
	@valor1 decimal(4,2),			
	@valor2 decimal(4,2)
)
--Tipo de dato que va a devolver la funcion
returns decimal(6,2)
as
	--Cuerpo de la funcion
	begin
		--Variables locales
		declare @resultado decimal(6,2)
		set @resultado = (@valor1 + @valor2)/2
		--Resultado que devuelve la funcion
		return @resultado
	end
go

select dbo.funcion_de_promedio(10,30) as promedio


