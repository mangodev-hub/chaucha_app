-- Borra todo lo sembrado (cuentas @semilla.chaucha.app y lo que cuelga de ellas).
begin;
create temp table _ids on commit drop as
  select id from auth.users where email like '%@semilla.chaucha.app';
delete from resenas where autor_id in (select id from _ids) or destinatario_id in (select id from _ids);
delete from mensajes where conversacion_id in (select c.id from conversaciones c join solicitudes_servicio s on s.id = c.solicitud_id where s.cliente_id in (select id from _ids) or c.tecnico_id in (select id from _ids));
delete from conversaciones where tecnico_id in (select id from _ids) or solicitud_id in (select id from solicitudes_servicio where cliente_id in (select id from _ids));
delete from comisiones where cotizacion_id in (select id from cotizaciones where tecnico_id in (select id from _ids) or solicitud_id in (select id from solicitudes_servicio where cliente_id in (select id from _ids)));
delete from cotizaciones where tecnico_id in (select id from _ids) or solicitud_id in (select id from solicitudes_servicio where cliente_id in (select id from _ids));
delete from historial_puntos where tecnico_id in (select id from _ids);
delete from solicitudes_servicio where cliente_id in (select id from _ids);
delete from eventos where payload->>'tecnico_id' in (select id::text from _ids);
delete from auth.users where id in (select id from _ids);
commit;
