# Diseño visual de la app (ChauchaApp)

> El **rediseño verde y celeste** quedó definido el 2026-11-12 en el lienzo "Rediseño ChauchaApp" (marca, paleta, componentes, cliente, técnico, agenda, franjas, chat y escritorio). Reemplaza al estilo blanco y azul del 2026-11-07. El **logo** es la C que es una llave; la **tipografía** es Figtree. El **modo oscuro** sigue pendiente.

Última actualización: 2026-11-12.

## Estado

| Tema | Estado |
| --- | --- |
| Paleta de colores (verde y celeste) | **Definida** |
| Color de acento positivo | Definido: el verde marca (`acento` = `primarioVivo`) |
| Componentes compartidos | **Definidos** (ver "Catálogo de componentes") |
| Nombre visible | **ChauchaApp**, con el lema "Técnicos de confianza a tu puerta en Quito" |
| Tipografía (Figtree) | **Definida**; falta incluir los archivos de la fuente en la app |
| Logo | **Definido**: `LogoChaucha`, una C verde con el brazo abierto como llave de boca y una tuerca celeste en la boca |
| Navegación | **Definida**: barra inferior fija de cinco destinos y chats como pestaña |
| Modo oscuro | No existe todavía |
| Contraste y accesibilidad | Revisado (ver "Accesibilidad") |

## Referencia de estilo

La referencia es el lienzo "Rediseño ChauchaApp" (skill `.claude/skills/diseno-chauchaapp/SKILL.md`). De él salen estas reglas:

1. **Verde y celeste.** El verde bosque (`primario`) es la marca y las acciones: botón principal, enlaces, pestaña activa y portada. El verde marca (`primarioVivo`) va en el logo, los íconos activos, el progreso y el foco. El celeste (`cielo`) es lo del cliente, la información y los acentos (la tuerca del logo, el sol de la portada).
2. **Fondo verde muy suave** (`fondo`). En login y registro, un degradado del mismo verde. El chat va sobre `fondoChat`, un celeste casi blanco.
3. **Tarjetas blancas** con esquinas redondeadas y **sombra sutil** (`TarjetaApp`). Login y registro van dentro de una tarjeta grande (radio 24).
4. **Campos verdosos sin borde** (`superficie`), con la **etiqueta en negrita arriba** (`CampoEtiquetado`), un **ícono al inicio** y el borde verde marca al enfocarlos.
5. **Botón principal verde bosque, alto y con sombra verde**. Puede llevar una flecha al final ("Iniciar sesión →"). Desactivado, queda gris y sin sombra.
6. **Botón secundario** con borde y texto verdes. **Enlaces** en verde y negrita ("¿No tienes cuenta? **Regístrate**").
7. **Íconos en recuadros verde claro** (`IconoRecuadro`) para opciones, documentos y encabezados de bloque.
8. **Elección con tarjetas**: sin elegir, verde claro; elegida, blanca con borde verde y un check (tipo de cuenta en el registro).
9. **Progreso con barras** y el texto "Paso X de Y" (`IndicadorPasos`).
10. **Estados en píldoras** (`Pildora`): fondo suave del color del estado y texto en su versión oscura.
11. **Hojas inferiores** con asa de arrastre y botón de cerrar en móvil (verificación, franjas), y diálogo en escritorio.
12. **Portada plana**, sin degradado: verde bosque con el sol celeste y el brote verde asomando por la derecha.
13. **Navegación como Facebook**: cinco destinos fijos abajo, siempre visibles, con insignias, y la acción principal ("Pedir") como botón redondo al centro. **Chats como WhatsApp**: pestaña con buscador, filtro "Sin leer" y lista con avatar, último mensaje, hora e insignia; en la conversación, mis burbujas en verde claro y las ajenas en blanco, ambas con texto oscuro.
14. **Sin emojis ni degradados decorativos.** El login y el registro conservan su distribución (con las animaciones Lottie) y solo toman los colores de los tokens.

No se copia el lienzo literalmente: su lenguaje visual se adapta a cada funcionalidad.

## Tokens

Todo vive en [`lib/core/theme/tokens.dart`](../lib/core/theme/tokens.dart).

### Colores (`Colores`)

