import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/pestana_solicitada.dart';
import '../../../../app/pie_pagina.dart';
import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/geo/sector_service.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/cabecera_perfil.dart';
import '../../../../core/widgets/etiqueta_sector.dart';
import '../../../../core/widgets/insignia_verificado.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../auth/presentation/views/perfil_cliente_view.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../../publicidad/domain/entities/anuncio.dart';
import '../../../publicidad/presentation/widgets/bloque_publicidad.dart';
import '../../../reclamos/presentation/widgets/entrada_mis_reclamos.dart';
import '../../../solicitudes/presentation/providers/inicio_tecnico_provider.dart';
import '../../domain/entities/cambios_perfil.dart';
import '../../domain/entities/nivel.dart';
import '../../domain/entities/perfil_publico.dart';
import '../../domain/entities/perfil_tecnico.dart';
import '../providers/perfil_publico_provider.dart';
import '../providers/perfil_tecnico_provider.dart';
import '../widgets/ajustes_tecnico.dart';
import '../widgets/certificaciones_widgets.dart';
import '../widgets/resenas_perfil.dart';
import 'verificacion_view.dart';

String _iniciales(Usuario u) {
  final a = u.nombres.trim();
  final b = u.apellidos.trim();
  return '${a.isEmpty ? '' : a[0]}${b.isEmpty ? '' : b[0]}'.toUpperCase();
}

class PerfilTecnicoView extends ConsumerStatefulWidget {
  const PerfilTecnicoView({super.key});

  @override
  ConsumerState<PerfilTecnicoView> createState() => _PerfilTecnicoViewState();
}

class _PerfilTecnicoViewState extends ConsumerState<PerfilTecnicoView> {
  final _formKey = GlobalKey<FormState>();
  final _tarifa = TextEditingController();
  final _claveOficios = GlobalKey();
  final _claveZona = GlobalKey();

  // Estado del formulario. Se llena una sola vez, con el primer perfil cargado.
  bool _inicializado = false;

  /// El último perfil cargado, para saber qué se editó en el formulario.
  PerfilTecnico? _base;
  Set<int> _seleccionados = const {};

