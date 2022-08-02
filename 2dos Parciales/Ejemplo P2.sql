create table tipos_eventos
(cod_tipo_evento	varchar(20)	not null,
 desc_tipo_evento	varchar(20)	not null,
 constraint PK__tipos_eventos__END	primary key (cod_tipo_evento),
 constraint UK__tipos_eventos__END	unique	(desc_tipo_evento)
)
go

create table eventos
(nro_evento			smallint		not null,
 nom_evento			varchar(20)		not null,
 cod_tipo_evento	varchar(20)		not null,
 fecha				date			not null,
 hora_inicio		time			not null,
 hora_fin			time			not null,
 costo				decimal(10,2)	null,
 constraint PK__eventos__END				primary key (nro_evento),
 constraint	UK__eventos__END				unique		(nom_evento),
 constraint FK__eventos__tipos_eventos__END	foreign key (cod_tipo_evento) references tipos_eventos,

 constraint CK__eventos__nro_evento__END	check (nro_evento>0),
 constraint CK__eventos__hora_fin__END		check(hora_fin>hora_inicio),
 constraint CK__eventos__costo__END			check(costo>0 or costo is null)
)
go

create table empresas
(nro_empresa	smallint	not null,
 nom_empresa	varchar(20)	not null,
 direccion		varchar(20)	not null,
 telefono		varchar(20)	not null,
 email			varchar(20)	not null,
 constraint PK__empresas__END	primary key (nro_empresa),
 constraint UK__empresas__END	unique(nom_empresa),
 constraint CK__empresas__nro_empresa__END check (nro_empresa>0)
)
go

create table empresas_eventos
(nro_evento				smallint	not null,
 nro_empresa			smallint	not null,
 cod_tipo_participacion	char(1)		not null,
 constraint PK__empresas_eventos__END	primary key (nro_evento,nro_empresa),
 constraint FK__empresas_eventos__empresas__END foreign key (nro_empresa) references empresas,
 constraint FK__empresas_eventos__eventos__END	foreign key (nro_evento) references eventos,

 constraint CK__empresas_eventos__cod_tipo_participacion__END	check (cod_tipo_participacion in ('O','S')),
 constraint CK__empresas_eventos__nro_evento__END check (nro_evento>0),
 constraint CK__empresas_eventos__nro_empresa__END check (nro_empresa>0)
)
go

create table tipos_documentos
(cod_tipo_documento		varchar(20)	not null,
 desc_tipo_documento	varchar(20)	not null,
 constraint PK__tipos_documentos__END	primary key (cod_tipo_documento),
 constraint UK__tipos_documentos__END	unique	(desc_tipo_documento)
)
go

create table personas
(cod_tipo_documento	varchar(20)	not null,
 nro_documento		integer		not null,
 apellido			varchar(20)	not null,
 nombre				varchar(20)	not null,
 telefono			varchar(20)	not null,
 email				varchar(20)	not null,
 constraint PK__personas__END	primary key (cod_tipo_documento,nro_documento),
 constraint FK__personas__tipos_documentos__END foreign key (cod_tipo_documento) references tipos_documentos,

 constraint CK__personas__nro_documento__END	check (nro_documento>0)
)
go

create table inscriptos
(nro_evento			smallint	not null,
 cod_tipo_documento	varchar(20)	not null,
 nro_documento		integer		not null,
 fecha_inscripcion	date		not null,
 invitado			char(1)		not null,
 baja				char(1)		not null,
 nro_recibo			smallint	null,
 fecha_pago			date		null,
 asistio			char(1)		null,
 constraint PK__inscriptos__END	primary key (nro_evento,cod_tipo_documento,nro_documento),
 constraint FK__inscriptos__personas__END	foreign key (cod_tipo_documento,nro_documento) references personas,
 constraint FK__inscriptos__eventos__END	foreign key (nro_evento) references eventos,

 constraint CK__inscriptos__nro_evento__END		check (nro_evento>0),
 constraint CK__inscriptos__nro_documento__END	check (nro_documento>0),
 constraint CK__inscriptos__nro_recibo__END		check (nro_recibo>0),
 constraint CK__inscriptos__invitado__END		check (invitado in ('S','N')),
 constraint CK__inscriptos__baja__END			check (baja in ('S','N')),
 constraint CK__inscriptos__asistio__END		check (asistio in ('S','N')),
 constraint CK__inscriptos__invitado_pago__END	check ((nro_recibo is null and fecha_pago is null and invitado='S')
													   or (nro_recibo is not null and fecha_pago is not null	and invitado='N' and baja='N')
													   or (invitado='N' and nro_recibo is null and fecha_pago is null and asistio is null))
)
go


