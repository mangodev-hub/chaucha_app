# CLAUDE.md

Este archivo orienta a Claude Code (claude.ai/code) y al equipo de desarrollo al trabajar con el código de este repositorio.

## Estructura del repositorio

- **`tecnicos_app/` es la aplicación real**: "Técnicos a domicilio" (EAGLEDEV 2026), una app Flutter (Android y web con un solo código) conectada a Supabase, que pone en contacto a clientes con técnicos a domicilio. Todo el trabajo se hace aquí.
- El proyecto `frontend/` de la raíz (`lib/main.dart`, `test/widget_test.dart`) es la plantilla de `flutter create` sin modificar. `untitled.cpp` y `untitled.h` son archivos sueltos de Qt que no tienen relación con la app.
- Es un repositorio git (la raíz es `frontend/`).

## Comandos (desde `tecnicos_app/`)

```bash
# Una sola vez: crear env.json a partir de la plantilla y completar los datos de Supabase (env.json está en .gitignore)
cp env.example.json env.json
flutter pub get

# Ejecutar en web. La configuración de Supabase se inyecta al compilar; sin ella la app lanza un StateError al arrancar.
flutter run -d chrome --web-port=3000 --dart-define-from-file=env.json
# Android: igual, con -d <id-del-dispositivo>

flutter analyze
flutter test                                   # los tests replican lib/: test/app/, test/features/<feature>/
flutter test test/algun_test.dart              # un solo archivo
flutter test test/algun_test.dart --plain-name "nombre del test"   # un solo test
```

El README menciona `bash scripts/verificar_adr.sh`, `docs/PROTOTIPO.md`, `docs/pasos/` y ADRs del frontend: ninguno existe en esta copia.

## Configuración del linter

`analysis_options.yaml` activa `strict-casts` y `strict-raw-types`, y reglas como `prefer_single_quotes`, `prefer_final_locals`, `prefer_const_constructors`, `directives_ordering`, `avoid_dynamic_calls`, `avoid_print` (usar `debugPrint`), `unawaited_futures` (envolver los futures que no se esperan en `unawaited(...)`), `cancel_subscriptions` y `close_sinks`. Con `strict-casts`, el JSON de Supabase se convierte explícitamente (por ejemplo `fila['id'] as String`). El SDK admite parámetros nombrados privados: `const X({required this._repo})` se llama como `X(repo: ...)`, y el linter lo pide con `prefer_initializing_formals`.

## Arquitectura

**Clean Architecture por features con Riverpod 3.** La migración desde el diseño anterior (MVVM con `BaseStore`) terminó el 2026-11-07 y no queda código viejo. Identificadores, comentarios y textos de la interfaz van **en español** (`iniciar`, `enviar`, `cerrarSesion`, `aEntidad`, etc.).

```text
lib/
  main.dart            # solo arranca: Env → SupabaseBootstrap → ProviderContainer (lee sesionProvider desde el inicio) → App
  app/                 # routerProvider, guardia de redirección (route_guard.dart), TecnicoShell (pestañas del técnico)
  core/                # transversal: providers base, errores, utilidades de Supabase, storage, geo, validadores, widgets compartidos
  features/            # admin, auth, catalogo, chat, cotizaciones, perfil_puntos, solicitudes
    <feature>/
      domain/        entities/ (Dart puro, sin JSON)  repositories/ (interfaces)  usecases/
      data/          models/ (fromJson + aEntidad(), mapeo de enums a la base)  repositories/ (implementación Supabase + su Provider)
      presentation/  providers/  views/  widgets/
```

Features de referencia: `catalogo` (la mínima), `auth` (sesión), `chat` (tiempo real) y `solicitudes` (casos de uso, acciones por entidad, formularios).

### Reglas de diseño

- **Casos de uso solo** cuando la lógica combina varios repositorios o tiene reglas de negocio (`ObtenerFeedTecnico` y `ObtenerDetalleSolicitud` en `solicitudes/domain/usecases/`). En los demás casos el notifier llama directo al repositorio. El `Provider` de un caso de uso vive en el archivo de providers de presentación que lo usa.
- Los providers se escriben **a mano**: sin `riverpod_generator` ni `build_runner`.
- El `Provider` de cada repositorio vive junto a su implementación Supabase (por ejemplo `solicitudRepositoryProvider`), para que los tests lo puedan sobrescribir. Una feature puede importar entidades, interfaces de repositorio y providers de repositorio de otra.
- Los detalles exclusivos de la base van en `data/models/` y nunca en `domain/`: listas de columnas y joins, mapeo de enums a texto (`RolDb`, `EstadoSolicitudDb`), metadatos de registro y valores por defecto para columnas faltantes. Los joins de Supabase pueden llegar como objeto o como lista de un elemento: se leen con `anidado(...)` de `core/utils/json_utils.dart`.
- No se crean providers que nadie usa: una feature sin pantallas propias (`cotizaciones`) solo expone el provider de su repositorio y sus widgets compartidos.

