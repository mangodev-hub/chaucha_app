# Diseño visual de la app (ChauchaApp)

> La **paleta**, el **estilo** y los **componentes** quedaron definidos el 2026-11-07 a partir de las pantallas de referencia de login, registro y verificación (skill `diseno-chauchaapp`). La **tipografía**, el **logo** y el **modo oscuro** siguen pendientes.

Última actualización: 2026-11-07.

## Estado

| Tema | Estado |
| --- | --- |
| Paleta de colores (blanco y azul) | **Definida** |
| Color de acento (verde) | Definido: solo para lo positivo (completado, aprobado, verificado) |
| Componentes compartidos | **Definidos** (ver "Catálogo de componentes") |
| Nombre visible | **ChauchaApp**, con el lema "Técnicos de confianza a tu puerta en Quito" |
| Tipografía (Plus Jakarta Sans) | Provisional |
| Logo | Provisional: una llave de Material en un círculo azul |
| Modo oscuro | No existe todavía |
| Contraste y accesibilidad | Revisado (ver "Accesibilidad") |

## Referencia de estilo

La referencia son las pantallas de **inicio de sesión**, **registro** y **verificación de identidad** del diseño del equipo (skill `.claude/skills/diseno-chauchaapp/SKILL.md`). De ellas salen estas reglas:

1. **Blanco y azul.** El azul (`primario`) es la marca: botón principal, enlaces, navegación activa, foco de los campos y progreso.
2. **Fondo celeste suave** (`fondo`). En login y registro, un degradado celeste.
3. **Tarjetas blancas** con esquinas redondeadas y **sombra sutil** (`TarjetaApp`). Login y registro van dentro de una tarjeta grande (radio 24).
4. **Campos celestes sin borde** (`superficie`), con la **etiqueta en negrita arriba** (`CampoEtiquetado`), un **ícono al inicio** y el borde azul al enfocarlos.
5. **Botón principal azul, alto y con sombra azulada**. Puede llevar una flecha al final ("Iniciar sesión →"). Desactivado, queda gris y sin sombra.
6. **Botón secundario** con borde y texto azules. **Enlaces** en azul y negrita ("¿No tienes cuenta? **Regístrate**").
7. **Íconos en recuadros celestes** (`IconoRecuadro`) para opciones, documentos y encabezados de bloque.
8. **Elección con tarjetas**: sin elegir, celeste; elegida, blanca con borde azul y un check (tipo de cuenta en el registro).
9. **Progreso con barras** y el texto "Paso X de Y" (`IndicadorPasos`).
10. **Estados en píldoras** (`Pildora`): fondo suave del color del estado y texto en su versión oscura.
11. **Hojas inferiores** con asa de arrastre y botón de cerrar en móvil (verificación), y diálogo en escritorio.
12. **Un solo acento verde**, reservado para lo positivo.

No se copian las pantallas de referencia literalmente: su lenguaje visual se adapta a cada funcionalidad.

## Tokens

Todo vive en [`lib/core/theme/tokens.dart`](../lib/core/theme/tokens.dart).

### Colores (`Colores`)

