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

ALTER TABLE "OKR_EVALUACION" ADD "AUTOEVALUACION_RECHAZO_ID" NUMBER(19)
/

ALTER TABLE "OKR_EVALUACION" ADD "FECHA_RECHAZO" TIMESTAMP(7)
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20220624163308_AddCamposHistoricosRechazoEvaluacion', N'5.0.12')
/