### Errores

- Toda llamada a Supabase dentro de un repositorio va envuelta en `supabaseGuard(() async { ... })` (`core/supabase/supabase_guard.dart`). Convierte `AuthException`, `PostgrestException` y `StorageException` en `AppFailure` con mensajes en español para el usuario: `42501` es permiso denegado por RLS, `23505` registro duplicado, y los `P0001` (`raise exception`) pasan su mensaje tal cual. No se usa `Either` ni `fpdart`.
- Las consultas en tiempo real (`.stream()`) no pasan por `supabaseGuard`: la **capa de datos** convierte sus errores en `AppFailure` (ver `SupabaseChatRepository.mensajes`).
- Los notifiers usan `asyncGuard` (`core/errors/async_guard.dart`) en lugar de `AsyncValue.guard`: además imprime en consola los errores inesperados (los que no son `AppFailure`).
- `AsyncValueView.mensajeDe(error)` convierte cualquier error en el mensaje para el usuario.
- `client.uidActual` (`core/supabase/supabase_extensions.dart`) devuelve el id del usuario conectado o lanza `AppFailure` si la sesión expiró.
- **Reintentos:** `main.dart` usa `Reintento.decidir` (`core/providers/reintento.dart`) como `retry` del contenedor. Los `AppFailure` no se reintentan (se muestran al instante); los demás errores se reintentan hasta 3 veces, y la causa técnica se imprime en consola. Sin esto, Riverpod 3 reintentaba 10 veces y la pantalla quedaba ~38 s en "cargando".
- Para cargas en paralelo que deben conservar el `AppFailure` original, usar `Future.wait` y no el `.wait` de records, que envuelve los errores en `ParallelWaitError`.

### Patrones de presentación

- **Leer datos:** `FutureProvider.autoDispose` (con `.family` si depende de un id). Las vistas lo muestran con `AsyncValueView<T>` (`core/widgets/async_value_view.dart`): muestra la carga la primera vez y al reintentar tras un error, pero mantiene los datos visibles durante una recarga. Reintentar: `ref.invalidate(provider)`. Deslizar para recargar: `onRefresh: () => esperarSinError(ref.refresh(provider.future))` (`core/utils/refrescar.dart`).
- **Datos del usuario conectado** (`perfilTecnicoProvider`, `misSolicitudesProvider`, …): observan `usuarioActualProvider.select((u) => u?.id)` para recargarse si cambia la cuenta. Los datos derivados observan su fuente: `feedProvider` espera a `perfilTecnicoProvider.future`, así que guardar el perfil actualiza el feed.
- **Acciones y envíos de formularios:** `AsyncNotifierProvider.autoDispose`, con `.family` si son por entidad. En Riverpod 3 el argumento de la family es un **parámetro del constructor** del notifier (por ejemplo `AccionesSolicitudNotifier(this.solicitudId)`). El patrón es:
  1. si `state.isLoading`, ignorar la llamada;
  2. pasar a `AsyncLoading`;
  3. ejecutar con `asyncGuard`;
  4. comprobar `ref.mounted` antes de asignar `state`;
  5. si salió bien, invalidar el provider de datos afectado;
  6. devolver `bool` o el id creado.

  La vista muestra el mensaje de éxito, o lee el `AsyncError` del provider para mostrar el error con `context.mostrarMensaje`. Las validaciones que son reglas de negocio lanzan `AppFailure` dentro del guard (por ejemplo "Selecciona al menos un oficio.").
- **Tiempo real:** `StreamProvider.autoDispose.family` por id; la suscripción se cancela al cerrar la pantalla (`mensajesProvider`).
- **Estado de formularios** (chips elegidos, pin del mapa, fotos, mostrar u ocultar contraseña): va en el `State` del widget con `setState`, no en providers. Los formularios que se llenan con datos cargados usan `ref.listenManual(provider, ..., fireImmediately: true)` en `initState` y completan los campos una sola vez (con una bandera `_inicializado`) sin `setState` (ver `perfil_tecnico_view.dart`). Nunca llamar a `setState` dentro de `initState`: asignar el campo directamente.
- En los callbacks de un `ConsumerWidget`, comprobar `context.mounted` después de cada `await` antes de usar `ref`.

### Sesión y navegación

