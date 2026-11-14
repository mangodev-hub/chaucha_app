# ChauchaApp

[![App Flutter](https://github.com/mangodev-hub/chaucha_app/actions/workflows/app.yml/badge.svg)](https://github.com/mangodev-hub/chaucha_app/actions/workflows/app.yml)
[![Edge Functions](https://github.com/mangodev-hub/chaucha_app/actions/workflows/edge-functions.yml/badge.svg)](https://github.com/mangodev-hub/chaucha_app/actions/workflows/edge-functions.yml)

Plataforma que conecta a clientes con **técnicos a domicilio verificados** (plomería, electricidad, cerrajería, pintura y más) en Ecuador. Proyecto de EagleDev 2026.

La app es una sola base de código en **Flutter** (web y Android). El backend es **Supabase**: Auth, PostgreSQL + PostGIS, RLS, Realtime, Storage y Edge Functions.

---

## Qué hace

**Cliente**
- Publica una solicitud con fotos y ubicación. Los técnicos verificados de su zona le envían su precio por la visita y cómo resolverían el problema.
- Compara propuestas, conversa por chat en tiempo real y agenda día y hora. Las visitas no se superponen: la base lo impide.
- Ve a los técnicos cercanos en un mapa, con su nivel, reseñas y estado "En línea".
- Al terminar, califica y el servicio queda con **30 días de garantía**. Si algo falla, abre un reclamo desde el detalle del servicio.
- En **Mi perfil** ve sus solicitudes activas, el historial con la garantía de cada servicio y los técnicos con los que ya trabajó.

**Técnico**
- Verifica su identidad: cédula, código dactilar y selfie con cámara en vivo, revisada con IA y por el equipo.
- Ve en un mapa las solicitudes de sus oficios dentro de su radio de cobertura, y envía propuestas y tickets.
- Tiene su agenda (Mes, Semana, Lista), su nivel y sus puntos (Bronce, Plata, Oro) y sus certificaciones.

**Administración**
- Panel con resumen, usuarios, verificaciones de identidad, solicitudes y reclamos.

**Reglas que aplica la base de datos**
- Reseñas en 3 niveles con puntos.
- Suspensión de 7 días por 3 reseñas negativas en 30 días.
- Caducidad de las solicitudes a los 30 días.
- Estado VIP del cliente.
- Bono de radio de cobertura por buenas reseñas.

---

## Tecnologías

| Capa | Tecnología |
|---|---|
| App | Flutter 3.47 / Dart 3.13, Riverpod 3, go_router, flutter_map + OpenStreetMap, geolocator, Plus Jakarta Sans |
| Datos | Supabase PostgreSQL + PostGIS (`geography`, `ST_DWithin`, índices GIST, restricción de exclusión para choques de horario) |
| Seguridad | Supabase Auth + Row-Level Security en tablas y buckets de Storage |
| Tiempo real | Supabase Realtime (chat, ofertas, estados y notificaciones) |
| Tareas programadas | `pg_cron` (caducidad, reputación, fin de sanciones) y `pg_net` (webhooks) |
| Serverless | Supabase Edge Functions (Deno) |
| IA y rostro | Google Gemini (visión): validación de la selfie y lectura de la cédula. AWS Rekognition: comparación de rostros (cédula, inicio de sesión y cada postulación) |
| Multihilo | `isolate_manager`: procesamiento de imágenes en isolates (Android) y Web Workers (web) |
| Notificaciones | Firebase Cloud Messaging (push en Android y web) |
| Caché, límites y presencia | Upstash Redis (REST) desde las Edge Functions |
| CI | GitHub Actions |

---

## Estructura

```
chaucha_app/
├── .github/workflows/   CI: app.yml (Flutter) y edge-functions.yml (Deno)
├── lib/
│   ├── app/             Router, shell (navegación web y móvil), pie de página
│   ├── core/            Tema y tokens, widgets comunes, geo, push, presencia, Supabase
│   └── features/        Un módulo por dominio, con Clean Architecture
│       ├── admin/  auth/  catalogo/  chat/  cotizaciones/  legal/
│       └── notificaciones/  perfil_puntos/  publicidad/  reclamos/  solicitudes/
│           └── (cada uno) data/ · domain/ · presentation/
├── supabase/
│   ├── migrations/      Esquema, RLS, triggers, RPC y jobs
│   ├── functions/       Edge Functions (Deno) y _shared/
│   ├── sql/             SQL auxiliar (aceptar_cotizacion, crear un admin)
│   └── semilla/         Datos de prueba
├── test/                Pruebas de widgets, modelos y providers
├── android/  web/       Plataformas
├── assets/              Fuentes, logo y animaciones
└── env.example.json     Plantilla de configuración
```

Cada módulo de `features/` separa sus capas así:
- **`domain`:** entidades y contratos, sin Flutter ni Supabase.
- **`data`:** modelos y repositorios de Supabase.
- **`presentation`:** providers de Riverpod, vistas y widgets.

---

## Puesta en marcha

### Requisitos
- Flutter 3.47 (canal stable)
- Para el backend: Supabase CLI y, si vas a revisar las funciones, Deno 2

### App

```bash
cp env.example.json env.json   # completa SUPABASE_URL y SUPABASE_ANON_KEY
flutter pub get
flutter run -d chrome --web-port=3000 --dart-define-from-file=env.json
```

- **Firebase (push) es opcional.** Sin las claves `FIREBASE_*` en `env.json`, la app funciona sin notificaciones push.
- **`env.json` no se sube al repositorio.**

### Backend (Supabase)

```bash
supabase link --project-ref <tu-proyecto>
supabase db push                      # aplica supabase/migrations/
```

**Secretos de las Edge Functions** (se cargan con `supabase secrets set`, nunca van en la app):

| Secreto | Uso |
|---|---|
| `GEMINI_API_KEY` | `validar-foto-rostro` y `comparar-rostro-cedula` |
| `MODELO_VISION_GEMINI` (opcional) | Modelos de Gemini a probar primero |
| `FIREBASE_SERVICE_ACCOUNT` | `enviar-push` (JSON de la cuenta de servicio) |
| `APP_URL` (opcional) | Enlace que abre el aviso push en la web |
| `UPSTASH_REDIS_REST_URL`, `UPSTASH_REDIS_REST_TOKEN` | Caché, límites de uso y presencia. Sin ellos, todo funciona igual, solo sin Redis |

**En Vault** (para los webhooks que llama la base): `push_url` (URL de `enviar-push`) y `push_secreto`.

**Despliegue de las funciones:**

```bash
supabase functions deploy validar-foto-rostro comparar-rostro-cedula sector presencia
supabase functions deploy enviar-push anuncios --no-verify-jwt
```

---

## Edge Functions

| Función | Qué hace |
|---|---|
| `validar-foto-rostro` | Revisa con Gemini que la selfie sea de una persona real, de frente y nítida. Guarda el veredicto en caché por huella de la imagen y tiene límite de intentos |
| `comparar-rostro-cedula` | Valida la identidad: compara el rostro de la selfie con la cédula (Rekognition), lee la cédula (Gemini) y coteja los datos del registro. Aprueba, pide corregir datos, rechaza la foto o deja el caso al admin |
| `verificar-rostro-sesion` | Selfie en vivo al iniciar sesión contra la foto de perfil, para cuentas verificadas |
| `verificar-rostro-postulacion` | Confirma con el rostro la identidad del técnico en cada postulación, contra su foto de perfil |
| `enviar-push` | Envía por FCM cada notificación nueva. La llama un trigger de la base. No avisa un mensaje si ese chat ya está abierto |
| `sector` | Barrio de un punto (Nominatim) con caché compartida y respetando el límite global de 1 consulta por segundo |
| `anuncios` | Anuncios vigentes con caché de 5 minutos, que se invalida cuando cambia la tabla |
| `presencia` | Latidos de "en línea", estado por usuario y técnicos en línea cerca (solo el conteo, sin coordenadas) |

Todas las que usan Redis siguen funcionando si Upstash no responde (*fail-open*): Redis acelera y protege, pero los datos viven en Postgres.

---

## Documentación

- [`docs/ARQUITECTURA.md`](docs/ARQUITECTURA.md): tecnologías y decisiones, con su motivo.
- [`docs/ARQUITECTURA_DIAGRAMA.md`](docs/ARQUITECTURA_DIAGRAMA.md): diagrama de componentes.
- [`docs/ARQUITECTURA_TECNICA.md`](docs/ARQUITECTURA_TECNICA.md): cómo está implementada cada pieza, con sus archivos, tablas y funciones.
- [`docs/DISENO.md`](docs/DISENO.md): sistema de diseño.

---

## Calidad

```bash
flutter analyze
flutter test

cd supabase/functions
deno check */index.ts
deno test --allow-env --allow-net=none _shared/
```

GitHub Actions corre estas mismas verificaciones en cada pull request y en cada push a `master`, además de un `flutter build web` de comprobación.
