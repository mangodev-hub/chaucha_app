// "Mi perfil" del cliente: cabecera con sus métricas, lo que dicen los
// técnicos de él y, a un lado, su ubicación y el menú de la cuenta. Los datos
// personales están verificados y no se editan; la foto es la selfie validada.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/menu_cuenta.dart';
import '../../../../app/pie_pagina.dart';
import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/geo/sector_service.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_baja.dart';
import '../../../../core/widgets/cabecera_perfil.dart';
import '../../../../core/widgets/etiqueta_sector.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../../perfil_puntos/domain/entities/perfil_publico.dart';
import '../../../perfil_puntos/presentation/views/aviso_verificacion_cliente.dart';
import '../../../perfil_puntos/presentation/widgets/resenas_perfil.dart';
import '../../../publicidad/domain/entities/anuncio.dart';
import '../../../publicidad/presentation/widgets/bloque_publicidad.dart';
import '../../../reclamos/presentation/widgets/entrada_mis_reclamos.dart';
import '../../data/repositories/supabase_auth_repository.dart';
import '../../data/repositories/supabase_usuario_repository.dart';
import '../../domain/entities/usuario.dart';
import '../providers/resenas_cliente_provider.dart';
import '../providers/sesion_provider.dart';
import '../widgets/perfil_cliente_secciones.dart';

String _iniciales(Usuario u) {
  final a = u.nombres.trim();
  final b = u.apellidos.trim();
  return '${a.isEmpty ? '' : a[0]}${b.isEmpty ? '' : b[0]}'.toUpperCase();
}

class PerfilClienteView extends ConsumerWidget {
  const PerfilClienteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    if (usuario == null) return const SizedBox.shrink();
    final resenas = ref.watch(resenasRecibidasProvider);
    final lista = resenas.value?.resenas ?? const <ResenaPublica>[];
    final promedio = resenas.value?.promedio ?? 0;
    final textos = Theme.of(context).textTheme;
    final ciudad = usuario.ciudad?.trim();

    final cabecera = CabeceraPerfil(
      nombre: usuario.nombreCompleto,
      iniciales: _iniciales(usuario),
      fotoRuta: usuario.fotoPerfilRuta,
      datos: Wrap(
        spacing: Espacios.m,
        runSpacing: Espacios.s,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (ciudad != null && ciudad.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colores.tintaSuave,
                ),
                const SizedBox(width: 4),
                Text(
                  '$ciudad, Ecuador',
                  style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colores.cieloSuave,
              borderRadius: BorderRadius.circular(Radios.pildora),
            ),
            child: Text(
              'Cliente',
              style: textos.labelMedium?.copyWith(
                color: Colores.cieloOscuro,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      metricas: [
        MetricaPerfil(
          icono: Icons.star_rounded,
          colorIcono: Colores.estrella,
          valor: lista.isEmpty
              ? '—'
              : promedio.toStringAsFixed(1).replaceAll('.', ','),
          etiqueta: 'Calificación',
        ),
        MetricaPerfil(
          icono: Icons.reviews_outlined,
          valor: '${lista.length}',
          etiqueta: lista.length == 1 ? 'Reseña' : 'Reseñas',
        ),
        MetricaPerfil(
          icono: Icons.calendar_month_outlined,
          valor: Formatos.mesAnio(usuario.creadoEn.toLocal()),
          etiqueta: 'Miembro desde',
        ),
      ],
    );

    final resenasBloque = AsyncValueView(
      value: resenas,
      onRetry: () => ref.invalidate(resenasRecibidasProvider),
      onData: (context, _) => ResenasPerfil(
        titulo: 'Lo que dicen los técnicos',
        resenas: lista,
        vacio: Text(
          'Aún no tienes reseñas. Aparecerán cuando completes tu primer '
          'servicio.',
          style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
        ),
      ),
    );
    // Orden: solicitudes activas, reseñas, historial y volver a contratar
    // (este último no aparece si aún no trabajó con nadie).
    final principal = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SolicitudesActivasPerfil(),
        const SizedBox(height: Espacios.l),
        resenasBloque,
        const SizedBox(height: Espacios.l),
        const HistorialServiciosPerfil(),
        const VolverAContratar(),
      ],
    );
    final lateral = [
      UbicacionCliente(usuario: usuario),
      const SizedBox(height: Espacios.l),
      const MenuCuentaPerfil(),
      const SizedBox(height: Espacios.l),
      const EntradaMisReclamos(esCliente: true),
      const SizedBox(height: Espacios.l),
      const BloquePublicidad(ubicacion: UbicacionAnuncio.homeCliente),
    ];
    final ancho = MediaQuery.sizeOf(context).width >= 1000;

    return ColoredBox(
      color: Colores.fondoClaro,
      child: _ConScroll(
        padding: EdgeInsets.all(ancho ? 0 : Espacios.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AvisoVerificacionCliente(margenInferior: Espacios.l),
            cabecera,
            const SizedBox(height: 20),
            if (ancho)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: principal),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 340,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: lateral,
                    ),
                  ),
                ],
              )
            else ...[
              principal,
              const SizedBox(height: Espacios.l),
              ...lateral,
            ],
            const PieLegalMovil(),
            const SizedBox(height: 32),
            const PiePagina(),
          ],
        ),
      ),
    );
  }
}

