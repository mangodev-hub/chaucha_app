---
name: diseno-chauchaapp
description: Diseña, implementa y mejora las interfaces UI/UX de ChauchaApp en Flutter, siguiendo las referencias visuales y las convenciones del proyecto.
---

# Skill de diseño UI/UX de ChauchaApp

## 1. Identidad visual

La aplicación debe transmitir:
- Confianza y seguridad.
- Profesionalismo.
- Cercanía y accesibilidad.
- Modernidad y simplicidad.

La interfaz debe ser limpia, intuitiva y fácil de utilizar.

## 2. Referencia de diseño

La referencia es el lienzo "Rediseño ChauchaApp" (2026-11-12) y lo que
documenta `tecnicos_app/docs/DISENO.md`. La paleta es verde y celeste:

- Verde bosque `#006414`: botones, enlaces, pestaña activa, portada.
- Verde marca `#009929`: logo, íconos activos, progreso, foco.
- Verde brote `#5ccb5f`: puntos del calendario, éxito, acentos.
- Celeste `#27a3df` y celeste claro `#41b6ef`: lo del cliente,
  información, la tuerca del logo, el sol de la portada.

Mantener las siguientes características:
- Predominio de blanco y verde, con el celeste como acento.
- Fondos verde muy suave; el chat sobre celeste casi blanco.
- Tarjetas blancas con esquinas redondeadas y sombra sutil.
- Botón principal verde bosque, alto y destacado. Nunca texto normal
  blanco sobre `#009929` ni sobre `#27a3df` (no llegan a AA).
- Campos de entrada con fondo verdoso y borde verde marca al enfocar.
- Logo: la C que es una llave, con la tuerca celeste (`LogoChaucha`).
- Navegación inferior fija de cinco destinos (Facebook) y chats como
  pestaña con lista (WhatsApp): mis burbujas en verde claro, ajenas
  en blanco.
- Una sola familia tipográfica: Figtree.
- Sin degradados ni emojis; iconografía sencilla y consistente.

El login y el registro conservan su distribución actual (con las
animaciones Lottie); solo toman los colores de los tokens.

## 3. Componentes reutilizables

Mantener consistencia en:
- Botones principales y secundarios.
- Campos de texto.
- Tarjetas informativas.
- Encabezados.
- Indicadores de progreso.
- Estados de carga, error y éxito.
- Diálogos y mensajes de confirmación.

Evitar crear diferentes versiones de un mismo componente
sin una justificación visual o funcional.

## 4. Experiencia de usuario

- Priorizar la facilidad de navegación.
- Evitar interfaces sobrecargadas.
- Mostrar claramente las acciones principales.
- Utilizar textos cortos y comprensibles.
- Proporcionar retroalimentación visual.
- Diseñar pensando en clientes y técnicos.
- Adaptar las interfaces a móvil y web.

## 5. Convenciones técnicas

- Utilizar Flutter y Dart.
- Respetar Clean Architecture por features.
- Utilizar Riverpod 3.
- Reutilizar los componentes existentes.
- Consultar core/theme/tokens.dart para los estilos.
- No escribir colores directamente en las pantallas.
- No modificar la arquitectura existente para resolver
  problemas exclusivamente visuales.

## 6. Forma de trabajo

Antes de implementar cambios:
1. Analizar la pantalla y sus componentes actuales.
2. Revisar las referencias visuales.
3. Identificar inconsistencias de diseño.
4. Presentar una propuesta de cambios.
5. Esperar aprobación.

Después de implementar:
1. Comprobar la adaptación a móvil y web.
2. Ejecutar flutter analyze.
3. Ejecutar flutter test.
4. Corregir los problemas encontrados.