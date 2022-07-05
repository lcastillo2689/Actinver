BEGIN 

execute immediate 'CREATE SEQUENCE "SQ_TF_FIRMAS" start with 1';

execute immediate 'CREATE TABLE "TF_FIRMAS" (
    "FIRMA_ID" NUMBER(19) NOT NULL,
    "DOCUMENTO" NVARCHAR2(255) NOT NULL,
    "IP" NVARCHAR2(255) NOT NULL,
    "LAST_UPDATE" TIMESTAMP(7) DEFAULT (sysdate) NOT NULL,
    "DATE_INSERT" TIMESTAMP(7) NOT NULL,
    "EMPLEADO_ID" NUMBER(18,0) NOT NULL,
    "ACTIVE_FLAG" NUMBER(1) NOT NULL,
    CONSTRAINT "PK_TF_FIRMAS" PRIMARY KEY ("FIRMA_ID"),
    CONSTRAINT "FK_EMPLEADO_FIRMA" FOREIGN KEY ("EMPLEADO_ID") REFERENCES "OKR_EMPLEADOS" ("EMPLEADO_ID") ON DELETE CASCADE
)';
execute immediate 'create or replace trigger "TR_TF_FIRMAS"
before insert on "TF_FIRMAS" for each row 
begin 
  if :new."FIRMA_ID" is NULL then 
    select "SQ_TF_FIRMAS".nextval into :new."FIRMA_ID" from dual;  
  end if; 
end;';
END;
/

CREATE INDEX "IX_TF_FIRMAS_EMPLEADO_ID" ON "TF_FIRMAS" ("EMPLEADO_ID")
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220623004701_AddTableTF_FIRMAS', N'5.0.12')
/

create or replace  NONEDITIONABLE PROCEDURE SP_TF_EMPLEADOS_DETALLE
            ( 
              DATE_PARAM DATE,
              CUR_PARAM OUT SYS_REFCURSOR
            )
            AS
            BEGIN
              OPEN CUR_PARAM FOR 
                SELECT 

                    TBEJ.EMPLEADO_ID                                                        AS "EMPLEADO_JEFE_ID",
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
                    DE.DESCRIPCION                                                          AS DIRECCION_EJECUTIVA,
                    P.PUESTO_ID                                                             AS "PUESTO_ID",
                    P.NUM_PUESTO                                                            AS "NUMERO_PUESTO",
                    P.DESCRIPCION                                                           AS "PUESTO_DESCRIPCION",
                    EMP.AVATAR                                                              AS "AVATAR",
                   (SELECT TOTAL_CALIFICACION
            FROM OKR_EVALUACION TBEVA
            INNER JOIN OKR_EVALUACION_EMPLEADO_XREF TBEVAEMP
                ON TBEVA.EVALUACION_ID = TBEVAEMP.EVALUACION_ID
                AND TBEVA.AUTOEVALUACION = 0
            WHERE TBEVAEMP.EMPLEADO_ID = EMP.EMPLEADO_ID AND tbeva.periodo_evaluacion_id = 1 and tbeva.evaluacion_estatus_id = 3)                      AS "CALIFICACION_EVALUACION",
        CASE WHEN
            (SELECT EVALUACION_ESTATUS_ID
            FROM OKR_EVALUACION TBEVA
            INNER JOIN OKR_EVALUACION_EMPLEADO_XREF TBEVAEMP
                ON TBEVA.EVALUACION_ID = TBEVAEMP.EVALUACION_ID
                AND TBEVA.AUTOEVALUACION = 0 and tbeva.periodo_evaluacion_id = 1 and tbeva.evaluacion_estatus_id <> 5
            WHERE TBEVAEMP.EMPLEADO_ID = EMP.EMPLEADO_ID) = 3
        THEN 1
        ELSE 0
        END AS "EVALUACION_FINALIZADA",
       CASE WHEN
            (SELECT CERRADA
            FROM OKR_RETROALIMENTACION TBR
             WHERE TBR.EMPLEADO_ID = EMP.EMPLEADO_ID AND CERRADA = 1 and tbr.periodo_evaluacion_id = 1 and tbr.year_evaluacion = 2022) = 1
        THEN 1
        ELSE 0
        END AS "RETROALIMENTACION_CERRADA",
                   CASE WHEN
                          (SELECT 1
                          FROM TF_FIRMAS TFIRMA
                          WHERE TFIRMA.EMPLEADO_ID = EMP.EMPLEADO_ID AND TFIRMA.ACTIVE_FLAG = 1) = 1
                      THEN 1
                      ELSE 0
                      END AS "DOCUMENTO_FIRMADO"

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
VALUES (N'20220623154452_SP_TF_DetalleColabored_Firmas', N'5.0.12')
/

ALTER TABLE "OKR_EVALUACION" ADD "COMENTARIOS_RECHAZO" NVARCHAR2(1500)
/

INSERT INTO OKR_CAT_ESTATUS_EVALUACION(ESTATUS_EVALUACION_ID,DESCRIPCION) VALUES(4, 'Rechazada')
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220623174140_AddRechazoEvaluacion', N'5.0.12')
/

UPDATE OKR_CAT_ESTATUS_EVALUACION SET ESTATUS_EVALUACION_ID = 5 WHERE ESTATUS_EVALUACION_ID = 4
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220623223714_UpdataEstatusEvaluacionColaborador', N'5.0.12')
/

