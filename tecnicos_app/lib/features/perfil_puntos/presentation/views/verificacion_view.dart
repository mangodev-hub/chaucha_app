// "Verifica tu identidad": el técnico sube su cédula (anverso y reverso) y una
// selfie. Se abre como hoja inferior en móvil y como diálogo en escritorio.
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/media/selector_fotos.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/indicador_pasos.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/documento_tecnico.dart';
import '../../domain/entities/verificacion.dart';
import '../providers/verificacion_provider.dart';

extension TipoDocumentoVista on TipoDocumento {
  String get titulo => switch (this) {
    TipoDocumento.cedulaFrontal => 'Foto frente de la cédula',
    TipoDocumento.cedulaPosterior => 'Foto atrás de la cédula',
    TipoDocumento.selfie => 'Selfie sosteniendo tu cédula',
  };

  String get ayuda => switch (this) {
    TipoDocumento.cedulaFrontal => 'Anverso del documento',
    TipoDocumento.cedulaPosterior => 'Reverso con código de barras',
    TipoDocumento.selfie => 'Rostro visible junto al documento',
  };

  IconData get icono => switch (this) {
    TipoDocumento.cedulaFrontal => Icons.badge_outlined,
    TipoDocumento.cedulaPosterior => Icons.flip_outlined,
    TipoDocumento.selfie => Icons.face_outlined,
  };
}

/// Abre la verificación. Al confirmar, avisa con un mensaje de éxito.
Future<void> mostrarVerificacion(BuildContext context) async {
  final Future<bool?> resultado;
  if (ResponsiveLayout.isDesktop(context)) {
    resultado = showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: const VerificacionPanel(enDialogo: true),
        ),
      ),
    );
  } else {
    resultado = showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const VerificacionPanel(),
    );
  }
  final confirmado = await resultado;
  if (confirmado == true && context.mounted) {
    context.mostrarMensaje(
      'Documentos enviados. Te avisaremos cuando tu cuenta quede verificada.',
      tipo: TipoMensaje.exito,
    );
  }
}

class VerificacionPanel extends ConsumerStatefulWidget {
  const VerificacionPanel({super.key, this.enDialogo = false});

  /// En el diálogo no hay asa de arrastre: se deja margen arriba.
  final bool enDialogo;

  @override
  ConsumerState<VerificacionPanel> createState() => _VerificacionPanelState();
}

class _VerificacionPanelState extends ConsumerState<VerificacionPanel> {
  /// Documento que se está subiendo (para mostrar la carga en su fila).
  TipoDocumento? _subiendo;

  Future<void> _subir(TipoDocumento tipo) async {
    final camara = kIsWeb ? false : await _elegirOrigen();
    if (camara == null) return;
    final Uint8List? bytes = await SelectorFotos.una(camara: camara);
    if (bytes == null || !mounted) return;
    setState(() => _subiendo = tipo);
    await ref.read(subirDocumentoProvider.notifier).subir(tipo, bytes);
    if (mounted) setState(() => _subiendo = null);
    // El resultado se ve en la fila (estado nuevo) o en el aviso de error:
    // dentro de la hoja, un snackbar quedaría tapado.
  }

  Future<bool?> _elegirOrigen() {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(context, true),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de la galería'),
              onTap: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final subida = ref.watch(subirDocumentoProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        Espacios.xl,
        widget.enDialogo ? Espacios.xl : 0,
        Espacios.xl,
        Espacios.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.shield, color: Colores.primario, size: 28),
              const SizedBox(width: Espacios.s),
              Expanded(
                child: Text(
                  'Verifica tu identidad',
                  style: textos.headlineSmall,
                ),
              ),
              IconButton(
                tooltip: 'Cerrar',
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: Espacios.xs),
          Text(
            'Ayúdanos a conocerte mejor para garantizar la seguridad de toda '
            'la comunidad de ChauchaApp en Quito.',
            style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
          ),
          const SizedBox(height: Espacios.l),
          const AvisoBanner(
            compacto: true,
            icono: Icons.badge_outlined,
            mensaje: 'Documento oficial de Ecuador (cédula de ciudadanía)',
          ),
          const SizedBox(height: Espacios.l + 4),
          AsyncValueView<Verificacion>(
            value: ref.watch(verificacionProvider),
            onRetry: () => ref.invalidate(verificacionProvider),
            onData: (context, verificacion) => _contenido(
              verificacion,
              errorDeSubida: subida.hasError && _subiendo == null
                  ? AsyncValueView.mensajeDe(subida.error!)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido(Verificacion v, {String? errorDeSubida}) {
    final textos = Theme.of(context).textTheme;
    const tipos = TipoDocumento.values;
    final enviados = tipos.where((t) => !v.puedeSubir(t)).length;
    final docs = v.documentos.values;
    final verificado =
        docs.length == tipos.length &&
        docs.every((d) => d.estado == EstadoDocumento.aprobada);
    final hayRechazo = docs.any((d) => d.estado == EstadoDocumento.rechazada);
    // La primera fila por subir se resalta: es el siguiente paso.
    final activa = tipos.where(v.puedeSubir).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IndicadorPasos(
          total: tipos.length,
          completados: enviados,
          titulo:
              'Paso ${math.min(enviados + 1, tipos.length)} de ${tipos.length}',
          detalle: 'Verificación de identidad',
        ),
        const SizedBox(height: Espacios.l),
        if (verificado)
          const _Aviso(
            tipo: TipoAviso.exito,
            mensaje:
                'Tu identidad está verificada. Los clientes verán tu '
                'insignia de técnico verificado.',
          )
        else if (hayRechazo)
          const _Aviso(
            tipo: TipoAviso.error,
            mensaje: 'Uno de tus documentos fue rechazado. Vuelve a enviarlo.',
          )
        else if (v.todoEnviado)
          const _Aviso(
            tipo: TipoAviso.info,
            mensaje:
                'Tus documentos están en revisión. Te avisaremos cuando '
                'tu cuenta quede verificada.',
          ),
        if (errorDeSubida != null)
          _Aviso(tipo: TipoAviso.error, mensaje: errorDeSubida),
        for (final tipo in tipos)
          _FilaDocumento(
            tipo: tipo,
            documento: v.documentos[tipo],
            activa: tipo == activa,
            subiendo: _subiendo == tipo,
            onSubir: v.puedeSubir(tipo) && _subiendo == null
                ? () => _subir(tipo)
                : null,
          ),
        const SizedBox(height: Espacios.s),
        Row(
          children: [
            const CircleAvatar(
              radius: 14,
              backgroundColor: Colores.primarioSuave,
              child: Icon(
                Icons.lock_outline,
                size: 15,
                color: Colores.primario,
              ),
            ),
            const SizedBox(width: Espacios.s),
            Expanded(
              child: Text(
                'Solo tú y el equipo de verificación pueden ver estos '
                'documentos.',
                style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
              ),
            ),
          ],
        ),
        const SizedBox(height: Espacios.xl),
        FilledButton.icon(
          onPressed: v.todoEnviado ? () => Navigator.pop(context, true) : null,
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Confirmar verificación'),
        ),
        if (!v.todoEnviado) ...[
          const SizedBox(height: Espacios.s),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hacerlo más tarde'),
          ),
        ],
      ],
    );
  }
}

