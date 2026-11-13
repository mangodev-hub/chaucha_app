// Diálogos cortos que explican la app: cómo funciona, la garantía, ayuda,
// reclamos, contacto y los resúmenes de Términos y Privacidad. Los abren el
// pie de página, el final de "Mi perfil" y el inicio.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/info_app.dart';
import '../theme/tokens.dart';

Future<void> _dialogo(
  BuildContext context, {
  required IconData icono,
  required String titulo,
  required List<String> puntos,
  List<Widget> extra = const [],
  String? nota,
  (String, VoidCallback)? accion,
}) {
  final textos = Theme.of(context).textTheme;
  return showDialog<void>(
    context: context,
    builder: (dialogo) => AlertDialog(
      icon: Icon(icono, color: Colores.cieloOscuro),
      title: Text(titulo),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final p in puntos)
              Padding(
                padding: const EdgeInsets.only(top: Espacios.s),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: Colores.primarioVivo,
                      ),
                    ),
                    const SizedBox(width: Espacios.s),
                    Expanded(child: Text(p, style: textos.bodyMedium)),
                  ],
                ),
              ),
            ...extra,
            if (nota != null) ...[
              const SizedBox(height: Espacios.m),
              Text(
                nota,
                style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (accion != null)
          TextButton(
            onPressed: () {
              Navigator.of(dialogo).pop();
              accion.$2();
            },
            child: Text(accion.$1),
          ),
        FilledButton(
          onPressed: () => Navigator.of(dialogo).pop(),
          child: const Text('Entendido'),
        ),
      ],
    ),
  );
}

/// Explica la garantía de 30 días.
Future<void> mostrarGarantia(BuildContext context) => _dialogo(
  context,
  icono: Icons.verified_user_outlined,
  titulo: 'Garantía de 30 días',
  puntos: const [
    'Cada servicio completado tiene 30 días de garantía desde que se cierra.',
    'Si algo falla, abre el detalle del servicio y toca "Reportar un '
        'problema".',
    'Un asesor de ChauchaApp revisa tu caso y te escribe por la app. La otra '
        'persona no ve tu reclamo.',
  ],
);

Future<void> mostrarComoFunciona(BuildContext context) => _dialogo(
  context,
  icono: Icons.lightbulb_outline_rounded,
  titulo: 'Cómo funciona',
  puntos: const [
    'Publicas lo que necesitas arreglar.',
    'Los técnicos verificados de tu zona te envían su precio por la visita y '
        'cómo lo resolverían.',
    'Conversas por el chat, eliges uno y agendan día y hora.',
    'Al terminar se califican mutuamente, y el servicio queda con 30 días de '
        'garantía.',
  ],
);

Future<void> mostrarUneteComoTecnico(BuildContext context) => _dialogo(
  context,
  icono: Icons.handyman_outlined,
  titulo: 'Únete como técnico',
  puntos: const [
    'Crea una cuenta y elige el rol "Técnico".',
    'Verifica tu identidad con tu cédula y una selfie.',
    'Elige tus oficios y tu zona: verás las solicitudes cercanas en tu mapa.',
  ],
);

Future<void> abrirCorreoSoporte() =>
    launchUrl(Uri(scheme: 'mailto', path: InfoApp.correoSoporte));

Future<void> mostrarAyuda(BuildContext context) => _dialogo(
  context,
  icono: Icons.help_outline_rounded,
  titulo: 'Centro de ayuda',
  puntos: const [
    'Si algo falló en un servicio, repórtalo desde su detalle dentro de los '
        '30 días de garantía.',
    'Para cambiar tus datos o tu foto, entra a Mi perfil.',
    'Para cualquier otra duda, escríbenos.',
  ],
  extra: [
    const SizedBox(height: Espacios.m),
    TextButton.icon(
      onPressed: abrirCorreoSoporte,
      icon: const Icon(Icons.mail_outline_rounded),
      label: const Text(InfoApp.correoSoporte),
    ),
  ],
);