| Token | Valor | Uso |
| --- | --- | --- |
| `primario` | `#006414` | Verde bosque, la marca: botones, enlaces, pestaña activa, foco, portada (con texto blanco: 7.4:1) |
| `primarioOscuro` | `#004B0F` | Nombre de la marca, pasos completados, texto sobre `primarioSuave` |
| `primarioVivo` | `#009929` | Verde marca: logo, íconos activos, progreso, borde de foco. Con texto blanco da 3.8:1: **no lleva texto normal encima** |
| `primarioClaro` | `#5CCB5F` | Verde brote: puntos del calendario, check de éxito, acentos de la portada, pasos pendientes. Decorativo o con texto oscuro |
| `primarioSuave` | `#E3F6E4` | Fondo de lo elegido o resaltado, mis burbujas del chat, íconos en recuadro, avatares, avisos informativos |
| `primarioProfundo` | `#003D0C` | Fondos de marca en escritorio (panel del login) |
| `cielo` / `cieloClaro` | `#27A3DF` / `#41B6EF` | Celeste: la tuerca del logo, el sol de la portada, lo del cliente. Con texto blanco no llega a AA: decoración o texto oscuro encima |
| `cieloSuave` / `cieloOscuro` | `#E3F3FC` / `#0B4F73` | Fondo celeste suave y su texto legible |
| `fondoChat` | `#EEF7FC` | Fondo de la conversación del chat |
| `tinta` | `#0E2A14` | Texto principal (verde muy oscuro), fondo del visor de fotos |
| `tintaSuave` | `#4F6654` | Texto secundario, íconos de los campos (sobre `fondo`: 5.6:1) |
| `fondo` | `#F3FAF4` | Fondo verde muy suave de las pantallas y de la barra superior |
| `tarjeta` | `#FFFFFF` | Tarjetas, diálogos, hojas inferiores, barras inferiores |
| `superficie` | `#EAF6EB` | Campos de texto, chips y opciones sin elegir |
| `superficieFuerte` | `#D5EBD7` | Pistas del slider, huecos de fotos que cargan, franjas ocupadas |
| `linea` | `#DCEBDD` | Divisores y bordes suaves |
| `acento` / `acentoSuave` / `acentoOscuro` | = `primarioVivo` / `#DDF5DE` / = `primario` | Lo positivo: completado, aceptada, aprobado, verificado, avisos de éxito |
| `info` | `#0F6E9E` | Celeste legible como texto: estados "Abierta" y "Con cotizaciones", oficio en los chats, distancia (5.6:1) |
| `aviso` / `avisoSuave` / `avisoOscuro` | `#B45309` / `#FDF0E1` / `#7C3A06` | "Por confirmar", avisos de advertencia |
| `error` / `errorSuave` / `errorOscuro` | `#B3261E` / `#FDECEA` / `#8C1D18` | Errores, acciones destructivas |
| `estrella` | `#E39B00` | Estrellas de calificación, ícono de puntos |

**Estados de solicitud:** Abierta y Con cotizaciones usan `info`, En curso `primario`, Por confirmar `aviso`, Completada `acento` y Cancelada `tintaSuave`.

### Sombras (`Sombras`)

- `Sombras.suave`: sombra verdosa al 8 %, desenfoque 18, desplazamiento vertical 6. Para tarjetas.
- `Sombras.boton`: color de la sombra del botón principal.
- `Sombras.fuerte`: sombra verde más marcada para la portada (`TarjetaPortada`) y el botón central de la barra inferior.

No hay degradados de marca: la portada es verde bosque plano con formas de color. El único degradado es el fondo suave del login y el registro (`AuthLayout`), que usa los tokens.

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

- Familia: **Figtree**, una sola para todo, cargada con `google_fonts`.
- Títulos (`display`, `headline`) en peso 800 y algo apretados; `title` en 700; botones y etiquetas en 600–700. El nombre de la marca va en 800 con `letterSpacing` -0.8.

## Catálogo de componentes (`lib/core/widgets/`)

Las pantallas se arman con estos componentes. No se crean versiones propias de lo mismo.

