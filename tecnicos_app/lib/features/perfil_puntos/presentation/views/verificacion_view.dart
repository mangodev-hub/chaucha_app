// "Verifica tu identidad" en dos pasos: 1) sube tu cédula (frente y reverso)
// y 2) tómate una selfie. Se abre como hoja inferior en móvil y como diálogo
// en escritorio.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/media/selector_fotos.dart';
import '../../../../core/media/selfie_camara.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../auth/presentation/providers/selfie_provider.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../domain/entities/documento_tecnico.dart';
import '../../domain/entities/verificacion.dart';
import '../providers/verificacion_provider.dart';

/// Paso con el que se abre la verificación (arranca solo al abrir).
enum PasoVerificacion { cedula, selfie }

/// Abre la verificación. Con [paso], arranca directo ese paso.
Future<void> mostrarVerificacion(
  BuildContext context, {
  PasoVerificacion? paso,
}) async {
  final Future<bool?> resultado;
  if (ResponsiveLayout.isDesktop(context)) {
    resultado = showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: VerificacionPanel(enDialogo: true, paso: paso),
        ),
      ),
    );
  } else {
    resultado = showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => VerificacionPanel(paso: paso),
    );
  }
  final confirmado = await resultado;
  if (confirmado == true && context.mounted) {
    context.mostrarMensaje(
      'Perfil en revisión. Tu verificación se realizará pronto.',
      tipo: TipoMensaje.exito,
    );
  }
}

class VerificacionPanel extends ConsumerStatefulWidget {
  const VerificacionPanel({super.key, this.enDialogo = false, this.paso});

  /// En el diálogo no hay asa de arrastre: se deja margen arriba.
  final bool enDialogo;

  /// Si viene, ese paso arranca solo al abrir el panel.
  final PasoVerificacion? paso;

  @override
  ConsumerState<VerificacionPanel> createState() => _VerificacionPanelState();
}

class _VerificacionPanelState extends ConsumerState<VerificacionPanel> {
  bool _subiendoCedula = false;
  bool _enviandoSelfie = false;

