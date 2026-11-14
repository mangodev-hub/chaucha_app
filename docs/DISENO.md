# Diseño visual de la app (ChauchaApp)

> El **estilo "Bento orgánico"** (2026-11-12) reemplaza al fondo neutro claro de la dirección v2: fondo verde bosque profundo, todo el contenido en tarjetas claras muy redondeadas, tarjetas principales con una onda pintada de un segundo tono, botones y campos en píldora y **ninguna sombra**. Mantiene la paleta verde y celeste del rediseño del mismo día (lienzo "Rediseño ChauchaApp") y el **logo** de la C que es una llave. La **tipografía** es Plus Jakarta Sans.

Última actualización: 2026-11-12.

## Estado

| Tema | Estado |
| --- | --- |
| Paleta de colores (verde y celeste) | **Definida** |
| Color de acento positivo | Definido: el verde marca (`acento` = `primarioVivo`) |
| Componentes compartidos | **Definidos** (ver "Catálogo de componentes") |
| Nombre visible | **ChauchaApp**, con el lema "Técnicos de confianza a tu puerta en Quito" |
| Estilo (Bento orgánico, fondo oscuro) | **Definido** (2026-11-12) |
| Tipografía (Plus Jakarta Sans) | **Definida**; falta incluir los archivos de la fuente en la app |
| Logo | **Definido**: `LogoChaucha`, una C verde con el brazo abierto como llave de boca y una tuerca celeste en la boca |
| Navegación | **Definida**: barra inferior fija de cinco destinos y chats como pestaña |
| Modo oscuro | El fondo de la app ya es oscuro; no hay un tema claro alternativo |
| Contraste y accesibilidad | Revisado (ver "Accesibilidad") |

## Referencia de estilo

La referencia es la skill `SKILL_REDISENO.md` (Bento orgánico), sobre la paleta del lienzo "Rediseño ChauchaApp". Reglas:

1. **Fondo verde bosque profundo** (`fondo`, `#0B2518`) en todas las pantallas. Sobre él solo va lo que está pensado para fondo oscuro: el saludo del inicio, la barra superior (título e íconos blancos), el pie y la marca en versión clara (`sobreOscuro`).
2. **Nada suelto sobre el fondo.** Cada pantalla común (listas, formularios, detalle, chat, perfil, admin) vive dentro de la **gran hoja clara** (`HojaClara`, superficie `lienzo`, radio 30). Los **inicios** se arman con **tarjetas bento** sueltas sobre el fondo oscuro, separadas por 18 px (`Espacios.bento`).
3. **Tarjetas con onda** (`TarjetaOnda`): las principales no son de un color plano; llevan una onda orgánica (`PintorOnda`) de un segundo tono, una mancha por la esquina superior derecha o una ola abajo. Dúos: verde claro con onda celeste (`TarjetaOnda.verde`, portada del cliente, garantías, "Para empezar"), celeste claro con ola verde (`TarjetaOnda.celeste`, servicios, cabeceras, portada del técnico) y superficie clara con onda celeste suave (`TarjetaOnda.clara`, secciones con listas). Las tres llevan **texto oscuro** (`tinta`).
4. **Sin sombras.** `elevation: 0` en todo; la jerarquía sale del contraste de color y de los radios. Las tarjetas blancas sobre la hoja clara llevan un borde fino (`linea`).
5. **Muy redondeado.** Hoja y tarjetas bento 30, sub-tarjetas 22, fichas de fecha 16, barra inferior y hojas inferiores 32 arriba. Ninguna caja baja de 12.
6. **Píldoras.** Botones principales en píldora verde oscuro (`primario`) con texto blanco en negrita; secundarios en píldora blanca con borde. Campos con relleno verdoso y muy redondeados (los de una línea quedan como píldora). El buscador del inicio es una píldora blanca con el botón redondo verde de acción a la derecha. Filtros en píldora: el activo en verde oscuro.
7. **Fechas y horas como fichas** (`FichasFecha`): bloques verde oscuro con texto blanco, `jue` `12` `nov` `10:00`.
8. **Opciones ilustradas** (`TarjetaOpcion`): arriba un área celeste con el ícono en un círculo, abajo el nombre y un botón redondo con flecha. Para elegir un servicio.
9. **Verde = acción, celeste = contexto.** El verde oscuro queda para el botón principal, la pestaña activa, las fichas y lo confirmado. El celeste va en cabeceras, avatares, íconos de sección (`IconoRecuadro`, ahora circular), datos y las pestañas inactivas.
10. **Navegación como Facebook**: cinco destinos fijos abajo en una barra clara con las esquinas de arriba muy redondeadas y una onda celeste suave; ítem activo en verde oscuro, inactivos con el ícono celeste; "Pedir" como botón redondo verde con aro claro, sobresaliendo. **Chats como WhatsApp**.
11. **Hojas inferiores y diálogos** sobre la superficie clara, con un indicador celeste de 40 × 4 arriba.
12. **Sin emojis.** El login y el registro conservan su distribución (con las animaciones Lottie) y solo toman los colores: fondo oscuro con onda celeste suave y la tarjeta clara.

