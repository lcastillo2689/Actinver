create or replace NONEDITIONABLE PROCEDURE SP_TF_EMPLEADOS_DETALLE
            ( 
              DATE_PARAM DATE,
              CUR_PARAM OUT SYS_REFCURSOR
            )
            AS
            BEGIN
              OPEN CUR_PARAM FOR 
        SELECT  
        EMP.CANDIDATO_TRABAJO_FLEXIBLE                              AS "CANDIDATO_TRABAJO_FLEXIBLE",
        EMP.TF_FULL_REMOTE                                          AS "FULL_REMOTE",
        EMP.TF_TUTORIAL_COMPLETO                                    AS "TUTORIAL_COMPLETO",
        TBEJ.EMPLEADO_ID                                            AS "EMPLEADO_JEFE_ID",
        TBEJ.NUM_EMPLEADO                                           AS "NUMERO_EMPLEADO_JEFE",
        TBEJ.NOMBRE                                                 AS "NOMBRE_EMPLEADO_JEFE",
        EMP.EMPLEADO_ID                                             AS "EMPLEADO_ID",
        EMP.NUM_EMPLEADO                                            AS "NUM_EMPLEADO",
        EMP.NOMBRE                                                  AS "NOMBRE_EMPLEADO",
        EMP.EMAIL                                                   AS "EMAIL_EMPLEADO",
        AREA.AREA_ID                                                AS "AREA_ID",
        AREA.NUM_AREA                                               AS "NUMERO_AREA",
        AREA.DESCRIPCION                                            AS "AREA_DESCRIPCION",
        CF.CENTRO_FINANCIERO_ID                                     AS "CENTRO_FINANCIERO_ID",
        CF.NUM_CF                                                   AS "NUMERO_CENTRO_FINANCIERO",
        CF.DESCRIPCION                                              AS "CENTRO_FINANCIERO",
        DE.DIRECCION_EJECUTIVA_ID                                   AS "DIRECCION_EJECUTIVA_ID",
        DE.NUM_DIRECCION_EJECUTIVA                                  AS "NUMERO_DIRECCION_EJECUTIVA",
        DE.DESCRIPCION                                              AS "DIRECCION_EJECUTIVA",
        P.PUESTO_ID                                                 AS "PUESTO_ID",
        P.NUM_PUESTO                                                AS "NUMERO_PUESTO",
        P.DESCRIPCION                                               AS "PUESTO_DESCRIPCION",

        CASE  WHEN
            TBEVAEMPQ1.total_calificacion IS NULL
        THEN 0
        ELSE
        TBEVAEMPQ1.total_calificacion
        END                                                         AS "CALIFICACION_Q1",

        CASE WHEN
            TBEVAEMPQ1.EVALUACION_ESTATUS_ID = 3
        THEN 1
        ELSE 0
        END                                                         AS "ESATATUS_Q1",

        CASE  WHEN
            TBEVAEMPQ2.total_calificacion IS NULL
        THEN 0
        ELSE
        TBEVAEMPQ2.total_calificacion
        END                                                         AS "CALIFICACION_Q2",

        CASE WHEN
            TBEVAEMPQ2.EVALUACION_ESTATUS_ID = 3
        THEN 1
        ELSE 0
        END                                                         AS "ESATATUS_Q2",

        CASE WHEN
            TBERQ1.CERRADA = 1
        THEN 1
        ELSE 0
        END                                                         AS "RETROALIMENTACION_Q1",
        0 as "DOCUMENTO_FIRMADO"
