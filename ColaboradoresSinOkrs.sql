SELECT
  TBDE.DESCRIPCION                                            AS  "DIRECCION EJECUTIVA",
    TBE.EMPLEADO_ID                                             AS  "EMPLEADO ID",    
    TBE.NUM_EMPLEADO                                            AS  "# DE N?MINA",
    TBE.NOMBRE                                                  AS  "EMPLEADO",
    TBEJ.EMPLEADO_ID                                            AS  "JEFE ID",
    TBEJ.NUM_EMPLEADO                                           AS  "NUMERO JEFE",
    TBEJ.NOMBRE                                                 AS  "NOMBRE JEFE"

from OKR_EMPLEADOS                          TBE
INNER JOIN okr_empleado_reporta_xref        TBES        ON tbes.empleado_id     =   tbe.empleado_id
INNER JOIN OKR_EMPLEADOS                    TBEJ        ON TBEJ.EMPLEADO_ID     =   tbes.reporta_id     AND     TBES.FECHA_BAJA IS NULL
LEFT JOIN  okr_empleado_dir_ejec_xref       TBEDIR      ON TBEDIR.EMPLEADO_ID   =   TBE.EMPLEADO_ID     AND     TBEDIR.FECHA_BAJA IS NULL
LEFT JOIN  OKR_CAT_DIRECCIONES_EJECUTIVAS   TBDE        ON tbedir.direccion_ejecutiva_id        =  tbde.direccion_ejecutiva_id
WHERE TBE.EMPLEADO_ID NOT IN 
(SELECT EMPLEADO_ID FROM okr_evaluacion_empleado_xref ) and tbe.active_flag = 1;