No se copia la referencia literalmente: su lenguaje visual se adapta a cada funcionalidad.

## Tokens

Todo vive en [`lib/core/theme/tokens.dart`](../lib/core/theme/tokens.dart).

### Colores (`Colores`)

Paleta Eco-Sky: tres verdes y dos celestes, más superficies y semánticos.

| Token | Valor | Uso |
| --- | --- | --- |
| `primario` | `#006414` | `darkGreen`: botones con texto, píldoras y filtros activos, fichas de fecha, pestaña activa (con texto blanco: 7.4:1) |
| `primarioOscuro` | `#004B0F` | Texto verde sobre fondos verdes claros |
| `primarioVivo` | `#009929` | `midGreen`: logo, íconos activos, progreso, borde de foco, lo confirmado. Con texto blanco da 3.8:1: **no lleva texto normal encima** |
| `primarioClaro` | `#5CCB5F` | `lightGreen`: tarjetas verdes con onda, aro del avatar, ondas. Con texto oscuro |
| `primarioSuave` | `#E3F6E4` | Lo elegido o resaltado, mis burbujas del chat |
| `cielo` | `#27A3DF` | `midBlue`: indicador de las hojas, íconos de pestañas inactivas, bordes destacados. Con texto blanco no llega a AA |
| `cieloClaro` | `#41B6EF` | `lightBlue`: tarjetas celestes con onda (cabeceras, servicios, portada del técnico) y ondas. Con texto oscuro |
| `cieloSuave` / `cieloOscuro` | `#E3F3FC` / `#0B4F73` | Fondo celeste suave (íconos en círculo, avatares, frecuentes) y su texto legible |
| `fondo` | `#0B2518` | `appBackground`: fondo de todas las pantallas y de la barra superior |
| `lienzo` | `#F4F9F6` | `surfaceLight`: la hoja clara, la barra inferior, hojas inferiores, diálogos y tarjetas del login |
| `tarjeta` | `#FFFFFF` | Tarjetas dentro de la hoja clara (con borde `linea`) |
| `superficie` / `neutro` | `#E8F1EC` | Campos de texto, chips sin elegir, filas de datos |
| `superficieFuerte` | `#D5E3DA` | Pistas del slider y del progreso, huecos que cargan, borde del botón secundario |
| `linea` | `#DCE8E0` | Borde fino de las tarjetas blancas y divisores |
| `fondoChat` | `#EEF7FC` | Fondo de la conversación del chat |
| `tinta` | `#062B14` | `textOnLight`: texto principal sobre superficies claras y tarjetas de color |
| `tintaSuave` | `#2D523B` | `textMuted`: texto secundario y placeholders |
| `sobreOscuro` | `#FFFFFF` | `textOnDark`: texto e íconos sobre el fondo y sobre `primario` |
| `acento` / `acentoSuave` / `acentoOscuro` | = `primarioVivo` / `#DDF5DE` / = `primario` | Lo positivo: completado, aceptada, aprobado, verificado |
| `info` | `#0F6E9E` | Celeste legible como texto: estados "Abierta" y "Con cotizaciones", distancia |
| `aviso` / `avisoSuave` / `avisoOscuro` | `#B45309` / `#FDF0E1` / `#7C3A06` | "Por confirmar", advertencias |
| `error` / `errorSuave` / `errorOscuro` | `#B3261E` / `#FDECEA` / `#8C1D18` | Errores, acciones destructivas |
| `estrella` | `#E39B00` | Estrellas de calificación |

