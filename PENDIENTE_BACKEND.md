# Pendiente para backend (Supabase)

> **Para el equipo de backend.** Hay que crear una función en la base de datos de Supabase. No cambia tablas ni políticas RLS. Cuando esté creada, avisen a frontend: hasta entonces la app no la usa y sigue funcionando como hoy.

## Qué hay que hacer

Crear la función `public.aceptar_cotizacion(p_cotizacion_id uuid)` con el SQL de abajo, probarla con los casos indicados y avisar a frontend.

## Por qué

Cuando un cliente acepta una cotización, hoy la app hace **tres escrituras separadas** desde el cliente:

1. `cotizaciones`: marca la elegida como `aceptada`.
2. `cotizaciones`: marca las demás pendientes de la misma solicitud como `rechazada`.
3. `solicitudes_servicio`: cambia la solicitud a `aceptada`.

Esto tiene tres problemas:

| Problema | Qué puede pasar |
| --- | --- |
| **No es atómico** | Si falla la escritura 2 o la 3 (red, timeout, RLS), queda una cotización aceptada con la solicitud todavía en `cotizada`, o con otras cotizaciones pendientes. |
| **RLS falla en silencio** | Cuando una política bloquea un `UPDATE`, Postgres no da error: modifica 0 filas. La app cree que todo salió bien. |
| **Carrera** | Si se aceptan dos cotizaciones de la misma solicitud casi al mismo tiempo (dos pestañas, doble toque), las dos pueden quedar aceptadas. |

## Qué hace la función

- Hace las tres escrituras en **una sola transacción**: si una falla, se revierten todas.
- **Bloquea la fila de la solicitud** (`for update`), así dos aceptaciones simultáneas se ejecutan una detrás de otra y la segunda falla.
- Revisa `row_count` después de cada `UPDATE` obligatorio y **aborta si RLS no dejó modificar** la fila.
- Valida que la cotización esté `pendiente` y que la solicitud esté en `abierta` o `cotizada`. Son las mismas condiciones con las que la app ya muestra el botón "Aceptar".
- Los errores usan `raise exception` (SQLSTATE `P0001`). La app muestra ese mensaje tal cual al usuario, por eso están en español.

**Seguridad:** la función es `security invoker`, así que corre con los permisos y las políticas RLS del usuario que la llama. No da permisos nuevos. Solo se concede `execute` al rol `authenticated`.

## Antes de ejecutar, verificar

Frontend no tiene acceso al esquema, así que estos supuestos no están comprobados. Si alguno no coincide, ajusten el SQL o avísennos:

- `cotizaciones.id`, `cotizaciones.solicitud_id` y `solicitudes_servicio.id` son `uuid`.
- `cotizaciones.estado` y `solicitudes_servicio.estado` son texto con `CHECK`. Valores: `pendiente / aceptada / rechazada` y `abierta / cotizada / aceptada / por_confirmar / completada / cancelada`.
- Las políticas RLS actuales permiten que el cliente dueño de la solicitud lea y actualice las cotizaciones de su solicitud, y lea y actualice su solicitud. Ya deberían existir, porque la app hace hoy esas mismas escrituras.

## SQL

Ejecutar en Supabase → SQL Editor:

```sql
-- Acepta una cotización, rechaza las demás pendientes de la misma solicitud
-- y marca la solicitud como aceptada. Todo o nada.
create or replace function public.aceptar_cotizacion(p_cotizacion_id uuid)
returns void
language plpgsql
security invoker            -- corre con los permisos (RLS) del usuario, igual que hoy
set search_path = public
as $$
declare
  v_solicitud_id      uuid;
  v_estado_cotizacion text;
  v_estado_solicitud  text;
  v_filas             int;
begin
  select solicitud_id, estado
    into v_solicitud_id, v_estado_cotizacion
    from cotizaciones
   where id = p_cotizacion_id;
  if not found then
    raise exception 'La cotización no existe.';
  end if;

  -- Bloquea la solicitud: dos aceptaciones simultáneas no pueden cruzarse.
  select estado
    into v_estado_solicitud
    from solicitudes_servicio
   where id = v_solicitud_id
     for update;
  if not found then
    raise exception 'No tienes permiso sobre esta solicitud.';
  end if;

  if v_estado_solicitud not in ('abierta', 'cotizada') then
    raise exception 'Esta solicitud ya no acepta cotizaciones.';
  end if;
  if v_estado_cotizacion <> 'pendiente' then
    raise exception 'Esta cotización ya no está pendiente.';
  end if;

  update cotizaciones set estado = 'aceptada' where id = p_cotizacion_id;
  get diagnostics v_filas = row_count;
  if v_filas = 0 then
    raise exception 'No tienes permiso para aceptar esta cotización.';
  end if;

  update cotizaciones
     set estado = 'rechazada'
   where solicitud_id = v_solicitud_id
     and id <> p_cotizacion_id
     and estado = 'pendiente';

  update solicitudes_servicio set estado = 'aceptada' where id = v_solicitud_id;
  get diagnostics v_filas = row_count;
  if v_filas = 0 then
    raise exception 'No tienes permiso para actualizar esta solicitud.';
  end if;
end;
$$;

grant execute on function public.aceptar_cotizacion(uuid) to authenticated;
```

## Cómo probar

En el SQL Editor se corre como `postgres`, que salta RLS. Para probar como un cliente real, simulen su sesión dentro de una transacción que se revierte al final. Reemplacen los ids por datos de prueba:

```sql
begin;
  -- Actuar como el cliente dueño de la solicitud
  select set_config('request.jwt.claims',
    '{"sub":"<uuid-del-cliente>","role":"authenticated"}', true);
  set local role authenticated;

  select public.aceptar_cotizacion('<uuid-de-cotizacion-pendiente>');

  -- Revisar el resultado
  select id, estado from cotizaciones where solicitud_id = '<uuid-solicitud>';
  select id, estado from solicitudes_servicio where id = '<uuid-solicitud>';
rollback;  -- no deja cambios
```

Casos a cubrir:

1. **Cliente dueño, cotización pendiente:** la elegida queda `aceptada`, las demás pendientes quedan `rechazada` y la solicitud queda `aceptada`.
2. **Otro usuario** (cambiar el `sub`): debe fallar con un mensaje de permiso y no modificar nada.
3. **Repetir la llamada** sobre la misma solicitud: debe fallar con "Esta solicitud ya no acepta cotizaciones."

## Cómo revertir

La función no modifica tablas ni políticas. Para quitarla:

```sql
drop function public.aceptar_cotizacion(uuid);
```

## Cambio en la app (frontend)

Lo puede hacer quien creó la función. **Orden obligatorio: primero crear y probar la función en Supabase, después cambiar la app.** Si la app llama a una función que no existe, aceptar cotizaciones deja de funcionar.

### 1. Preparar el entorno

```bash
git clone https://github.com/mangodev-hub/chaucha_app.git
cd chaucha_app
git checkout -b <tu-nombre>/rpc-aceptar-cotizacion
cd tecnicos_app
flutter pub get
```

- Para subir la rama necesitas acceso de colaborador al repositorio en GitHub.
- `tecnicos_app/env.json` no está en el repo porque tiene las claves de Supabase. Pídelo por un canal privado y nunca lo subas.

### 2. El repositorio de cotizaciones llama a la función

En `tecnicos_app/lib/features/cotizaciones/data/repositories/supabase_cotizacion_repository.dart`, reemplaza el método `aceptar` completo, con su comentario `// OJO: ...`, por:

```dart
  /// Acepta la cotización, rechaza las demás pendientes y marca la solicitud
  /// como aceptada, todo en una transacción (función RPC en Supabase).
  @override
  Future<void> aceptar(Cotizacion cotizacion) {
    return supabaseGuard(() async {
      await _client.rpc(
        'aceptar_cotizacion',
        params: {'p_cotizacion_id': cotizacion.id},
      );
    });
  }
```