| Token | Valor | Uso |
| --- | --- | --- |
| `primario` | `#1976D2` | Marca: botones, enlaces, navegación activa, foco, progreso (con texto blanco: 4.6:1) |
| `primarioOscuro` | `#1565C0` | Nombre de la marca, pasos completados, texto sobre `primarioSuave` |
| `primarioVivo` | `#2196F3` | El azul brillante de la referencia, **solo decorativo** (círculo del logo). Con texto blanco no llega a AA |
| `primarioClaro` | `#BBDEFB` | Pasos pendientes, bordes de lo resaltado |
| `primarioSuave` | `#E3F2FD` | Fondo de lo elegido o resaltado, íconos en recuadro, avatares, avisos informativos |
| `tinta` | `#0F2A44` | Texto principal (azul marino), fondo del visor de fotos |
| `tintaSuave` | `#5B6B7F` | Texto secundario, íconos de los campos |
| `fondo` | `#F2F8FE` | Fondo celeste de las pantallas y de la barra superior |
| `tarjeta` | `#FFFFFF` | Tarjetas, diálogos, hojas inferiores, barras inferiores |
| `superficie` | `#EAF3FC` | Campos de texto, chips y opciones sin elegir |
| `superficieFuerte` | `#D6E6F7` | Pistas del slider, huecos de fotos que cargan, separadores del chat |
| `linea` | `#E1EAF4` | Divisores y bordes suaves |
| `acento` / `acentoSuave` / `acentoOscuro` | `#2E9E5B` / `#E3F4EA` / `#1B5E36` | Lo positivo: completado, aceptada, aprobado, verificado, avisos de éxito |
| `info` | `#0369A1` | Estados "Abierta" y "Con cotizaciones", cotización pendiente, distancia |
| `aviso` / `avisoSuave` / `avisoOscuro` | `#D97706` / `#FEF3E2` / `#92400E` | "Por confirmar", avisos de advertencia |
| `error` / `errorSuave` / `errorOscuro` | `#C62828` / `#FDECEC` / `#8C1D18` | Errores, acciones destructivas |
| `estrella` | `#F5A623` | Estrellas de calificación, ícono de puntos |

**Estados de solicitud:** Abierta y Con cotizaciones usan `info`, En curso `primario`, Por confirmar `aviso`, Completada `acento` y Cancelada `tintaSuave`.

### Sombras (`Sombras`)

- `Sombras.suave`: sombra azulada al 8 %, desenfoque 18, desplazamiento vertical 6. Para tarjetas.
- `Sombras.boton`: color de la sombra del botón principal.

### Radios (`Radios`) y espacios (`Espacios`)

- Radios: `pequeno` 8 · `medio` 12 (botones, campos, avisos) · `grande` 16 (tarjetas) · `muyGrande` 24 (tarjeta de login y registro, hojas, diálogos) · `pildora` 999.
- Espacios: `xs` 4 · `s` 8 · `m` 12 · `l` 16 · `xl` 24 · `xxl` 32.

### Movimiento (`Movimiento`)

Animaciones cortas, solo para dar respuesta a una acción o celebrar un éxito; nada en bucle ni decorativo.

| Token | Valor | Uso |
| --- | --- | --- |
| `rapido` | 150 ms | Íconos que cambian (ojo de la contraseña), `Presionable` |
| `normal` | 250 ms | Cambios de estado: `BotonCarga`, `Pildora`, `IndicadorPasos`, pestañas, estrellas, mensajes nuevos del chat |
| `lento` | 500 ms | Éxito: `CheckAnimado` y el rebote de `EstadoMensaje` |
| `entrada` | `easeOutCubic` | Curva general |
| `rebote` | `easeOutBack` | "Pop" de lo positivo |

La duración se pide siempre con `Movimiento.de(context, Movimiento.normal)`: devuelve cero si el sistema tiene activado "reducir animaciones".

Dónde hay animación:

- **Botones y tarjetas:** `BotonCarga` y las `TarjetaApp` con `onTap` se encogen un poco al presionarlas (`Presionable`).
- **Errores al enviar un formulario:** el botón principal se sacude (`Sacudir`) si falla la validación o el servidor responde con error. Está en login, registro, completar perfil, recuperar y restablecer contraseña. Patrón: un contador `_fallos` en el `State`, que se incrementa al fallar `validate()` y desde `ref.listen` del provider cuando queda en error.
- **Éxito:** `EstadoMensaje` de tipo éxito (rebote y `CheckAnimado`).
- **Pestañas:** el ícono de la pestaña elegida rebota (móvil) y la pestaña de escritorio cambia de color con una transición.
- **Reseña:** las estrellas que se llenan rebotan y la etiqueta ("Muy bueno") cambia con un fundido.
- **Chat:** los mensajes que llegan con la pantalla abierta entran desde abajo; los que ya estaban al abrirla, no.