| Componente | Archivo | Para qué |
| --- | --- | --- |
| `TarjetaApp` | `tarjeta_app.dart` | La única tarjeta: blanca, radio 16, sombra suave, `onTap` (se encoge al presionarla), borde de color opcional |
| `BloqueTarjeta` | `tarjeta_app.dart` | Tarjeta con encabezado (número de paso o ícono, título y subtítulo) para agrupar partes de un formulario |
| `IconoRecuadro` | `tarjeta_app.dart` | Ícono verde en un recuadro verde claro |
| `EncabezadoPantalla` | `encabezado_pantalla.dart` | Título y subtítulo de una pantalla o una hoja, con ícono opcional |
| `CampoEtiquetado` | `campos.dart` | Etiqueta en negrita arriba del campo, con ayuda verde opcional ("Opcional", "Ecuador (10 dígitos)") |
| `CampoContrasena` | `campos.dart` | Campo de contraseña con candado y ojo para mostrarla u ocultarla |
| `BotonCarga` | `boton_carga.dart` | Botón principal con carga (cambio animado entre texto e indicador), ícono opcional (al inicio o al final) |
| `TarjetaPortada` | `tarjeta_portada.dart` | Portada del inicio: verde bosque plano con el sol celeste y el brote verde asomando por la derecha, título grande en blanco (el signo final va en verde brote como acento), subtítulo, dato en una píldora blanca y una ilustración (se oculta con menos de 300 px) |
| `BarraAccion` | `barra_accion.dart` | Barra blanca fija abajo con la acción principal (móvil) |
| `AvisoBanner` | `aviso_banner.dart` | Aviso dentro de la pantalla: `info`, `exito`, `aviso` o `error`. Versión `compacto` para etiquetas |
| `EstadoMensaje` | `estado_mensaje.dart` | Hueco de la pantalla: lista vacía, error o éxito (`TipoEstado`), centrado o `compacto`, con botón opcional y, en la versión grande, una acción secundaria debajo ("Regresar", "Volver al inicio"). En éxito, el ícono aparece con rebote y lleva un `CheckAnimado` |
| `EsqueletoCarga` / `BloqueEsqueleto` | `esqueleto_carga.dart` | Carga con la forma de la pantalla: bloques celestes que laten (quietos con "reducir animaciones"). Se pasa a `AsyncValueView` con `cargando:`. Lo usa el detalle de solicitud |
| `Sacudir` | `sacudir.dart` | Sacude a su hijo cada vez que cambia `senal` (contador de fallos). Para el botón de un formulario que falló |
| `Presionable` | `presionable.dart` | Encoge a su hijo mientras se presiona, sin competir con sus gestos. Ya lo usan `BotonCarga` y `TarjetaApp` |
| `CheckAnimado` | `check_animado.dart` | Check verde que se dibuja una vez (círculo con rebote y tilde). Decorativo, o con `etiqueta` para lectores de pantalla |
| `AnimacionLottie` | `animacion_lottie.dart` | Animación Lottie decorativa (`assets/lottie/*.json`) en una caja de `alto` × `proporcion` que recorta el margen vacío del lienzo. Reserva su espacio mientras carga, queda quieta con "reducir animaciones" y no redibuja lo que la rodea. Con `tramo` reproduce un marcador del archivo: al cambiarlo pasa una vez por la transición `<tramo>_in` (si existe) y repite el tramo. El login usa dos: en escritorio, `tecnico.json` (saluda, se repite entero) grande al centro del panel azul con el titular debajo (`AuthLayout(animacionEscritorio: ...)`); en móvil, `tecnico_login.json` apoyado sobre el borde superior de la tarjeta (superpuesto con un `Stack`), con la marca en fila arriba y los tramos `idle`, `email` y `password` según el campo con foco (`animacionMovil` y `tramoAnimacion`) |
| `IndicadorPasos` | `indicador_pasos.dart` | Barras de progreso con "Paso X de Y" o etiquetas bajo cada paso; la barra se llena con animación al avanzar |
| `Pildora` | `pildora.dart` | Estados y datos cortos (estado de solicitud o cotización, distancia, "Ya cotizaste"); anima el cambio de color y texto |
| `CuadriculaAdaptable` | `cuadricula_adaptable.dart` | Lista que pasa a dos columnas con 640 px o más |
| `LogoChaucha` | `marca.dart` | El logo dibujado con `CustomPainter` (sin assets): una C verde marca con el brazo abierto, como una llave de boca, y una tuerca celeste en la boca. `tamano`, `sobreOscuro` (C blanca y tuerca celeste clara para fondos verdes) y `fondo` (el color que se ve por el agujero de la tuerca). Mínimo 24 px |
| `Marca` / `Marca.vertical` | `marca.dart` | Logo y nombre en fila (barras) o apilados con el lema (login, registro, splash). El nombre va en 800, verde bosque o blanco |
| `AsyncValueView` | `async_value_view.dart` | Carga (spinner, o la propia con `cargando:`), error (con `EstadoMensaje` y "Reintentar") o datos |
| `mostrarMensaje` / `confirmar` | `mensajes.dart` | Avisos inferiores con tipo (`info`, `exito`, `error`) y diálogo de confirmación (con ícono y versión `destructivo`) |

