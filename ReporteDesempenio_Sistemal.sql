SELECT 
    tbe.evaluacion_id,
    TBC.NUM_EMPLEADO                                                            AS "# EMPLEADO", 
    TBC.NOMBRE                                                                  AS "NOMBRE",         
    TBC.PUESTO,
    TBJ.NUM_EMPLEADO                                                            AS "# JEFE",
    TBJ.NOMBRE                                                                  AS "LÍDER/EVALUADOR",
    CASE WHEN TBE.RESULTADO_OBJETIVOS IS NULL
        THEN 0
        ELSE TBE.RESULTADO_OBJETIVOS
    END                                                                                     AS "CALIFICACIÓN DE OBJETIVOS",
    CASE WHEN TBE.RESULTADO_COMPORTAMIENTOS IS NULL
        THEN 0
        ELSE TBE.RESULTADO_COMPORTAMIENTOS
    END                                                                                     AS "CALIFICACIÓN DE COMPORTAMIENTOS",
    CASE 
        WHEN TBE.TOTAL_EVALUACION IS NULL 
            THEN 0 
            ELSE TBE.TOTAL_EVALUACION 
        END                                                                                 AS "CALIFICACIÓN", 
    
    CASE  WHEN TBE.TOTAL_EVALUACION  >= 3.60 
        THEN  'EXCEPCIONAL'
        WHEN 
           TBE.TOTAL_EVALUACION >= 2.60  AND TBE.TOTAL_EVALUACION < 3.60
        THEN 'SOBRESALIENTE'
          WHEN 
           TBE.TOTAL_EVALUACION >= 1.60  AND TBE.TOTAL_EVALUACION < 2.60
        THEN 'SATISFACTORIO'
          WHEN 
           TBE.TOTAL_EVALUACION >= 1  AND TBE.TOTAL_EVALUACION < 1.59
        THEN 'NO CUMPLE'
        ELSE 
        'PENDIENTE'
        END                                              AS "CALIFICACIÓN",               
      TBEC.DESCRIPCION_FORTALEZA,
    TBEC.DESCRIPCION_MEJORA
        
FROM DC_EMPLEADO                            TBC
LEFT JOIN DC_EMPLEADO_REPORTA_XREF          TBER            ON TBER.EMPLEADO_ID                 =  TBC.EMPLEADO_ID
LEFT JOIN DC_EMPLEADO                       TBJ             ON TBER.REPORTA_ID                  = TBJ.EMPLEADO_ID
LEFT JOIN DC_EMPLEADO_REPORTA_XREF          TBERJ           ON TBER.REPORTA_ID                  = TBERJ.EMPLEADO_ID
LEFT JOIN DC_EVALUACION_EMPLEADO_XREF       TBEE            ON TBEE.EMPLEADO_ID                 =  TBC.EMPLEADO_ID 
RIGHT JOIN DC_EVALUACION                    TBE             ON TBE.EVALUACION_ID                =  TBEE.EVALUACION_ID
RIGHT JOIN DC_CAT_ESTATUS_EVALUACION        TBEV            ON TBEV.ESTATUS_EVALUACION_ID       = TBE.ESTATUS_ID
RIGHT JOIN DC_CONCLUSION                    TBEC            ON TBEC.EVALUACION_ID               =  TBE.EVALUACION_ID    
WHERE   

 (TBE.ESTATUS_ID = 3 AND TBE.AUTOEVALUACION = 0)
 order by tbc.NUM_EMPLEADO;