  @override
  void initState() {
    super.initState();
    ref.listenManual(perfilTecnicoProvider, (_, estado) {
      if (estado case AsyncData(:final value)) _inicializar(value);
    }, fireImmediately: true);
    ref.listenManual(seccionPerfilProvider, (_, seccion) {
      if (seccion == null) return;
      ref.read(seccionPerfilProvider.notifier).limpiar();
      // Espera al cambio de pestaña para que la sección ya esté visible.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final contexto =
            (seccion == 'zona' ? _claveZona : _claveOficios).currentContext;
        if (contexto == null) return;
        unawaited(
          Scrollable.ensureVisible(
            contexto,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _tarifa.dispose();
    super.dispose();
  }

  void _inicializar(PerfilTecnico perfil) {
    final base = _base;
    _base = perfil;
    if (_inicializado) {
      if (base == null || !mounted) return;
      if (_seleccionados.length == base.oficioIds.length &&
          _seleccionados.containsAll(base.oficioIds)) {
        setState(() => _seleccionados = perfil.oficioIds.toSet());
      }
      return;
    }
    _inicializado = true;
    _tarifa.text = perfil.tarifaBase.toStringAsFixed(2);
    _seleccionados = perfil.oficioIds.toSet();
  }

  void _alternarOficio(int id) {
    setState(() {
      final nuevo = {..._seleccionados};
      if (!nuevo.remove(id)) nuevo.add(id);
      _seleccionados = nuevo;
    });
  }

  /// Guarda tarifa y oficios. La zona se cambia aparte, en su tarjeta.
  Future<void> _guardar(PerfilTecnico perfil) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final guardado = await ref
        .read(guardarPerfilProvider.notifier)
        .guardar(
          CambiosPerfil(
            tarifaBase: double.parse(_tarifa.text.trim().replaceAll(',', '.')),
            rangoCoberturaM: perfil.rangoCoberturaM,
            oficioIds: _seleccionados,
          ),
        );
    if (!mounted) return;
    if (guardado) {
      context.mostrarMensaje('Datos guardados.', tipo: TipoMensaje.exito);
    } else if (ref.read(guardarPerfilProvider) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ref.watch(usuarioActualProvider);
    if (usuario == null) return const SizedBox.shrink();
    final guardando = ref.watch(guardarPerfilProvider).isLoading;

    return AsyncValueView<PerfilTecnico>(
      value: ref.watch(perfilTecnicoProvider),
      onRetry: () => ref.invalidate(perfilTecnicoProvider),
      onData: (context, perfil) {
        final resumen = ref.watch(resumenTecnicoProvider).value;
        final publico = ref.watch(perfilPublicoProvider(usuario.id));
        final resenas = publico.value?.resenas ?? const <ResenaPublica>[];
        final textos = Theme.of(context).textTheme;
        final ciudad = usuario.ciudad?.trim();
        final esNuevo = perfil.totalResenas == 0;

        final cabecera = CabeceraPerfil(
          nombre: usuario.nombreCompleto,
          iniciales: _iniciales(usuario),
          fotoRuta: usuario.fotoPerfilRuta,
          verificado: perfil.verificado,
          datos: Wrap(
            spacing: Espacios.m,
            runSpacing: Espacios.s,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
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
                    '${ciudad == null || ciudad.isEmpty ? 'Quito' : ciudad}, '
                    'Ecuador',
                    style: textos.bodyMedium?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
                ],
              ),
              const _ChipRol('Técnico'),
              if (perfil.verificado) const InsigniaVerificado(),
              InsigniaSiCertificado(tecnicoId: perfil.usuarioId),
            ],
          ),
          metricas: [
            MetricaPerfil(
              icono: Icons.star_rounded,
              colorIcono: Colores.estrella,
              valor: esNuevo
                  ? '—'
                  : perfil.calificacionPromedio
                        .toStringAsFixed(1)
                        .replaceAll('.', ','),
              etiqueta: esNuevo
                  ? 'Calificación'
                  : '${perfil.totalResenas} '
                        '${perfil.totalResenas == 1 ? 'reseña' : 'reseñas'}',
            ),
            MetricaPerfil(
              icono: Icons.task_alt_rounded,
              valor: '${resumen?.completados ?? '—'}',
              etiqueta: 'Trabajos',
            ),
            MetricaPerfil(
              icono: Icons.workspace_premium_outlined,
              valor: '${perfil.puntos}',
              etiqueta: 'Puntos · ${perfil.nivelNombre}',
            ),
            MetricaPerfil(
              icono: Icons.calendar_month_outlined,
              valor: Formatos.mesAnio(usuario.creadoEn.toLocal()),
              etiqueta: 'Miembro desde',
            ),
          ],
        );

        final datosTrabajo = KeyedSubtree(
          key: _claveOficios,
          child: _DatosTrabajo(
            tarifa: _tarifa,
            seleccionados: _seleccionados,
            onOficio: _alternarOficio,
            guardando: guardando,
            onGuardar: () => _guardar(perfil),
          ),
        );
        final resenasBloque = AsyncValueView<PerfilPublico>(
          value: publico,
          onRetry: () => ref.invalidate(perfilPublicoProvider(usuario.id)),
          onData: (context, _) => ResenasPerfil(
            titulo: 'Lo que dicen los clientes',
            resenas: resenas,
            vacio: Text(
              'Aún no tienes reseñas. Aparecerán cuando completes tu primer '
              'trabajo.',
              style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
            ),
          ),
        );

        final principal = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TarjetaNivel(perfil: perfil),
            const SizedBox(height: Espacios.l),
            datosTrabajo,
            const SizedBox(height: Espacios.l),
            resenasBloque,
            const SeccionCertificaciones(),
          ],
        );
        final lateral = [
          KeyedSubtree(
            key: _claveZona,
            child: _ZonaTrabajo(perfil: perfil),
          ),
          const SizedBox(height: Espacios.l),
          const MenuCuentaPerfil(),
          const SizedBox(height: Espacios.l),
          const EntradaMisReclamos(esCliente: false),
          const SizedBox(height: Espacios.l),
          const BloquePublicidad(ubicacion: UbicacionAnuncio.homeTecnico),
        ];
        final ancho = MediaQuery.sizeOf(context).width >= 1000;

        return ColoredBox(
          color: Colores.fondoClaro,
          child: _ConScroll(
            padding: EdgeInsets.all(ancho ? 0 : Espacios.l),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!perfil.verificado) ...[
                    const _BannerVerificacion(),
                    const SizedBox(height: Espacios.l),
                  ],
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
          ),
        );
      },
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

class _ChipRol extends StatelessWidget {
  const _ChipRol(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colores.primarioSuave,
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: Text(
        texto,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: Colores.primario, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Aviso para verificarse, arriba del todo mientras no lo esté.
class _BannerVerificacion extends StatelessWidget {
  const _BannerVerificacion();

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaApp(
      onTap: () => mostrarVerificacion(context),
      colorBorde: Colores.primarioClaro,
      child: Row(
        children: [
          const IconoRecuadro(icono: Icons.shield_outlined, lado: 44),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verifica tu identidad', style: textos.titleSmall),
                Text(
                  'Sube tu cédula y una selfie. Los clientes confían más '
                  'en técnicos verificados.',
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colores.primario),
        ],
      ),
    );
  }
}

/// Título de una tarjeta del perfil.
class _TituloTarjeta extends StatelessWidget {
  const _TituloTarjeta(this.texto, {this.subtitulo});

  final String texto;
  final String? subtitulo;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final subtitulo = this.subtitulo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          texto,
          style: textos.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (subtitulo != null)
          Text(
            subtitulo,
            style: textos.bodySmall?.copyWith(
              fontSize: 13,
              color: Colores.tintaSuave,
            ),
          ),
      ],
    );
  }
}

