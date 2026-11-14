# ChauchaApp: arquitectura y tecnologías

Los diagramas están en [ARQUITECTURA_DIAGRAMA.md](ARQUITECTURA_DIAGRAMA.md).

## En una frase

Una sola app **Flutter** (web y Android) habla directo con **Supabase**, que
hace de backend completo. Las reglas de negocio viven **en la base de datos**
(triggers, RLS y RPC), no en la app. Así no se pueden saltar aunque alguien
modifique el cliente.

---

## Frontend (app)

| Tecnología | Para qué la usamos | Por qué |
|---|---|---|
| **Flutter** | Toda la interfaz: cliente, técnico y panel admin | Un solo código para web y Android. Con el tiempo que teníamos no daba para dos apps. |
| **Riverpod** | Estado de la app (sesión, listas, formularios) | Separa la lógica de la UI y permite probar sin pantallas. Además se puede sobrescribir en `main.dart` (cliente de Supabase, push). |
| **go_router** | Navegación y rutas protegidas por rol | Redirige según la sesión (login, completar perfil, cliente, técnico, admin) en un solo lugar. |
| **supabase_flutter** | Login, consultas, RPC, Realtime y Storage | SDK oficial: un solo paquete para todo el backend. |
| **flutter_map + OpenStreetMap** | Mapa de técnicos cercanos y zona de trabajo | Gratis y sin clave de API. Google Maps pide tarjeta y factura por uso. |
| **geolocator** | Ubicación del usuario | Para buscar técnicos cerca y fijar la zona del técnico. |
| **camera / image_picker / file_selector** | Selfie, cédula, fotos del problema, certificados | La selfie se toma **solo con cámara en vivo**, sin galería, para evitar fotos de fotos. |
| **image** | Detectar fotos borrosas y preparar cada foto antes de subirla (`core/hilos/tareas.dart`) | Varianza del Laplaciano: barato, sin servicios externos y avisa al instante. |
| **isolate_manager** | Procesar imágenes en otro hilo (`core/hilos`) | Isolates en Android y Web Workers en web: la pantalla no se congela. |
| **table_calendar** | Agenda de visitas | Calendario mensual con las citas marcadas. |
| **firebase_messaging** | Recibir notificaciones push | Ver "Por qué Firebase" más abajo. |
| **http** | El admin registra usuarios | Crear una cuenta con el SDK cambia la sesión actual; con una llamada HTTP aparte el admin no pierde la suya. |

---

## Backend (Supabase)

| Pieza | Para qué la usamos | Por qué |
|---|---|---|
| **Auth** | Registro e inicio de sesión con correo | Integrado con la base: `auth.uid()` está disponible en las reglas de seguridad. Al registrarse, un trigger crea el perfil y valida la **cédula** (dígito verificador). |
| **PostgreSQL** | Todos los datos | Relacional: solicitudes, cotizaciones, chats y reseñas están muy conectados entre sí. |
| **RLS (Row Level Security)** | Que cada usuario vea y toque solo lo suyo | La seguridad la hace la base. Aunque alguien llame a la API a mano, no puede leer el chat de otro. |
| **Triggers** | Reglas de negocio: estados de la solicitud, puntos, niveles, sanciones, notificaciones | Son automáticos y auditables. No dependen de que la app los llame, y no se pueden saltar. |
| **RPC (funciones SQL)** | Acciones delicadas: enviar ticket, aceptar, reagendar, iniciar chat | Validan todo en una sola transacción (permisos, horarios y estados). |
| **PostGIS** | "Técnicos a menos de X km", zona de cobertura | Calcula distancias reales sobre el mapa con índices. Hacerlo en la app sería lento e inseguro. |
| **btree_gist** | Que un técnico no tenga dos visitas a la misma hora | Restricción de exclusión: la base **rechaza** el choque aunque dos clientes acepten a la vez. |
| **Realtime** | Chat, contador de no leídas y cambios de estado en vivo | La pantalla se actualiza sola sin recargar. |
| **Storage** | Fotos de perfil (público), cédulas y documentos (privado), evidencias | Los buckets privados protegen los datos biométricos (LOPDP). Las políticas obligan a que cada uno suba solo a su carpeta. |
| **Edge Functions (Deno)** | Validar la selfie, validar la identidad con la cédula, verificar el rostro al iniciar sesión y al postular, enviar push | Código de servidor con claves secretas (Gemini y Firebase) que **no pueden** ir en la app. |
| **pg_cron** | Tareas nocturnas: expirar solicitudes, reputación reciente, fin de sanciones | Reglas que dependen del **tiempo**: deben ocurrir aunque nadie use la app. |
| **pg_net + Vault** | La base avisa a la Edge Function de push | `pg_net` hace la llamada HTTP sin bloquear el guardado; **Vault** guarda el secreto del webhook cifrado, fuera del código. |