/*
       CASE WHEN
              (SELECT 1
              FROM TF_FIRMAS TFIRMA
              WHERE TFIRMA.EMPLEADO_ID = EMP.EMPLEADO_ID 
              AND TFIRMA.ACTIVE_FLAG = 1) = 1
        THEN 1
        ELSE 0
        END                                                         AS "DOCUMENTO_FIRMADO"
*/
    FROM OKR_EMPLEADOS EMP


    LEFT JOIN OKR_EMPLEADO_AREA_XREF EMPA ON EMP.EMPLEADO_ID = EMPA.EMPLEADO_ID
                                AND EMPA.ACTIVE_FLAG = 1
                                AND EMPA.FECHA_ALTA <= DATE_PARAM AND(EMPA.FECHA_BAJA IS NULL OR EMPA.FECHA_BAJA >= DATE_PARAM)


    LEFT JOIN OKR_CAT_AREAS AREA ON EMPA.AREA_ID = AREA.AREA_ID


    LEFT JOIN OKR_EMPLEADO_CENTRO_FINANCIERO_XREF EMPCF ON EMP.EMPLEADO_ID = EMPCF.EMPLEADO_ID
                                AND EMPCF.ACTIVE_FLAG = 1
                                AND EMPCF.FECHA_ALTA <= DATE_PARAM AND(EMPCF.FECHA_BAJA IS NULL OR EMPCF.FECHA_BAJA >= DATE_PARAM)
    LEFT JOIN OKR_CAT_CENTROS_FINANCIEROS CF ON EMPCF.CENTRO_FINANCIERO_ID = CF.CENTRO_FINANCIERO_ID


    LEFT JOIN OKR_EMPLEADO_DIR_EJEC_XREF EMPDE ON EMP.EMPLEADO_ID = EMPDE.EMPLEADO_ID
                                AND EMPDE.ACTIVE_FLAG = 1
                                AND EMPDE.FECHA_ALTA <= DATE_PARAM AND(EMPDE.FECHA_BAJA IS NULL OR EMPDE.FECHA_BAJA >= DATE_PARAM)


    LEFT JOIN OKR_CAT_DIRECCIONES_EJECUTIVAS DE ON EMPDE.DIRECCION_EJECUTIVA_ID = DE.DIRECCION_EJECUTIVA_ID


    LEFT JOIN OKR_EMPLEADO_PUESTO_XREF EMPP ON EMP.EMPLEADO_ID = EMPP.EMPLEADO_ID
                                AND EMPP.ACTIVE_FLAG = 1
                                AND EMPP.FECHA_ALTA <= DATE_PARAM AND(EMPP.FECHA_BAJA IS NULL OR EMPP.FECHA_BAJA >= DATE_PARAM)


    LEFT JOIN OKR_CAT_PUESTOS P ON EMPP.PUESTO_ID = P.PUESTO_ID


    INNER JOIN OKR_EMPLEADO_REPORTA_XREF TBER ON EMP.EMPLEADO_ID = TBER.EMPLEADO_ID


    INNER JOIN OKR_EMPLEADOS TBEJ    ON TBEJ.EMPLEADO_ID = TBER.REPORTA_ID

   --evaluacion de empleados de Q1
    LEFT JOIN
    (
       SELECT 
TBEVA.PERIODO_EVALUACION_ID,
TBEVE.EMPLEADO_ID,
TBEVA.EVALUACION_ID, 
TBEVA.AUTOEVALUACION,
TBEVA.EVALUACION_ESTATUS_ID,
TBEVA.TOTAL_CALIFICACION
--ROW_NUMBER() OVER(PARTITION BY TBEVA.PERIODO_EVALUACION_ID ORDER BY TBEVA.PERIODO_EVALUACION_ID ASC) ORD
FROM OKR_EVALUACION TBEVA
INNER JOIN OKR_EVALUACION_EMPLEADO_XREF TBEVE ON TBEVE.EVALUACION_ID = TBEVA.EVALUACION_ID
WHERE TBEVA.AUTOEVALUACION = 0 AND (TBEVA.PERIODO_EVALUACION_ID = 1 AND TBEVA.YEAR_EVALUACION = 2022)
)TBEVAEMPQ1 ON TBEVAEMPQ1.EMPLEADO_ID = EMP.EMPLEADO_ID

--evaluacion de empleados de Q2
LEFT JOIN
    (
       SELECT 
TBEVAQ2.PERIODO_EVALUACION_ID,
TBEVEQ2.EMPLEADO_ID,
TBEVAQ2.EVALUACION_ID, 
TBEVAQ2.AUTOEVALUACION,
TBEVAQ2.EVALUACION_ESTATUS_ID,
TBEVAQ2.TOTAL_CALIFICACION
--ROW_NUMBER() OVER(PARTITION BY TBEVA.PERIODO_EVALUACION_ID ORDER BY TBEVA.PERIODO_EVALUACION_ID ASC) ORD
FROM OKR_EVALUACION TBEVAQ2
INNER JOIN OKR_EVALUACION_EMPLEADO_XREF TBEVEQ2 ON TBEVEQ2.EVALUACION_ID = TBEVAQ2.EVALUACION_ID
WHERE TBEVAQ2.AUTOEVALUACION = 0 AND (TBEVAQ2.PERIODO_EVALUACION_ID = 2 AND TBEVAQ2.YEAR_EVALUACION = 2022)
AND TBEVAQ2.EVALUACION_ESTATUS_ID <> 5
)TBEVAEMPQ2 ON TBEVAEMPQ2.EMPLEADO_ID = EMP.EMPLEADO_ID

    LEFT JOIN
    (
        SELECT EMPLEADO_ID, CERRADA
        FROM OKR_RETROALIMENTACION TBR
        WHERE CERRADA = 1 and tbr.periodo_evaluacion_id = 1 and tbr.year_evaluacion = 2022
    ) TBERQ1 ON TBERQ1.EMPLEADO_ID = emp.empleado_id
    

    WHERE EMP.ACTIVE_FLAG = 1

ORDER BY EMP.EMPLEADO_ID ASC;
            END;
