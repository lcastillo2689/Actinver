Select 
tbee.empleado_id,
tbe.evaluacion_id,
tbe.year_evaluacion,
tbe.periodo_evaluacion_id,
tbe.autoevaluacion,
tbe.evaluacion_estatus_id,
tbe.calificacion_objetivos,
tbe.total_calificacion,
tboc.objetivo_id, 
tboc.calificacion,
tboc.active_flag,
tboc.resultado
from okr_evaluacion_empleado_xref  tbee 
inner join okr_evaluacion tbe on tbe.evaluacion_id = tbee.evaluacion_id
inner join okr_objetivos_calificacion tboc on tboc.evaluacion_id = tbe.evaluacion_id
where tbee.empleado_id = (select empleado_id from okr_empleados where num_empleado = 64636) 
and tbe.periodo_evaluacion_id = 2
order by tbe.evaluacion_id;

select  
    tbe.evaluacion_id,
    tbe.evaluacion_estatus_id,
    tbe.autoevaluacion,
    tbe.fecha_rechazo,
    tbe.autoevaluacion_rechazo_id,
    tbe.active_flag,
    tbe.comentarios_rechazo
from okr_evaluacion tbe 
inner join okr_evaluacion_empleado_xref tbec on tbe.evaluacion_id = tbec.evaluacion_id
where  tbec.empleado_id = (select empleado_id from okr_empleados where num_empleado = 64636) AND tbe.periodo_evaluacion_id = 2
order by tbe.evaluacion_id;

delete from  okr_evaluacion
where evaluacion_id in (select tbe.evaluacion_id from okr_evaluacion tbe 
inner join okr_evaluacion_empleado_xref tbee on tbee.evaluacion_id = tbe.evaluacion_id
where tbee.empleado_id = (select  iemp.empleado_id from okr_empleados iemp where iemp.num_empleado = 64636) and tbe.periodo_evaluacion_id = 2)

update okr_objetivos
set estatus_id = 4
where objetivo_id in (3491,
41,
11621);

select * from okr_objetivos
where periodo_evaluacion_id = 41;

delete from okr_objetivos
where objetivo_id in (16753);

select * from okr_retroalimentacion
where empleado_id = (select empleado_id from okr_empleados where num_empleado = 64636);

delete from okr_retroalimentacion
where retroalimentacion_id in (4688,
4689);


select * from okr_objetivos_mediciones;
select max(objetivo_medicion_id)from okr_objetivos_mediciones;

ALTER SEQUENCE SQ_OKR_RESULTADOS_C_1210324853 INCREMENT BY 1761;
SELECT SQ_OKR_RESULTADOS_C_1210324853.NEXTVAL FROM dual;
ALTER SEQUENCE SQ_OKR_RESULTADOS_C_1210324853 INCREMENT BY 1;


select * from okr_cat_periodo_evaluacion;

select * from okr_periodos_evaluacion
where empleado_id = 530;


select * from okr_objetivos
where periodo_evaluacion_id in (41, 1);

select * from okr_objetivos_dimensiones_xref
where objetivo_id in (41,
16752,
11621);

select * from okr_cat_dimensiones;
