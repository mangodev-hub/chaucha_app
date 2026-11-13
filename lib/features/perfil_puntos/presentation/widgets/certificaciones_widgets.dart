// Certificados del técnico: sección opcional del perfil propio, insignia
// "Técnico certificado" y lista pública de los aprobados.
import 'dart:async';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/certificacion.dart';
import '../providers/certificaciones_provider.dart';

/// Insignia que se muestra junto al nombre con al menos un certificado aprobado.
class InsigniaCertificado extends StatelessWidget {
  const InsigniaCertificado({super.key});

  @override
  Widget build(BuildContext context) => const Pildora(
    texto: 'Técnico certificado',
    icono: Icons.school_outlined,
    color: Colores.info,
  );
}

/// La insignia solo si el técnico tiene un certificado aprobado.
class InsigniaSiCertificado extends ConsumerWidget {
  const InsigniaSiCertificado({super.key, required this.tecnicoId});

  final String tecnicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista =
        ref.watch(certificacionesAprobadasProvider(tecnicoId)).value ??
        const <Certificacion>[];
    return lista.isEmpty
        ? const SizedBox.shrink()
        : const InsigniaCertificado();
  }
}

/// Sección "Certificaciones (opcional)" del perfil del técnico.
class SeccionCertificaciones extends ConsumerWidget {
  const SeccionCertificaciones({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final cargando = ref.watch(accionesCertificacionProvider).isLoading;
    return Seccion(
      titulo: 'Certificaciones (opcional)',
      child: TarjetaApp(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Si tienes certificados de cursos o capacitaciones, súbelos. '
              'Cuando el equipo los apruebe, tu perfil mostrará la insignia '
              '«Técnico certificado».',
              style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
            ),
            const SizedBox(height: Espacios.m),
            AsyncValueView<List<Certificacion>>(
              value: ref.watch(misCertificacionesProvider),
              onRetry: () => ref.invalidate(misCertificacionesProvider),
              onData: (context, lista) => Column(
                children: [
                  for (final c in lista)
                    _FilaCertificacion(certificacion: c, bloqueado: cargando),
                ],
              ),
            ),
            const SizedBox(height: Espacios.s),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: cargando
                    ? null
                    : () => unawaited(
                        showDialog<void>(
                          context: context,
                          builder: (_) => const _FormularioCertificacion(),
                        ),
                      ),
                icon: const Icon(Icons.add),
                label: const Text('Agregar certificado'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilaCertificacion extends ConsumerWidget {
  const _FilaCertificacion({
    required this.certificacion,
    required this.bloqueado,
  });

  final Certificacion certificacion;
  final bool bloqueado;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final c = certificacion;
    final (etiqueta, color) = switch (c.estado) {
      EstadoCertificacion.pendiente => ('En revisión', Colores.aviso),
      EstadoCertificacion.aprobada => ('Aprobado', Colores.acento),
      EstadoCertificacion.rechazada => ('Rechazado', Colores.error),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacios.s),
      child: Row(
        children: [
          const Icon(Icons.school_outlined, color: Colores.primario),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.nombre, style: textos.titleSmall),
                Text(
                  c.detalle,
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          ),
          Pildora(texto: etiqueta, color: color),
          IconButton(
            tooltip: 'Eliminar',
            onPressed: bloqueado
                ? null
                : () => unawaited(_eliminar(context, ref)),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminar(BuildContext context, WidgetRef ref) async {
    final seguir = await context.confirmar(
      'Eliminar certificado',
      certificacion.aprobada
          ? 'Si es tu único certificado aprobado, perderás la insignia '
                '«Técnico certificado».'
          : 'Se quitará «${certificacion.nombre}» de tu perfil.',
      textoConfirmar: 'Sí, eliminar',
      destructivo: true,
      icono: Icons.delete_outline,
    );
    if (!seguir) return;
    final ok = await ref
        .read(accionesCertificacionProvider.notifier)
        .eliminar(certificacion.id);
    if (!context.mounted || ok) return;
    if (ref.read(accionesCertificacionProvider) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }
}

class _FormularioCertificacion extends ConsumerStatefulWidget {
  const _FormularioCertificacion();

  @override
  ConsumerState<_FormularioCertificacion> createState() =>
      _FormularioCertificacionState();
}

class _FormularioCertificacionState
    extends ConsumerState<_FormularioCertificacion> {
  final _nombre = TextEditingController();
  final _entidad = TextEditingController();
  final _anio = TextEditingController();
  Uint8List? _archivo;
  String? _extension;
  String? _nombreArchivo;
  String? _error;

  @override
  void dispose() {
    _nombre.dispose();
    _entidad.dispose();
    _anio.dispose();
    super.dispose();
  }

  Future<void> _elegirArchivo() async {
    const tipos = XTypeGroup(
      label: 'Certificado',
      extensions: ['jpg', 'jpeg', 'png', 'pdf'],
      mimeTypes: ['image/jpeg', 'image/png', 'application/pdf'],
    );
    final f = await openFile(acceptedTypeGroups: const [tipos]);
    if (f == null || !mounted) return;
    if (await f.length() > 5 * 1024 * 1024) {
      if (mounted) setState(() => _error = 'El archivo pesa más de 5 MB.');
      return;
    }
    final bytes = await f.readAsBytes();
    if (!mounted) return;
    setState(() {
      _archivo = bytes;
      _extension = f.name.contains('.') ? f.name.split('.').last : '';
      _nombreArchivo = f.name;
      _error = null;
    });
  }

  String? _validar() {
    if (_nombre.text.trim().length < 3) {
      return 'Escribe el nombre del certificado.';
    }
    if (_entidad.text.trim().length < 2) return 'Escribe quién lo emitió.';
    final texto = _anio.text.trim();
    if (texto.isNotEmpty) {
      final anio = int.tryParse(texto);
      if (anio == null || anio < 1950 || anio > DateTime.now().year) {
        return 'El año no es válido.';
      }
    }
    if (_archivo == null) return 'Adjunta el certificado (JPG, PNG o PDF).';
    return null;
  }

  Future<void> _guardar() async {
    final error = _validar();
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    final ok = await ref
        .read(accionesCertificacionProvider.notifier)
        .agregar(
          nombre: _nombre.text,
          entidad: _entidad.text,
          anio: int.tryParse(_anio.text.trim()),
          bytes: _archivo!,
          extension: _extension ?? '',
        );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      context.mostrarMensaje(
        'Certificado enviado. Lo revisaremos pronto.',
        tipo: TipoMensaje.exito,
      );
    } else if (ref.read(accionesCertificacionProvider) case AsyncError(
      :final error,
    )) {
      setState(() => _error = AsyncValueView.mensajeDe(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final guardando = ref.watch(accionesCertificacionProvider).isLoading;
    return AlertDialog(
      title: const Text('Agregar certificado'),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nombre,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nombre del certificado',
                  hintText: 'Ej.: Instalaciones eléctricas residenciales',
                ),
              ),
              const SizedBox(height: Espacios.m),
              TextField(
                controller: _entidad,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Entidad que lo emitió',
                  hintText: 'Ej.: SECAP',
                ),
              ),
              const SizedBox(height: Espacios.m),
              TextField(
                controller: _anio,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Año (opcional)',
                  counterText: '',
                ),
              ),
              const SizedBox(height: Espacios.m),
              OutlinedButton.icon(
                onPressed: guardando ? null : _elegirArchivo,
                icon: Icon(
                  _archivo == null
                      ? Icons.upload_outlined
                      : Icons.check_circle_outline,
                ),
                label: Text(
                  _nombreArchivo ?? 'Adjuntar certificado (JPG, PNG o PDF)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: Espacios.m),
                Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Colores.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: guardando ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        SizedBox(
          width: 140,
          child: BotonCarga(
            texto: 'Enviar',
            cargando: guardando,
            onPressed: _guardar,
          ),
        ),
      ],
    );
  }
}

/// Certificados aprobados, como los ve cualquier usuario en un perfil.
class ListaCertificacionesPublica extends StatelessWidget {
  const ListaCertificacionesPublica({super.key, required this.certificaciones});

  final List<Certificacion> certificaciones;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Column(
      children: [
        for (final c in certificaciones)
          Padding(
            padding: const EdgeInsets.only(bottom: Espacios.s),
            child: TarjetaApp(
              child: Row(
                children: [
                  const Icon(Icons.school_outlined, color: Colores.info),
                  const SizedBox(width: Espacios.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
            ),
          ),
      ],
    );
  }
}
