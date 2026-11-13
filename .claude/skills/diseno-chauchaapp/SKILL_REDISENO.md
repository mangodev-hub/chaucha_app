---
name: flutter-organic-bento-ui
description: Sistema de diseño UI/UX para aplicaciones Flutter basado en tarjetas Bento ultra-redondeadas, fondos con ondas orgánicas (CustomPainter) y paleta estricta Eco-Sky (verdes y azules).
---

# Skill: Flutter Organic Bento & Blob UI System

## 1. Rol y Directriz Principal
Actúa como un Senior Flutter UI/UX Engineer. Cada pantalla, widget, diálogo, bottom sheet y componente que generes en Dart/Flutter debe replicar la estética orgánica, curva y en bloques (Bento) de la interfaz de referencia, aplicando estrictamente la paleta de colores verde y azul definida.

## 2. Tokens de Color (`AppColors`)
Usa exclusivamente estos colores en `ThemeData`, `BoxDecoration`, `TextStyle` y `CustomPainter`. No inventes colores fuera de esta escala:

* **Paleta Principal:**
  * `darkGreen`: `Color(0xFF006414)` — Verde oscuro (pills activos, bloques de fecha/hora, iconos seleccionados, alto contraste).
  * `midGreen`: `Color(0xFF009929)` — Verde medio (botones primarios, acentos principales, estados confirmados).
  * `lightGreen`: `Color(0xFF5CCB5F)` — Verde claro (fondo de tarjetas Hero, badges circulares, ondas orgánicas).
  * `midBlue`: `Color(0xFF27A3DF)` — Azul medio (fondo de contenedores de selección/categorías, bordes destacados).
  * `lightBlue`: `Color(0xFF41B6EF)` — Azul claro (fondo de tarjetas inferiores, ondas decorativas, acentos secundarios).

* **Superficies y Tipografía:**
  * `appBackground`: `Color(0xFF0B2518)` — Fondo base del `Scaffold` (verde bosque muy profundo para contrastar las tarjetas).
  * `surfaceLight`: `Color(0xFFF4F9F6)` — Superficie clara para sub-tarjetas, campos de texto (`TextField`) y barra inferior.
  * `textOnDark`: `Color(0xFFFFFFFF)` — Texto sobre `appBackground`, `darkGreen` o `midBlue`.
  * `textOnLight`: `Color(0xFF062B14)` — Texto principal sobre `lightGreen`, `lightBlue` o `surfaceLight`.
  * `textMuted`: `Color(0xFF2D523B)` — Placeholders y textos secundarios.

## 3. Reglas de Geometría y Layout en Flutter
1. **Encapsulamiento Bento:**
   * Nunca dejes elementos sueltos directamente sobre el `Scaffold`. Agrupa cada sección lógica dentro de un contenedor curvo (`BorderRadius.circular(30)`) con separación vertical de `16.0` a `20.0` (`SizedBox(height: 18)`).
2. **Fondos Orgánicos Obligatorios (`CustomPainter`):**
   * Las tarjetas principales no deben ser de un solo color plano. Deben usar `ClipRRect(borderRadius: BorderRadius.circular(30))` combinado con un `CustomPaint` que dibuje una curva orgánica (*blob* superior derecho o *ola* inferior) superponiendo dos tonos de la paleta (ejemplo: base `lightGreen` con onda `lightBlue.withValues(alpha: 0.55)`, o base `midBlue` con ola `lightGreen.withValues(alpha: 0.45)`).
3. **Sin Sombras Pesadas:**
   * Usa `elevation: 0` en todos los componentes Material (`Card`, `AppBar`, `ElevatedButton`, `BottomNavigationBar`). La jerarquía visual se logra únicamente por contraste cromático y radios de borde.
4. **Tipografía:**
   * Usa tipografía geométrica redondeada (`PlusJakartaSans`, `Nunito` o `Poppins`).
   * Títulos de tarjeta: `fontSize: 20-22`, `fontWeight: FontWeight.w700`.
   * Cuerpo / descripciones: `fontSize: 13`, `fontWeight: FontWeight.w500`.

## 4. Especificaciones de Widgets Flutter
* **Header (`Row` en `SafeArea`):**
  * `CircleAvatar` (`radius: 22`) envuelto en un `Container` con borde de `2.5px` en `lightGreen` o `lightBlue`.
  * Columna con saludo en `textOnDark` (`w700`) y subtítulo con `withValues(alpha: 0.75)`.
  * `IconButton` a la derecha con iconos redondeados (`Icons.*_rounded`) en `textOnDark`.
* **Buscadores e Inputs (`TextField`):**
  * Siempre dentro de un `Container` tipo píldora (`BorderRadius.circular(999)`), fondo `surfaceLight`, `InputBorder.none`, y un icono de acción a la derecha en `darkGreen`.
* **Tarjetas de Opción / Grid (`Row` o `GridView`):**
  * Sub-tarjetas internas con fondo `surfaceLight` y `BorderRadius.circular(22)`.
  * Parte superior con ilustración limpia, vector SVG o animación Lottie.
  * Fila inferior con etiqueta en `textOnLight` (`w700`) a la izquierda y un botón circular (`width: 28, height: 28`, `BoxShape.circle`) con `Icons.arrow_forward_rounded` a la derecha.
* **Selectores de Fecha, Hora o Filtros (Pills):**
  * Bloques individuales con `BorderRadius.circular(16)`, fondo `darkGreen` (`#006414`), padding horizontal `12` y vertical `14`, con texto centrado en `textOnDark` (`w700`).
* **Botones Primarios:**
  * `FilledButton` o `GestureDetector` con forma de píldora (`BorderRadius.circular(999)`), fondo `midGreen` (`#009929`) o `darkGreen` (`#006414`) y texto blanco en negrita.
* **Navegación Inferior (`bottomNavigationBar`):**
  * `ClipRRect` con `BorderRadius.vertical(top: Radius.circular(32))`, fondo `surfaceLight` y onda sutil en `lightBlue`.
  * Ítem seleccionado en `darkGreen`; ítems inactivos en `midBlue.withValues(alpha: 0.7)`.
* **Modales y Bottom Sheets (`showModalBottomSheet`):**
  * Usa `shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32)))`, fondo `surfaceLight`, e incluye un indicador superior tipo píldora (`width: 40, height: 4`) en `midBlue`.

## 5. Reglas de Código Dart
* Crea widgets pequeños, privados o modulares (`StatelessWidget`) por cada bloque visual.
* Usa `const` en constructores, paddings y bordes siempre que sea posible.
* Utiliza `.withValues(alpha: ...)` en lugar de `.withOpacity(...)` para compatibilidad moderna con Flutter.
* Si se solicita una pantalla nueva (Login, Perfil, Detalle, Historial, Ajustes), constrúyela automáticamente respetando esta misma estructura de tarjetas Bento curvas, ondas orgánicas y exclusivamente los 5 colores hexadecimales definidos.