select 
    TBDE.DESCRIPCION                                            AS  "DIRECCION EJECUTIVA",
    TBE.EMPLEADO_ID                                             AS  "EMPLEADO ID",    
    TBE.NUM_EMPLEADO                                            AS  "# DE NÓMINA",
    TBE.NOMBRE                                                  AS  "EMPLEADO",
    TBEJ.EMPLEADO_ID                                            AS  "JEFE ID",
    TBEJ.NUM_EMPLEADO                                           AS  "NUMERO JEFE",
    TBEJ.NOMBRE                                                 AS  "NOMBRE JEFE",
    tbev.evaluacion_id                                          AS  "EVALUACION ID",
    TBCEEV.DESCRIPCION                                          AS  "ESTATUS EVALUACION",
    CASE WHEN TBEV.CALIFICACION_OBJETIVOS IS NULL
        THEN 0
        ELSE TBEV.CALIFICACION_OBJETIVOS
    END                                                         AS "CALIFICACIÓN DE OBJETIVOS",
    CASE 
        WHEN TBEV.TOTAL_CALIFICACION IS NULL 
            THEN 0 
            ELSE TBEV.TOTAL_CALIFICACION 
    END                                                         AS "CALIFICACIÓN", 
    
    CASE  WHEN TBEV.TOTAL_CALIFICACION  >= 3.70
        THEN  'EXCEPCIONAL'
        WHEN 
           TBEV.TOTAL_CALIFICACION >= 2.80  AND TBEV.TOTAL_CALIFICACION < 3.69
        THEN 'SOBRESALIENTE'
          WHEN 
           TBEV.TOTAL_CALIFICACION >= 1.80  AND TBEV.TOTAL_CALIFICACION < 2.79
        THEN 'SATISFACTORIO'
          WHEN 
           TBEV.TOTAL_CALIFICACION >= 1  AND TBEV.TOTAL_CALIFICACION < 1.79
        THEN 'EN DESARROLLO'
        ELSE 
        'PENDIENTE'
        END                                                                                  AS "ESTATUS EVALUACIÓN"
from okr_empleados                          TBE
INNER JOIN okr_empleado_reporta_xref        TBES        ON tbes.empleado_id     =   tbe.empleado_id
INNER JOIN OKR_EMPLEADOS                    TBEJ        ON TBEJ.EMPLEADO_ID     =   tbes.reporta_id     AND     TBES.FECHA_BAJA IS NULL
LEFT JOIN  okr_empleado_dir_ejec_xref       TBEDIR      ON TBEDIR.EMPLEADO_ID   =   TBE.EMPLEADO_ID     AND     TBEDIR.FECHA_BAJA IS NULL
LEFT JOIN  OKR_CAT_DIRECCIONES_EJECUTIVAS   TBDE        ON tbedir.direccion_ejecutiva_id        =  tbde.direccion_ejecutiva_id
LEFT JOIN okr_evaluacion_empleado_xref      TBEEV       ON TBEEV.EMPLEADO_ID        = TBE.EMPLEADO_ID
RIGHT JOIN OKR_EVALUACION                    TBEV        ON TBEV.EVALUACION_ID       = TBEEV.EVALUACION_ID
RIGHT JOIN OKR_CAT_ESTATUS_EVALUACION       TBCEEV      ON tbev.evaluacion_estatus_id = tbceev.estatus_evaluacion_id

WHERE    
    (TBEV.EVALUACION_ESTATUS_ID = 1 AND TBEV.AUTOEVALUACION = 1)
OR  (TBEV.EVALUACION_ESTATUS_ID = 2 AND TBEV.AUTOEVALUACION = 0)
OR  (TBEV.EVALUACION_ESTATUS_ID = 3 AND TBEV.AUTOEVALUACION = 0 )
ORDER BY tbEv.last_update desc;


SELECT (SELECT COUNT(*) FROM OKR_EVALUACION WHERE EVALUACION_ESTATUS_ID = 1 AND AUTOEVALUACION = 1) AS AUTOEVALUACION,
(SELECT COUNT(*) FROM OKR_EVALUACION WHERE EVALUACION_ESTATUS_ID = 2 AND AUTOEVALUACION = 0) AS REVISION,
(SELECT COUNT(*) FROM OKR_EVALUACION WHERE EVALUACION_ESTATUS_ID = 3 AND AUTOEVALUACION = 0) AS FINALIZADAS,
(SELECT COUNT(*) FROM OKR_EMPLEADOS) AS "TOTAL EMPLEADOS"
FROM DUAL;