- `sesionProvider` (`SesionNotifier`, en `features/auth/presentation/providers/sesion_provider.dart`) es la única fuente de verdad de la sesión. Su estado `SesionEstado` puede ser `SesionVerificando`, `SinSesion(aviso)` o `ConSesion(usuario)`.
  - Escucha `AuthRepository.cambiosDeSesion` y carga el perfil `Usuario`.
  - Si el perfil no existe o falla la carga, cierra la sesión con un aviso.
  - Un contador de versión descarta respuestas que llegan tarde.
  - `usuarioActualProvider` expone el `Usuario?` actual. Para cerrar sesión: `ref.read(sesionProvider.notifier).cerrarSesion()`.
- `routerProvider` (`app/app_router.dart`) crea el GoRouter **una sola vez**. Conecta `sesionProvider` con `refreshListenable` usando `ref.listen`, nunca `ref.watch`, que recrearía el router en cada cambio de sesión.
  - `redirect` delega en la función pura `resolverRedireccion` (`app/route_guard.dart`): mientras verifica va a `/`; sin sesión va a `/login` salvo en rutas públicas; con sesión queda dentro de la zona de su rol (`/cliente/...` o `/tecnico/...`).
  - Las pantallas reciben solo parámetros de ruta (`SolicitudDetalleView(solicitudId: ...)`) y leen todo lo demás de providers.
- Las rutas están en `core/router/app_routes.dart`. Usar sus helpers (`AppRoutes.detalleSolicitud(id, esCliente: ...)`, `AppRoutes.chat(...)`), porque el detalle y el chat existen tanto bajo `/cliente` como bajo `/tecnico`.
- El rol `admin` va a `/admin` (panel con pestañas Resumen, Solicitudes, Usuarios y Verificaciones, en `features/admin/`). No tiene cédula, así que `resolverRedireccion` nunca lo manda a completar el perfil.
- El inicio de cada rol es `InicioShell` (`app/inicio_shell.dart`), un `IndexedStack` con las pestañas montadas. En móvil es una barra inferior fija de cinco destinos; en escritorio, pestañas en la barra superior. Cliente: Inicio · Solicitudes · **Pedir** (acción central, `AccionCentral`) · Chats · Perfil; su agenda no es pestaña y se abre en `/cliente/agenda` desde el menú de la cuenta y desde Mis solicitudes. Técnico: Inicio · Trabajos · Agenda · Chats · Perfil. Los chats son la pestaña `ChatsView` (`features/chat/presentation/views/chats_view.dart`), ya no un botón flotante.

### Lo que la app espera de Supabase

- Configuración por dart-defines `SUPABASE_URL` y `SUPABASE_ANON_KEY` (`core/config/env.dart`). Los providers de infraestructura compartida están en `core/providers/core_providers.dart`: `supabaseClientProvider` (se sobrescribe en `main.dart`), `storageServiceProvider` y `ubicacionServiceProvider`.
- Tablas usadas: `usuarios`, `perfiles_tecnicos`, `tecnico_oficios`, `niveles_gamificacion`, `oficios`, `solicitudes_servicio`, `solicitud_archivos`, `cotizaciones`, `conversaciones`, `mensajes`, `resenas` y `documentos_tecnico`. Los permisos dependen de RLS; un permiso denegado llega como código `42501`.
- El esquema completo (tablas, políticas RLS, funciones) exportado con el CLI de Supabase está en `tecnicos_app/supabase/migrations/`.
- **Panel admin** (`20261109150000_panel_admin.sql`): funciones `security definer` que exigen `mi_rol() = 'admin'` y no tocan a otros admins: `admin_resumen`, `admin_usuarios` (incluye correo y suspensión desde `auth.users`), `admin_actualizar_usuario`, `admin_suspender_usuario` (`banned_until`) y `admin_eliminar_usuario` (solo cuentas sin historial). La cuenta admin se crea una vez con [`base_de_datos/crear_admin.sql`](base_de_datos/crear_admin.sql) (`raw_app_meta_data.rol = admin`, que signUp no puede escribir) y entra por el login normal. **Nunca** poner su contraseña en `env.json` ni en el repo: en web los dart-defines quedan en el JavaScript público.
- El panel crea usuarios con `RegistroSinSesion` (POST directo a `/auth/v1/signup`), no con un segundo `SupabaseClient`: en web, el cliente avisa los inicios de sesión por un `BroadcastChannel` y reemplazaría la sesión del admin.
- Buckets de Storage (`core/storage/storage_service.dart`): `solicitudes` y `cedulas`, ambos **privados**. Las imágenes se leen con URLs firmadas (válidas 1 hora), nunca con URLs públicas.

### Operaciones con varias escrituras