/// Scroll propio, salvo dentro del scroll único de la página web.
class _ConScroll extends StatelessWidget {
  const _ConScroll({required this.padding, required this.child});

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) => ScrollDePagina.activo(context)
      ? Padding(padding: padding, child: child)
      : SingleChildScrollView(padding: padding, child: child);
}

/// "Mi ubicación": la zona con la que se buscan técnicos cercanos. Se puede
/// cambiar con la ubicación actual o eligiéndola en el mapa.
class UbicacionCliente extends ConsumerStatefulWidget {
  const UbicacionCliente({super.key, required this.usuario});

  final Usuario usuario;

  @override
  ConsumerState<UbicacionCliente> createState() => _UbicacionClienteState();
}

class _UbicacionClienteState extends ConsumerState<UbicacionCliente> {
  bool _guardando = false;

  Future<void> _guardar(LatLng punto) async {
    setState(() => _guardando = true);
    try {
      await ref.read(usuarioRepositoryProvider).actualizarUbicacion(punto);
      await ref.read(sesionProvider.notifier).recargarUsuario();
      if (mounted) {
        context.mostrarMensaje(
          'Ubicación actualizada.',
          tipo: TipoMensaje.exito,
        );
      }
    } on Object catch (e) {
      if (mounted) {
        context.mostrarMensaje(
          AsyncValueView.mensajeDe(e),
          tipo: TipoMensaje.error,
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _usarActual() async {
    setState(() => _guardando = true);
    final punto = await ref.read(ubicacionServiceProvider).obtenerActual();
    if (!mounted) return;
    if (punto == null) {
      setState(() => _guardando = false);
      context.mostrarMensaje(
        'No pudimos obtener tu ubicación actual. Revisa los permisos.',
        tipo: TipoMensaje.error,
      );
      return;
    }
    await _guardar(punto);
  }

  Future<void> _elegirEnMapa(LatLng inicial) async {
    final elegido = await showDialog<LatLng>(
      context: context,
      builder: (_) => _ElegirEnMapa(inicial: inicial),
    );
    if (elegido != null && mounted) await _guardar(elegido);
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final guardada = widget.usuario.ubicacionRegistro;
    final punto = guardada ?? GeoMapper.quito;
    final barrio = guardada == null
        ? null
        : ref.watch(sectorProvider(SectorService.clave(guardada))).value;
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radios.pequeno),
    );
    return TarjetaInicio(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Radios.tarjeta),
            ),
            child: IgnorePointer(
              child: MapaUbicacion(
                punto: punto,
                altura: 150,
                radioMetros: 500,
                zoom: 14,
                colorRadio: Colores.cielo,
                colorMarcador: Colores.primarioVivo,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Espacios.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Mi ubicación',
                  style: textos.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  guardada == null
                      ? 'Aún no eliges tu ubicación'
                      : barrio ?? 'Ubicación guardada',
                  style: textos.bodyMedium?.copyWith(
                    color: guardada == null
                        ? Colores.tintaSuave
                        : Colores.primario,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: Espacios.m),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      child: FilledButton.icon(
                        onPressed: _guardando ? null : _usarActual,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          shape: forma,
                        ),
                        icon: _guardando
                            ? const SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.my_location_rounded, size: 18),
                        label: const Text('Usar la actual'),
                      ),
                    ),
                    const SizedBox(height: Espacios.s),
                    SizedBox(
                      child: OutlinedButton(
                        onPressed: _guardando
                            ? null
                            : () => _elegirEnMapa(punto),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          shape: forma,
                        ),
                        child: const Text('Elegir en el mapa'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Espacios.m),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: Colores.tintaSuave,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Se usa para encontrar técnicos cercanos sin exponer '
                        'tu domicilio particular.',
                        style: textos.bodySmall?.copyWith(
                          fontSize: 11,
                          color: Colores.tintaSuave,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ElegirEnMapa extends StatefulWidget {
  const _ElegirEnMapa({required this.inicial});

  final LatLng inicial;

  @override
  State<_ElegirEnMapa> createState() => _ElegirEnMapaState();
}

class _ElegirEnMapaState extends State<_ElegirEnMapa> {
  late LatLng _punto = widget.inicial;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Elige tu ubicación'),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Toca el mapa para mover el punto.'),
            const SizedBox(height: Espacios.m),
            MapaUbicacion(
              punto: _punto,
              altura: 320,
              colorMarcador: Colores.primarioVivo,
              mostrarSector: true,
              onCambio: (p) => setState(() => _punto = p),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_punto),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

/// Menú de la cuenta: datos personales (solo lectura), contraseña, cerrar
/// sesión y darse de baja.
class MenuCuentaPerfil extends ConsumerWidget {
  const MenuCuentaPerfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TarjetaInicio(
      padding: const EdgeInsets.symmetric(vertical: Espacios.s),
      child: Column(
        children: [
          _FilaMenu(
            icono: Icons.badge_outlined,
            texto: 'Datos personales',
            onTap: () => unawaited(
              showDialog<void>(
                context: context,
                builder: (_) => const _DatosPersonales(),
              ),
            ),
          ),
          const Divider(height: 1, color: Colores.divisor),
          _FilaMenu(
            icono: Icons.lock_outline_rounded,
            texto: 'Contraseña y seguridad',
            onTap: () => unawaited(mostrarConfiguracionCuenta(context)),
          ),
          const Divider(height: 1, color: Colores.divisor),
          _FilaMenu(
            icono: Icons.logout_rounded,
            texto: 'Cerrar sesión',
            onTap: () =>
                unawaited(ref.read(sesionProvider.notifier).cerrarSesion()),
          ),
          const Divider(height: 1, color: Colores.divisor),
          _FilaMenu(
            icono: Icons.person_remove_outlined,
            texto: 'Darse de baja',
            color: Colores.error,
            conChevron: false,
            onTap: () => unawaited(
              mostrarDialogoBaja(
                context,
                detalle:
                    'Tu cuenta quedará desactivada y se cancelarán tus '
                    'solicitudes activas.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaMenu extends StatelessWidget {
  const _FilaMenu({
    required this.icono,
    required this.texto,
    required this.onTap,
    this.color = Colores.tinta,
    this.conChevron = true,
  });

  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  final Color color;
  final bool conChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: Espacios.l),
        child: Row(
          children: [
            Icon(icono, size: 20, color: color),
            const SizedBox(width: Espacios.m),
            Expanded(
              child: Text(
                texto,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: color, fontWeight: FontWeight.w700),
              ),
            ),
            if (conChevron)
              const Icon(
                Icons.chevron_right_rounded,
                color: Colores.tintaSuave,
              ),
          ],
        ),
      ),
    );
  }
}

/// Datos personales en solo lectura: están verificados con la cédula.
class _DatosPersonales extends ConsumerWidget {
  const _DatosPersonales();

  static String enmascarar(String cedula) {
    final c = cedula.trim();
    if (c.length < 5) return '••••••';
    return '${c.substring(0, 2)}••••••${c.substring(c.length - 2)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final usuario = ref.watch(usuarioActualProvider);
    final correo = ref.watch(authRepositoryProvider).correoActual;
    final f = usuario?.creadoEn.toLocal();
    Widget dato(String etiqueta, String valor) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              etiqueta,
              style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: textos.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    return AlertDialog(
      icon: const Icon(Icons.verified_user_outlined, color: Colores.primario),
      title: const Text('Datos personales'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            dato('Nombres', usuario?.nombres ?? ''),
            dato('Apellidos', usuario?.apellidos ?? ''),
            FutureBuilder<String?>(
              future: ref.read(usuarioRepositoryProvider).miCedula(),
              builder: (context, s) => dato(
                'Cédula',
                s.hasData && s.data != null
                    ? enmascarar(s.data!)
                    : (s.connectionState == ConnectionState.done ? '—' : '…'),
              ),
            ),
            dato('Correo', correo ?? '—'),
            dato(
              'Registro',
              f == null
                  ? '—'
                  : '${f.day.toString().padLeft(2, '0')}/'
                        '${f.month.toString().padLeft(2, '0')}/${f.year}',
            ),
            const SizedBox(height: Espacios.m),
            Text(
              'Tus datos están verificados y no se pueden modificar. Si hay un '
              'error, escríbenos a soporte.',
              style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Entendido'),
        ),
      ],
    );
  }
}