create or replace NONEDITIONABLE PROCEDURE SP_EMPLEADOS_ESTRUCTURA 
( 
  CUR_PARAM OUT sys_REFCURSOR
--, DATE_PARAM IN DATE DEFAULT to_date('2022-01-01', 'yyyy-MM-dd')
, EMP_PARAM NUMBER DEFAULT 0
, version_param in number default 2  
)
AS
BEGIN
    IF (version_param = 1) THEN 
        OPEN CUR_PARAM FOR 
      --inicia vista vEmpleadoReportaActivo
      with reporta01(empleado_id, n) as
      ( 
        select empleado_id, count(*) n
        from okr_empleado_reporta_xref
        group by empleado_id
      )
      , reporta02(n, empleado_id, reporta_id, active_flag, fecha_alta, fecha_baja, ord) as
      (
        select a.n, er.empleado_id, er.reporta_id, er.active_flag, er.fecha_alta, er.fecha_baja
        , ROW_NUMBER() OVER (PARTITION BY a.empleado_id ORDER BY er.fecha_alta desc) ord--se ordenan registros duplicados, para identificar registro más reciente
        from reporta01 a
        inner join okr_empleado_reporta_xref er on a.empleado_id = er.empleado_id
      )
      , reporta03(empleado_id, reporta_id, fecha_alta, activo, n) as
      (
        select b.empleado_id, b.reporta_id, b.fecha_alta
        , case when b.active_flag = 1 AND b.FECHA_ALTA <= SYSDATE AND (b.FECHA_BAJA IS NULL OR b.FECHA_BAJA >= sysdate) then 1 else 0 end activo
        , n
        from reporta02 b
        where ord = 1
      )
      , v_reporta(empleado_id, reporta_id, fecha_alta, activo, n) as
      (
        select EMPLEADO_ID,REPORTA_ID, FECHA_ALTA,ACTIVO, n
        from reporta03 c
      )
      --termina vista vEmpleadoReportaActivo
      
      --inicia vista vEmpleadoAreaActivo
      , area01(empleado_id, n) as
      (
        select empleado_id, count(*) n
        from okr_empleado_area_xref
        group by empleado_id
      )
      , area02(n, empleado_id, area_id, active_flag, fecha_alta, fecha_baja, ord) as
      (
        select a.n, ea.empleado_id, ea.area_id, ea.active_flag, ea.fecha_alta, ea.fecha_baja
        , ROW_NUMBER() OVER (PARTITION BY a.empleado_id ORDER BY ea.fecha_alta desc) ord
        from area01 a
        inner join okr_empleado_area_xref ea on a.empleado_id = ea.empleado_id
      )
      , area03(empleado_id, area_id, activo, n) as
      (
        select b.empleado_id, b.area_id
        , case when b.active_flag = 1 AND b.FECHA_ALTA <= SYSDATE AND (b.FECHA_BAJA IS NULL OR b.FECHA_BAJA >= sysdate) then 1 else 0 end activo
        , n
        from area02 b
        where ord = 1
      )
      , v_area(empleado_id, area_id, activo, n, num_area, area, area_activa) as
      (
        select c.empleado_id, c.area_id,activo, c.n, a.num_area, a.descripcion area, a.active_flag area_activa
        from area03 c
        left join okr_cat_areas a on c.area_id = a.area_id
      )
      --termina vista vEmpleadoAreaActivo
    
      --inicia vista vEmpleadoPuestoActivo
      , puesto01(empleado_id, n) as
      (
        select empleado_id, count(*) n
        from okr_empleado_puesto_xref
        group by empleado_id
      )
      , puesto02(n, empleado_id, puesto_id, active_flag, fecha_alta, fecha_baja, ord) as
      (
        select a.n, ea.empleado_id, ea.puesto_id, ea.active_flag, ea.fecha_alta, ea.fecha_baja
        , ROW_NUMBER() OVER (PARTITION BY a.empleado_id ORDER BY ea.fecha_alta desc) ord
        from puesto01 a
        inner join okr_empleado_puesto_xref ea on a.empleado_id = ea.empleado_id
      )
      , puesto03(empleado_id, puesto_id, activo, n) as
      (
        select b.empleado_id, b.puesto_id
        , case when b.active_flag = 1 AND b.FECHA_ALTA <= SYSDATE AND (b.FECHA_BAJA IS NULL OR b.FECHA_BAJA >= sysdate) then 1 else 0 end activo
        , n
        from puesto02 b
        where ord = 1
      )
      , v_puesto(empleado_id, puesto_id, activo, n, num_puesto, puesto, puesto_activa) as
      (
        select c.empleado_id, c.puesto_id,activo, c.n, a.num_puesto, a.descripcion puesto, a.active_flag puesto_activa
        from puesto03 c
        left join okr_cat_puestos a on c.puesto_id = a.puesto_id
      )
      --termina vista vEmpleadoPuestoActivo
    
      --inicia vista vDirEjecArea
      , v_direjecarea(dir_eject_area_id, direccion_ejecutiva_id, area_id, last_update, active_flag, num_direccion_ejecutiva, direccion_ejecutiva, dir_ejec_activa, num_area, area, area_activa) as
      (
        select dea.DIR_EJEC_AREA_ID,dea.DIRECCION_EJECUTIVA_ID,dea.AREA_ID,dea.LAST_UPDATE,dea.ACTIVE_FLAG, de.num_direccion_ejecutiva, de.descripcion direccion_ejecutiva, de.active_flag dir_ejec_activa
        , a.num_area, a.descripcion area, a.active_flag area_activa
        from okr_dir_ejec_area_xref dea
        inner join okr_cat_direcciones_ejecutivas de on dea.direccion_ejecutiva_id = de.direccion_ejecutiva_id
        inner join okr_cat_areas a on dea.area_id = a.area_id
      )
      --termina vista vDirEjecArea
    
      --inicia vista vDirEjecAreaColor
      , direjeccolor01(direccion_ejecutiva_id, cnt) as
      (
        select direccion_ejecutiva_id, count(*) cnt
        from v_area er
        inner join okr_empleados e on er.empleado_id = e.empleado_id
        inner join v_area ea on er.empleado_id = ea.empleado_id
        inner join V_DIREJECAREA dea on dea.area_id = ea.area_id
        group by dea.direccion_ejecutiva_id
      )
      , direjeccolor02(direccion_ejecutiva_id, cnt, ord) as
      (
        select direccion_ejecutiva_id, a.cnt
        , row_number() over (order by a.cnt) ord
        from direjeccolor01 a
      )
      , direjeccolor03(area_id, direccion_ejecutiva_id, cnt, ord, color, de_, a_) as
      (
        select dea.area_id, b.direccion_ejecutiva_id, b.cnt, b.ord
        , case 
          when mod(b.ord, 6) = 1 then 'tagDep01b'
          when mod(b.ord, 6) = 2 then 'tagDep02b'
          when mod(b.ord, 6) = 3 then 'tagDep03b'
          when mod(b.ord, 6) = 4 then 'tagDep04b'
          when mod(b.ord, 6) = 5 then 'tagDep05b'
          when mod(b.ord, 6) = 0 then 'tagDep06b'
          end color
          , dea.direccion_ejecutiva, dea.area
        from direjeccolor02 b
        inner join v_direjecarea dea on dea.direccion_ejecutiva_id = b.direccion_ejecutiva_id
      )
      , v_direjecareacolor(area_id, direccion_ejecutiva_id, cnt, ord, color, de_, a_) as
      (
        select AREA_ID,DIRECCION_EJECUTIVA_ID,CNT,ORD,COLOR,DE_,A_ 
        from direjeccolor03 c
      )
      --termina vista vDirEjecAreaColor
    
      --termina vista vEmpleadoCalificacion
      , calificacion01(periodo, empleado_id, calificacion_total) as
      (
        select evp.periodo, eve.empleado_id, avg(ev.TOTAL_CALIFICACION)
        from OKR_EVALUACION ev
        inner join OKR_EVALUACION_EMPLEADO_XREF eve on eve.evaluacion_id = ev.evaluacion_id
        inner join OKR_PERIODOS_EVALUACION evp on eve.empleado_id = evp.empleado_id
          and EXTRACT( YEAR FROM evp.PERIODO) = EXTRACT( YEAR FROM sysdate)
        --where eve.empleado_id = 532
        where eve.active_flag = 1
        and ev.autoevaluacion = 0
        group by evp.periodo, eve.empleado_id, eve.active_flag
      )
      , calificacion02(periodo, empleado_id, calificacion_total, calificacion_texto) as
      (
        select a.periodo, a.empleado_id, a.calificacion_total
        , case 
          when a.calificacion_total between 1 and 1.79 then 'DS'
          when a.calificacion_total between 1.8 and 2.79 then 'ST'
          when a.calificacion_total between 2.8 and 3.69 then 'SS'
          when a.calificacion_total between 3.7 and 4.00 then 'EX'
          else 'PD' end
        from calificacion01 a
      )
      , v_calificacion(periodo, empleado_id, calificacion_total, calificacion_texto, reporta_id) as
      (
        select b.PERIODO, b.EMPLEADO_ID,b.CALIFICACION_TOTAL,b.CALIFICACION_TEXTO, nvl(er.reporta_id, 0) reporta_id
        from calificacion02 b
        left join v_reporta er on b.empleado_id = er.empleado_id and er.activo = 1--vista vempleadoreportaactivo
      )
      --termina vista vEmpleadoCalificacion
    
      --inicia consulta principal de procedimiento
      , niv(empleado_id, reporta_id, nivel)as
      (
        select e.empleado_id, 0 reporta_id, 1 nivel
        from okr_empleados e
        left join v_reporta er on e.empleado_id = er.empleado_id--vista vempleadoreportaactivo
        where er.empleado_id is null
        and e.active_flag = 1
        union all
        select er.empleado_id, er.reporta_id, niv.nivel + 1 nivel
        from niv
        inner join v_reporta er on er.reporta_id = niv.empleado_id--vista vempleadoreportaactivo
      )
      ,ea(empleado_id, area_id) as
      (
        select ea.empleado_id, ea.area_id
        from v_area ea--vista vempleadoareaactivo
        --where ea.activo = 1
      )
      , ep(empleado_id, puesto_id) as
      (
        select ep.empleado_id, ep.puesto_id
        from v_puesto ep--vista vempleadopuestoactivo
        where ep.activo = 1
      )
      , er(empleado_id, reporta_id, fecha_alta) as
      (
        select er.empleado_id, er.reporta_id, er.fecha_alta
        from v_reporta er--vista vempleadoreportaactivo
        where er.activo = 1
      ) 
      , ee(empleado_id, area_id, direccion_ejecutiva_id, numero_direccion_ejecutiva, direccion_ejecutiva_descripcion
      , color, puesto_id, reporta_id, nivel, fecha_alta, calificacion_total, calificacion_texto) as
      (
        select e.empleado_id, ea.area_id
        , nvl(dea.direccion_ejecutiva_id, 0), nvl(dea.num_direccion_ejecutiva, 0), nvl(dea.direccion_ejecutiva, ''), nvl(cl.color, 'tagDep01b')
        , ep.puesto_id, er.reporta_id, nvl(niv.nivel, -1) nivel
        , nvl(er.fecha_alta, sysdate) fecha_alta
        , nvl(ec.calificacion_total, 0) calificacion_total
        , nvl(ec.calificacion_texto, 'PD') calificacion_texto
        from okr_empleados e
        left join ea on ea.empleado_id = e.empleado_id
        left join v_direjecarea dea on dea.area_id = ea.area_id --vista vdirejecarea
        left join v_direjecareacolor cl on dea.area_id = cl.area_id--vista vdirejecareacolor
        inner join ep on ep.empleado_id = e.empleado_id
        left join er on er.empleado_id = e.empleado_id
        left join niv on e.empleado_id = niv.empleado_id
        left join v_calificacion ec on ec.empleado_id = e.empleado_id--vista vempleadocalificacion
          and EXTRACT( YEAR FROM ec.PERIODO) = EXTRACT( YEAR FROM sysdate)
        where e.active_flag = 1
      )--select * from ee
      select nvl(a.area_id, 0) area_id, nvl(a.num_area, 0) numero_area, nvl(a.descripcion, '') area_descripcion
      , ee.direccion_ejecutiva_id, ee.numero_direccion_ejecutiva, ee.direccion_ejecutiva_descripcion, ee.color
      , p.puesto_id, p.descripcion puesto_descripcion
      , e.empleado_id, e.num_empleado, e.nombre nombre_empleado, e.email email_empleado, e.avatar
      , j.empleado_id empleado_jefe_id, j.num_empleado numero_empleado_jefe, j.nombre nombre_empleado_jefe
      , ee.nivel, ee.fecha_alta, ee.calificacion_total, ee.calificacion_texto
      from ee
      inner join okr_empleados e on ee.empleado_id = e.empleado_id
      left join okr_cat_areas a on ee.area_id = a.area_id
      inner join okr_cat_puestos p on ee.puesto_id = p.puesto_id
      left join okr_empleados j on ee.reporta_id = j.empleado_id
      where p.num_puesto not in (487, 512, 334)
      order by ee.nivel, e.nombre
      ;
    ELSE
    open cur_param for
      --inicia vista vEmpleadoReportaActivo
      with reporta01(empleado_id, n) as
      (
        select empleado_id, count(*) n
        from okr_empleado_reporta_xref
        group by empleado_id
      )
      , reporta02(n, empleado_id, reporta_id, active_flag, fecha_alta, fecha_baja, ord) as
      (
        select a.n, er.empleado_id, er.reporta_id, er.active_flag, er.fecha_alta, er.fecha_baja
        , ROW_NUMBER() OVER (PARTITION BY a.empleado_id ORDER BY er.fecha_alta desc) ord
        from reporta01 a
        inner join okr_empleado_reporta_xref er on a.empleado_id = er.empleado_id
      )
      , reporta03(empleado_id, reporta_id, fecha_alta, activo, n) as
      (
        select b.empleado_id, b.reporta_id, b.fecha_alta
        , case when b.active_flag = 1 AND b.FECHA_ALTA <= SYSDATE AND (b.FECHA_BAJA IS NULL OR b.FECHA_BAJA >= sysdate) then 1 else 0 end activo
        , n
        from reporta02 b
        where ord = 1
      )
      , v_reporta(empleado_id, reporta_id, fecha_alta, activo, n) as
      (
        select EMPLEADO_ID,REPORTA_ID, FECHA_ALTA,ACTIVO, n
        from reporta03 c
      )
      --termina vista vEmpleadoReportaActivo
      
      --inicia vista vEmpleadoAreaActivo
      , area01(empleado_id, n) as
      (
        select empleado_id, count(*) n
        from okr_empleado_area_xref
        group by empleado_id
      )
      , area02(n, empleado_id, area_id, active_flag, fecha_alta, fecha_baja, ord) as
      (
        select a.n, ea.empleado_id, ea.area_id, ea.active_flag, ea.fecha_alta, ea.fecha_baja
        , ROW_NUMBER() OVER (PARTITION BY a.empleado_id ORDER BY ea.fecha_alta desc) ord
        from area01 a
        inner join okr_empleado_area_xref ea on a.empleado_id = ea.empleado_id
      )
      , area03(empleado_id, area_id, activo, n) as
      (
        select b.empleado_id, b.area_id
        , case when b.active_flag = 1 AND b.FECHA_ALTA <= SYSDATE AND (b.FECHA_BAJA IS NULL OR b.FECHA_BAJA >= sysdate) then 1 else 0 end activo
        , n
        from area02 b
        where ord = 1
      )
      , v_area(empleado_id, area_id, activo, n, num_area, area, area_activa) as
      (
        select c.empleado_id, c.area_id,activo, c.n, a.num_area, a.descripcion area, a.active_flag area_activa
        from area03 c
        left join okr_cat_areas a on c.area_id = a.area_id
      )
      --termina vista vEmpleadoAreaActivo
    
      --inicia vista vEmpleadoPuestoActivo
      , puesto01(empleado_id, n) as
      (
        select empleado_id, count(*) n
        from okr_empleado_puesto_xref
        group by empleado_id
      )
      , puesto02(n, empleado_id, puesto_id, active_flag, fecha_alta, fecha_baja, ord) as
      (
        select a.n, ea.empleado_id, ea.puesto_id, ea.active_flag, ea.fecha_alta, ea.fecha_baja
        , ROW_NUMBER() OVER (PARTITION BY a.empleado_id ORDER BY ea.fecha_alta desc) ord
        from puesto01 a
        inner join okr_empleado_puesto_xref ea on a.empleado_id = ea.empleado_id
      )
      , puesto03(empleado_id, puesto_id, activo, n) as
      (
        select b.empleado_id, b.puesto_id
        , case when b.active_flag = 1 AND b.FECHA_ALTA <= SYSDATE AND (b.FECHA_BAJA IS NULL OR b.FECHA_BAJA >= sysdate) then 1 else 0 end activo
        , n
        from puesto02 b
        where ord = 1
      )
      , v_puesto(empleado_id, puesto_id, activo, n, num_puesto, puesto, puesto_activa) as
      (
        select c.empleado_id, c.puesto_id,activo, c.n, a.num_puesto, a.descripcion puesto, a.active_flag puesto_activa
        from puesto03 c
        left join okr_cat_puestos a on c.puesto_id = a.puesto_id
      )
      --termina vista vEmpleadoPuestoActivo
    
      --inicia vista vDirEjecArea
      , v_direjecarea(dir_eject_area_id, direccion_ejecutiva_id, area_id, last_update, active_flag, num_direccion_ejecutiva, direccion_ejecutiva, dir_ejec_activa, num_area, area, area_activa) as
      (
        select dea.DIR_EJEC_AREA_ID,dea.DIRECCION_EJECUTIVA_ID,dea.AREA_ID,dea.LAST_UPDATE,dea.ACTIVE_FLAG, de.num_direccion_ejecutiva, de.descripcion direccion_ejecutiva, de.active_flag dir_ejec_activa
        , a.num_area, a.descripcion area, a.active_flag area_activa
        from okr_dir_ejec_area_xref dea
        inner join okr_cat_direcciones_ejecutivas de on dea.direccion_ejecutiva_id = de.direccion_ejecutiva_id
        inner join okr_cat_areas a on dea.area_id = a.area_id
      )
      --termina vista vDirEjecArea
    
      --inicia vista vDirEjecAreaColor
      , direjeccolor01(direccion_ejecutiva_id, cnt) as
      (
        select direccion_ejecutiva_id, count(*) cnt
        from v_area er
        inner join okr_empleados e on er.empleado_id = e.empleado_id
        inner join v_area ea on er.empleado_id = ea.empleado_id
        inner join V_DIREJECAREA dea on dea.area_id = ea.area_id
        group by dea.direccion_ejecutiva_id
      )
      , direjeccolor02(direccion_ejecutiva_id, cnt, ord) as
      (
        select direccion_ejecutiva_id, a.cnt
        , row_number() over (order by a.cnt) ord
        from direjeccolor01 a
      )
      , direjeccolor03(area_id, direccion_ejecutiva_id, cnt, ord, color, de_, a_) as
      (
        select dea.area_id, b.direccion_ejecutiva_id, b.cnt, b.ord
        , case 
          when mod(b.ord, 6) = 1 then 'tagDep01b'
          when mod(b.ord, 6) = 2 then 'tagDep02b'
          when mod(b.ord, 6) = 3 then 'tagDep03b'
          when mod(b.ord, 6) = 4 then 'tagDep04b'
          when mod(b.ord, 6) = 5 then 'tagDep05b'
          when mod(b.ord, 6) = 0 then 'tagDep06b'
          end color
          , dea.direccion_ejecutiva, dea.area
        from direjeccolor02 b
        inner join v_direjecarea dea on dea.direccion_ejecutiva_id = b.direccion_ejecutiva_id
      )
      , v_direjecareacolor(area_id, direccion_ejecutiva_id, cnt, ord, color, de_, a_) as
      (
        select AREA_ID,DIRECCION_EJECUTIVA_ID,CNT,ORD,COLOR,DE_,A_ 
        from direjeccolor03 c
      )
      --termina vista vDirEjecAreaColor
    
      --termina vista vEmpleadoCalificacion
      , calificacion01(periodo, empleado_id, calificacion_total) as
      (
              select p_e.periodo, eve.empleado_id, avg(ev.TOTAL_CALIFICACION)
              from OKR_EVALUACION ev
              inner join OKR_EVALUACION_EMPLEADO_XREF eve on eve.evaluacion_id = ev.evaluacion_id
              inner join OKR_FRZ_PERIODOS_EVALUACION p_e on eve.empleado_id = p_e.empleado_id
                and EXTRACT( YEAR FROM to_date('2022-01-01','yyyy-MM-dd')) = p_e.year
                and ceil(extract(MONTH from to_date('2022-01-01','yyyy-MM-dd'))/3) = p_e.quarter
                and EXTRACT( YEAR FROM p_e.PERIODO) = EXTRACT( YEAR FROM to_date('2022-01-01','yyyy-MM-dd'))
              --where eve.empleado_id = 532
              where eve.active_flag = 1
              and ev.autoevaluacion = 0
              group by p_e.periodo, eve.empleado_id, eve.active_flag
      )
      , calificacion02(periodo, empleado_id, calificacion_total, calificacion_texto) as
      (
        select a.periodo, a.empleado_id, a.calificacion_total
        , case 
          when a.calificacion_total between 1 and 1.79 then 'DS'
          when a.calificacion_total between 1.8 and 2.79 then 'ST'
          when a.calificacion_total between 2.8 and 3.69 then 'SS'
          when a.calificacion_total between 3.7 and 4.00 then 'EX'
          else 'PD' end
        from calificacion01 a
      )
      , v_calificacion(periodo, empleado_id, calificacion_total, calificacion_texto, reporta_id) as
      (
        select b.PERIODO, b.EMPLEADO_ID,b.CALIFICACION_TOTAL,b.CALIFICACION_TEXTO, nvl(er.reporta_id, 0) reporta_id
        from calificacion02 b
        left join v_reporta er on b.empleado_id = er.empleado_id and er.activo = 1--vista vempleadoreportaactivo
      )
      --termina vista vEmpleadoCalificacion
    
      --inicia consulta principal de procedimiento
      , niv(empleado_id, reporta_id, nivel)as
      (
        select e.empleado_id, 0 reporta_id, 1 nivel
        from okr_empleados e
        left join v_reporta er on e.empleado_id = er.empleado_id--vista vempleadoreportaactivo
        where er.empleado_id is null
        and e.active_flag = 1
        union all
        select er.empleado_id, er.reporta_id, niv.nivel + 1 nivel
        from niv
        inner join v_reporta er on er.reporta_id = niv.empleado_id--vista vempleadoreportaactivo
      )
      ,ea(empleado_id, area_id) as
      (
        select ea.empleado_id, ea.area_id
        from v_area ea--vista vempleadoareaactivo
        --where ea.activo = 1
      )
      , ep(empleado_id, puesto_id) as
      (
        select ep.empleado_id, ep.puesto_id
        from v_puesto ep--vista vempleadopuestoactivo
        where ep.activo = 1
      )
      , er(empleado_id, reporta_id, fecha_alta) as
      (
        select er.empleado_id, er.reporta_id, er.fecha_alta
        from v_reporta er--vista vempleadoreportaactivo
        where er.activo = 1
      ) 
      , ee(empleado_id, area_id, direccion_ejecutiva_id, numero_direccion_ejecutiva, direccion_ejecutiva_descripcion
      , color, puesto_id, reporta_id, nivel, fecha_alta, calificacion_total, calificacion_texto) as
      (
        select e.empleado_id, ea.area_id
        , nvl(dea.direccion_ejecutiva_id, 0), nvl(dea.num_direccion_ejecutiva, 0), nvl(dea.direccion_ejecutiva, ''), nvl(cl.color, 'tagDep01b')
        , ep.puesto_id, er.reporta_id, nvl(niv.nivel, -1) nivel
        , nvl(er.fecha_alta, sysdate) fecha_alta
        , nvl(ec.calificacion_total, 0) calificacion_total
        , nvl(ec.calificacion_texto, 'PD') calificacion_texto
        from okr_empleados e
        left join ea on ea.empleado_id = e.empleado_id
        left join v_direjecarea dea on dea.area_id = ea.area_id --vista vdirejecarea
        left join v_direjecareacolor cl on dea.area_id = cl.area_id--vista vdirejecareacolor
        inner join ep on ep.empleado_id = e.empleado_id
        left join er on er.empleado_id = e.empleado_id
        left join niv on e.empleado_id = niv.empleado_id
        left join v_calificacion ec on ec.empleado_id = e.empleado_id--vista vempleadocalificacion
          and EXTRACT( YEAR FROM ec.PERIODO) = EXTRACT( YEAR FROM sysdate)
        where e.active_flag = 1
      )--select * from ee
      select nvl(a.area_id, 0) area_id, nvl(a.num_area, 0) numero_area, nvl(a.descripcion, '') area_descripcion
      , ee.direccion_ejecutiva_id, ee.numero_direccion_ejecutiva, ee.direccion_ejecutiva_descripcion, ee.color
      , p.puesto_id, p.descripcion puesto_descripcion
      , e.empleado_id, e.num_empleado, e.nombre nombre_empleado, e.email email_empleado, e.avatar
      , j.empleado_id empleado_jefe_id, j.num_empleado numero_empleado_jefe, j.nombre nombre_empleado_jefe
      , ee.nivel, ee.fecha_alta, ee.calificacion_total, ee.calificacion_texto
      from ee
      inner join okr_empleados e on ee.empleado_id = e.empleado_id
      left join okr_cat_areas a on ee.area_id = a.area_id
      inner join okr_cat_puestos p on ee.puesto_id = p.puesto_id
      left join okr_empleados j on ee.reporta_id = j.empleado_id
      where p.num_puesto not in (487, 512, 334)      
      order by ee.nivel, e.nombre
      ;
    end if;    