/// Tarifa base y oficios, con su botón de guardar.
class _DatosTrabajo extends ConsumerWidget {
  const _DatosTrabajo({
    required this.tarifa,
    required this.seleccionados,
    required this.onOficio,
    required this.guardando,
    required this.onGuardar,
  });

  final TextEditingController tarifa;
  final Set<int> seleccionados;
  final ValueChanged<int> onOficio;
  final bool guardando;
  final VoidCallback onGuardar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    return TarjetaInicio(
      padding: const EdgeInsets.all(Espacios.l + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _TituloTarjeta(
            'Datos de trabajo',
            subtitulo: 'Lo que ven los clientes cuando postulas.',
          ),
          const SizedBox(height: Espacios.l),
          Text(
            'Precio por la visita',
            style: textos.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: Espacios.s),
          // Campo corto: un precio no necesita todo el ancho.
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: TextFormField(
                controller: tarifa,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: '0.00',
                ),
                validator: (v) => FormValidators.monto(v, campo: 'La tarifa'),
              ),
            ),
          ),
          const SizedBox(height: Espacios.l),
          Text(
            'Mis oficios',
            style: textos.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            'Verás solicitudes de los oficios que elijas.',
            style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
          ),
          const SizedBox(height: Espacios.s),
          AsyncValueView<List<Oficio>>(
            value: ref.watch(oficiosProvider),
            onRetry: () => ref.invalidate(oficiosProvider),
            onData: (context, catalogo) => Wrap(
              spacing: Espacios.s,
              runSpacing: Espacios.s,
              children: [
                for (final oficio in catalogo)
                  FilterChip(
                    label: Text(oficio.nombre),
                    selected: seleccionados.contains(oficio.id),
                    onSelected: (_) => onOficio(oficio.id),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Espacios.l),
          Align(
            alignment: Alignment.centerRight,
            child: BotonCarga(
              texto: 'Guardar cambios',
              icono: Icons.save_outlined,
              cargando: guardando,
              onPressed: onGuardar,
            ),
          ),
        ],
      ),
    );
  }
}

/// Zona de trabajo: mapa con el radio, el sector y el botón para cambiarla.
/// Mismo formato que "Mi ubicación" del cliente.
class _ZonaTrabajo extends ConsumerWidget {
  const _ZonaTrabajo({required this.perfil});