Los semánticos (`info`, `aviso`, `error`, `estrella`) quedan fuera de la paleta de cinco colores a propósito: un error tiene que distinguirse de un estado normal.

**Estados de solicitud:** Abierta y Con cotizaciones usan `info`, En curso `primario`, Por confirmar `aviso`, Completada `acento` y Cancelada `tintaSuave`.

### Sombras y degradados

No hay: se eliminaron `Sombras` y `Degradados`. La profundidad sale del color (tarjetas claras sobre fondo oscuro, ondas de un segundo tono) y de los bordes finos.

### Radios (`Radios`) y espacios (`Espacios`)

- Radios: `pequeno` 12 · `medio` 16 (cajas internas, fichas de fecha) · `grande` = `subtarjeta` 22 (sub-tarjetas, filas de datos, avisos) · `muyGrande` 30 (diálogos) · `bento` 30 (hoja clara y tarjetas con onda) · `hoja` 32 (barra inferior y hojas inferiores) · `pildora` 999.
- Espacios: `xs` 4 · `s` 8 · `m` 12 · `l` 16 · `bento` 18 (entre tarjetas bento) · `xl` 24 · `xxl` 32.

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

- Familia: **Plus Jakarta Sans** (geométrica y redondeada), una sola para todo, cargada con `google_fonts`.
- Títulos (`display`, `headline`) en peso 800; títulos de tarjeta (`titleLarge`) en 21 y 700; cuerpo en peso 500; botones en 700. El nombre de la marca va en 800 con `letterSpacing` -0.8.

## Catálogo de componentes (`lib/core/widgets/`)

Las pantallas se arman con estos componentes. No se crean versiones propias de lo mismo.

