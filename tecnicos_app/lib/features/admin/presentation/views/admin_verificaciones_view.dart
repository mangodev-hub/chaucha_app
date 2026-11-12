// Pestaña "Verificaciones" del panel: técnicos con cédula o selfie por
// revisar. Al aprobar sus 3 documentos, la base lo marca como verificado
// (trigger `fn_verificar_tecnico`) y empieza a recibir solicitudes.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../perfil_puntos/domain/entities/certificacion.dart';
import '../../../perfil_puntos/domain/entities/documento_tecnico.dart';
import '../../domain/entities/revision_tecnico.dart';
import '../providers/admin_providers.dart';
import '../providers/certificaciones_admin_provider.dart';
import '../widgets/admin_widgets.dart';

class AdminVerificacionesView extends ConsumerWidget {
  const AdminVerificacionesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PantallaAdmin(
      titulo: 'Verificaciones',
      subtitulo: 'Compara la cédula con la selfie antes de aprobar.',
      onRecargar: () async {
        ref.invalidate(certificacionesPendientesProvider);
        await esperarSinError(ref.refresh(revisionesProvider.future));
      },
      children: [
        AsyncValueView<List<RevisionTecnico>>(
          value: ref.watch(revisionesProvider),
          onRetry: () => ref.invalidate(revisionesProvider),
          onData: (context, revisiones) {
            if (revisiones.isEmpty) {
              return const EstadoMensaje(
                tipo: TipoEstado.exito,
                icono: Icons.verified_user_outlined,
                titulo: 'Todo al día',
                mensaje: 'No hay documentos por revisar.',
              );
            }
            return Column(
              children: [
                for (final r in revisiones)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Espacios.l),
                    child: TarjetaRevision(revision: r),
                  ),
              ],
            );
          },
        ),
        const _CertificadosPendientes(),
      ],
    );
  }
}

/// Certificados que los técnicos subieron y esperan aprobación.
class _CertificadosPendientes extends ConsumerWidget {
  const _CertificadosPendientes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista =
        ref.watch(certificacionesPendientesProvider).value ??
        const <Certificacion>[];
    if (lista.isEmpty) return const SizedBox.shrink();
    final procesando = ref.watch(revisarCertificacionProvider).isLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: Espacios.xl, bottom: Espacios.m),
          child: Text(
            'Certificados por revisar (${lista.length})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        for (final c in lista)
          Padding(
            padding: const EdgeInsets.only(bottom: Espacios.l),
            child: _TarjetaCertificado(certificacion: c, procesando: procesando),
          ),
      ],
    );
  }
}

class _TarjetaCertificado extends ConsumerWidget {
  const _TarjetaCertificado({
    required this.certificacion,
    required this.procesando,
  });

  final Certificacion certificacion;
  final bool procesando;

