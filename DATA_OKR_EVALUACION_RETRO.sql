select 
    TBDE.DESCRIPCION                                            AS  "DIRECCION EJECUTIVA",
    TBE.EMPLEADO_ID                                             AS  "EMPLEADO ID",    
    TBE.NUM_EMPLEADO                                            AS  "# DE NÓMINA",
    TBE.NOMBRE                                                  AS  "EMPLEADO",
    TBEJ.EMPLEADO_ID                                            AS  "JEFE ID",
    TBEJ.NUM_EMPLEADO                                           AS  "NUMERO JEFE",
    TBEJ.NOMBRE                                                 AS  "NOMBRE JEFE",
    TBR.RETROALIMENTACION_ID,
    CASE WHEN  tbr.evaluacion_acordada  IS NULL
        THEN 'PENDIENTE' 
        WHEN  TBR.EVALUACION_ACORDADA = 1 
        THEN 'COINCIDE'
        ELSE
            'NO COINCIDE' 
        END                                                     AS  "¿COINCIDE?"
from okr_empleados                          TBE
INNER JOIN okr_empleado_reporta_xref        TBES        ON tbes.empleado_id     =   tbe.empleado_id
INNER JOIN OKR_EMPLEADOS                    TBEJ        ON TBEJ.EMPLEADO_ID     =   tbes.reporta_id     AND     TBES.FECHA_BAJA IS NULL
LEFT JOIN  okr_empleado_dir_ejec_xref       TBEDIR      ON TBEDIR.EMPLEADO_ID   =   TBE.EMPLEADO_ID     AND     TBEDIR.FECHA_BAJA IS NULL
LEFT JOIN  OKR_CAT_DIRECCIONES_EJECUTIVAS   TBDE        ON tbedir.direccion_ejecutiva_id        =  tbde.direccion_ejecutiva_id
RIGHT JOIN OKR_RETROALIMENTACION            TBR         ON TBR.EMPLEADO_ID = TBE.EMPLEADO_ID
WHERE tbr.cerrada = 1;


SELECT (SELECT COUNT(*) FROM okr_retroalimentacion WHERE CERRADA = 0 AND (SELECT COUNT(*) FROM OKR_RETROALIMENTACION) = 1) AS Pendientes,
(SELECT COUNT(*) FROM okr_retroalimentacion WHERE CERRADA = 1) AS Concluidas,
(SELECT COUNT (DISTINCT EMPLEADO_ID) FROM okr_retroalimentacion) AS "TOTAL DE EMPLEADOS CON RETRO",
(SELECT COUNT(*) FROM OKR_EMPLEADOS) AS "TOTAL EMPLEADOS"
FROM DUAL;


select * from okr_empleados
where nombre like '%RAFAEL%';
where cerrada = 1;

SELECT EMPLEADO_id, COUNT(*) FROM OKR_RETROALIMENTACION
GROUP BY EMPLEADO_ID
ORDER BY COUNT(*) DESC;

SELECT EMPLEADO_ID, COUNT(*)
FROM OKR_RETROALIMENTACION
GROUP BY EMPLEADO_ID
HAVING COUNT(*) >= 2 ;

SELECT EMPLEADO_ID, CERRADA
FROM OKR_RETROALIMENTACION
WHERE CERRADA = 1;