| Componente | Archivo | Para qué |
| --- | --- | --- |
| `HojaClara` | `hoja_clara.dart` | La gran tarjeta clara (radio 30) donde va el contenido de cada pantalla común. La pone el shell en las pestañas sin saludo; las pantallas con ruta propia la usan como `body`. Con `abajoRecto: true` llega hasta abajo y la cierra la `BarraAccion` o el campo del chat |
| `TarjetaOnda` | `tarjeta_onda.dart` | Tarjeta bento de color con una onda pintada (`PintorOnda`), título y acción opcionales. Variantes `.verde`, `.celeste` y `.clara`; `FormaOnda.esquina` (mancha arriba a la derecha) o `.inferior` (ola). `FondoOnda` es solo el fondo, para franjas que arman su propio recorte (portada de los perfiles, fondo del login) |
| `TarjetaOpcion` | `tarjeta_opcion.dart` | Opción ilustrada: área celeste con el ícono en un círculo, nombre (y subtítulo) y botón redondo con flecha. Los servicios del inicio |
| `FichaDato` / `FichasFecha` | `ficha_dato.dart` | Fichas verde oscuro con texto blanco (radio 16) para fecha y hora: `jue` `12` `nov` `10:00` |
| `EncabezadoSaludo` | `app/encabezado_saludo.dart` | Saludo del inicio sobre el fondo oscuro: avatar con aro verde claro (abre el menú de la cuenta), "Hola, Nombre" en blanco y una línea debajo. Lo pone el shell en los destinos con `saludo` |
| `TarjetaApp` | `tarjeta_app.dart` | Sub-tarjeta: blanca, radio 22, sin sombra, borde fino `linea` (`conBorde: false` para quitarlo), `onTap` (se encoge al presionarla), borde de color opcional |
| `BloqueTarjeta` | `tarjeta_app.dart` | Tarjeta con encabezado (número de paso o ícono, título y subtítulo) para agrupar partes de un formulario |
| `IconoRecuadro` | `tarjeta_app.dart` | Ícono celeste oscuro en un círculo celeste suave |
| `EncabezadoPantalla` | `encabezado_pantalla.dart` | Título y subtítulo de una pantalla o una hoja, con ícono opcional |
| `CampoEtiquetado` | `campos.dart` | Etiqueta en negrita arriba del campo, con ayuda verde opcional ("Opcional", "Ecuador (10 dígitos)") |
| `CampoContrasena` | `campos.dart` | Campo de contraseña con candado y ojo para mostrarla u ocultarla |
| `BotonCarga` | `boton_carga.dart` | Botón principal con carga (cambio animado entre texto e indicador), ícono opcional (al inicio o al final) |
| `TarjetaPortada` | `tarjeta_portada.dart` | Portada del inicio sobre `TarjetaOnda`: verde claro con mancha celeste (cliente) o, con `celeste: true`, celeste claro con ola verde (técnico). Título grande en tinta (el signo final en verde oscuro), subtítulo, dato en una píldora verde oscuro con texto blanco y una ilustración en un círculo claro (se oculta con menos de 300 px) |
| `CabeceraCielo` | `cabecera_cielo.dart` | Cabecera de detalle y perfil: tarjeta celeste claro con ola verde (radio 30), título y subtítulo en tinta oscura, `pildora` opcional a la derecha, `child` debajo y una animación Lottie (`animacion`, el técnico) abajo a la derecha con 360 px o más. La usa `EncabezadoSolicitud` |
| `FilaDato` | `fila_dato.dart` | Fila de datos neutra: `etiqueta` (y `detalle`), `icono` opcional, `valor` grande en celeste oscuro a la derecha y `trailing` (una `Pildora`). Precio de la visita y ticket en `CotizacionCard` |
| `BarraAccion` | `barra_accion.dart` | Acción principal fija abajo (móvil): continúa la `HojaClara(abajoRecto: true)` y la cierra con las esquinas redondeadas |
| `AvisoBanner` | `aviso_banner.dart` | Aviso dentro de la pantalla: `info`, `exito`, `aviso` o `error`. Versión `compacto` para etiquetas |
| `EstadoMensaje` | `estado_mensaje.dart` | Hueco de la pantalla: lista vacía, error o éxito (`TipoEstado`), centrado o `compacto`, con botón opcional y, en la versión grande, una acción secundaria debajo ("Regresar", "Volver al inicio"). En éxito, el ícono aparece con rebote y lleva un `CheckAnimado` |
| `EsqueletoCarga` / `BloqueEsqueleto` | `esqueleto_carga.dart` | Carga con la forma de la pantalla: bloques celestes que laten (quietos con "reducir animaciones"). Se pasa a `AsyncValueView` con `cargando:`. Lo usa el detalle de solicitud |
| `Sacudir` | `sacudir.dart` | Sacude a su hijo cada vez que cambia `senal` (contador de fallos). Para el botón de un formulario que falló |
| `Presionable` | `presionable.dart` | Encoge a su hijo mientras se presiona, sin competir con sus gestos. Ya lo usan `BotonCarga` y `TarjetaApp` |
| `CheckAnimado` | `check_animado.dart` | Check verde que se dibuja una vez (círculo con rebote y tilde). Decorativo, o con `etiqueta` para lectores de pantalla |
| `AnimacionLottie` | `animacion_lottie.dart` | Animación Lottie decorativa (`assets/lottie/*.json`) en una caja de `alto` × `proporcion` que recorta el margen vacío del lienzo. Reserva su espacio mientras carga, queda quieta con "reducir animaciones" y no redibuja lo que la rodea. Con `tramo` reproduce un marcador del archivo: al cambiarlo pasa una vez por la transición `<tramo>_in` (si existe) y repite el tramo. El login usa dos: en escritorio, `tecnico.json` (saluda, se repite entero) grande al centro del panel azul con el titular debajo (`AuthLayout(animacionEscritorio: ...)`); en móvil, `tecnico_login.json` apoyado sobre el borde superior de la tarjeta (superpuesto con un `Stack`), con la marca en fila arriba y los tramos `idle`, `email` y `password` según el campo con foco (`animacionMovil` y `tramoAnimacion`) |
| `IndicadorPasos` | `indicador_pasos.dart` | Barras de progreso con "Paso X de Y" o etiquetas bajo cada paso; la barra se llena con animación al avanzar |
| `Pildora` | `pildora.dart` | Estados y datos cortos, con fondo suave opaco (se lee también sobre las tarjetas de color) (estado de solicitud o cotización, distancia, "Ya cotizaste"); anima el cambio de color y texto |
| `CuadriculaAdaptable` | `cuadricula_adaptable.dart` | Lista que pasa a dos columnas con 640 px o más |
| `LogoChaucha` | `marca.dart` | El logo dibujado con `CustomPainter` (sin assets): una C verde marca con el brazo abierto, como una llave de boca, y una tuerca celeste en la boca. `tamano`, `sobreOscuro` (C blanca y tuerca celeste clara para fondos verdes) y `fondo` (el color que se ve por el agujero de la tuerca). Mínimo 24 px |
| `Marca` / `Marca.vertical` | `marca.dart` | Logo y nombre en fila (barras) o apilados con el lema (login, registro, splash). El nombre va en 800, verde bosque o blanco |
| `AsyncValueView` | `async_value_view.dart` | Carga (spinner, o la propia con `cargando:`), error (con `EstadoMensaje` y "Reintentar") o datos |
| `mostrarMensaje` / `confirmar` | `mensajes.dart` | Avisos inferiores con tipo (`info`, `exito`, `error`) y diálogo de confirmación (con ícono y versión `destructivo`) |

