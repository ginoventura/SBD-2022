------------------------------------------------------------------------------------------------------------------------------
-- 1. Crear tablas con reglas de integridad declarativas
------------------------------------------------------------------------------------------------------------------------------
drop table dbo.inscriptos
drop table dbo.personas
drop table dbo.tipos_documentos
drop table dbo.empresas_eventos
drop table dbo.empresas
drop table dbo.eventos
drop table dbo.tipos_eventos
go

create table dbo.tipos_eventos
(
 cod_tipo_evento	varchar(3)		not null,
 desc_tipo_evento	varchar(30)		not null,
 constraint PK__tipos_eventos__END    primary key (cod_tipo_evento),
 constraint UK__tipos_eventos__1__END unique (desc_tipo_evento)
)
	
create table dbo.eventos
(
 nro_evento			smallint		not null, 
 nom_evento			varchar(50)		not null,
 cod_tipo_evento	varchar(3)		not null,
 fecha				date			not null,
 hora_inicio		time			not null,
 hora_fin			time			not null,
 costo				decimal(7,2)	null,
 constraint PK__eventos__END
            primary key (nro_evento),
 constraint UK__eventos__1__END
            unique (nom_evento),
 constraint FK__eventos__tipos_eventos__1__END 
            foreign key (cod_tipo_evento) references dbo.tipos_eventos,
 constraint CK__eventos__nro_evento__END
            check (nro_evento > 0),
 constraint CK__eventos__horas__END
            check (hora_inicio < hora_fin),
 constraint CK__eventos__costo__END
            check (costo > 0.00)
)
	
create table dbo.empresas
(
 nro_empresa		smallint		not null,
 nom_empresa		varchar(50)		not null,
 dirección			varchar(255)	not null,
 teléfono			varchar(255)	not null,
 email				varchar(255)	not null,
 constraint PK__empresas__END
            primary key (nro_empresa),
 constraint UK__empresas__1__END
            unique (nom_empresa),
 constraint CK__empresas__nro_empresa__END 
            check (nro_empresa > 0)
)

create table dbo.empresas_eventos
(
 nro_evento				smallint		not null, 
 nro_empresa			smallint		not null,
 cod_tipo_participacion	char(1)			not null,
 constraint PK__empresas_eventos__END
            primary key (nro_evento, nro_empresa),
 constraint FK__empresas_eventos__eventos__1__END
            foreign key (nro_evento) references dbo.eventos,
 constraint FK__empresas_eventos__empresas__1__END
            foreign key (nro_empresa) references dbo.empresas,
 constraint CK__empresas_eventos__cod_tipo_participacion__END 
            check (cod_tipo_participacion in ('O','S'))
)

create table dbo.tipos_documentos
(
 cod_tipo_documento		varchar(3)		not null,
 desc_tipo_documento	varchar(30)		not null,
 constraint PK__tipos_documentos__END 
            primary key (cod_tipo_documento),
 constraint UK__tipos_documentos__1__END 
            unique (desc_tipo_documento)
)

create table dbo.personas
(
 cod_tipo_documento		varchar(3)		not null,
 nro_documento			integer			not null,
 apellido				varchar(40)		not null,
 nombre					varchar(40)		not null,
 teléfono				varchar(255)	not null,
 email					varchar(255)	not null,
 constraint PK__personas__END 
            primary key (cod_tipo_documento, nro_documento),
 constraint FK__personas__tipos_documentos__1__END 
            foreign key (cod_tipo_documento) references dbo.tipos_documentos,
 constraint CK__personas__nro_documento__END 
            check (nro_documento > 0)
)

create table dbo.inscriptos
(
 nro_evento				smallint		not null, 
 cod_tipo_documento		varchar(3)		not null,
 nro_documento			integer			not null,
 fecha_inscripcion		date			not null,
 invitado				char(1)			not null,
 baja					char(1)			not null,
 nro_recibo				integer			null,
 fecha_pago				date			null,
 asistio				char(1)			null,
 constraint PK__inscriptos__END 
            primary key (nro_evento, cod_tipo_documento, nro_documento),
 constraint FK__inscriptos__eventos__1__END 
            foreign key (nro_evento) references dbo.eventos,
 constraint FK__inscriptos__personas__1__END 
            foreign key (cod_tipo_documento, nro_documento) references dbo.personas,
 constraint CK__inscriptos__invitado__END 
            check (invitado in ('S','N')),
 constraint CK__inscriptos__baja__END 
            check (baja in ('S','N')),
 constraint CK__inscriptos__nro_recibo__END 
            check (nro_recibo > 0),
 constraint CK__inscriptos__asistio__END 
            check (asistio in ('S','N')),
 constraint CK__inscriptos__invitado__pago__END 
            check (invitado = 'S' and nro_recibo is null and fecha_pago is null or 
			       invitado = 'N'),
 constraint CK__inscriptos__confirmacion__baja__END 
            check (nro_recibo is not null and fecha_pago is not null and invitado = 'N' and baja = 'N' or 
			       nro_recibo is null     and fecha_pago is null),
 constraint CK__inscriptos__confirmacion__asistencia__END 
            check (invitado = 'N' and nro_recibo is null and fecha_pago is null and asistio is null or 
			       invitado = 'S' or 
				   nro_recibo is not null and fecha_pago is not null)
)
go