insert into tipos_eventos (cod_tipo_evento,desc_tipo_evento)
					values(	1			  ,'BODA'),
						  ( 2			  ,'CUMPLE'),
						  ( 3			  ,'REUNION'),
						  ( 4			  ,'SOLIDARIO')
go

insert into eventos (nro_evento, nom_evento, cod_tipo_evento, fecha        ,hora_inicio, hora_fin, costo)
values				(1		   , 'AAAAAA'  , 1				, '2015-07-20' , '20:00'   , '23:00' , 2000),
					(2		   , 'BBBBBB'  , 4				, '2014-08-15' , '16:00'   , '22:00' , null),
					(3		   , 'CCCCCC'  , 2				, '2016-10-20' , '18:00'   , '23:59' , 100 ),
					(4		   , 'DDDDDD'  , 3				, '2018-04-14' , '19:00'   , '23:00' , 500 )
go


insert into empresas(nro_empresa,nom_empresa,direccion,telefono,email)
values				(1			,'EMPRESA A','AV. AAA',11111111,'A@gmail.com'),
					(2			,'EMPRESA B','AV. BBB',22222222,'B@gmail.com'),
					(3			,'EMPRESA C','AV. CCC',33333333,'C@gmail.com'),
					(4			,'EMPRESA D','AV. DDD',44444444,'D@gmail.com'),
					(5			,'EMPRESA E','AV. EEE',55555555,'E@gmail.com')
go

insert into empresas_eventos(nro_evento,nro_empresa,cod_tipo_participacion)
values						(1		   , 1		   , 'S'				  ),
							(1		   , 2		   , 'O'				  ),
							(2		   , 3		   , 'O'				  ),
							(2		   , 4		   , 'S'				  ),
							(3		   , 5		   , 'O'			      )
go

insert into tipos_documentos(cod_tipo_documento, desc_tipo_documento)
values						(1				   , 'DNI'				),
							(2				   , 'PASAPORTE'		),
							(3				   , 'LICENCIA DE CONDUCIR')
go

insert into personas(cod_tipo_documento,nro_documento,nombre,apellido,telefono,email)
values				(1				   ,11111111	 ,'AAAA','AAAAAA',11111111,'PA@gmail.com'),
					(1				   ,22222222	 ,'BBBB','BBBBBB',22222222,'PB@gmail.com'),
					(2				   ,33333333	 ,'CCCC','CCCCCC',33333333,'PC@gmail.com'),
					(3				   ,44444444	 ,'DDDD','DDDDDD',44444444,'PD@gmail.com'),
					(2				   ,55555555	 ,'EEEE','EEEEEE',55555555,'PE@gmail.com')
go

insert into inscriptos(nro_evento,cod_tipo_documento,nro_documento,fecha_inscripcion,invitado,baja,nro_recibo,fecha_pago	,asistio)
values			      (1		 ,1					,11111111	  ,'2015-03-20'	    ,'S'     ,'N' ,null		 ,null			,'S'),
					  (2		 ,1					,11111111	  ,'2015-03-20'		,'N'	 ,'N' ,2222		 ,'2015-03-20'	,'S'),
					  (1		 ,1					,22222222	  ,'2015-07-19'		,'N'	 ,'S' ,null		 ,null			,null),
					  (2		 ,2					,33333333	  ,'2014-08-14'		,'S'	 ,'N' ,null		 ,null			,'N'),
					  (4		 ,1					,11111111	  ,'2018-02-01'		,'N'	 ,'N' ,1111		 ,'2018-01-01'	,'S'),
					  (4		 ,3					,44444444	  ,'2018-02-01'		,'S'	 ,'N',null		 ,null			,'N'),
					  (4		 ,2					,55555555	  ,'2018-03-02'		,'N'	 ,'N', 5555		 ,'2018-03-02'	,'S'),
					  (1		 ,3					,44444444	  ,'2015-02-02'		,'N'	 ,'N', 4444		 ,'2015-03-02'	,'S')