  @override
  void initState() {
    super.initState();
    final paso = widget.paso;
    if (paso != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _iniciar(paso);
      });
    }
  }

  Future<void> _iniciar(PasoVerificacion paso) async {
    if (!mounted) return;
    if (paso == PasoVerificacion.selfie) {
      await _tomarSelfie();
      return;
    }
    final v = await ref.read(verificacionProvider.future);
    if (!mounted) return;
    final faltantes = [
      TipoDocumento.cedulaFrontal,
      TipoDocumento.cedulaPosterior,
    ].where(v.puedeSubir).toList();
    if (faltantes.isNotEmpty) await _subirCedula(faltantes);
  }

  Future<void> _subirCedula(List<TipoDocumento> faltantes) async {
    final camara = kIsWeb ? false : await _elegirOrigen();
    if (camara == null) return;
    for (final tipo in faltantes) {
      if (!mounted) return;
      final seguir = await _pedirLado(tipo, camara);
      if (seguir != true || !mounted) return;
      final Uint8List? bytes = await SelectorFotos.una(camara: camara);
      if (bytes == null || !mounted) return;
      setState(() => _subiendoCedula = true);
      final ok = await ref
          .read(subirDocumentoProvider.notifier)
          .subir(tipo, bytes);
      if (mounted) setState(() => _subiendoCedula = false);
      if (!ok) return;
    }
  }

  Future<void> _tomarSelfie() async {
    final Uint8List? bytes = kIsWeb
        ? await Navigator.of(context).push<Uint8List>(
            MaterialPageRoute(builder: (_) => const SelfieCamara()),
          )
        : await SelectorFotos.una(camara: true);
    if (bytes == null || !mounted) return;
    setState(() => _enviandoSelfie = true);
    await ref.read(selfieProvider.notifier).enviar(bytes);
    if (!mounted) return;
    // La misma selfie queda como documento para que el admin la compare.
    final valida = ref.read(usuarioActualProvider)?.fotoVerificada ?? false;
    if (valida) {
      await ref
          .read(subirDocumentoProvider.notifier)
          .subir(TipoDocumento.selfie, bytes);
    }
    if (mounted) setState(() => _enviandoSelfie = false);
  }

  Future<bool?> _pedirLado(TipoDocumento tipo, bool camara) {
    final frente = tipo == TipoDocumento.cedulaFrontal;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(frente ? 'Frente de la cédula' : 'Reverso de la cédula'),
        content: Text(
          frente
              ? 'Pon la cédula sobre una superficie plana, con buena luz, '
                    'y que se lea todo.'
              : 'Ahora el reverso, donde está el código de barras.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(camara ? 'Tomar foto' : 'Elegir foto'),
          ),
        ],
      ),
    );
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
    final fotoOk = ref.watch(
      usuarioActualProvider.select((u) => u?.fotoVerificada ?? false),
    );
    final foto = ref.watch(selfieProvider);
    final errorFoto = foto.isLoading || fotoOk
        ? null
        : foto.hasError
        ? AsyncValueView.mensajeDe(foto.error!)
        : foto.value;
    final errorSubida =
        subida.hasError && !_subiendoCedula && !_enviandoSelfie
        ? AsyncValueView.mensajeDe(subida.error!)
        : null;

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
              fotoOk: fotoOk,
              errorFoto: errorFoto,
              errorSubida: errorSubida,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido(
    Verificacion v, {
    required bool fotoOk,
    String? errorFoto,
    String? errorSubida,
  }) {
    final textos = Theme.of(context).textTheme;
    final cedula = [TipoDocumento.cedulaFrontal, TipoDocumento.cedulaPosterior];
    final faltantes = cedula.where(v.puedeSubir).toList();
    final cedulaLista = faltantes.isEmpty;
    final cedulaIniciada = faltantes.length < cedula.length;
    final cedulaRechazada = cedula.any(
      (t) => v.documentos[t]?.estado == EstadoDocumento.rechazada,
    );
    final cedulaAprobada = cedula.every(
      (t) => v.documentos[t]?.estado == EstadoDocumento.aprobada,
    );
    final docSelfie = v.documentos[TipoDocumento.selfie];
    final selfieRechazada = docSelfie?.estado == EstadoDocumento.rechazada;
    final todoListo = fotoOk && v.todoEnviado;
    final verificado =
        todoListo &&
        v.documentos.values.every((d) => d.estado == EstadoDocumento.aprobada);
    final hayRechazo = cedulaRechazada || selfieRechazada;
    final enRevision = todoListo && !verificado && !hayRechazo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (verificado)
          const _Aviso(
            tipo: TipoAviso.exito,
            mensaje: 'Tu identidad está verificada.',
          )
        else if (enRevision)
          const _EnRevision()
        else if (hayRechazo)
          const _Aviso(
            tipo: TipoAviso.error,
            mensaje: 'Algo de lo que enviaste fue rechazado. Vuelve a enviarlo.',
          ),
        if (errorFoto != null)
          _Aviso(tipo: TipoAviso.error, mensaje: errorFoto),
        if (errorSubida != null)
          _Aviso(tipo: TipoAviso.error, mensaje: errorSubida),
        _Paso(
          numero: 1,
          titulo: 'Sube tu cédula',
          ayuda: 'Foto del frente y del reverso.',
          listo: cedulaLista,
          activo: !cedulaLista,
          cargando: _subiendoCedula,
          etiquetaListo: cedulaAprobada ? 'Aprobada' : 'Enviada',
          textoBoton: cedulaRechazada
              ? 'Reenviar cédula'
              : cedulaIniciada
              ? 'Continuar'
              : 'Subir cédula',
          icono: Icons.upload_outlined,
          onPressed: _subiendoCedula || _enviandoSelfie
              ? null
              : () => _subirCedula(faltantes),
        ),
        _Paso(
          numero: 2,
          titulo: 'Tómate una selfie',
          ayuda:
              'De frente y con el rostro descubierto. Será tu foto pública '
              'y no podrás cambiarla.',
          listo: fotoOk,
          activo: cedulaLista && !fotoOk,
          cargando: _enviandoSelfie,
          etiquetaListo: docSelfie?.estado == EstadoDocumento.aprobada
              ? 'Aprobada'
              : 'Enviada',
          textoBoton: 'Tomar selfie',
          icono: Icons.photo_camera_outlined,
          onPressed: _subiendoCedula || _enviandoSelfie ? null : _tomarSelfie,
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
                'Solo tú y el equipo de verificación pueden ver tu cédula.',
                style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
              ),
            ),
          ],
        ),
        const SizedBox(height: Espacios.xl),
        if (verificado)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          )
        else if (todoListo)
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Entendido'),
          )
        else
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hacerlo más tarde'),
          ),
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