END SP_EMPLEADOS_ESTRUCTURA;
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220623234954_UpdateProcedureSP_EMPLEADOS_ESTRUCTURA_FRZ', N'5.0.12')
/

ALTER TABLE "OKR_EVALUACION" ADD "AUTOEVALUACION_RECHAZO_ID" NUMBER(19)
/

ALTER TABLE "OKR_EVALUACION" ADD "FECHA_RECHAZO" TIMESTAMP(7)
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220624163308_AddCamposHistoricosRechazoEvaluacion', N'5.0.12')
/

ALTER TABLE "TF_FIRMAS" ADD "TIPO_DOCUMENTO_ID" NUMBER(19) DEFAULT 0 NOT NULL
/

BEGIN 

execute immediate 'CREATE SEQUENCE "SQ_TF_CAT_TIPO_DOCUMENTO" start with 1';

execute immediate 'CREATE TABLE "TF_CAT_TIPO_DOCUMENTO" (
    "TIPO_DOCUMENTO_ID" NUMBER(19) NOT NULL,
    "DESCRIPCION" NVARCHAR2(255) NOT NULL,
    "ACTIVE_FLAG" NUMBER(1) DEFAULT 1 NOT NULL,
    "LAST_UPDATE" TIMESTAMP(7) DEFAULT (sysdate) NOT NULL,
    CONSTRAINT "PK_TF_TIPO_DOCUMENTO" PRIMARY KEY ("TIPO_DOCUMENTO_ID")
)';
execute immediate 'create or replace trigger "TR_TF_CAT_TIPO_DOCUMENTO"
before insert on "TF_CAT_TIPO_DOCUMENTO" for each row 
begin 
  if :new."TIPO_DOCUMENTO_ID" is NULL then 
    select "SQ_TF_CAT_TIPO_DOCUMENTO".nextval into :new."TIPO_DOCUMENTO_ID" from dual;  
  end if; 
