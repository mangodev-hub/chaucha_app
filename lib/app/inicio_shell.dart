// Shell del inicio: pestañas fijas abajo en móvil (como Facebook: siempre
// visibles, con insignias y una acción principal al centro) y pestañas en
// la barra superior en escritorio. Las vistas se mantienen montadas en un
// IndexedStack.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';

import '../core/presence/presencia_service.dart';
import '../core/providers/core_providers.dart';
import '../core/providers/sincronizacion_provider.dart';
import '../core/push/push_service.dart';
import '../core/router/app_routes.dart';
import '../core/theme/tokens.dart';
import '../core/utils/formatos.dart';
import '../core/widgets/etiqueta_sector.dart';
import '../core/widgets/foto_perfil_caja.dart';
import '../core/widgets/hoja_clara.dart';
import '../core/widgets/marca.dart';
import '../core/widgets/pantalla_secundaria.dart';
import '../core/widgets/scroll_pagina.dart';
import '../features/auth/domain/entities/rol.dart';
import '../features/auth/presentation/providers/inicio_provider.dart';
import '../features/auth/presentation/providers/sesion_provider.dart';
import '../features/notificaciones/presentation/providers/notificaciones_provider.dart';
import '../features/notificaciones/presentation/widgets/escucha_notificaciones.dart';
import '../features/notificaciones/presentation/widgets/punto_no_leidas.dart';
import 'encabezado_saludo.dart';
import 'menu_cuenta.dart';
import 'pestana_solicitada.dart';
import 'pie_pagina.dart';

class Destino {
  const Destino(
    this.titulo,
    this.icono,
    this.vista, {
    this.iconoActivo,
    this.corto,
    this.tiposNotificacion = const [],
    this.marcaAlEntrar = true,
    this.saludo,
    this.conteo,
  });

  /// Título completo: barra superior y pestañas de escritorio.
  final String titulo;

  /// Línea bajo "Hola, Nombre". Si no es null, en móvil la pestaña lleva el
  /// saludo (`EncabezadoSaludo`, con el menú de la cuenta en el avatar) en
  /// lugar de la barra superior.
  final String? saludo;
  final IconData icono;

  /// Versión rellena del ícono para la pestaña elegida.
  final IconData? iconoActivo;

  /// Etiqueta corta para la barra inferior del móvil (si no, [titulo]).
  final String? corto;
  final List<String> tiposNotificacion;
  final Widget vista;
  final bool marcaAlEntrar;

  /// Número a mostrar en la pestaña además de las notificaciones (por
  /// ejemplo, reclamos sin tomar en el panel del asesor).
  final ProviderListenable<AsyncValue<int>>? conteo;

  String get etiqueta => corto ?? titulo;
}

/// Acción principal del shell ("Pedir un técnico"): en móvil es el botón
/// redondo al centro de la barra inferior; en escritorio, un botón en la
/// barra superior. Abre [ruta].
class AccionCentral {
  const AccionCentral({
    required this.etiqueta,
    required this.icono,
    required this.ruta,
    this.corto,
  });

  final String etiqueta;

  /// Etiqueta corta bajo el botón redondo (si no, [etiqueta]).
  final String? corto;
  final IconData icono;
  final String ruta;

  String get etiquetaCorta => corto ?? etiqueta;
}

class InicioShell extends ConsumerStatefulWidget {
  const InicioShell({
    super.key,
    required this.destinos,
    required this.onCerrarSesion,
    this.accionCentral,
    this.rutaAgenda,
    this.notaMenu,
    this.claro = false,
    this.onBuscar,
    this.pagina,
    this.paginaLlena = false,
    this.rutaInicio,
    this.barraExtra,
  });

  /// Desde este ancho la navegación es un menú lateral en vez de la barra
  /// inferior.
  static const double anchoMenuLateral = 700;

  /// Ancho máximo del contenido y de la barra superior, y su margen lateral.
  static const double anchoMaximo = 1480;
  static const double margen = 32;

  final List<Destino> destinos;
  final VoidCallback onCerrarSesion;
  final AccionCentral? accionCentral;