## Pantallas

| Pantalla | Archivo | Notas |
| --- | --- | --- |
| Login y registro | `features/auth/presentation/` | Tarjeta clara (radio 30) sobre el fondo oscuro con una onda celeste suave, con las animaciones Lottie; la marca de arriba en versión clara. En escritorio, panel verde con la marca y tres beneficios. La distribución no cambió con el rediseño; solo los colores |
| Verificación de identidad | `features/perfil_puntos/presentation/views/verificacion_view.dart` | Hoja inferior en móvil y diálogo en escritorio (`mostrarVerificacion`). Se abre desde el perfil |
| Perfil del técnico | `features/perfil_puntos/presentation/views/perfil_tecnico_view.dart` | Cabecera celeste con el avatar en un aro blanco, nivel en píldora celeste, banner de verificación y bloques. Dos columnas en escritorio. El perfil público y el del cliente siguen la misma cabecera celeste |
| Pestañas (shell) | `app/inicio_shell.dart` | En móvil, barra clara fija abajo con las esquinas de arriba de 32 y una onda celeste suave, con cinco destinos (como Facebook): íconos con insignia, la pestaña activa en verde oscuro y las inactivas con el ícono celeste. Si el shell tiene `AccionCentral` ("Pedir un técnico" para el cliente), va como botón redondo verde con aro claro al centro, sobresaliendo. Cada `Destino` puede tener `iconoActivo`, `corto` y `saludo`: con `saludo` (los inicios), en móvil la pestaña lleva `EncabezadoSaludo` en lugar de la barra superior y su contenido son tarjetas bento sobre el fondo oscuro; sin `saludo`, el contenido va en `HojaClara`. En escritorio, barra superior oscura con la `Marca` clara, pestañas en píldora (la activa clara) y la acción central. El cliente abre su agenda desde el menú de la cuenta (`rutaAgenda`) |
| Chats | `features/chat/presentation/views/chats_view.dart` | Pestaña al estilo WhatsApp: título con "N sin leer", buscador por nombre u oficio, chips Todos / Sin leer y la lista en una tarjeta: avatar (abre el perfil), nombre en negrita si hay nuevos, hora en verde, último mensaje ("Tú: …"), oficio en píldora e insignia con la cantidad. Los no leídos salen de `notificacionesNoLeidasProvider` (tipos `tiposDeChat`) |
| Agenda | `features/solicitudes/presentation/views/agenda_view.dart` | Tickets por confirmar arriba; luego `CalendarioAgenda` (mes en español con cabecera propia, día elegido en verde bosque, hoy con borde verde marca, puntos verde brote en los días con visitas) y la lista del día elegido, o las próximas, como línea de tiempo: hora y "Hoy / Mañana" a la izquierda y tarjeta con borde de color (ámbar ticket, verde hoy, celeste más adelante) |
| Elegir franja | `features/cotizaciones/presentation/widgets/selector_franja.dart` | Hoja inferior en móvil y diálogo en escritorio (`elegirFranja`): calendario, leyenda y cuadrícula de franjas de 1 hora. Libre (blanca), elegida (verde bosque), ocupada por otra visita del técnico o del cliente (rayada con candado, bloqueada) y pasada (tachada). El botón dice "Confirmar jue 12 de nov, 11:00 a 12:00" |
| Inicio del cliente | `features/auth/presentation/views/inicio_view.dart` | Bento sobre el fondo oscuro: `TarjetaPortada` verde, buscador en píldora con frecuentes (`TarjetaOnda.clara`), servicios en `TarjetaOpcion` (`TarjetaOnda.celeste`, seis en el teléfono), mapa (radio 30), técnicos cerca con filtros en píldora (`TarjetaOnda.clara`), aliados, garantías (`TarjetaOnda.verde`) y el pie en blanco |
| Inicio del técnico | `features/solicitudes/presentation/views/inicio_tecnico_view.dart` | Bento sobre el fondo oscuro: `TarjetaPortada(celeste: true)` con los pendientes del día; cada sección ("Tu zona", "Para empezar" en verde, pendientes, solicitudes cerca) es una `TarjetaOnda` con título |
| Mis solicitudes | `features/solicitudes/presentation/views/mis_solicitudes_view.dart` | Título con el botón a la agenda y "Nueva solicitud", y filtros Activas / Finalizadas |
| Nueva solicitud | `features/solicitudes/presentation/views/crear_solicitud_view.dart` | Cuatro bloques numerados, oficios en chips, "Publicar" fijo abajo. Al publicar, pantalla de éxito (`SolicitudPublicada`) con "Ver mi solicitud" y "Volver al inicio" |
| Feed y mis trabajos | `features/solicitudes/presentation/views/` | Resumen de la zona, tarjetas con píldoras y grupos "En curso" y "Finalizados" |
| Panel de administrador | `features/admin/presentation/views/` | Mismo shell (barra inferior en móvil, pestañas arriba en escritorio), sin acción central. Resumen con `TarjetaPortada` y cifras; Solicitudes, Usuarios y Verificaciones con `PantallaAdmin` (título, buscador, filtros en chips y lista). Crear y editar usuarios en hojas inferiores; suspender y eliminar con `confirmar(destructivo: true)`. Verificaciones: miniaturas de cédula y selfie con estado en `Pildora`, zoom al tocar, "Rechazar" y "Aprobar" |
| Detalle de solicitud | `features/solicitudes/presentation/views/solicitud_detalle_view.dart` | `CabeceraCielo` con el oficio, el estado, la descripción y el técnico (Lottie); guía "Qué sigue", progreso y acción fija abajo. La oferta del técnico (`CotizacionCard`) muestra el precio y el ticket en `FilaDato`. Dos columnas en escritorio. Mientras carga, `EsqueletoCarga`; si falla, "Reintentar" y "Regresar" |
| Chat | `features/chat/presentation/views/chat_view.dart` | El cliente ve el nombre del técnico en la barra. Fondo `fondoChat`, separadores por día en píldoras blancas, mis burbujas en verde claro y las ajenas en blanco (texto oscuro en ambas), el ticket como tarjeta con el precio grande y la franja de la visita, notas del sistema en verde claro, barra de envío con campo redondeado y botón verde |

