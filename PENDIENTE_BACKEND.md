# Pendiente para backend (Supabase)

> La función `public.aceptar_cotizacion(p_cotizacion_id uuid)` ya existe en Supabase. Su SQL está en [`base_de_datos/aceptar_cotizacion.sql`](base_de_datos/aceptar_cotizacion.sql).

## Otros candidatos, sin urgencia

Estas operaciones también hacen varias escrituras separadas y podrían pasar a funciones RPC más adelante:

- **Guardar el perfil del técnico:** actualiza `perfiles_tecnicos` y luego sincroniza `tecnico_oficios`. Si falla a mitad, volver a guardar lo corrige.
- **Crear una solicitud:** inserta en `solicitudes_servicio` y después sube las fotos (`solicitud_archivos` + Storage). Si falla una foto, la solicitud ya quedó creada y, si el usuario reintenta, se duplica.