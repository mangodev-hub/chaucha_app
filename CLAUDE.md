# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository layout

- **`tecnicos_app/` is the real application** — "Técnicos a domicilio" (EAGLEDEV 2026): a Flutter app (Android + web from one codebase) backed by Supabase that connects clients with home-service technicians. All work should normally happen here.
- The root `frontend/` project (`lib/main.dart`, `test/widget_test.dart`) is an unmodified `flutter create` counter template. `untitled.cpp` / `untitled.h` are stray Qt files unrelated to the app.
- Not a git repository.

## Commands (run from `tecnicos_app/`)

```bash
# One-time: create env.json from the template and fill in Supabase values (env.json is gitignored)
cp env.example.json env.json
flutter pub get

# Run (web). Supabase config is injected at compile time; the app throws a StateError at startup without it.
flutter run -d chrome --web-port=3000 --dart-define-from-file=env.json
# Android: same, with -d <device-id>

flutter analyze
flutter test                                   # test/ is currently empty
flutter test test/some_test.dart               # single file
flutter test test/some_test.dart --plain-name "test name"   # single test
```

The README also lists `bash scripts/verificar_adr.sh` and refers to `docs/PROTOTIPO.md`, `docs/pasos/`, and frontend ADRs — none of these exist in this checkout.

## Lint configuration

`analysis_options.yaml` enables `strict-casts` and `strict-raw-types`, plus rules including `prefer_single_quotes`, `prefer_final_locals`, `prefer_const_constructors`, `directives_ordering`, `avoid_dynamic_calls`, `avoid_print` (use `debugPrint`), `unawaited_futures` (wrap fire-and-forget futures in `unawaited(...)`), `cancel_subscriptions`, `close_sinks`. With strict casts, JSON from Supabase must be cast explicitly (e.g. `row['id'] as String`).

## Architecture

MVVM organized by feature, with a **custom state manager** (no Provider/Riverpod/Bloc). Identifiers, comments, and UI strings are in **Spanish** — keep new code consistent (`iniciar`, `enviar`, `crearViewModel`, `cerrarSesion`, etc.).

```
lib/
  main.dart            # bootstrap only: Env → SupabaseBootstrap → AppDependencies → App
  app/                 # composition root: DI container, GoRouter, redirect guard, technician shell
  core/                # cross-cutting: state, errors, supabase helpers, storage, geo, validators, shared widgets
  features/<feature>/  # auth, solicitudes, cotizaciones, chat, perfil_puntos
    models/ services/ viewmodels/ views/
```

### Dependency injection
`app/app_dependencies.dart` is a hand-written container. `AppDependencies.supabase(client)` instantiates every `Supabase*Service` implementation once. Services are passed down explicitly via constructors — there is no service locator or `InheritedWidget`. Adding a service means: define the `abstract interface class` in `features/x/services/`, add a `Supabase...` implementation, and wire it in `AppDependencies`.

### State management (`core/state/`)
- `ViewState<T>` is a sealed class: `ViewInitial` / `ViewLoading` / `ViewLoaded(data)` / `ViewError(message)`.
- `BaseStore<T> extends ValueNotifier<ViewState<T>>` is the base for every ViewModel:
  - `execute(action)` — loads data, emitting Loading → Loaded/Error automatically.
  - `ejecutarAccion(action)` — for user actions (submit, send); toggles the `procesando` notifier, ignores re-entry while busy, and **returns `String?` error message (null = success)** instead of changing the main state. Views show the returned message with `context.mostrarMensaje(...)`.
  - `createField(initial)` creates extra `ValueNotifier` fields that are auto-disposed; `addSubscription(...)` / `addDisposer(...)` register cleanup. `emit` is a no-op after dispose.
- Views render state with `core/widgets/view_state_builder.dart` (`ViewStateBuilder<T>`), which handles loading/error/retry by default.

### View ↔ ViewModel lifecycle
Views are `StatefulWidget`s that receive a **factory** `crearViewModel: () => XViewModel(...)` (not an instance). The State creates it with `late final _vm = widget.crearViewModel();`, calls `_vm.iniciar()` / load in `initState`, and **disposes it in `dispose`**. The router builds these factories, pulling services from `AppDependencies` and route params from `GoRouterState`.

### Errors
All Supabase calls in services are wrapped in `supabaseGuard(() async { ... })` (`core/supabase/supabase_guard.dart`), which converts `AuthException` / `PostgrestException` / `StorageException` into `AppFailure` with user-facing Spanish messages (maps Postgres codes like `42501` RLS denial, `23505` unique, `P0001` raised exceptions pass their message through). ViewModels only catch `AppFailure`; anything else becomes a generic error. Realtime `.stream()` queries are not wrapped — handle errors in the `listen(onError:)`.

`client.uidActual` (extension in `supabase_extensions.dart`) returns the current user id or throws `AppFailure` if the session expired.

### Session and routing
- `SessionStore` (`features/auth/viewmodels/session_store.dart`) is the single source of truth for auth: a `ValueNotifier<SesionEstado>` (`SesionVerificando` / `SinSesion(aviso)` / `ConSesion(usuario)`). It listens to auth changes, loads the `Usuario` profile, and signs out with a notice if the profile is missing. A version counter discards stale async results.
- `app/app_router.dart` uses GoRouter with `refreshListenable: sessionStore` and delegates `redirect` to the pure function `resolverRedireccion` in `app/route_guard.dart`: verifying → `/`, no session → `/login` unless on a public route, logged in → forced into the role's zone (`/cliente/...` or `/tecnico/...`).
- Route paths live in `core/router/app_routes.dart`; use its helpers (`AppRoutes.detalleSolicitud(id, esCliente: ...)`, `AppRoutes.chat(...)`) since detail/chat routes are duplicated under both the client and technician prefixes.
- Role `admin` redirects to `/admin`, but no admin route is defined yet.
- The technician home is `TecnicoShell`, a tabbed shell (feed / my jobs / profile).

### Supabase backend expectations
- Config via dart-defines `SUPABASE_URL` and `SUPABASE_ANON_KEY` (`core/config/env.dart`).
- Tables referenced include `conversaciones`, `mensajes`, plus those used by solicitudes, cotizaciones, perfiles, documentos, oficios. Authorization relies on RLS (permission errors surface as code `42501`).
- Storage buckets (`core/storage/storage_service.dart`): `solicitudes` and `cedulas`, both **private** — images are read through signed URLs (1 h validity), never public URLs.