## Accesibilidad

- **Contraste (WCAG AA):** blanco sobre `fondo` 16.3:1 y sobre `primario` 7.4:1; `tinta` sobre `lienzo` 14.5:1, sobre verde claro 7.5:1 y sobre celeste claro 6.7:1; `tintaSuave` sobre `lienzo` 8.3:1 y sobre `superficie` 7.7:1. Por eso las tarjetas de color llevan texto oscuro. El verde medio (`#009929`, 3.8:1) y el azul medio (`#27A3DF`, 2.8:1) no llegan a AA con texto blanco: van en íconos, fondos y acentos, nunca con texto normal encima. Los botones con texto van siempre en `primario`, aunque la skill admite `#009929`. Las etiquetas de las pestañas inactivas van en `tintaSuave`; solo el ícono es celeste.
- **Píldoras:** el texto usa una versión oscurecida del color del estado, para que se lea sobre su fondo suave.
- **Texto grande:** todas las pantallas se revisaron a 360 px y a 1280 px, con texto al 100 % y al 130 %, sin desbordes.
- **Animaciones:** respetan "reducir animaciones" del sistema (`Movimiento.de`). El check de éxito es decorativo: el mensaje ya dice lo que pasó.
- **Pendiente:** revisar los tamaños mínimos de toque con el equipo.

