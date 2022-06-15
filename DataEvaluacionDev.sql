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
tboc.resultado
from okr_evaluacion_empleado_xref  tbee 
inner join okr_evaluacion tbe on tbe.evaluacion_id = tbee.evaluacion_id
inner join okr_objetivos_calificacion tboc on tboc.evaluacion_id = tbe.evaluacion_id
where tbee.empleado_id = (select empleado_id from okr_empleados where num_empleado = 64636)
order by tbe.evaluacion_id;


delete from  okr_evaluacion
where evaluacion_id in (5531, 5532);

update okr_objetivos
set estatus_id = 4
where objetivo_id in (3491,
41,
11621);

select * from okr_retroalimentacion
where empleado_id = (select empleado_id from okr_empleados where num_empleado = 64636);

delete from okr_retroalimentacion
where retroalimentacion_id in (4688,
4689);

delete from okr_periodos_evaluacion
where periodo_evaluacion_id in (1);

select max(retroalimentacion_id)from okr_retroalimentacion;

ALTER SEQUENCE SQ_OKR_RETROALIMENTACION INCREMENT BY 4481;
SELECT SQ_OKR_RETROALIMENTACION.NEXTVAL FROM dual;
ALTER SEQUENCE SQ_OKR_RETROALIMENTACION INCREMENT BY 1;


select * from okr_cat_periodo_evaluacion;

select * from okr_periodos_evaluacion
where empleado_id = 530;


select * from okr_objetivos
where periodo_evaluacion_id in (41, 1);
