--------------------------------------------------------
-- Archivo creado  - mi�rcoles-febrero-23-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table OKR_CAT_AREAS
--------------------------------------------------------

  CREATE TABLE "OKR_CAT_AREAS" 
   (	"AREA_ID" NUMBER(10,0), 
	"NUM_AREA" NUMBER(19,0), 
	"DESCRIPCION" NVARCHAR2(255), 
	"LAST_UPDATE" TIMESTAMP (7) DEFAULT (sysdate), 
	"ACTIVE_FLAG" NUMBER(1,0) DEFAULT 1
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_CDO_APP" ;
REM INSERTING into OKR_CAT_AREAS
SET DEFINE OFF;
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (181,0,'Cr�dito Comercial',to_timestamp('01/02/22 14:11:01.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (182,0,'Cr�dito Consumo',to_timestamp('01/02/22 14:11:28.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (201,0,'INFRAESTRUCTURA',to_timestamp('03/02/22 16:32:57.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (162,0,'Cr�dito',to_timestamp('28/01/22 10:07:23.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (81,3,'DIRECCION GENERAL HM',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (82,5,'DIRECCION GENERAL ADJUNTA RV',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (83,6,'DIRECCION GENERAL ADJUNTA JPV',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (84,8,'SEGURIDAD INFORMATICA',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (85,9,'INFORMACION ESTRATEGICA',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (86,20,'AUDITORIA INTERNA',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (87,30,'CONTROL INTERNO',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (88,31,'COMPLIANCE',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (89,32,'NORMATIVA Y PLD',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (90,50,'JURIDICO',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (91,51,'FIDUCIARIO',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (92,78,'RECUPERACION DE CARTERA',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (93,41,'PREVISION SOCIAL',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (94,16,'VALORES',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (95,17,'FINANZAS',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (96,18,'ADMINISTRACION DE CREDITO',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (97,22,'LIQUIDACION A TERCEROS',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (98,23,'UNIDAD INTERNA',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (99,24,'OPERACIONES BANCARIAS',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (100,27,'OPERACIONES ARRENDADORA',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (101,49,'CONTRATOS',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (102,100,'PRODUCTOS BANCARIOS',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (103,52,'PROMOCION Y ASESORIA',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (104,53,'SERVICIOS CAT',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (105,56,'WEALTH MANAGEMENT',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (106,75,'EDUCACION FINANCIERA',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (107,80,'BANCA SOLUCIONES',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (108,95,'EXPERIENCIA AL CLIENTE',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (109,101,'OFICINA DE INVERSIONES',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (110,12,'ASESORIA CORPORATIVA',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (111,42,'BANCA DE INVERSION',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (112,92,'BANCA DE RELACION',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (113,102,'BANCA CORPORATIVA  Y BANCA DE INVERSION',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (114,54,'BURSANET CANALES Y MEDIOS DIGITALES',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (115,97,'CANALES DIGITALES',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (116,99,'DINN',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (117,36,'ANALISIS',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (118,40,'INSTITUCIONALES Y BANCA DE GOBIERNO',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (119,43,'MESA DE CAMBIOS',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (120,44,'TESORERIA Y MESA DE DINERO',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (121,45,'MESA DE CAPITALES',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (122,47,'POSICION PROPIA Y ARBITRAJE',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (123,70,'MESA DE DERIVADOS',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (124,76,'VENTAS INSTITUCIONALES',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (125,90,'VENTAS TRANSACCIONAL',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (126,98,'PLATAFORMAS ELECTRONICAS',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (127,108,'ESTRUCTURACION DE DERIVADOS',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (128,109,'VENTAS TESORERIA',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (129,110,'ESTRATEGIA COMERCIAL FX Y TRANSACCIONAL',to_timestamp('06/01/22 18:58:58.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (130,10,'CAPITAL HUMANO',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (131,74,'COMUNICACION Y CULTURA',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (132,104,'ESTRATEGIA TRANSFORMACIONAL',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (133,111,'MERCADOTECNIA',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (134,113,'METODOS Y PROCESOS',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (135,26,'COMERCIAL ARRENDADORA',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (136,94,'ADMINISTRACION DE ACTIVOS',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (137,7,'RIESGOS',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (138,29,'ASSET MANAGEMENT',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (139,33,'ANALISIS DE CREDITO',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (140,34,'CREDITO PERSONAS MORALES',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (141,35,'CREDITO PERSONAS FISICAS',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (142,14,'CONSULTORIA Y SEGUROS',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (143,0,'DESARROLLO',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (144,0,'OFICINA DE DATOS',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (145,0,'LABORATORIO DIGITAL',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (146,0,'ARQUITECTURA',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (147,0,'PROYECTOS ESTRAT�GICOS',to_timestamp('06/01/22 18:58:59.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
Insert into OKR_CAT_AREAS (AREA_ID,NUM_AREA,DESCRIPCION,LAST_UPDATE,ACTIVE_FLAG) values (148,15,'TECNOLOGIAS DE LA INFORMACION',to_timestamp('06/01/22 19:05:12.000000000','DD/MM/RR HH24:MI:SSXFF'),1);
--------------------------------------------------------
--  DDL for Index PK_OKR_CAT_AREAS
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_OKR_CAT_AREAS" ON "OKR_CAT_AREAS" ("AREA_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_CDO_APP" ;
--------------------------------------------------------
--  DDL for Trigger TR_OKR_CAT_AREAS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_OKR_CAT_AREAS" 
before insert on "OKR_CAT_AREAS" for each row 
begin 
  if :new."AREA_ID" is NULL then 
    select "SQ_OKR_CAT_AREAS".nextval into :new."AREA_ID" from dual;  
  end if; 
end;
/
ALTER TRIGGER "TR_OKR_CAT_AREAS" ENABLE;
--------------------------------------------------------
--  Constraints for Table OKR_CAT_AREAS
--------------------------------------------------------

  ALTER TABLE "OKR_CAT_AREAS" MODIFY ("AREA_ID" NOT NULL ENABLE);
  ALTER TABLE "OKR_CAT_AREAS" MODIFY ("NUM_AREA" NOT NULL ENABLE);
  ALTER TABLE "OKR_CAT_AREAS" MODIFY ("DESCRIPCION" NOT NULL ENABLE);
  ALTER TABLE "OKR_CAT_AREAS" MODIFY ("LAST_UPDATE" NOT NULL ENABLE);
  ALTER TABLE "OKR_CAT_AREAS" MODIFY ("ACTIVE_FLAG" NOT NULL ENABLE);
  ALTER TABLE "OKR_CAT_AREAS" ADD CONSTRAINT "PK_OKR_CAT_AREAS" PRIMARY KEY ("AREA_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_CDO_APP"  ENABLE;