end;';
END;
/

CREATE INDEX "IX_TF_FIRMAS_TIPO_DOCUMENTO_ID" ON "TF_FIRMAS" ("TIPO_DOCUMENTO_ID")
/

ALTER TABLE "TF_FIRMAS" ADD CONSTRAINT "FK_TIPO_DOCUMENTO" FOREIGN KEY ("TIPO_DOCUMENTO_ID") REFERENCES "TF_CAT_TIPO_DOCUMENTO" ("TIPO_DOCUMENTO_ID") ON DELETE CASCADE
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220628165128_AddCatTipoDocumentoTrabajoFlexible', N'5.0.12')
/

INSERT INTO TF_CAT_TIPO_DOCUMENTO (descripcion, contenido) VALUES ('Carta Compromiso 1', '<p style="text - align: justify; font - size:18px; "> Nulla facilisi. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis
                        egestas.Mauris auctor turpis et tortor accumsan mattis.Mauris ultricies arcu in laoreet sodales.
                        Nulla dolor mi, congue eget aliquam in, convallis a quam.Maecenas nec gravida nibh, vel aliquet quam.
                        Praesent fermentum cursus nibh, ut lacinia ligula tempor a. </ p >
                        < p style = "text-align: justify; font-size:18px;" > enean scelerisque tortor nec odio rutrum, ut condimentum urna luctus. Praesent quis
                        leo id odio pharetra mollis quis in ex.Donec molestie sem non accumsan finibus. Morbi ullamcorper egestas
                        mi.In sit amet viverra felis.</ p > ')
/

INSERT INTO TF_CAT_TIPO_DOCUMENTO (descripcion, contenido) VALUES ('Carta Compromiso 2', '<p style="text - align: justify; font - size:18px; "> Egestas diam in arcu cursus euismod quis viverra nibh. Eu scelerisque felis imperdiet proin fermentum leo vel orci. Amet cursus sit amet dictum sit amet justo donec enim. In arcu cursus euismod quis viverra nibh cras. </p>
                        < p style = "text-align: justify; font-size:18px;" > Amet facilisis magna etiam tempor orci eu lobortis.Senectus et netus et malesuada fames ac turpis egestas sed. </ p > ')
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220628170438_PopulateCatTipoDocumentoTrabajoFlexible', N'5.0.12')
/

ALTER TABLE "TF_CAT_TIPO_DOCUMENTO" ADD "CONTENIDO" NVARCHAR2(2000)
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220628221703_AddColumnCatTipoDocumentoTrabajoFlexible', N'5.0.12')
/

ALTER TABLE "OKR_EMPLEADOS" ADD "CANDIDATO_TRABAJO_FLEXIBLE" NUMBER(1) DEFAULT 0 NOT NULL
/

ALTER TABLE "OKR_EMPLEADOS" ADD "TF_FULL_REMOTE" NUMBER(1) DEFAULT 0 NOT NULL
/

ALTER TABLE "OKR_EMPLEADOS" ADD "TF_TUTORIAL_COMPLETO" NUMBER(1) DEFAULT 0 NOT NULL
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220630165234_AddColumnsOKREmpleadoTrabajoFlexible', N'5.0.12')
/

merge into TF_CAT_SENTIMIENTOS s
using
(
    select '01_Amazed.png' imagen, 'Increíble' sentimiento, 1 orden from dual
    union all select '02_Angry.png' imagen, 'Con enojo' sentimiento, 2 orden from dual
    union all select '03_Confused.png' imagen, 'Con angustia, preocupación' sentimiento, 3 orden from dual
    union all select '04_Crying.png' imagen, 'Muy triste' sentimiento, 4 orden from dual
    union all select '05_Happy.png' imagen, 'Feliz' sentimiento, 5 orden from dual
    union all select '06_In_Love.png' imagen, 'Con calma, serenidad' sentimiento, 6 orden from dual
    union all select '07_Laughter.png' imagen, 'Con entusiasmo' sentimiento, 7 orden from dual
    union all select '08_Pokerface.png' imagen, 'Neutral' sentimiento, 8 orden from dual
    union all select '09_Sad.png' imagen, 'Decaído(a)' sentimiento, 9 orden from dual
    union all select '10_Skeptic.png' imagen, 'Listo(a)' sentimiento, 10 orden from dual
    union all select '11_Wink.png' imagen, 'Con esperanza' sentimiento, 11 orden from dual
    union all select '12_Laughter.png' imagen, 'Risueño(a)' sentimiento, 12 orden from dual
    union all select '13_Breathe.png' imagen, 'Con estrés' sentimiento, 13 orden from dual
    union all select '14_Stunned.png' imagen, 'Confundido(a)' sentimiento, 14 orden from dual
    union all select '15_Angel.png' imagen, 'Bendecido(a)' sentimiento, 15 orden from dual
    union all select '16_Devil.png' imagen, 'Malvado(a)' sentimiento, 16 orden from dual
    union all select '17_Scared.png' imagen, 'Temeroso(a)' sentimiento, 17 orden from dual
    union all select '18_Sleeping.png' imagen, 'Con sueño' sentimiento, 18 orden from dual
    union all select '19_Kiss.png' imagen, 'Encantador(a)' sentimiento, 19 orden from dual
    union all select '20_Worry.png' imagen, 'Preocupado(a)' sentimiento, 20 orden from dual
    union all select '21_Joke.png' imagen, 'Como nuevo(a)' sentimiento, 21 orden from dual
    union all select '22_Cool.png' imagen, 'Ganador(a)' sentimiento, 22 orden from dual
    union all select '23_Bubble Gum.png' imagen, 'Distraído(a)' sentimiento, 23 orden from dual
    union all select '24_Cat.png' imagen, 'Tranquilo(a)' sentimiento, 24 orden from dual
    union all select '25_Death.png' imagen, 'Sorprendido(a)' sentimiento, 25 orden from dual
    union all select '26_Singing.png' imagen, 'Relajado(a)' sentimiento, 26 orden from dual
    union all select '27_Rock.png' imagen, 'Motivado(a)' sentimiento, 27 orden from dual
    union all select '28_Wonder.png' imagen, 'Ilusionado(a)' sentimiento, 28 orden from dual
    union all select '29_Jumping.png' imagen, 'Bien' sentimiento, 29 orden from dual
    union all select '30_Sick.png' imagen, 'Enfermo(a)' sentimiento, 30 orden from dual
    union all select '31_Frozen.png' imagen, 'Con frío' sentimiento, 31 orden from dual
    union all select '32_Girl.png' imagen, 'Amable' sentimiento, 32 orden from dual
    union all select '33_Flirty.png' imagen, 'Con confianza' sentimiento, 33 orden from dual
    union all select '34_Hello.png' imagen, 'Alegre' sentimiento, 34 orden from dual
    union all select '35_Ashamed.png' imagen, 'Agobiado(a)' sentimiento, 35 orden from dual
    union all select '36_Vomited.png' imagen, 'Cansado(a)' sentimiento, 36 orden from dual
    union all select '37_Goodwork.png' imagen, 'Positivo(a)' sentimiento, 37 orden from dual
    union all select '38_Party.png' imagen, 'Festivo(a)' sentimiento, 38 orden from dual
    union all select '39_Facepalm.png' imagen, 'Con frustración' sentimiento, 39 orden from dual
    union all select '40_Stop It!.png' imagen, 'Molesto(a)' sentimiento, 40 orden from dual
    union all select '41_Shock.png' imagen, 'Asombrado(a)' sentimiento, 41 orden from dual
    union all select '42_Silence.png' imagen, 'Reservado(a)' sentimiento, 42 orden from dual
    union all select '43_Disgust.png' imagen, 'Pesimista' sentimiento, 43 orden from dual
    union all select '44_Exactly.png' imagen, 'Sabelotodo' sentimiento, 44 orden from dual
    union all select '45_Yawn.png' imagen, 'Aburrido(a)' sentimiento, 45 orden from dual
    union all select '46_Dancing.png' imagen, 'Fantástico(a)' sentimiento, 46 orden from dual
    union all select '47_Badwork.png' imagen, 'En desacuerdo' sentimiento, 47 orden from dual
    union all select '48_Clown.png' imagen, 'Bromista' sentimiento, 48 orden from dual
    union all select '49_Yes.png' imagen, 'Mal' sentimiento, 49 orden from dual
    union all select '50_No.png' imagen, 'Triste' sentimiento, 50 orden from dual
) t
on (s.orden = t.orden)
when matched then
update set imagen = t.imagen, sentimiento = t.sentimiento
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220705154854_UPDATE_TF_CAT_SENTIMIENTO', N'5.0.12')
/

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
                        TBEVAQ1.total_calificacion IS NULL
                    THEN 0
                    ELSE
                    TBEVAQ1.total_calificacion
                    END                                                         AS "CALIFICACION_Q1",

                    CASE WHEN
                        TBEVAQ1.EVALUACION_ESTATUS_ID = 3
                    THEN 1
                    ELSE 0
                    END                                                         AS "ESATATUS_Q1",

                    CASE  WHEN
                        TBEVAQ2.total_calificacion IS NULL
                    THEN 0
                    ELSE
                    TBEVAQ2.total_calificacion
                    END                                                         AS "CALIFICACION_Q2",

                    CASE WHEN
                        TBEVAQ2.EVALUACION_ESTATUS_ID = 3
                    THEN 1
                    ELSE 0
                    END                                                         AS "ESATATUS_Q2",

                    CASE WHEN
                        TBERQ1.CERRADA = 1
                    THEN 1
                    ELSE 0
                    END                                                         AS "RETROALIMENTACION_Q1",

                   CASE WHEN
                          (SELECT 1
                          FROM TF_FIRMAS TFIRMA
                          WHERE TFIRMA.EMPLEADO_ID = EMP.EMPLEADO_ID 
                          AND TFIRMA.ACTIVE_FLAG = 1) = 1
                    THEN 1
                    ELSE 0
                    END                                                         AS "DOCUMENTO_FIRMADO"

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

                /*Evaluacion de empleados de Q1*/
                LEFT JOIN
                (
                    SELECT TBE.EVALUACION_ID, tbeve.empleado_id
                    FROM OKR_EVALUACION TBE
                    LEFT JOIN okr_evaluacion_empleado_xref TBEVE ON tbeve.evaluacion_id = TBE.EVALUACION_ID
                        AND TBE.AUTOEVALUACION = 0 AND(tbe.periodo_evaluacion_id = 1 AND TBE.YEAR_EVALUACION = 2022)
                ) TBEVAEMP ON TBEVAEMP.EMPLEADO_ID = EMP.EMPLEADO_ID

                LEFT JOIN
                (
                    SELECT EVALUACION_ID, AUTOEVALUACION, EVALUACION_ESTATUS_ID, TOTAL_CALIFICACION
                    FROM okr_evaluacion WHERE AUTOEVALUACION = 0
                ) TBEVAQ1  ON TBEVAQ1.evaluacion_id = TBEVAEMP.evaluacion_id

                /*Evaluacion de empleados Q2 Migration*/
                LEFT JOIN
                (
                    SELECT TBE.EVALUACION_ID, tbeve.empleado_id
                    FROM OKR_EVALUACION TBE
                    LEFT JOIN okr_evaluacion_empleado_xref TBEVE ON tbeve.evaluacion_id = TBE.EVALUACION_ID
                        AND TBE.AUTOEVALUACION = 0 AND(tbe.periodo_evaluacion_id = 2 AND TBE.YEAR_EVALUACION = 2022)
                ) TBEVAEMPQ2 ON TBEVAEMPQ2.EMPLEADO_ID = EMP.EMPLEADO_ID

                LEFT JOIN
                (
                    SELECT EVALUACION_ID, AUTOEVALUACION, EVALUACION_ESTATUS_ID, TOTAL_CALIFICACION
                    FROM okr_evaluacion WHERE AUTOEVALUACION = 0
                ) TBEVAQ2  ON TBEVAQ2.evaluacion_id = TBEVAEMPQ2.evaluacion_id


                LEFT JOIN
                (
                    SELECT EMPLEADO_ID, CERRADA
                    FROM OKR_RETROALIMENTACION TBR
                    WHERE CERRADA = 1 and tbr.periodo_evaluacion_id = 1 and tbr.year_evaluacion = 2022
                ) TBERQ1 ON TBERQ1.EMPLEADO_ID = emp.empleado_id
                WHERE EMP.ACTIVE_FLAG = 1

            ORDER BY EMP.EMPLEADO_ID ASC;
            END;
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220705160113_UpdateSP_TF_EMPLEADOS_DETALLE', N'5.0.12')
/

delete from tf_cat_sentimientos where orden>50
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220705170812_DELETE_TF_CAT_SENTIMIENTO', N'5.0.12')
/

