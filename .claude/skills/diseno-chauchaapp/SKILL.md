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

Tomar como referencia las pantallas de inicio de sesión,
registro y verificación de identidad.

Mantener las siguientes características:
- Predominio de blanco y azul.
- Fondos celestes suaves.
- Tarjetas con esquinas redondeadas.
- Sombras sutiles.
- Botones principales azules y destacados.
- Campos de entrada con fondos ligeramente azulados.
- Iconografía sencilla y consistente.
- Jerarquía visual clara.

No copiar las pantallas literalmente.
Adaptar su lenguaje visual a cada funcionalidad.

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