## Pantallas

| Pantalla | Archivo | Notas |
| --- | --- | --- |
| Login y registro | `features/auth/presentation/` | Tarjeta sobre degradado verde suave, con las animaciones Lottie. En escritorio, panel verde con la marca y tres beneficios. La distribución no cambió con el rediseño; solo los colores |
| Verificación de identidad | `features/perfil_puntos/presentation/views/verificacion_view.dart` | Hoja inferior en móvil y diálogo en escritorio (`mostrarVerificacion`). Se abre desde el perfil |
| Perfil del técnico | `features/perfil_puntos/presentation/views/perfil_tecnico_view.dart` | Encabezado verde con puntos, banner de verificación y bloques. Dos columnas en escritorio |
| Pestañas (shell) | `app/inicio_shell.dart` | En móvil, barra blanca fija abajo con cinco destinos (como Facebook): íconos con insignia, la pestaña activa con el ícono relleno en verde marca y la etiqueta en verde bosque. Si el shell tiene `AccionCentral` ("Pedir un técnico" para el cliente), va como botón redondo verde al centro, un poco por encima de la barra. Cada `Destino` puede tener `iconoActivo` (relleno) y `corto` (etiqueta de la barra). En escritorio, la `Marca`, las pestañas y la acción central en la barra superior. El cliente abre su agenda desde el menú de la cuenta (`rutaAgenda`) |
| Chats | `features/chat/presentation/views/chats_view.dart` | Pestaña al estilo WhatsApp: título con "N sin leer", buscador por nombre u oficio, chips Todos / Sin leer y la lista en una tarjeta: avatar (abre el perfil), nombre en negrita si hay nuevos, hora en verde, último mensaje ("Tú: …"), oficio en píldora e insignia con la cantidad. Los no leídos salen de `notificacionesNoLeidasProvider` (tipos `tiposDeChat`) |
| Agenda | `features/solicitudes/presentation/views/agenda_view.dart` | Tickets por confirmar arriba; luego `CalendarioAgenda` (mes en español con cabecera propia, día elegido en verde bosque, hoy con borde verde marca, puntos verde brote en los días con visitas) y la lista del día elegido, o las próximas, como línea de tiempo: hora y "Hoy / Mañana" a la izquierda y tarjeta con borde de color (ámbar ticket, verde hoy, celeste más adelante) |
| Elegir franja | `features/cotizaciones/presentation/widgets/selector_franja.dart` | Hoja inferior en móvil y diálogo en escritorio (`elegirFranja`): calendario, leyenda y cuadrícula de franjas de 1 hora. Libre (blanca), elegida (verde bosque), ocupada por otra visita del técnico o del cliente (rayada con candado, bloqueada) y pasada (tachada). El botón dice "Confirmar jue 12 de nov, 11:00 a 12:00" |
| Inicio del cliente | `features/auth/presentation/views/inicio_view.dart` | `TarjetaPortada` ("¿Qué arreglamos hoy?" y técnicos cerca), buscador con frecuentes, especialidades, mapa y técnicos destacados |
| Inicio del técnico | `features/solicitudes/presentation/views/inicio_tecnico_view.dart` | `TarjetaPortada` con saludo y pendientes del día, luego "Para empezar", pendientes, solicitudes cerca, actividad y reputación |
| Mis solicitudes | `features/solicitudes/presentation/views/mis_solicitudes_view.dart` | Título con el botón a la agenda y "Nueva solicitud", y filtros Activas / Finalizadas |
| Nueva solicitud | `features/solicitudes/presentation/views/crear_solicitud_view.dart` | Cuatro bloques numerados, oficios en chips, "Publicar" fijo abajo. Al publicar, pantalla de éxito (`SolicitudPublicada`) con "Ver mi solicitud" y "Volver al inicio" |
| Feed y mis trabajos | `features/solicitudes/presentation/views/` | Resumen de la zona, tarjetas con píldoras y grupos "En curso" y "Finalizados" |
| Panel de administrador | `features/admin/presentation/views/` | Mismo shell (barra inferior en móvil, pestañas arriba en escritorio), sin acción central. Resumen con `TarjetaPortada` y cifras; Solicitudes, Usuarios y Verificaciones con `PantallaAdmin` (título, buscador, filtros en chips y lista). Crear y editar usuarios en hojas inferiores; suspender y eliminar con `confirmar(destructivo: true)`. Verificaciones: miniaturas de cédula y selfie con estado en `Pildora`, zoom al tocar, "Rechazar" y "Aprobar" |
| Detalle de solicitud | `features/solicitudes/presentation/views/solicitud_detalle_view.dart` | Guía "Qué sigue", progreso y acción fija abajo. Dos columnas en escritorio. Mientras carga, `EsqueletoCarga`; si falla, "Reintentar" y "Regresar" |
| Chat | `features/chat/presentation/views/chat_view.dart` | El cliente ve el nombre del técnico en la barra. Fondo `fondoChat`, separadores por día en píldoras blancas, mis burbujas en verde claro y las ajenas en blanco (texto oscuro en ambas), el ticket como tarjeta con el precio grande y la franja de la visita, notas del sistema en verde claro, barra de envío con campo redondeado y botón verde |