class _Aviso extends StatelessWidget {
  const _Aviso({required this.tipo, required this.mensaje});

  final TipoAviso tipo;
  final String mensaje;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Espacios.m),
    child: AvisoBanner(tipo: tipo, mensaje: mensaje),
  );
}

/// Fila de un documento: ícono o miniatura, título y ayuda, y a la derecha
/// su estado o el botón para subirlo.
class _FilaDocumento extends StatelessWidget {
  const _FilaDocumento({
    required this.tipo,
    required this.documento,
    required this.activa,
    required this.subiendo,
    required this.onSubir,
  });

  final TipoDocumento tipo;
  final DocumentoTecnico? documento;
  final bool activa;
  final bool subiendo;
  final VoidCallback? onSubir;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final doc = documento;
    final url = doc?.url;
    final rechazado = doc?.estado == EstadoDocumento.rechazada;

    return TarjetaApp(
      margin: const EdgeInsets.only(bottom: Espacios.m),
      padding: const EdgeInsets.all(Espacios.m),
      radio: Radios.medio,
      conSombra: false,
      color: activa ? Colores.primarioSuave : Colores.tarjeta,
      colorBorde: activa ? Colores.primarioClaro : Colores.linea,
      // Con poco espacio (pantalla angosta o texto grande), la acción baja
      // debajo del texto en lugar de apretarlo.
      child: LayoutBuilder(
        builder: (context, restricciones) {
          final escala = MediaQuery.textScalerOf(context).scale(1);
          final abajo = restricciones.maxWidth < 280 * escala;
          final fila = Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Radios.medio),
                child: url == null
                    ? IconoRecuadro(
                        icono: tipo.icono,
                        lado: 44,
                        fondo: activa ? Colores.tarjeta : Colores.primarioSuave,
                      )
                    : Image.network(
                        url,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, pila) =>
                            IconoRecuadro(icono: tipo.icono, lado: 44),
                      ),
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tipo.titulo,
                      maxLines: abajo ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.titleSmall,
                    ),
                    Text(
                      rechazado ? 'Rechazado: vuelve a enviarlo' : tipo.ayuda,
                      maxLines: abajo ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        color: rechazado ? Colores.error : Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
              if (!abajo) ...[const SizedBox(width: Espacios.s), _accion(doc)],
            ],
          );
          if (!abajo) return fila;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              fila,
              const SizedBox(height: Espacios.s),
              Align(alignment: Alignment.centerRight, child: _accion(doc)),
            ],
          );
        },
      ),
    );
  }

  Widget _accion(DocumentoTecnico? doc) {
    if (subiendo) {
      return const SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    }
    if (doc != null && doc.estado != EstadoDocumento.rechazada) {
      return doc.estado == EstadoDocumento.aprobada
          ? const Pildora(
              texto: 'Aprobado',
              icono: Icons.verified,
              color: Colores.acento,
            )
          : const Pildora(
              texto: 'En revisión',
              icono: Icons.check_circle_outline,
              color: Colores.acento,
            );
    }
    final esSelfie = tipo == TipoDocumento.selfie;
    final texto = doc == null
        ? (esSelfie ? 'Tomar selfie' : 'Subir')
        : 'Reenviar';
    final icono = esSelfie
        ? Icons.photo_camera_outlined
        : Icons.upload_outlined;
    const compacto = Size(0, 38);
    const relleno = EdgeInsets.symmetric(horizontal: Espacios.m);
    // El siguiente paso va como botón principal; los demás, como secundarios.
    return activa
        ? FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: compacto,
              padding: relleno,
            ),
            onPressed: onSubir,
            icon: Icon(icono, size: 18),
            label: Text(texto),
          )
        : OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: compacto,
              padding: relleno,
            ),
            onPressed: onSubir,
            icon: Icon(icono, size: 18),
            label: Text(texto),
          );
  }
}