  /// Si la agenda no es una pestaña (cliente), se abre desde el menú de la
  /// cuenta con esta ruta.
  final String? rutaAgenda;

  /// Texto chico al pie del menú lateral.
  final String? notaMenu;

  /// Con menú lateral: fondo claro, barra superior blanca y el menú directo
  /// sobre el fondo (la web de los tres roles).
  final bool claro;

  /// Buscador de la barra superior clara: recibe lo escrito.
  final void Function(BuildContext context, WidgetRef ref, String texto)?
  onBuscar;

  /// Pantalla secundaria (detalle, chat, perfil...) que se dibuja dentro de
  /// la estructura web del modo claro en lugar de una pestaña. El menú
  /// marca la pestaña desde donde se llegó y, al tocar otra, vuelve a
  /// [rutaInicio] con esa pestaña. En el teléfono se muestra sola.
  final Widget? pagina;

  /// La [pagina] ocupa el alto visible y tiene su propio scroll (chat).
  final bool paginaLlena;
  final String? rutaInicio;

  /// Lo propio del rol en la barra superior clara, antes de la campana (la
  /// píldora "Disponible" y el sector del técnico). Sin buscador ni
  /// [barraExtra] (admin), la barra solo lleva la marca y la cuenta.
  final Widget? barraExtra;

  @override
  ConsumerState<InicioShell> createState() => _InicioShellState();
}

class _InicioShellState extends ConsumerState<InicioShell> {
  int _indice = 0;
  StreamSubscription<ToquePush>? _toques;

  bool get _esSecundaria => widget.pagina != null;