---

## Servicios externos

| Servicio | Para qué | Por qué |
|---|---|---|
| **Google Gemini** | Revisar que la selfie tenga un rostro y leer los datos impresos en la cédula | Servicio gestionado, sin entrenar ni hospedar un modelo propio. El resultado **no es la decisión final**: si hay duda, revisa el admin. La foto de la cédula ecuatoriana es pequeña y de baja calidad. |
| **AWS Rekognition** | Comparar rostros: selfie contra cédula, al iniciar sesión y al postular | `CompareFaces` devuelve un puntaje de similitud; el umbral lo aplicamos nosotros y lo dudoso va al admin. El usuario IAM solo puede usar `CompareFaces`. |
| **Firebase Cloud Messaging** | Notificaciones push en Android y web | Es el canal estándar para notificaciones con la app cerrada. Lo usamos **solo** para eso. |
| **OpenStreetMap** | Teselas del mapa | Gratis y abierto. |

---

## Por qué Firebase si ya teníamos Supabase

**Realtime solo funciona con la app abierta.** Mantiene una conexión
(WebSocket) mientras la pantalla está activa. Si el técnico minimiza el
navegador o cierra la app en el celular, el sistema operativo corta esa
conexión y el aviso no le llega.

Para avisar con la app cerrada hay que pasar por el canal de push del sistema:
en Android ese canal es **Firebase Cloud Messaging**, y en web es el estándar
Web Push, que Firebase también maneja. Supabase no tiene un servicio de push
propio.

Por eso hay **dos canales que se complementan**:

- **App abierta:** Realtime muestra el aviso dentro de la app al instante.
- **App cerrada o minimizada:** el push de FCM muestra la notificación del sistema.

No se duplican: con la app abierta, FCM no muestra nada y el aviso sale de Realtime.

**Un solo punto de envío.** Todos los eventos (mensaje, postulación, ticket,
cierre, expiración, sanción) ya terminan en la tabla `notificaciones`. Un
único trigger sobre esa tabla dispara el push. Cuando se agrega un evento
nuevo, el push funciona sin tocar nada más.

---

## Otras decisiones y su motivo

- **La lógica en la base, no en la app.** Si una regla solo estuviera en
  Flutter, bastaría con llamar a la API directo para saltársela. Por eso los
  estados, los puntos, las sanciones y los choques de horario se validan en
  PostgreSQL.
- **Verificar la identidad una vez, no en cada postulación.** Pedir una selfie
  en cada postulación cansa al usuario y, sin una prueba de vida real, no
  demuestra nada. Se verifica al registrarse; la revisión manual del admin
  queda como respaldo.
- **Calificación de 1 a 5 normalizada a 3 niveles** (excelente, neutro, malo).
  El usuario ve estrellas, pero los puntos y las sanciones usan los 3 niveles:
  la regla es simple y difícil de manipular.
- **Sanciones: 3 malas en 30 días suspenden 7 días.** Una sola mala reseña no
  hunde a nadie. Las malas que ya causaron una sanción no se vuelven a contar.
- **Secretos fuera del repo.** Las claves de Firebase de servidor y de Gemini
  están en los secretos de Supabase; el secreto del webhook está en Vault. En
  `env.json` (ignorado por git) solo van claves públicas.
- **Procesamiento de imágenes en paralelo (multihilo).** Detectar fotos
  borrosas y preparar cada foto antes de subirla (enderezarla, reducirla a
  1280 px y pasarla a JPEG) es trabajo pesado: en el hilo de la interfaz la
  pantalla se congela. `core/hilos` lo ejecuta con `isolate_manager` en un
  grupo de hilos: isolates en Android y Web Workers en web (Flutter web no
  tiene isolates; `compute` ahí corre en el mismo hilo). Varias fotos, como
  las evidencias, se preparan a la vez. Si un hilo falla o no responde en
  15 s, la tarea corre en el hilo principal. Los workers de web se generan
  con `dart run isolate_manager:generate --single` (quedan en `web/*.js`) y
  hay que volver a generarlos si cambia `core/hilos/tareas.dart`;
  `tool/prueba_workers.dart` comprueba que funcionan en un navegador.
