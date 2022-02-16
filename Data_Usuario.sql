select 
    tbu.usuario_id,
    tbup.usuario_puesto_id,
    tbu.numero_nomina,
    tbu.nombre_usuario,
    tbu.apellido_paterno || ' ' || tbu.apellido_materno || ' ' || tbu.nombre as "Nombre",
    tbr.nombre      as "Rol",
    tbp.nombre      as "Proyecto",
    tbo.nombre      as "Opcion"
from 
            app_usuario                     tbu
left join   app_usuario_puesto_xref         tbup on tbu.usuario_id              =  tbup.usuario_puesto_id       
left join   app_usuario_rol_xref            tbur on tbur.usuario_puesto_id      =  tbup.usuario_puesto_id  and tbur.active_flag = 1
left join   app_rol                         tbr  on tbr.rol_id                  =  tbur.rol_id
left join   app_proyecto_opcion_xref        tbpo on tbpo.proyecto_opcion_id     =  tbur.proyecto_opcion_id
left join   app_opcion                      tbo  on tbo.opcion_id               =  tbpo.opcion_id
left join   app_proyecto                    tbp  on tbp.proyecto_id             =  tbpo.proyecto_id
where tbp.nombre = 'Dashboard Banca Soluciones' and tbo.nombre = 'Clientes';