  Future<void> _revisar(
    BuildContext context,
    WidgetRef ref, {
    required bool aprobado,
  }) async {
    final ok = await ref
        .read(revisarCertificacionProvider.notifier)
        .revisar(certificacion.id, aprobado: aprobado);
    if (!context.mounted) return;
    if (ok) {
      context.mostrarMensaje(
        aprobado ? 'Certificado aprobado.' : 'Certificado rechazado.',
        tipo: TipoMensaje.exito,
      );
    } else if (ref.read(revisarCertificacionProvider)
        case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final c = certificacion;
    final url = c.url;
    return TarjetaApp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: Colores.superficie,
                borderRadius: BorderRadius.circular(Radios.medio),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: url == null
                      ? null
                      : () => unawaited(
                          c.esPdf
                              ? launchUrl(
                                  Uri.parse(url),
                                  mode: LaunchMode.externalApplication,
                                )
                              : _ampliarUrl(context, url, c.nombre),
                        ),
                  child: SizedBox(
                    width: 112,
                    height: 112,
                    child: url == null
                        ? const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colores.tintaSuave,
                          )
                        : c.esPdf
                        ? const Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 48,
                            color: Colores.primario,
                          )
                        : Image.network(
                            url,
                            fit: BoxFit.cover,
                            semanticLabel: c.nombre,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.broken_image_outlined,
                              color: Colores.tintaSuave,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.tecnicoNombre ?? 'Técnico', style: textos.titleMedium),
                    const SizedBox(height: Espacios.xs),
                    Text(c.nombre, style: textos.titleSmall),
                    Text(
                      c.detalle,
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Espacios.l),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: Espacios.m,
            runSpacing: Espacios.s,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colores.error,
                  side: const BorderSide(color: Colores.error),
                ),
                onPressed: procesando
                    ? null
                    : () => unawaited(_revisar(context, ref, aprobado: false)),
                icon: const Icon(Icons.close),
                label: const Text('Rechazar'),
              ),
              SizedBox(
                width: 220,
                child: BotonCarga(
                  texto: 'Aprobar',
                  icono: Icons.check,
                  cargando: procesando,
                  onPressed: () =>
                      unawaited(_revisar(context, ref, aprobado: true)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Muestra una imagen grande, con zoom.
Future<void> _ampliarUrl(BuildContext context, String url, String etiqueta) {
  return showDialog<void>(
    context: context,
    builder: (dialogo) => Dialog(
      backgroundColor: Colores.tinta,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          InteractiveViewer(
            maxScale: 5,
            child: Image.network(
              url,
              fit: BoxFit.contain,
              semanticLabel: etiqueta,
            ),
          ),
          Positioned(
            top: Espacios.s,
            right: Espacios.s,
            child: IconButton.filledTonal(
              tooltip: 'Cerrar',
              onPressed: () => Navigator.of(dialogo).pop(),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    ),
  );
}

extension on TipoDocumento {
  String get etiqueta => switch (this) {
    TipoDocumento.cedulaFrontal => 'Cédula (frente)',
    TipoDocumento.cedulaPosterior => 'Cédula (reverso)',
    TipoDocumento.selfie => 'Selfie',
  };
}

extension on EstadoDocumento {
  (String, Color) get pildora => switch (this) {
    EstadoDocumento.pendiente => ('Por revisar', Colores.aviso),
    EstadoDocumento.aprobada => ('Aprobado', Colores.acento),
    EstadoDocumento.rechazada => ('Rechazado', Colores.error),
  };
}

/// Un técnico: sus documentos y los botones para aprobar o rechazar los
/// pendientes.
class TarjetaRevision extends ConsumerWidget {
  const TarjetaRevision({super.key, required this.revision});

  final RevisionTecnico revision;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final procesando = ref
        .watch(revisionTecnicoProvider(revision.tecnicoId))
        .isLoading;
    final pendientes = revision.pendientes;

    return TarjetaApp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const IconoRecuadro(icono: Icons.engineering_outlined),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(revision.nombre, style: textos.titleMedium),
                    Text(
                      revision.cedula == null
                          ? 'Sin cédula registrada'
                          : 'C.I. registrada: ${revision.cedula}',
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
              Pildora(
                texto: '${pendientes.length} por revisar',
                color: Colores.aviso,
              ),
            ],
          ),
          const SizedBox(height: Espacios.l),
          Wrap(
            spacing: Espacios.m,
            runSpacing: Espacios.m,
            children: [
              for (final doc in revision.documentos)
                _Documento(
                  documento: doc,
                  onTap: () => unawaited(_ampliar(context, doc)),
                ),
            ],
          ),
          const SizedBox(height: Espacios.l),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: Espacios.m,
            runSpacing: Espacios.s,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colores.error,
                  side: const BorderSide(color: Colores.error),
                ),
                onPressed: procesando
                    ? null
                    : () => unawaited(
                        _revisar(context, ref, pendientes, aprobado: false),
                      ),
                icon: const Icon(Icons.close),
                label: const Text('Rechazar'),
              ),
              SizedBox(
                width: 220,
                child: BotonCarga(
                  texto: 'Aprobar',
                  icono: Icons.check,
                  cargando: procesando,
                  onPressed: () => unawaited(
                    _revisar(context, ref, pendientes, aprobado: true),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _revisar(
    BuildContext context,
    WidgetRef ref,
    List<DocumentoTecnico> documentos, {
    required bool aprobado,
  }) async {
    final notifier = ref.read(
      revisionTecnicoProvider(revision.tecnicoId).notifier,
    );
    if (!aprobado) {
      final seguir = await context.confirmar(
        'Rechazar documentos',
        '${revision.nombre} tendrá que volver a subir '
            '${documentos.length == 1 ? 'ese documento' : 'esos documentos'}.',
        textoConfirmar: 'Sí, rechazar',
        destructivo: true,
        icono: Icons.close,
      );
      if (!seguir) return;
    }
    final ok = await notifier.revisar([
      for (final d in documentos) d.id,
    ], aprobado: aprobado);
    if (!context.mounted) return;
    if (ok) {
      context.mostrarMensaje(
        aprobado
            ? 'Documentos aprobados. Si están los 3, ya está verificado.'
            : 'Documentos rechazados.',
        tipo: TipoMensaje.exito,
      );
    } else if (ref.read(revisionTecnicoProvider(revision.tecnicoId))
        case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }
}

/// Miniatura de un documento con su tipo y estado.
class _Documento extends StatelessWidget {
  const _Documento({required this.documento, required this.onTap});

  final DocumentoTecnico documento;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final (estado, color) = documento.estado.pildora;
    final url = documento.url;
    return SizedBox(
      width: 168,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colores.superficie,
            borderRadius: BorderRadius.circular(Radios.medio),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: url == null ? null : onTap,
              child: SizedBox(
                height: 112,
                width: double.infinity,
                child: url == null
                    ? const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colores.tintaSuave,
                      )
                    : Image.network(
                        url,
                        fit: BoxFit.cover,
                        semanticLabel: documento.tipo.etiqueta,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.broken_image_outlined,
                          color: Colores.tintaSuave,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: Espacios.xs),
          Text(documento.tipo.etiqueta, style: textos.labelLarge),
          const SizedBox(height: Espacios.xs),
          Pildora(texto: estado, color: color),
        ],
      ),
    );
  }
}

/// Muestra el documento grande, con zoom.
Future<void> _ampliar(BuildContext context, DocumentoTecnico documento) {
  final url = documento.url;
  if (url == null) return Future.value();
  return showDialog<void>(
    context: context,
    builder: (dialogo) => Dialog(
      backgroundColor: Colores.tinta,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          InteractiveViewer(
            maxScale: 5,
            child: Image.network(
              url,
              fit: BoxFit.contain,
              semanticLabel: documento.tipo.etiqueta,
            ),
          ),
          Positioned(
            top: Espacios.s,
            right: Espacios.s,
            child: IconButton.filledTonal(
              tooltip: 'Cerrar',
              onPressed: () => Navigator.of(dialogo).pop(),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    ),
  );
}