/// Cómo reportar un problema; [onIrAReclamos] abre "Mis reclamos".
Future<void> mostrarReportarProblema(
  BuildContext context, {
  VoidCallback? onIrAReclamos,
}) => _dialogo(
  context,
  icono: Icons.report_gmailerrorred_outlined,
  titulo: 'Reportar un problema',
  puntos: const [
    'Abre el detalle del servicio completado y toca "Reportar un problema". '
        'Tienes 30 días desde que se cerró.',
    'Elige qué pasó, cuéntalo en al menos 20 caracteres y, si quieres, '
        'agrega hasta 3 fotos.',
    'Recibirás un código (por ejemplo, REC-0007). Un asesor te escribe por '
        'la app y te avisamos con una notificación cuando haya novedades.',
    'La otra persona no ve tu reclamo.',
  ],
  accion: onIrAReclamos == null ? null : ('Ver mis reclamos', onIrAReclamos),
);

Future<void> mostrarContacto(BuildContext context) => _dialogo(
  context,
  icono: Icons.mail_outline_rounded,
  titulo: 'Contacto',
  puntos: const [
    'Escríbenos a ${InfoApp.correoSoporte} con tu nombre y, si es sobre un '
        'servicio, el código del reclamo o la descripción de la solicitud.',
    'Si es un problema con un servicio, es más rápido reportarlo desde su '
        'detalle: queda registrado y un asesor lo sigue.',
  ],
  accion: ('Escribir un correo', () => abrirCorreoSoporte()),
);

const _notaLegal =
    'Resumen informativo. El texto legal completo está en revisión.';

/// Resumen de Términos; [onVerCompleto] abre la página.
Future<void> mostrarResumenTerminos(
  BuildContext context, {
  required VoidCallback onVerCompleto,
}) => _dialogo(
  context,
  icono: Icons.gavel_outlined,
  titulo: 'Términos y condiciones',
  puntos: const [
    'ChauchaApp conecta a clientes con técnicos verificados de su zona. No '
        'cobra comisión: se financia con publicidad de negocios externos.',
    'Para usarla necesitas una cuenta y verificar tu identidad con tu cédula '
        'y una selfie.',
    'El técnico envía su precio por la visita; el trabajo en sí se acuerda '
        'directamente entre ustedes.',
    'Cada servicio completado tiene 30 días de garantía para reportar '
        'problemas.',
    'Las calificaciones son mutuas. Tres reseñas negativas en 30 días '
        'suspenden la cuenta por 7 días.',
  ],
  nota: _notaLegal,
  accion: ('Ver página completa', onVerCompleto),
);

/// Resumen de Privacidad; [onVerCompleto] abre la página.
Future<void> mostrarResumenPrivacidad(
  BuildContext context, {
  required VoidCallback onVerCompleto,
}) => _dialogo(
  context,
  icono: Icons.privacy_tip_outlined,
  titulo: 'Política de privacidad',
  puntos: const [
    'Recogemos tus datos de cuenta, tu cédula y selfie para verificarte, la '
        'ubicación de tus solicitudes o de tu zona de trabajo, y tus chats.',
    'Los usamos para verificar identidades, mostrar técnicos o solicitudes '
        'cercanas y atender reclamos.',
    'Los clientes ven una ubicación aproximada del técnico; los chats solo '
        'los ven sus participantes, y los reclamos, quien los hace y el '
        'equipo de ChauchaApp.',
    'Puedes pedir acceso, corrección o eliminación de tus datos escribiendo '
        'a ${InfoApp.correoSoporte}.',
  ],
  nota: _notaLegal,
  accion: ('Ver página completa', onVerCompleto),
);

/// Uso de los datos de verificación; [onVerCompleto] abre esa sección.
Future<void> mostrarUsoDatosVerificacion(
  BuildContext context, {
  required VoidCallback onVerCompleto,
}) => _dialogo(
  context,
  icono: Icons.lock_outline_rounded,
  titulo: 'Uso de datos de verificación',
  puntos: const [
    'Pedimos el frente y el reverso de tu cédula y una selfie tomada en el '
        'momento.',
    'La selfie se compara con la foto de la cédula y una persona del equipo '
        'revisa los documentos antes de aprobarte.',
    'Las fotos se guardan en un almacenamiento privado: solo tú y el equipo '
        'de revisión pueden verlas. Nunca se muestran a otros usuarios.',
    'Solo se usan para verificar tu identidad y atender reclamos o '
        'denuncias.',
  ],
  nota: _notaLegal,
  accion: ('Ver página completa', onVerCompleto),
);