class _EnRevision extends StatelessWidget {
  const _EnRevision();

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacios.m),
      child: TarjetaApp(
        padding: const EdgeInsets.all(Espacios.l),
        radio: Radios.medio,
        conSombra: false,
        color: Colores.primarioSuave,
        colorBorde: Colores.primarioClaro,
        child: Column(
          children: [
            const Icon(
              Icons.hourglass_top_rounded,
              color: Colores.primario,
              size: 36,
            ),
            const SizedBox(height: Espacios.s),
            Text('Perfil en revisión', style: textos.titleLarge),
            const SizedBox(height: Espacios.xs),
            Text(
              'Tu verificación se realizará pronto. Te avisaremos cuando '
              'tu cuenta quede verificada.',
              textAlign: TextAlign.center,
              style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
            ),
          ],
        ),
      ),
    );
  }
}

/// Una línea numerada: círculo con el número (o check si ya está), título,
/// ayuda y, debajo, el botón o el estado.
class _Paso extends StatelessWidget {
  const _Paso({
    required this.numero,
    required this.titulo,
    required this.ayuda,
    required this.listo,
    required this.activo,
    required this.cargando,
    required this.etiquetaListo,
    required this.textoBoton,
    required this.icono,
    required this.onPressed,
  });

  final int numero;
  final String titulo;
  final String ayuda;
  final bool listo;
  final bool activo;
  final bool cargando;
  final String etiquetaListo;
  final String textoBoton;
  final IconData icono;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    const compacto = Size(0, 38);
    const relleno = EdgeInsets.symmetric(horizontal: Espacios.m);

    final Widget accion;
    if (cargando) {
      accion = const SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    } else if (listo) {
      accion = Pildora(
        texto: etiquetaListo,
        icono: Icons.check_circle_outline,
        color: Colores.acento,
      );
    } else if (activo) {
      accion = FilledButton.icon(
        style: FilledButton.styleFrom(minimumSize: compacto, padding: relleno),
        onPressed: onPressed,
        icon: Icon(icono, size: 18),
        label: Text(textoBoton),
      );
    } else {
      accion = OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: compacto,
          padding: relleno,
        ),
        onPressed: onPressed,
        icon: Icon(icono, size: 18),
        label: Text(textoBoton),
      );
    }

    return TarjetaApp(
      margin: const EdgeInsets.only(bottom: Espacios.m),
      padding: const EdgeInsets.all(Espacios.m),
      radio: Radios.medio,
      conSombra: false,
      color: activo ? Colores.primarioSuave : Colores.tarjeta,
      colorBorde: activo ? Colores.primarioClaro : Colores.linea,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: listo ? Colores.acento : Colores.primario,
            child: listo
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : Text(
                    '$numero',
                    style: textos.titleSmall?.copyWith(color: Colors.white),
                  ),
          ),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: textos.titleSmall),
                const SizedBox(height: 2),
                Text(
                  ayuda,
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
                const SizedBox(height: Espacios.s),
                accion,
              ],
            ),
          ),
        ],
      ),
    );
  }
}