  @override
  void initState() {
    super.initState();
    if (_esSecundaria) {
      _indice = ref.read(pestanaActualProvider);
      return;
    }
    final push = ref.read(pushServiceProvider);
    _toques = push.toques.listen(_abrirDesdePush);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pendiente = push.consumirPendiente();
      if (pendiente != null && mounted) _abrirDesdePush(pendiente);
    });
  }

  @override
  void dispose() {
    unawaited(_toques?.cancel());
    super.dispose();
  }

  /// Al tocar un push, va a la pestaña que maneja ese tipo de notificación.
  void _abrirDesdePush(ToquePush toque) {
    final referencia = toque.referenciaId;
    if (toque.tipo == 'reclamo' && referencia != null) {
      final rol = ref.read(usuarioActualProvider)?.rol;
      unawaited(
        context.push(
          AppRoutes.reclamo(
            referencia,
            esCliente: rol != Rol.tecnico,
            esAdmin: rol == Rol.admin,
          ),
        ),
      );
      return;
    }
    final i = widget.destinos.indexWhere(
      (d) => d.tiposNotificacion.contains(toque.tipo),
    );
    if (i >= 0) _cambiar(i);
  }

  void _cambiar(int indice) {
    if (_esSecundaria) {
      ref
          .read(pestanaSolicitadaProvider.notifier)
          .pedir(widget.destinos[indice].titulo);
      context.go(widget.rutaInicio ?? AppRoutes.clienteInicio);
      return;
    }
    setState(() => _indice = indice);
    ref.read(pestanaActualProvider.notifier).fijar(indice);
    final destino = widget.destinos[indice];
    if (destino.tiposNotificacion.isEmpty || !destino.marcaAlEntrar) return;
    final tipos = destino.tiposNotificacion;
    final uid = ref.read(supabaseClientProvider).auth.currentUser?.id;
    if (uid == null) return;
    unawaited(
      ref.read(notificacionesRepoProvider).marcarLeidas(uid, tipos: tipos),
    );
  }

  // Solo hay "Mi perfil" para cliente y técnico (el admin no tiene).
  int get _indicePerfil =>
      widget.destinos.indexWhere((d) => d.titulo == 'Mi perfil');

  VoidCallback? get _alPerfil =>
      _indicePerfil < 0 ? null : () => _cambiar(_indicePerfil);

  /// La ruta abierta es la agenda (pantalla secundaria del cliente).
  bool get _enAgenda {
    final ruta = widget.rutaAgenda;
    if (ruta == null || !_esSecundaria) return false;
    return GoRouterState.of(context).matchedLocation == ruta;
  }

  /// Abre la agenda. Si ya está abierta no hace nada: volver a apilar la
  /// misma ruta duplica la página y go_router deja la pantalla en blanco.
  /// Con `go` (y no `push`) tampoco se apila sobre otra pantalla secundaria.
  VoidCallback? get _aLaAgenda {
    final ruta = widget.rutaAgenda;
    if (ruta == null) return null;
    return () {
      if (_enAgenda) return;
      context.go(ruta);
    };
  }

  void _accion() {
    final accion = widget.accionCentral;
    if (accion != null) context.push(accion.ruta);
  }

  @override
  Widget build(BuildContext context) {
    final pagina = widget.pagina;
    if (pagina != null) {
      final ancho = MediaQuery.sizeOf(context).width;
      final web = widget.claro && ancho >= InicioShell.anchoMenuLateral;
      return web ? _paginaClara(context, ancho, secundaria: pagina) : pagina;
    }
    ref.watch(sincronizacionProvider);
    ref.watch(presenciaProvider);
    ref.listen(pestanaSolicitadaProvider, (_, titulo) {
      if (titulo == null) return;
      final i = widget.destinos.indexWhere((d) => d.titulo == titulo);
      if (i >= 0) _cambiar(i);
      ref.read(pestanaSolicitadaProvider.notifier).limpiar();
    });
    return EscuchaNotificaciones(child: _contenido(context));
  }

  Widget _contenido(BuildContext context) {
    final destinos = widget.destinos;
    final ancho = MediaQuery.sizeOf(context).width;
    final escritorio = ancho >= InicioShell.anchoMenuLateral;
    // Sobre el fondo oscuro nada va suelto: cada pestaña vive en la gran
    // hoja clara.
    final pestanas = IndexedStack(
      index: _indice,
      children: [
        for (final d in destinos) _Pagina(destino: d, escritorio: escritorio),
      ],
    );
    final usuario = ref.watch(usuarioActualProvider);
    final contenido = usuario != null && usuario.estaSuspendido
        ? Column(
            children: [
              _BannerSuspension(
                hasta: usuario.suspendidoHasta!,
                esCliente: usuario.rol == Rol.cliente,
              ),
              Expanded(child: pestanas),
            ],
          )
        : pestanas;

    if (escritorio && widget.claro) return _paginaClara(context, ancho);

    if (escritorio) {
      final claro = widget.claro;
      return Scaffold(
        backgroundColor: claro ? Colores.fondoClaro : null,
        body: Column(
          children: [
            if (claro) _barraClara(context) else _barraSuperior(context),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: InicioShell.anchoMaximo,
                  ),
                  child: Padding(
                    // En el modo claro, la pestaña deja 12 px a los lados
                    // para las sombras de sus tarjetas: se descuentan aquí.
                    padding: EdgeInsets.fromLTRB(
                      InicioShell.margen,
                      claro ? 20 : Espacios.s,
                      claro ? InicioShell.margen - 12 : InicioShell.margen,
                      claro ? 0 : 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ancho >= 1280 ? 248 : 220,
                          child: _MenuLateral(
                            destinos: destinos,
                            indice: _indice,
                            onCambio: _cambiar,
                            onAgenda: _aLaAgenda,
                            accion: widget.accionCentral,
                            onAccion: _accion,
                            nota: widget.notaMenu,
                            claro: claro,
                          ),
                        ),
                        SizedBox(width: claro ? 24 - 12 : 24),
                        Expanded(child: contenido),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final actual = destinos[_indice];
    return Scaffold(
      appBar: actual.saludo != null
          ? null
          : AppBar(
              title: Text(actual.titulo),
              actions: [
                MenuCuenta(
                  compacto: true,
                  onPerfil: _alPerfil,
                  onAgenda: _aLaAgenda,
                  onCerrarSesion: widget.onCerrarSesion,
                ),
                const SizedBox(width: Espacios.s),
              ],
            ),
      body: SafeArea(
        bottom: false,
        child: AccionesShell(
          onCerrarSesion: widget.onCerrarSesion,
          onPerfil: _alPerfil,
          onAgenda: _aLaAgenda,
          child: contenido,
        ),
      ),
      bottomNavigationBar: _BarraInferior(
        destinos: destinos,
        indice: _indice,
        onCambio: _cambiar,
        accion: widget.accionCentral,
        onAccion: _accion,
      ),
    );
  }

  /// Web del cliente: toda la página en un solo scroll (barra, menú y
  /// pestaña, y el pie a todo el ancho). La pestaña sabe que va dentro de
  /// este scroll ([ScrollDePagina]) y no crea el suyo.
  Widget _paginaClara(
    BuildContext context,
    double ancho, {
    Widget? secundaria,
  }) {
    final usuario = ref.watch(usuarioActualProvider);
    final destino = widget.destinos[_indice];
    final menu = SizedBox(
      width: ancho >= 1280 ? 248 : 220,
      child: _MenuLateral(
        destinos: widget.destinos,
        indice: _enAgenda ? -1 : _indice,
        agendaActiva: _enAgenda,
        onCambio: _cambiar,
        onAgenda: _aLaAgenda,
        accion: widget.accionCentral,
        onAccion: _accion,
        nota: widget.notaMenu,
        claro: true,
      ),
    );
    // Chat y pantallas con campo fijo: alto visible, sin pie.
    if (secundaria != null && widget.paginaLlena) {
      return Scaffold(
        backgroundColor: Colores.fondoClaro,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _barraClara(context),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: InicioShell.anchoMaximo,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      InicioShell.margen,
                      20,
                      InicioShell.margen,
                      20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SingleChildScrollView(child: menu),
                        const SizedBox(width: 24),
                        Expanded(
                          child: EstructuraWeb(llena: true, child: secundaria),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colores.fondoClaro,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _barraClara(context),
            if (usuario != null && usuario.estaSuspendido)
              _BannerSuspension(
                hasta: usuario.suspendidoHasta!,
                esCliente: usuario.rol == Rol.cliente,
              ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: InicioShell.anchoMaximo,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    InicioShell.margen,
                    20,
                    InicioShell.margen,
                    0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      menu,
                      const SizedBox(width: 24),
                      Expanded(
                        child: ScrollDePagina(
                          child: secundaria != null
                              ? EstructuraWeb(llena: false, child: secundaria)
                              : KeyedSubtree(
                                  key: ValueKey(_indice),
                                  child: _Pagina(
                                    destino: destino,
                                    escritorio: true,
                                    claro: true,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            const PiePagina(),
          ],
        ),
      ),
    );
  }

  /// Barra blanca del modo claro: marca, buscador, ubicación, avisos y la
  /// cuenta, alineados al mismo ancho máximo que el contenido.
  Widget _barraClara(BuildContext context) {
    final usuario = ref.watch(usuarioActualProvider);
    final noLeidas =
        ref.watch(notificacionesNoLeidasProvider).value ?? const [];
    final onBuscar = widget.onBuscar;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colores.tarjeta,
        border: Border(bottom: BorderSide(color: Colores.bordeBarra)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: InicioShell.anchoMaximo),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: InicioShell.margen),
            child: SizedBox(
              height: 72,
              child: Row(
                children: [
                  const Marca(),
                  const SizedBox(width: Espacios.l),
                  Expanded(
                    child: onBuscar == null
                        ? const SizedBox.shrink()
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: _Buscador(
                                onBuscar: (texto) =>
                                    onBuscar(context, ref, texto),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: Espacios.l),
                  if (widget.barraExtra case final extra?)
                    extra
                  else if (onBuscar != null)
                    const _UbicacionActual(),
                  const SizedBox(width: Espacios.s),
                  _Campana(
                    cantidad: noLeidas.length,
                    onTap: noLeidas.isEmpty
                        ? null
                        : () => _abrirDesdePush(
                            ToquePush(
                              tipo: noLeidas.first.tipo,
                              referenciaId: noLeidas.first.referenciaId,
                            ),
                          ),
                  ),
                  const SizedBox(width: Espacios.s),
                  MenuCuenta(
                    compacto: true,
                    onPerfil: _alPerfil,
                    onAgenda: _aLaAgenda,
                    onCerrarSesion: widget.onCerrarSesion,
                    hijo: FotoPerfilCaja(
                      tamano: 40,
                      circular: true,
                      rutaFoto: usuario?.fotoPerfilRuta,
                      iniciales: _iniciales(usuario?.nombreCompleto ?? ''),
                      colorFondo: Colores.cieloSuave,
                      estiloTexto: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(
                            color: Colores.cieloOscuro,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _barraSuperior(BuildContext context) {
    return ColoredBox(
      color: Colores.fondo,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: InicioShell.anchoMaximo),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: InicioShell.margen),
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  const Marca(sobreOscuro: true),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(left: Espacios.m),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colores.sobreOscuro.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    child: MenuCuenta(
                      sobreOscuro: true,
                      onPerfil: _alPerfil,
                      onAgenda: _aLaAgenda,
                      onCerrarSesion: widget.onCerrarSesion,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _iniciales(String nombre) => nombre
    .split(' ')
    .where((p) => p.isNotEmpty)
    .take(2)
    .map((p) => p[0])
    .join()
    .toUpperCase();

class _Buscador extends StatefulWidget {
  const _Buscador({required this.onBuscar});

  final ValueChanged<String> onBuscar;

  @override
  State<_Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<_Buscador> {
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  void _enviar() {
    widget.onBuscar(_texto.text.trim());
    _texto.clear();
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: Espacios.l),
      decoration: BoxDecoration(
        color: Colores.fondoClaro,
        borderRadius: BorderRadius.circular(Radios.pildora),
        border: Border.all(color: Colores.linea, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colores.tintaSuave, size: 20),
          const SizedBox(width: Espacios.s + 2),
          Expanded(
            child: TextField(
              controller: _texto,
              onSubmitted: (_) => _enviar(),
              textInputAction: TextInputAction.search,
              style: textos.bodyMedium,
              decoration: InputDecoration.collapsed(
                hintText: 'Busca plomero, electricista, cerrajero…',
                hintStyle: textos.bodyMedium?.copyWith(
                  color: Colores.tintaSuave,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sector de la ubicación con la que se buscan los técnicos cercanos.
class _UbicacionActual extends ConsumerWidget {
  const _UbicacionActual();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      SectorEnBarra(punto: ref.watch(ubicacionInicioProvider).value);
}

class _Campana extends StatelessWidget {
  const _Campana({required this.cantidad, required this.onTap});

  final int cantidad;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: cantidad == 0 ? 'Avisos' : 'Avisos, $cantidad nuevos',
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: SizedBox.square(
          dimension: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colores.fondoClaro,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colores.tinta,
                  size: 22,
                ),
              ),
              if (cantidad > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 18),
                    height: 18,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colores.primario,
                      borderRadius: BorderRadius.circular(Radios.pildora),
                      border: Border.all(color: Colores.tarjeta, width: 2),
                    ),
                    child: Text(
                      cantidad > 99 ? '99+' : '$cantidad',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: Colores.sobreOscuro,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// En el modo claro el menú va dentro del scroll de la página; si no, tiene
/// el suyo.
class _ScrollMenu extends StatelessWidget {
  const _ScrollMenu({required this.claro, required this.child});

  final bool claro;
  final Widget child;

  @override
  Widget build(BuildContext context) => claro
      ? child
      : SingleChildScrollView(
          padding: const EdgeInsets.all(Espacios.m),
          child: child,
        );
}

/// Menú lateral (web y tabletas): los destinos con sus no leídos, la
/// agenda, la acción principal y una nota al pie, sobre una hoja clara.
class _MenuLateral extends StatelessWidget {
  const _MenuLateral({
    required this.destinos,
    required this.indice,
    required this.onCambio,
    required this.onAgenda,
    required this.accion,
    required this.onAccion,
    required this.nota,
    required this.claro,
    this.agendaActiva = false,
  });

  final bool claro;

  /// La agenda está abierta: su ítem se marca como el de una pestaña.
  final bool agendaActiva;
  final List<Destino> destinos;
  final int indice;
  final ValueChanged<int> onCambio;
  final VoidCallback? onAgenda;
  final AccionCentral? accion;
  final VoidCallback onAccion;
  final String? nota;

  @override
  Widget build(BuildContext context) {
    final accion = this.accion;
    final onAgenda = this.onAgenda;
    final nota = this.nota;
    // La agenda del cliente no es una pestaña: va antes de "Mi perfil".
    final antesDeAgenda = onAgenda == null
        ? -1
        : destinos.indexWhere((d) => d.titulo == 'Mi perfil');
    final agenda = onAgenda == null
        ? null
        : _ItemMenu(
            texto: 'Agenda',
            icono: agendaActiva
                ? Icons.calendar_month_rounded
                : Icons.calendar_month_outlined,
            activo: agendaActiva,
            onTap: onAgenda,
          );

    return Material(
      color: claro ? Colors.transparent : Colores.lienzo,
      borderRadius: BorderRadius.circular(Radios.bento),
      clipBehavior: Clip.antiAlias,
      child: _ScrollMenu(
        claro: claro,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < destinos.length; i++) ...[
              if (i == antesDeAgenda) ?agenda,
              _ItemMenu(
                texto: destinos[i].titulo,
                icono: i == indice
                    ? destinos[i].iconoActivo ?? destinos[i].icono
                    : destinos[i].icono,
                tipos: destinos[i].tiposNotificacion,
                conteo: destinos[i].conteo,
                activo: i == indice,
                onTap: () => onCambio(i),
              ),
            ],
            if (antesDeAgenda < 0) ?agenda,
            if (accion != null) ...[
              const SizedBox(height: Espacios.m),
              FilledButton.icon(
                onPressed: onAccion,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radios.pequeno),
                  ),
                  textStyle: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                icon: Icon(accion.icono),
                label: Text(accion.etiqueta),
              ),
            ],
            if (nota != null) ...[
              const SizedBox(height: Espacios.m),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  nota,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    height: 1.45,
                    color: Colores.tintaSuave,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ItemMenu extends ConsumerWidget {
  const _ItemMenu({
    required this.texto,
    required this.icono,
    required this.activo,
    required this.onTap,
    this.tipos = const [],
    this.conteo,
  });

  final String texto;
  final IconData icono;
  final bool activo;
  final VoidCallback onTap;
  final ProviderListenable<AsyncValue<int>>? conteo;
  final List<String> tipos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sinLeer = tipos.isEmpty
        ? 0
        : (ref.watch(notificacionesNoLeidasProvider).value ?? const [])
              .where((n) => tipos.contains(n.tipo))
              .length;
    final conteo = this.conteo;
    final total = sinLeer + (conteo == null ? 0 : ref.watch(conteo).value ?? 0);
    final color = activo ? Colores.primario : Colores.tinta;
    final borde = BorderRadius.circular(Radios.pequeno);
    return Semantics(
      button: true,
      selected: activo,
      child: Material(
        color: activo ? Colores.primarioSuave : Colors.transparent,
        borderRadius: borde,
        child: InkWell(
          onTap: onTap,
          borderRadius: borde,
          child: Container(
            constraints: const BoxConstraints(minHeight: 46),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(
                  icono,
                  color: activo ? Colores.primario : Colores.tintaSuave,
                ),
                const SizedBox(width: Espacios.m),
                Expanded(
                  child: Text(
                    texto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 15,
                      color: color,
                      fontWeight: activo ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
                if (total > 0)
                  Container(
                    constraints: const BoxConstraints(minWidth: 20),
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colores.primario,
                      borderRadius: BorderRadius.circular(Radios.pildora),
                    ),
                    child: Text(
                      total > 99 ? '99+' : '$total',
                      semanticsLabel: '$total pendientes',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colores.sobreOscuro,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Barra de pestañas del móvil: superficie clara con las esquinas de arriba
/// muy redondeadas y una onda celeste suave. Si hay [accion], va como botón
/// redondo verde al centro, un poco por encima de la barra.
class _BarraInferior extends StatelessWidget {
  const _BarraInferior({
    required this.destinos,
    required this.indice,
    required this.onCambio,
    required this.accion,
    required this.onAccion,
  });

  final List<Destino> destinos;
  final int indice;
  final ValueChanged<int> onCambio;
  final AccionCentral? accion;
  final VoidCallback onAccion;

  @override
  Widget build(BuildContext context) {
    final accion = this.accion;
    final mitad = destinos.length ~/ 2;
    final items = <Widget>[
      for (var i = 0; i < destinos.length; i++) ...[
        if (accion != null && i == mitad)
          _BotonCentral(accion: accion, onTap: onAccion),
        Expanded(
          child: _ItemBarra(
            destino: destinos[i],
            activo: i == indice,
            onTap: () => onCambio(i),
          ),
        ),
      ],
    ];

    // Con textos muy grandes la barra crecería demasiado: se limita la
    // escala, como hace la barra de Material.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: CustomPaint(
        // La forma se pinta (no se recorta) para que el botón central pueda
        // sobresalir por arriba.
        painter: const _FondoBarra(),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Espacios.s,
              Espacios.xs,
              Espacios.s,
              Espacios.xs,
            ),
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: items,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fondo de la barra inferior: superficie clara con las esquinas de arriba
/// redondeadas y una onda celeste suave que entra por la derecha.
class _FondoBarra extends CustomPainter {
  const _FondoBarra();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final forma = RRect.fromRectAndCorners(
      Offset.zero & size,
      topLeft: const Radius.circular(Radios.hoja),
      topRight: const Radius.circular(Radios.hoja),
    );
    canvas
      ..drawRRect(forma, Paint()..color = Colores.lienzo)
      ..save()
      ..clipRRect(forma);
    final onda = Path()
      ..moveTo(w * 0.38, h)
      ..cubicTo(w * 0.55, h * 0.55, w * 0.72, h * 0.95, w * 0.86, h * 0.35)
      ..cubicTo(w * 0.92, h * 0.12, w * 0.97, h * 0.1, w, h * 0.12)
      ..lineTo(w, h)
      ..close();
    canvas
      ..drawPath(
        onda,
        Paint()..color = Colores.cieloClaro.withValues(alpha: 0.18),
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_FondoBarra anterior) => false;
}

/// Insignia con el número de [conteo] sobre el ícono de una pestaña.
class _ConConteo extends ConsumerWidget {
  const _ConConteo({required this.conteo, required this.child});

  final ProviderListenable<AsyncValue<int>>? conteo;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conteo = this.conteo;
    final n = conteo == null ? 0 : ref.watch(conteo).value ?? 0;
    return Badge(
      isLabelVisible: n > 0,
      backgroundColor: Colores.primario,
      label: Text(n > 99 ? '99+' : '$n'),
      child: child,
    );
  }
}

class _ItemBarra extends StatelessWidget {
  const _ItemBarra({
    required this.destino,
    required this.activo,
    required this.onTap,
  });

  final Destino destino;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Activo en verde oscuro; inactivos con el ícono celeste.
    final colorIcono = activo
        ? Colores.primario
        : Colores.cielo.withValues(alpha: 0.7);
    final colorTexto = activo ? Colores.primario : Colores.tintaSuave;
    return Semantics(
      container: true,
      button: true,
      selected: activo,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radios.subtarjeta),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Espacios.s + 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ConConteo(
                conteo: destino.conteo,
                child: PuntoNoLeidas(
                  tipos: destino.tiposNotificacion,
                  child: activo
                      ? _IconoActivo(
                          destino.iconoActivo ?? destino.icono,
                          color: colorIcono,
                        )
                      : Icon(destino.icono, color: colorIcono),
                ),
              ),
              const SizedBox(height: Espacios.xs),
              AnimatedDefaultTextStyle(
                duration: Movimiento.de(context, Movimiento.normal),
                curve: Movimiento.entrada,
                style:
                    (Theme.of(context).textTheme.labelMedium ??
                            const TextStyle())
                        .copyWith(
                          color: colorTexto,
                          fontWeight: activo
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                child: Text(
                  destino.etiqueta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón redondo verde al centro de la barra, con su etiqueta debajo. Sube
/// un poco por encima del borde de la barra.
class _BotonCentral extends StatelessWidget {
  const _BotonCentral({required this.accion, required this.onTap});

  final AccionCentral accion;
  final VoidCallback onTap;

  static const double _lado = 58;

  @override
  Widget build(BuildContext context) {
    // El InkWell aporta las acciones (tocar, foco) al nodo semántico; el
    // texto de adentro se excluye porque la etiqueta ya lo dice.
    return Semantics(
      container: true,
      button: true,
      label: accion.etiqueta,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radios.medio),
        child: ExcludeSemantics(
          child: SizedBox(
            width: 76,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, -Espacios.m),
                  child: Container(
                    width: _lado,
                    height: _lado,
                    // Aro claro para separarlo del fondo oscuro cuando
                    // sobresale de la barra.
                    decoration: BoxDecoration(
                      color: Colores.primario,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colores.lienzo, width: 4),
                    ),
                    child: Icon(
                      accion.icono,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 28,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -Espacios.s),
                  child: Text(
                    accion.etiquetaCorta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colores.primario,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconoActivo extends StatelessWidget {
  const _IconoActivo(this.icono, {required this.color});

  final IconData icono;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.7, end: 1),
      duration: Movimiento.de(context, Movimiento.normal),
      curve: Movimiento.rebote,
      builder: (context, escala, child) =>
          Transform.scale(scale: escala, child: child),
      child: Icon(icono, color: color),
    );
  }
}

/// Una pestaña del shell. Las pestañas comunes van en la hoja clara. Las
/// que tienen [Destino.saludo] (los inicios) se arman con tarjetas bento
/// directo sobre el fondo oscuro, y en móvil llevan el saludo arriba.
class _Pagina extends StatelessWidget {
  const _Pagina({
    required this.destino,
    required this.escritorio,
    this.claro = false,
  });

  /// Web del cliente: la página ya es clara, la pestaña va sin hoja.
  final bool claro;

  final Destino destino;
  final bool escritorio;

  @override
  Widget build(BuildContext context) {
    final saludo = destino.saludo;
    if (claro) return destino.vista;
    if (saludo == null) return HojaClara(child: destino.vista);
    if (escritorio) return destino.vista;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Espacios.l,
            Espacios.m,
            Espacios.l,
            Espacios.m,
          ),
          child: EncabezadoSaludo(subtitulo: saludo),
        ),
        Expanded(child: destino.vista),
      ],
    );
  }
}

/// Aviso fijo mientras dure la sanción por reseñas negativas.
class _BannerSuspension extends StatelessWidget {
  const _BannerSuspension({required this.hasta, required this.esCliente});

  final DateTime hasta;
  final bool esCliente;

  @override
  Widget build(BuildContext context) {
    final bloqueo = esCliente
        ? 'No puedes publicar solicitudes'
        : 'No puedes enviar propuestas';
    return Material(
      color: Colores.errorSuave,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Espacios.l,
          vertical: Espacios.m,
        ),
        child: Row(
          children: [
            const Icon(Icons.gpp_bad_outlined, color: Colores.error),
            const SizedBox(width: Espacios.m),
            Expanded(
              child: Text(
                'Cuenta suspendida por 3 reseñas negativas. $bloqueo hasta el '
                '${Formatos.fechaCorta(hasta)} a las ${Formatos.hora(hasta)}.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: Colores.errorOscuro),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