------------------------------------------------------------------------------------------------------------------------------
-- 2a. Cantidad de inscriptos confirmados y cantidad de inscriptos que han asistido a los eventos del 14-04-2018. 
--     Mostrar nom_evento, cant_confirmados, cant_asistieron. 
--     NOTA: Un inscripto está confirmado cuando (está invitado o pagó) y no está dado de baja. 
--     Un inscripto asistió cuando asistió = ‘S’. 
------------------------------------------------------------------------------------------------------------------------------
select nom_evento      = e.nom_evento,
       cant_inscriptos = count(case when (i.invitado = 'S' or i.nro_recibo is not null and i.fecha_pago is not null) then 1 else null end),
       cant_asistieron = count(case when i.asistio = 'S' then 1 else null end)
  from dbo.inscriptos i
       join dbo.eventos e
	     on i.nro_evento = e.nro_evento
		and e.fecha = '2018-04-14'
 group by e.nom_evento

select nom_evento      = e.nom_evento, 
       cant_inscriptos = (select count(*)
                            from dbo.inscriptos i
                           where e.nro_evento = i.nro_evento
                             and (i.invitado = 'S' or i.nro_recibo is not null and i.fecha_pago is not null)),
       cant_asistieron = (select count(*)
                            from dbo.inscriptos i
                           where e.nro_evento = i.nro_evento
                             and i.asistio    = 'S')
  from dbo.eventos e
 where e.fecha = '2018-04-14'

select nom_evento      = e.nom_evento, 
       cant_inscriptos = i.cant_inscriptos,
       cant_asistieron = a.cant_asistieron
  from dbo.eventos e
       join (select i.nro_evento, count(*) cant_inscriptos
               from dbo.inscriptos i
              where (i.invitado = 'S' or i.nro_recibo is not null and i.fecha_pago is not null)
              group by i.nro_evento) i
		 on e.nro_evento = i.nro_evento
       join (select i.nro_evento, count(*) cant_asistieron
               from dbo.inscriptos i
              where i.asistio    = 'S'
			  group by i.nro_evento) a
		 on e.nro_evento = a.nro_evento
 where e.fecha = '2018-04-14'

------------------------------------------------------------------------------------------------------------------------------
-- 2b. Personas que han asistido a algún evento y no asistieron a ninguno desde el 01-01-2018. 
--     Mostrar: apellido, nombre y fecha del último evento al cual han asistido. 
------------------------------------------------------------------------------------------------------------------------------
select p.apellido, p.nombre, max(e.fecha) fecha_ult_evento
  from dbo.personas p
       join dbo.inscriptos i
	     on p.cod_tipo_documento = i.cod_tipo_documento
		and p.nro_documento      = i.nro_documento
		and i.asistio            = 'S'
       join dbo.eventos e
	     on i.nro_evento = e.nro_evento
 where not exists (select *
                     from dbo.inscriptos i1
                          join dbo.eventos e1
 	                        on i1.nro_evento = e1.nro_evento
						   and e1.fecha     >= '2018-01-01'
	                where p.cod_tipo_documento = i1.cod_tipo_documento
		              and p.nro_documento      = i1.nro_documento
		              and i1.asistio           = 'S')
 group by p.apellido, p.nombre


------------------------------------------------------------------------------------------------------------------------------
-- 2c. Eventos con la mayor cantidad de asistentes. Mostrar: nom_evento, cant_asistentes. 
------------------------------------------------------------------------------------------------------------------------------
select top 1 with ties e.nom_evento, count(*) cant_asistentes
  from dbo.eventos e
       join dbo.inscriptos i
	     on e.nro_evento = i.nro_evento
        and i.asistio    = 'S'
 group by e.nom_evento
 order by cant_asistentes desc

select e.nom_evento, count(*) cant_asistentes
  from dbo.eventos e
       join dbo.inscriptos i
	     on e.nro_evento = i.nro_evento
        and i.asistio    = 'S'
 group by e.nom_evento
having count(*) >= all (select count(*)
                          from dbo.inscriptos i
	                     where i.asistio = 'S'
                         group by i.nro_evento)

select e.nom_evento, count(*) cant_asistentes
  from dbo.eventos e
       join dbo.inscriptos i
	     on e.nro_evento = i.nro_evento
        and i.asistio    = 'S'
 group by e.nom_evento 
having count(*) = (select max(i.cant_asistentes) max_cant_asistentes
	                 from (select count(*) cant_asistentes
                             from dbo.inscriptos i
	                        where i.asistio = 'S'
                            group by i.nro_evento) i)
                    