### Tipografía (`Tipografia`)

- Familia: **Plus Jakarta Sans**, cargada con `google_fonts`.
- Títulos (`display`, `headline`) en peso 800; `title` en 700; botones y etiquetas en 600–700.

## Catálogo de componentes (`lib/core/widgets/`)

Las pantallas se arman con estos componentes. No se crean versiones propias de lo mismo.

| Componente | Archivo | Para qué |
| --- | --- | --- |
| `TarjetaApp` | `tarjeta_app.dart` | La única tarjeta: blanca, radio 16, sombra suave, `onTap` (se encoge al presionarla), borde de color opcional |
| `BloqueTarjeta` | `tarjeta_app.dart` | Tarjeta con encabezado (número de paso o ícono, título y subtítulo) para agrupar partes de un formulario |
| `IconoRecuadro` | `tarjeta_app.dart` | Ícono azul en un recuadro celeste |
| `EncabezadoPantalla` | `encabezado_pantalla.dart` | Título y subtítulo de una pantalla o una hoja, con ícono opcional |
| `CampoEtiquetado` | `campos.dart` | Etiqueta en negrita arriba del campo, con ayuda azul opcional ("Opcional", "Ecuador (10 dígitos)") |
| `CampoContrasena` | `campos.dart` | Campo de contraseña con candado y ojo para mostrarla u ocultarla |
| `BotonCarga` | `boton_carga.dart` | Botón principal con carga (cambio animado entre texto e indicador), ícono opcional (al inicio o al final) |
| `BarraAccion` | `barra_accion.dart` | Barra blanca fija abajo con la acción principal (móvil) |
| `AvisoBanner` | `aviso_banner.dart` | Aviso dentro de la pantalla: `info`, `exito`, `aviso` o `error`. Versión `compacto` para etiquetas |
| `EstadoMensaje` | `estado_mensaje.dart` | Hueco de la pantalla: lista vacía, error o éxito (`TipoEstado`), centrado o `compacto`, con botón opcional. En éxito, el ícono aparece con rebote y lleva un `CheckAnimado` |
| `Sacudir` | `sacudir.dart` | Sacude a su hijo cada vez que cambia `senal` (contador de fallos). Para el botón de un formulario que falló |
| `Presionable` | `presionable.dart` | Encoge a su hijo mientras se presiona, sin competir con sus gestos. Ya lo usan `BotonCarga` y `TarjetaApp` |
| `CheckAnimado` | `check_animado.dart` | Check verde que se dibuja una vez (círculo con rebote y tilde). Decorativo, o con `etiqueta` para lectores de pantalla |
| `IndicadorPasos` | `indicador_pasos.dart` | Barras de progreso con "Paso X de Y" o etiquetas bajo cada paso; la barra se llena con animación al avanzar |
| `Pildora` | `pildora.dart` | Estados y datos cortos (estado de solicitud o cotización, distancia, "Ya cotizaste"); anima el cambio de color y texto |
| `CuadriculaAdaptable` | `cuadricula_adaptable.dart` | Lista que pasa a dos columnas con 640 px o más |
| `Marca` / `Marca.vertical` | `marca.dart` | Logo y nombre en fila (barras) o apilados con el lema (login, registro, splash) |
| `AsyncValueView` | `async_value_view.dart` | Carga, error (con `EstadoMensaje` y "Reintentar") o datos |
| `mostrarMensaje` / `confirmar` | `mensajes.dart` | Avisos inferiores con tipo (`info`, `exito`, `error`) y diálogo de confirmación (con ícono y versión `destructivo`) |

## Pantallas

