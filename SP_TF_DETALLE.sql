create or replace NONEDITIONABLE PROCEDURE SP_TF_EMPLEADOS_DETALLE
(
  DATE_PARAM DATE,
  CUR_PARAM OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN CUR_PARAM FOR
    SELECT

        TBEJ.EMPLEADO_ID                                                        AS "EMPLEADO_JEFE_ID"
        TBEJ.NUM_EMPLEADO                                                       AS "NUMERO_EMPLEADO_JEFE",
        TBEJ.NOMBRE                                                             AS "NOMBRE_EMPLEADO_JEFE",
        EMP.EMPLEADO_ID                                                         AS "EMPLEADO_ID",
        EMP.NUM_EMPLEADO                                                        AS "NUM_EMPLEADO",
        EMP.NOMBRE                                                              AS "NOMBRE_EMPLEADO",
        EMP.EMAIL                                                               AS "EMAIL_EMPLEADO",
        AREA.AREA_ID                                                            AS "AREA_ID",
        AREA.NUM_AREA                                                           AS "NUMERO_AREA",
        AREA.DESCRIPCION                                                        AS "AREA_DESCRIPCION",
        CF.CENTRO_FINANCIERO_ID                                                 AS "CENTRO_FINANCIERO_ID",
        CF.NUM_CF                                                               AS "NUMERO_CENTRO_FINANCIERO",
        CF.DESCRIPCION                                                          AS "CENTRO_FINANCIERO",
        DE.DIRECCION_EJECUTIVA_ID                                               AS "DIRECCION_EJECUTIVA_ID",
        DE.NUM_DIRECCION_EJECUTIVA                                              AS "NUMERO_DIRECCION_EJECUTIVA",
        DE.DESCRIPCION                                                          AS "IRECCION_EJECUTIVA",
        P.PUESTO_ID                                                             AS "PUESTO_ID",
        P.NUM_PUESTO                                                            AS "NUMERO_PUESTO",
        P.DESCRIPCION                                                           AS "PUESTO_DESCRIPCION",
        EMP.AVATAR                                                              AS "AVATAR",
        (SELECT TOTAL_CALIFICACION
            FROM OKR_EVALUACION TBEVA
            INNER JOIN OKR_EVALUACION_EMPLEADO_XREF TBEVAEMP
                ON TBEVA.EVALUACION_ID = TBEVAEMP.EVALUACION_ID
                AND TBEVA.AUTOEVALUACION = 0
            WHERE TBEVAEMP.EMPLEADO_ID = EMP.EMPLEADO_ID AND tbeva.periodo_evaluacion_id = 1)                      AS "CALIFICACION_EVALUACION",
        CASE WHEN
            (SELECT EVALUACION_ESTATUS_ID
            FROM OKR_EVALUACION TBEVA
            INNER JOIN OKR_EVALUACION_EMPLEADO_XREF TBEVAEMP
                ON TBEVA.EVALUACION_ID = TBEVAEMP.EVALUACION_ID
                AND TBEVA.AUTOEVALUACION = 0 and tbeva.periodo_evaluacion_id = 1
            WHERE TBEVAEMP.EMPLEADO_ID = EMP.EMPLEADO_ID) = 3
        THEN 1
        ELSE 0
        END AS "EVALUACION_FINALIZADA",
       CASE WHEN
            (SELECT CERRADA
            FROM OKR_RETROALIMENTACION TBR
            WHERE TBR.EMPLEADO_ID = EMP.EMPLEADO_ID AND CERRADA = 1) = 1
        THEN 1
        ELSE 0
        END AS "RETROALIMENTACION_CERRADA"



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
    WHERE EMP.ACTIVE_FLAG = 1
ORDER BY EMP.EMPLEADO_ID ASC;
            END;
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220621212224_SP_TF_DetalleColabored', N'5.0.12')
/