## Decisiones pendientes

- [x] **Paleta definitiva** y **color de marca**: verde y celeste (2026-11-12).
- [x] **Componentes compartidos**: ver el catálogo.
- [x] **Tipografía definitiva**: Plus Jakarta Sans (2026-11-12; antes Figtree). Antes de publicar, **incluir los archivos de la fuente en la app** (`assets/fonts/` y `pubspec.yaml`) y desactivar la descarga en tiempo de ejecución de `google_fonts`.
- [x] **Logo**: `LogoChaucha`. El ícono de la app (Android adaptativo y web), el splash nativo y el favicon se generan desde él: `flutter test tool/generar_marca.dart` exporta los PNG a `assets/marca/`, y luego `dart run flutter_launcher_icons` y `dart run flutter_native_splash:create` (configurados en `pubspec.yaml`). El nombre visible es "ChauchaApp" en `web/index.html`, `web/manifest.json` y el `AndroidManifest.xml`.
- [ ] **Funciones de la referencia que la app aún no tiene**: "¿Olvidaste tu contraseña?", "Continuar con Google" y los enlaces a Términos y Política de privacidad. No se pusieron botones que no hacen nada. Se agregan cuando exista la función o la página.
- [x] **Estilo Bento orgánico** con fondo oscuro (2026-11-12).

## Cómo cambiar el diseño

1. **Colores, radios, espacios o fuente:** cambiar el valor en `tokens.dart`. Toda la app se actualiza sola.
2. **Cómo se ve un tipo de componente de Material** (todos los botones, todos los campos…): cambiarlo en `app_theme.dart`.
3. **Un componente propio** (tarjeta, aviso, píldora…): cambiarlo en `core/widgets/`.
4. **Una pantalla en particular:** cambiar su archivo en `presentation/`.

**Regla:** no escribir colores sueltos (`Colors.green`, `Colors.white`, `Color(0xFF...)`) en las pantallas. Usar siempre `Colores.*` o `Theme.of(context).colorScheme` (por ejemplo `onPrimary` para el texto blanco sobre verde).