| Pantalla | Archivo | Notas |
| --- | --- | --- |
| Login y registro | `features/auth/presentation/` | Tarjeta sobre degradado celeste. En escritorio, panel azul con la marca y tres beneficios |
| Verificación de identidad | `features/perfil_puntos/presentation/views/verificacion_view.dart` | Hoja inferior en móvil y diálogo en escritorio (`mostrarVerificacion`). Se abre desde el perfil |
| Perfil del técnico | `features/perfil_puntos/presentation/views/perfil_tecnico_view.dart` | Encabezado azul con puntos, banner de verificación y bloques. Dos columnas en escritorio |
| Inicio del cliente | `features/solicitudes/presentation/views/mis_solicitudes_view.dart` | Bienvenida azul con "Pedir un técnico" y filtros Activas / Finalizadas |
| Nueva solicitud | `features/solicitudes/presentation/views/crear_solicitud_view.dart` | Cuatro bloques numerados, oficios en chips, "Publicar" fijo abajo |
| Feed y mis trabajos | `features/solicitudes/presentation/views/` | Resumen de la zona, tarjetas con píldoras y grupos "En curso" y "Finalizados" |
| Detalle de solicitud | `features/solicitudes/presentation/views/solicitud_detalle_view.dart` | Guía "Qué sigue", progreso y acción fija abajo. Dos columnas en escritorio |
| Chat | `features/chat/presentation/views/chat_view.dart` | Separadores por día, mis burbujas en azul, barra de envío redondeada |

## Accesibilidad

- **Contraste (WCAG AA):** blanco sobre `primario` da 4.6:1, `tinta` sobre `fondo` 13:1 y `tintaSuave` sobre `fondo` 5.1:1. El azul exacto de la referencia (`#2196F3`) da 3.1:1 con texto blanco, así que se usa solo como decoración (`primarioVivo`).
- **Píldoras:** el texto usa una versión oscurecida del color del estado, para que se lea sobre su fondo suave.
- **Texto grande:** todas las pantallas se revisaron a 360 px y a 1280 px, con texto al 100 % y al 130 %, sin desbordes.
- **Animaciones:** respetan "reducir animaciones" del sistema (`Movimiento.de`). El check de éxito es decorativo: el mensaje ya dice lo que pasó.
- **Pendiente:** revisar los tamaños mínimos de toque con el equipo.

## Decisiones pendientes

- [x] **Paleta definitiva** y **color de marca**: blanco y azul.
- [x] **Componentes compartidos**: ver el catálogo.
- [ ] **Tipografía definitiva**. Antes de publicar, **incluir los archivos de la fuente en la app** (`assets/fonts/` y `pubspec.yaml`) y desactivar la descarga en tiempo de ejecución de `google_fonts`.
- [ ] **Logo**: reemplazar el ícono provisional de `Marca`. Definir el ícono de la app y el splash nativo, y cambiar el nombre visible en `web/index.html`, `web/manifest.json` y el `AndroidManifest.xml` (hoy solo se cambió dentro de la app).
- [ ] **Funciones de la referencia que la app aún no tiene**: "¿Olvidaste tu contraseña?", "Continuar con Google" y los enlaces a Términos y Política de privacidad. No se pusieron botones que no hacen nada. Se agregan cuando exista la función o la página.
- [ ] **Modo oscuro**: hoy solo existe el tema claro.

## Cómo cambiar el diseño

1. **Colores, radios, espacios, sombras o fuente:** cambiar el valor en `tokens.dart`. Toda la app se actualiza sola.
2. **Cómo se ve un tipo de componente de Material** (todos los botones, todos los campos…): cambiarlo en `app_theme.dart`.
3. **Un componente propio** (tarjeta, aviso, píldora…): cambiarlo en `core/widgets/`.
4. **Una pantalla en particular:** cambiar su archivo en `presentation/`.

**Regla:** no escribir colores sueltos (`Colors.green`, `Colors.white`, `Color(0xFF...)`) en las pantallas. Usar siempre `Colores.*` o `Theme.of(context).colorScheme` (por ejemplo `onPrimary` para el texto blanco sobre azul).
