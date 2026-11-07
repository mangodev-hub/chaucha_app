# Diseño visual de la app

> **⚠️ DISEÑO PROVISIONAL.** El estilo actual es una primera versión para que la app se sienta propia y no genérica. **Va a cambiar.** Todavía falta definir con el equipo la paleta de colores, la tipografía, la marca y varias correcciones del sistema. También se prevé agregar y quitar componentes. Nada de lo que está aquí es definitivo.

Última actualización: 2026-11-07.

## Estado

| Tema | Estado |
|---|---|
| Paleta de colores | Provisional |
| Color de acento (verde) | Provisional, a la espera de un color de marca |
| Tipografía (Plus Jakarta Sans) | Provisional |
| Marca / logo | Provisional: hoy es un ícono de Material con el nombre de la app |
| Radios, espaciados, tamaños | Provisional |
| Modo oscuro | No existe todavía |
| Revisión de contraste y accesibilidad | Pendiente |

## De dónde sale el estilo actual

Se tomó como referencia el estilo de apps de movilidad modernas: títulos grandes y en negrita, botones negros, tarjetas grises planas y un solo color de acento para los datos positivos. **Se tomaron los patrones, no la identidad**: no se usa el logo, la tipografía ni los colores de marca de ninguna otra app, y no se debe hacer.

Principios que se aplicaron:

1. **Jerarquía con tipografía**, no con colores: títulos grandes en negrita (`headlineLarge`, `headlineMedium`) y texto secundario en gris.
2. **Base en blanco y negro**: fondo blanco, texto y botones casi negros.
3. **Tarjetas planas en gris claro**: sin bordes ni sombras, con esquinas redondeadas.
4. **Un solo color de acento**, reservado para lo positivo: puntos, nivel, verificado, trabajo completado.
5. **Datos destacados en píldoras**: calificación, comisión y estado.

## Tokens actuales (todos provisionales)

Todo vive en [`lib/core/theme/tokens.dart`](../lib/core/theme/tokens.dart).

### Colores (`Colores`)

| Token | Valor | Uso |
|---|---|---|
| `tinta` | `#111111` | Texto principal, botones, barra de navegación activa |
| `tintaSuave` | `#5E5E5E` | Texto secundario, íconos inactivos |
| `fondo` | `#FFFFFF` | Fondo de las pantallas |
| `superficie` | `#F3F3F3` | Tarjetas, campos de texto, chips |
| `superficieFuerte` | `#E8E8E8` | Superficies más marcadas, pista del slider |
| `linea` | `#E2E2E2` | Divisores y bordes suaves |
| `acento` | `#2E9E5B` | Lo positivo: encabezado del perfil, completado |
| `acentoSuave` | `#E3F4EA` | Fondo de elementos positivos, mis mensajes en el chat |
| `acentoOscuro` | `#1B5E36` | Texto sobre `acentoSuave` |
| `info` | `#2563C9` | Estados "Abierta" y "Con cotizaciones" |
| `aviso` | `#D97706` | Estados "Por confirmar" y "En revisión" |
| `error` / `errorSuave` | `#C62828` / `#FDECEC` | Errores y avisos de sesión |
| `estrella` | `#F5A623` | Estrellas de calificación |

### Tipografía (`Tipografia`)

- Familia: **Plus Jakarta Sans**, cargada con el paquete `google_fonts`.
- Títulos (`display`, `headline`) en peso 800 con letras un poco más juntas; `title` en 700; botones en 600.

### Radios (`Radios`) y espacios (`Espacios`)

- Radios: `pequeno` 8 · `medio` 12 (botones, campos) · `grande` 16 (tarjetas, encabezados) · `pildora` 999.
- Espacios: `xs` 4 · `s` 8 · `m` 12 · `l` 16 · `xl` 24 · `xxl` 32.

## Dónde se aplica

| Qué | Archivo |
|---|---|
| Tokens | `lib/core/theme/tokens.dart` |
| Tema global (botones, campos, tarjetas, chips, navegación, diálogos…) | `lib/core/theme/app_theme.dart` |
| Marca provisional (ícono + nombre) | `lib/core/widgets/marca.dart` |
| Splash | `lib/core/widgets/splash_view.dart` |
| Títulos de sección | `lib/core/widgets/seccion.dart` |
| Listas vacías | `lib/core/widgets/estado_vacio.dart` |
| Login y registro (marca, título grande, panel oscuro en escritorio) | `lib/features/auth/presentation/widgets/auth_layout.dart` |
| Encabezado del perfil del técnico (puntos, nivel, píldoras) | `lib/features/perfil_puntos/presentation/views/perfil_tecnico_view.dart` |
| Saludo del inicio del cliente | `lib/features/solicitudes/presentation/views/mis_solicitudes_view.dart` |
| Colores de cada estado de solicitud | `lib/features/solicitudes/presentation/widgets/solicitud_widgets.dart` |

## Decisiones pendientes

- [ ] **Paleta definitiva** y **color de marca**. Decidir si el acento sigue siendo verde.
- [ ] **Tipografía definitiva**. Antes de publicar, **incluir los archivos de la fuente en la app** (`assets/fonts/` y `pubspec.yaml`) y desactivar la descarga en tiempo de ejecución de `google_fonts`. Hoy la fuente se descarga de internet la primera vez; sin conexión se usa la fuente del sistema.
- [ ] **Logo e identidad**: reemplazar el ícono provisional de `Marca` y definir el ícono de la app y el splash nativo (Android/web).
- [ ] **Iconografía**: hoy se usan los íconos de Material sin criterio unificado (algunos `outlined`, otros `rounded`).
- [ ] **Modo oscuro**: hoy solo existe el tema claro.
- [ ] **Contraste y accesibilidad**: revisar el texto blanco sobre el verde del encabezado del perfil, los colores de estado sobre fondo claro y los tamaños mínimos de toque.
- [ ] **Correcciones del sistema**: revisar con el equipo los componentes y pantallas que se agregan o se quitan, y ajustar este documento.
- [ ] **Escritorio y web**: revisar el diseño en pantallas anchas (panel de marca del login, `NavigationRail` del técnico).

## Cómo cambiar el diseño

1. **Colores, radios, espacios o fuente:** cambiar el valor en `tokens.dart`. Toda la app se actualiza sola.
2. **Cómo se ve un tipo de componente** (todos los botones, todos los campos…): cambiarlo en `app_theme.dart`.
3. **Una pantalla en particular:** cambiar su archivo en `presentation/`.

**Regla:** no escribir colores sueltos (`Colors.green`, `Color(0xFF...)`) en las pantallas. Usar siempre `Colores.*` o `Theme.of(context).colorScheme`, para que cambiar la paleta siga siendo cambiar un solo archivo.

Al tomar una decisión pendiente, actualiza la tabla de **Estado** y marca la casilla correspondiente.