  final PerfilTecnico perfil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final guardada = perfil.ubicacionActual;
    final punto = guardada ?? GeoMapper.quito;
    final sector = guardada == null
        ? null
        : ref.watch(sectorProvider(SectorService.clave(guardada))).value;
    final km = (perfil.rangoCoberturaM / 1000).round();
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
                radioMetros: guardada == null
                    ? null
                    : perfil.rangoCoberturaM.toDouble(),
                // Con el radio entero a la vista en 150 px de alto.
                zoom: guardada == null ? 12 : 10,
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
                  'Zona de trabajo',
                  style: textos.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  guardada == null
                      ? 'Aún no marcas tu zona'
                      : '${sector ?? 'Zona guardada'} · hasta $km km',
                  style: textos.bodyMedium?.copyWith(
                    color: guardada == null
                        ? Colores.tintaSuave
                        : Colores.primario,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: Espacios.m),
                FilledButton.icon(
                  onPressed: () => unawaited(mostrarZonaTrabajo(context)),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radios.pequeno),
                    ),
                  ),
                  icon: const Icon(Icons.edit_location_alt_outlined),
                  label: Text(
                    guardada == null ? 'Marcar mi zona' : 'Cambiar zona',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Nivel actual (Bronce, Plata, Oro), con lo que falta para el siguiente.
class _TarjetaNivel extends ConsumerWidget {
  const _TarjetaNivel({required this.perfil});

  final PerfilTecnico perfil;

  static const _colores = {
    'Bronce': Color(0xFFCD7F32),
    'Plata': Color(0xFF9EA7B0),
    'Oro': Color(0xFFF5B301),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final niveles = ref.watch(nivelesProvider).value;
    final progreso = niveles == null || niveles.isEmpty
        ? null
        : ProgresoNivel.calcular(perfil.puntos, niveles);
    if (niveles == null || progreso == null) return const SizedBox.shrink();

    return TarjetaInicio(
      padding: const EdgeInsets.all(Espacios.l + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TituloTarjeta(
            'Tu nivel: ${perfil.nivelNombre}',
            subtitulo: 'Sube de nivel con buenas reseñas y certificados.',
          ),
          const SizedBox(height: Espacios.l),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final n in niveles)
                Expanded(
                  child: _Insignia(
                    nombre: n.nombre,
                    puntos: n.puntosMinimos,
                    color: _colores[n.nombre] ?? Colores.primario,
                    lograda: perfil.puntos >= n.puntosMinimos,
                    actual: n.nombre == perfil.nivelNombre,
                  ),
                ),
            ],
          ),
          const SizedBox(height: Espacios.l),
          ClipRRect(
            borderRadius: BorderRadius.circular(Radios.pildora),
            child: LinearProgressIndicator(
              value: progreso.esNivelMaximo ? 1 : progreso.fraccion,
              minHeight: 8,
              color: Colores.primarioVivo,
              backgroundColor: Colores.superficie,
            ),
          ),
          const SizedBox(height: Espacios.s),
          Text(
            progreso.esNivelMaximo
                ? '¡Llegaste al nivel más alto!'
                : 'Te faltan ${progreso.puntosFaltantes} puntos para llegar '
                      'a ${progreso.siguiente!.nombre}.',
            textAlign: TextAlign.center,
            style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }
}

class _Insignia extends StatelessWidget {
  const _Insignia({
    required this.nombre,
    required this.puntos,
    required this.color,
    required this.lograda,
    required this.actual,
  });

  final String nombre;
  final int puntos;
  final Color color;
  final bool lograda;
  final bool actual;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lograda ? color : Colores.superficieFuerte,
            border: actual
                ? Border.all(color: Colores.primario, width: 3)
                : null,
          ),
          child: Icon(
            lograda ? Icons.workspace_premium_rounded : Icons.lock_outline,
            color: Colores.sobreOscuro,
            size: 28,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(nombre, maxLines: 1, style: textos.labelLarge),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$puntos pts',
            maxLines: 1,
            style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
          ),
        ),
      ],
    );
  }
}