- **Aceptar una cotización** usa la función RPC `aceptar_cotizacion` (atómica, `security invoker`, solo el cliente dueño de la solicitud). Su SQL está en [`base_de_datos/aceptar_cotizacion.sql`](base_de_datos/aceptar_cotizacion.sql).
- Siguen siendo no atómicas, con menos riesgo, y son candidatas a RPC:
  - `PerfilRepository.guardar`: actualiza el perfil y luego sincroniza `tecnico_oficios`; volver a guardar lo corrige.
  - `SolicitudRepository.crear`: inserta la solicitud y después sube las fotos. Si falla una foto, la solicitud ya quedó creada, y reintentar la duplica.

### Diseño visual

El estilo sigue la skill `diseno-chauchaapp` (`.claude/skills/diseno-chauchaapp/SKILL.md`): verde y celeste. Verde bosque (`Colores.primario`, `#006414`) para botones, enlaces y pestaña activa; verde marca (`Colores.primarioVivo`, `#009929`) para el logo, íconos activos y progreso; celeste (`Colores.cielo`) para información y acentos; fondo verde muy suave, tarjetas blancas con sombra sutil y campos verdosos. `#009929` y `#27A3DF` no llegan a AA con texto blanco: nunca texto normal encima. El rediseño (paleta, logo `LogoChaucha`, tipografía Figtree, navegación) quedó definido el 2026-11-12. Todo lo documenta [`tecnicos_app/docs/DISENO.md`](tecnicos_app/docs/DISENO.md). Colores, radios, espacios y fuente viven en `core/theme/tokens.dart`, y el tema global en `core/theme/app_theme.dart`. **No escribir colores sueltos** (`Colors.green`, `Color(0xFF...)`) en las pantallas: usar `Colores.*` o `Theme.of(context).colorScheme`. `google_fonts` está fijado en `^8.0.0`, porque la 9.x usa el paquete separado `material_ui` y sus tipos no son compatibles con `flutter/material`.

**Componentes visuales compartidos** (`core/widgets/`): las pantallas se arman con ellos y no con versiones propias. Son `TarjetaApp`, `BloqueTarjeta` e `IconoRecuadro` (tarjetas), `TarjetaPortada` (portada verde plana con el sol celeste arriba de cada inicio), `LogoChaucha` y `Marca` (logo y nombre), `EncabezadoPantalla`, `CampoEtiquetado` y `CampoContrasena` (formularios), `AvisoBanner` (avisos dentro de la pantalla), `EstadoMensaje` (lista vacía, error o éxito, con acción secundaria opcional), `EsqueletoCarga` y `BloqueEsqueleto` (carga con la forma de la pantalla, vía `AsyncValueView(cargando: ...)`), `IndicadorPasos`, `Pildora` (estados), `BarraAccion` (acción principal fija abajo en móvil), `CuadriculaAdaptable` (listas en dos columnas en escritorio), `BotonCarga`, `CheckAnimado` (check de éxito), `Sacudir` (sacude el botón de un formulario que falló, con un contador `_fallos`) y `Presionable` (encoge al presionar). Las animaciones usan los tokens `Movimiento` y piden la duración con `Movimiento.de(context, ...)`, que respeta "reducir animaciones". Para avisos inferiores se usa `context.mostrarMensaje(texto, tipo: TipoMensaje.exito | error)`. El catálogo completo está en `DISENO.md`.

### Tests

Se usa `ProviderContainer.test(overrides: [...])` con repositorios falsos. Pasar `retry: (_, _) => null` al probar estados de error, para desactivar el reintento automático de Riverpod 3. Mantener vivos los providers con `container.listen(provider, (_, _) {})`. Los falsos y datos de prueba compartidos van en un archivo que no termine en `_test.dart` (por ejemplo `test/features/solicitudes/falsos.dart`). Cerrar los `StreamController` desde un método del falso, por la regla `close_sinks`.

## Reglas del equipo (GUÍA OBLIGATORIA)

- **Idioma:** responde siempre en español. Comentarios, nombres de variables y métodos, y textos de la interfaz se escriben en español.
- **Arquitectura:** la app usa **Clean Architecture por features con Riverpod**. Todo código nuevo sigue las convenciones de este archivo; no se vuelve a introducir `BaseStore`, `ViewModel` ni un contenedor de dependencias propio.
- **Reglas de trabajo:**
  1. Antes de modificar código, explica el plan paso a paso  y espera confirmación.
  2. Después de cada cambio, ejecuta `flutter analyze` y `flutter test` dentro de `tecnicos_app/` y corrige cualquier error, advertencia o test fallido antes de continuar.
  3. No rompas la navegación de `GoRouter` (redirecciones por rol) ni la integración con Supabase (`supabaseGuard`, RLS, buckets privados).