Si después de este cambio el import de `estado_cotizacion_db.dart` queda sin usar, bórralo: `flutter analyze` lo va a marcar.

En `tecnicos_app/lib/features/cotizaciones/domain/repositories/cotizacion_repository.dart`, actualiza el comentario de `aceptar`:

```dart
  /// Acepta [cotizacion], rechaza las demás pendientes de la misma solicitud
  /// y marca la solicitud como aceptada, en una sola transacción.
  Future<void> aceptar(Cotizacion cotizacion);
```

### 3. Quitar el caso de uso `AceptarCotizacion`

Ya no combina dos repositorios, porque la base cambia el estado de la solicitud. Si se dejara como está, la solicitud se actualizaría dos veces. Según las reglas del proyecto, sin esa combinación ya no corresponde un caso de uso:

1. Borra `tecnicos_app/lib/features/solicitudes/domain/usecases/aceptar_cotizacion.dart`.
2. En `tecnicos_app/lib/features/solicitudes/presentation/providers/detalle_provider.dart`:
   - borra `aceptarCotizacionProvider` y el import de `aceptar_cotizacion.dart`;
   - cambia el método `aceptar` del notifier por:

     ```dart
     Future<bool> aceptar(Cotizacion cotizacion) => _ejecutar(
           () => ref.read(cotizacionRepositoryProvider).aceptar(cotizacion),
         );
     ```

### 4. Actualizar los tests

1. Borra `tecnicos_app/test/features/solicitudes/aceptar_cotizacion_test.dart`.
2. En `tecnicos_app/test/features/solicitudes/acciones_solicitud_provider_test.dart`, reemplaza el último test (`'aceptar usa el caso de uso: ...'`) por:

   ```dart
   test('aceptar llama al repositorio; el estado lo cambia la base', () async {
     expect(await acciones().aceptar(cotizacionDePrueba(id: 'q7')), isTrue);

     expect(cotizaciones.aceptadas, ['q7']);
     expect(solicitudes.cambiosDeEstado, isEmpty);
   });
   ```

### 5. Actualizar la documentación

- **`CLAUDE.md`**:
  - Borra la regla 4 de "Reglas del equipo" ("No uses la función RPC `aceptar_cotizacion`…").
  - En "Reglas de diseño", quita `AceptarCotizacion` de la lista de casos de uso.
  - En "Operaciones con varias escrituras no atómicas", reemplaza el punto de "Aceptar una cotización" por: "Aceptar una cotización usa la función RPC `aceptar_cotizacion` (atómica)."
- **`PENDIENTE_BACKEND.md`** (este archivo): deja solo la sección "Otros candidatos, sin urgencia", o bórralo si ya no queda nada pendiente.

### 6. Verificar

Desde `tecnicos_app/`:

```bash
flutter analyze   # debe decir "No issues found!"
flutter test      # todos los tests deben pasar
flutter run -d chrome --web-port=3000 --dart-define-from-file=env.json
```

Prueba manual en la app: con una cuenta de cliente, acepta una cotización de una solicitud que tenga varias. Debe quedar "Aceptada", las demás "Rechazada", y la solicitud debe aparecer como "En curso".

### 7. Subir y pedir revisión

```bash
git add -A
git commit -m "Aceptar cotización con la función RPC aceptar_cotizacion"
git push -u origin <tu-nombre>/rpc-aceptar-cotizacion
```

Después abre un **Pull Request hacia `master`** en GitHub para que lo revisen antes de unirlo.

## Otros candidatos, sin urgencia

Estas operaciones también hacen varias escrituras separadas y podrían pasar a funciones RPC más adelante:

- **Guardar el perfil del técnico:** actualiza `perfiles_tecnicos` y luego sincroniza `tecnico_oficios`. Si falla a mitad, volver a guardar lo corrige.
- **Crear una solicitud:** inserta en `solicitudes_servicio` y después sube las fotos (`solicitud_archivos` + Storage). Si falla una foto, la solicitud ya quedó creada y, si el usuario reintenta, se duplica.