## Accesibilidad

- **Contraste (WCAG AA):** blanco sobre `primario` da 7.4:1, `tinta` sobre `fondo` 14:1 y `tintaSuave` sobre `fondo` 5.6:1. El verde marca (`#009929`, 3.8:1) y el celeste (`#27A3DF`, 2.8:1) no llegan a AA con texto blanco, así que van en íconos, fondos y acentos, nunca con texto normal encima; para texto celeste se usa `info` (5.6:1).
- **Píldoras:** el texto usa una versión oscurecida del color del estado, para que se lea sobre su fondo suave.
- **Texto grande:** todas las pantallas se revisaron a 360 px y a 1280 px, con texto al 100 % y al 130 %, sin desbordes.
- **Animaciones:** respetan "reducir animaciones" del sistema (`Movimiento.de`). El check de éxito es decorativo: el mensaje ya dice lo que pasó.
- **Pendiente:** revisar los tamaños mínimos de toque con el equipo.

## Decisiones pendientes

- [x] **Paleta definitiva** y **color de marca**: verde y celeste (2026-11-12).
- [x] **Componentes compartidos**: ver el catálogo.
- [x] **Tipografía definitiva**: Figtree. Antes de publicar, **incluir los archivos de la fuente en la app** (`assets/fonts/` y `pubspec.yaml`) y desactivar la descarga en tiempo de ejecución de `google_fonts`.
- [x] **Logo**: `LogoChaucha`. El ícono de la app (Android adaptativo y web), el splash nativo y el favicon se generan desde él: `flutter test tool/generar_marca.dart` exporta los PNG a `assets/marca/`, y luego `dart run flutter_launcher_icons` y `dart run flutter_native_splash:create` (configurados en `pubspec.yaml`). El nombre visible es "ChauchaApp" en `web/index.html`, `web/manifest.json` y el `AndroidManifest.xml`.
- [ ] **Funciones de la referencia que la app aún no tiene**: "¿Olvidaste tu contraseña?", "Continuar con Google" y los enlaces a Términos y Política de privacidad. No se pusieron botones que no hacen nada. Se agregan cuando exista la función o la página.
- [ ] **Modo oscuro**: hoy solo existe el tema claro.

## Cómo cambiar el diseño

1. **Colores, radios, espacios, sombras o fuente:** cambiar el valor en `tokens.dart`. Toda la app se actualiza sola.
2. **Cómo se ve un tipo de componente de Material** (todos los botones, todos los campos…): cambiarlo en `app_theme.dart`.
3. **Un componente propio** (tarjeta, aviso, píldora…): cambiarlo en `core/widgets/`.
4. **Una pantalla en particular:** cambiar su archivo en `presentation/`.

**Regla:** no escribir colores sueltos (`Colors.green`, `Colors.white`, `Color(0xFF...)`) en las pantallas. Usar siempre `Colores.*` o `Theme.of(context).colorScheme` (por ejemplo `onPrimary` para el texto blanco sobre verde).