-- a.	Cantidad de inscriptos confirmados y cantidad de inscriptos que han asistido a los eventos del 14-04-2018. Mostrar nom_evento, cant_confirmados, cant_asistieron. 
--		NOTA: Un inscripto está confirmado cuando (está invitado o pagó) y no está dado de baja. Un inscripto asistió cuando asistió = ‘S’


-- confirmados
create view v_confirmados	(nro_evento,nom_evento,cant_confirmados)
as
select i.nro_evento,e.nom_evento,count(*) as confirmados
	from inscriptos i
	join eventos e
		on e.nro_evento=i.nro_evento
	where	(			(i.invitado='S'
				or		(i.fecha_pago is not null and i.nro_recibo is not null))
				and		(i.baja='N'))
	and e.fecha='2018-04-14'
	group by i.nro_evento,e.nom_evento



select c.nro_evento,c.nom_evento,c.confirmados,a.asistentes
	from (select i.nro_evento,e.nom_evento,count(*) as confirmados
			from inscriptos i
			join eventos e
				on e.nro_evento=i.nro_evento
			where	(			(i.invitado='S'
						or		(i.fecha_pago is not null and i.nro_recibo is not null))
						and		(i.baja='N'))
			and e.fecha='2018-04-14'
			group by i.nro_evento,e.nom_evento) c
	join (select i.nro_evento,e.nom_evento,count(*) as asistentes
			from inscriptos i
			join eventos e
				on e.nro_evento=i.nro_evento
			where	e.fecha='2018-04-14'
			and		i.asistio='S'
			group by i.nro_evento,e.nom_evento) a
	on c.nro_evento=a.nro_evento
	and c.nom_evento=a.nom_evento

select *
	from v_confirmados



--asistentes
select i.nro_evento,e.nom_evento,count(*) as asistentes
	from inscriptos i
	join eventos e
		on e.nro_evento=i.nro_evento
	where	e.fecha='2018-04-14'
	and		i.asistio='S'
	group by i.nro_evento,e.nom_evento



-- b.	Personas que han asistido a algún evento y no asistieron a ninguno desde el 01-01-2018. Mostrar: apellido, nombre y fecha del último evento al cual han asistido. 

select aux.apellido,aux.nombre,max(e.fecha)
from 
(select p.apellido,p.nombre,p.cod_tipo_documento,p.nro_documento
	from personas p
	where not exists (select *
						from inscriptos i
						join eventos e
							on e.nro_evento=i.nro_evento
						where	i.cod_tipo_documento=p.cod_tipo_documento
						and		i.nro_documento=p.nro_documento
						and		e.fecha>='2018-01-01'
						and		i.asistio='S')
	and	exists		 (select *
						from inscriptos i
						where i.nro_documento=p.nro_documento
						and	  i.cod_tipo_documento=p.cod_tipo_documento
						and	  i.asistio='S'))aux
join inscriptos i2
	on i2.cod_tipo_documento=aux.cod_tipo_documento
	and i2.nro_documento=aux.nro_documento
join eventos e
	on e.nro_evento=i2.nro_evento
where e.fecha<'2018-01-01'
and i2.asistio='S'
group by aux.nro_documento,aux.cod_tipo_documento,aux.apellido,aux.nombre


-- c.	Eventos con la mayor cantidad de asistentes. Mostrar: nom_evento, cant_asistentes. 
select top(3) nom_evento, count(*) as cant_asistentes
	from inscriptos i
	join eventos e
		on e.nro_evento=i.nro_evento
	where i.asistio='S'
	group by i.nro_evento,e.nom_evento
	order by count(*) desc