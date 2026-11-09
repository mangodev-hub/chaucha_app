// Chat en tiempo real entre cliente y técnico. Solo el cliente inicia la
// conversación. Cuando acuerdan el precio, el técnico envía el ticket de
// trabajo ("Empezar trabajo") y el cliente lo confirma o lo rechaza.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../auth/domain/entities/rol.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import '../../../cotizaciones/domain/entities/reglas_tarifa.dart';
import '../../../cotizaciones/presentation/widgets/tarifa_widgets.dart';
import '../../domain/entities/mensaje.dart';
import '../../domain/entities/reglas_chat.dart';
import '../providers/enviar_mensaje_provider.dart';
import '../providers/mensajes_provider.dart';
import '../providers/tarifa_chat_provider.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key, required this.conversacionId});

  final String conversacionId;

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  static const double _anchoMaximo = 720;

  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final envio = enviarMensajeProvider(widget.conversacionId);
    final texto = _texto.text;
    if (texto.trim().isEmpty || ref.read(envio).isLoading) return;

    _texto.clear();
    final enviado = await ref.read(envio.notifier).enviar(texto);
    if (enviado || !mounted) return;

    _texto.text = texto; // Se devuelve el texto para no perderlo.
    if (ref.read(envio) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  AccionesTarifaNotifier get _tarifa =>
      ref.read(accionesTarifaProvider(widget.conversacionId).notifier);

  /// Muestra [exito] si salió bien, o el error de la acción si falló.
  Future<void> _resultado(Future<bool> accion, String exito) async {
    final ok = await accion;
    if (!mounted) return;
    if (ok) {
      context.mostrarMensaje(exito, tipo: TipoMensaje.exito);
    } else if (ref.read(accionesTarifaProvider(widget.conversacionId))
        case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  /// El técnico envía el ticket con el precio acordado.
  Future<void> _empezarTrabajo(double precioBase) async {
    final tarifa = await mostrarFormularioTarifa(
      context,
      precioBase: precioBase,
    );
    if (tarifa == null) return;
    await _resultado(
      _tarifa.enviar(tarifa),
      'Ticket enviado. El cliente debe confirmarlo.',
    );
  }

  Future<void> _confirmar(Cotizacion oferta) async {
    final total = oferta.tarifa?.total ?? oferta.precioBase;
    final ok = await context.confirmar(
      'Confirmar ticket',
      '¿Contratar este trabajo por ${Formatos.dinero(total)}? '
          'Las demás ofertas no se elegirán.',
      textoConfirmar: 'Confirmar',
      icono: Icons.handshake_outlined,
    );
    if (ok) {
      await _resultado(
        _tarifa.confirmar(),
        'Ticket confirmado. El trabajo está en curso.',
      );
    }
  }

  Future<void> _rechazar() async {
    final ok = await context.confirmar(
      'Rechazar ticket',
      'Pueden seguir conversando y el técnico podrá enviarte otro.',
      textoConfirmar: 'Sí, rechazar',
      textoCancelar: 'Volver',
      destructivo: true,
      icono: Icons.cancel_outlined,
    );
    if (ok) await _resultado(_tarifa.rechazar(), 'Ticket rechazado.');
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.conversacionId;
    final usuario = ref.watch(usuarioActualProvider);
    final miId = usuario?.id;
    final soyCliente = usuario?.rol == Rol.cliente;
    final mensajes = ref.watch(mensajesProvider(id));
    final enviando = ref.watch(enviarMensajeProvider(id)).isLoading;
    // Mientras cargan los mensajes, el técnico todavía no puede escribir.
    final puedeEscribir =
        miId != null &&
        ReglasChat.puedeEscribir(
          soyCliente: soyCliente,
          miId: miId,
          mensajes: mensajes.value ?? const [],
        );

    // Cada acción del ticket deja un mensaje: cuando llega uno nuevo se
    // recarga la oferta, así la otra persona ve el ticket sin recargar.
    ref.listen(mensajesProvider(id), (anterior, actual) {
      final antes = anterior?.value?.length;
      if (antes != null && actual.value?.length != antes) {
        ref.invalidate(contextoChatProvider(id));
      }
    });

    final contexto = ref.watch(contextoChatProvider(id));
    final oferta = contexto.value?.oferta;
    final estadoSolicitud = contexto.value?.estadoSolicitud;
    final procesando = ref.watch(accionesTarifaProvider(id)).isLoading;
    final puedeEnviarTicket =
        puedeEscribir &&
        estadoSolicitud != null &&
        ReglasTarifa.puedeEnviar(
          soyCliente: soyCliente,
          oferta: oferta,
          estadoSolicitud: estadoSolicitud,
        );
    final puedeResponder =
        estadoSolicitud != null &&
        ReglasTarifa.puedeResponder(
          soyCliente: soyCliente,
          oferta: oferta,
          estadoSolicitud: estadoSolicitud,
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          FranjaTarifa(
            soyCliente: soyCliente,
            oferta: oferta,
            cargando: procesando,
            error: contexto.hasError
                ? AsyncValueView.mensajeDe(contexto.error!)
                : null,
            onEmpezar: puedeEnviarTicket
                ? () => _empezarTrabajo(oferta!.precioBase)
                : null,
            onVerTicket: oferta?.tarifa == null
                ? null
                : () => mostrarDetalleTarifa(
                    context,
                    oferta: oferta!,
                    onConfirmar: puedeResponder && !procesando
                        ? () => _confirmar(oferta)
                        : null,
                    onRechazar: puedeResponder && !procesando
                        ? _rechazar
                        : null,
                  ),
          ),
          Expanded(
            child: AnchoMaximo(
              ancho: _anchoMaximo,
              child: AsyncValueView<List<Mensaje>>(
                value: mensajes,
                onRetry: () => ref.invalidate(mensajesProvider(id)),
                onData: (context, mensajes) => mensajes.isEmpty
                    ? soyCliente
                          ? const EstadoMensaje(
                              icono: Icons.chat_bubble_outline,
                              titulo: 'Inicia la conversación',
                              mensaje:
                                  'Pregunta lo que necesites y acuerden el '
                                  'precio del trabajo.',
                            )
                          : const EstadoMensaje(
                              icono: Icons.mark_chat_unread_outlined,
                              titulo: 'Esperando al cliente',
                              mensaje:
                                  'Cuando el cliente te escriba, podrás '
                                  'responderle aquí.',
                            )
                    : _Mensajes(mensajes: mensajes, miId: miId),
              ),
            ),
          ),
          _BarraEnvio(
            controller: _texto,
            enviando: enviando,
            habilitada: puedeEscribir,
            onEnviar: _enviar,
            anchoMaximo: _anchoMaximo,
          ),
        ],
      ),
    );
  }
}

/// Lista de mensajes, el más nuevo abajo, con separadores por día. Los
/// mensajes que llegan con la pantalla abierta entran con una animación; los
/// que ya estaban al abrirla, no.
class _Mensajes extends StatefulWidget {
  const _Mensajes({required this.mensajes, required this.miId});

  final List<Mensaje> mensajes;
  final String? miId;

  @override
  State<_Mensajes> createState() => _MensajesState();
}

class _MensajesState extends State<_Mensajes> {
  /// Ids ya mostrados. Null hasta la primera carga, que no se anima.
  Set<String>? _vistos;

  @override
  Widget build(BuildContext context) {
    final vistos = _vistos;
    // Se arma en orden cronológico y se muestra invertido (reverse: true)
    // para que el más nuevo quede junto al campo de texto. Cada elemento
    // lleva su clave para que la lista conserve su estado (y su animación)
    // cuando llegan mensajes nuevos.
    final elementos = <Widget>[];
    String? diaAnterior;
    for (final m in widget.mensajes) {
      final dia = Formatos.dia(m.enviadoEn);
      if (dia != diaAnterior) {
        elementos.add(_SeparadorDia(dia, key: ValueKey('dia-$dia')));
        diaAnterior = dia;
      }
      elementos.add(
        _EntradaMensaje(
          key: ValueKey(m.id),
          animar: vistos != null && !vistos.contains(m.id),
          child: _Burbuja(mensaje: m, esMio: m.autorId == widget.miId),
        ),
      );
    }
    _vistos = {...?vistos, for (final m in widget.mensajes) m.id};

    final indices = {
      for (var i = 0; i < elementos.length; i++)
        elementos[i].key!: elementos.length - 1 - i,
    };
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(Espacios.m),
      itemCount: elementos.length,
      itemBuilder: (context, i) => elementos[elementos.length - 1 - i],
      findChildIndexCallback: (clave) => indices[clave],
    );
  }
}

/// Si [animar] al montarse, [child] crece desde abajo con un fundido. Solo
/// cuenta el valor inicial: no se repite al volver a construirse.
class _EntradaMensaje extends StatefulWidget {
  const _EntradaMensaje({super.key, required this.animar, required this.child});

  final bool animar;
  final Widget child;

  @override
  State<_EntradaMensaje> createState() => _EntradaMensajeState();
}

class _EntradaMensajeState extends State<_EntradaMensaje>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador = AnimationController(
    vsync: this,
    value: widget.animar ? 0 : 1,
  );
  late final Animation<double> _curva = CurvedAnimation(
    parent: _controlador,
    curve: Movimiento.entrada,
  );
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iniciado) {
      _iniciado = true;
      if (widget.animar) {
        _controlador.duration = Movimiento.de(context, Movimiento.normal);
        unawaited(_controlador.forward());
      }
    }
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _curva,
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: _curva,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(_curva),
          child: widget.child,
        ),
      ),
    );
  }
}

class _SeparadorDia extends StatelessWidget {
  const _SeparadorDia(this.dia, {super.key});

  final String dia;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Espacios.m),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Espacios.m,
            vertical: Espacios.xs,
          ),
          decoration: BoxDecoration(
            color: Colores.superficieFuerte,
            borderRadius: BorderRadius.circular(Radios.pildora),
          ),
          child: Text(
            dia,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: Colores.tinta),
          ),
        ),
      ),
    );
  }
}

class _Burbuja extends StatelessWidget {
  const _Burbuja({required this.mensaje, required this.esMio});

  final Mensaje mensaje;
  final bool esMio;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final blanco = Theme.of(context).colorScheme.onPrimary;
    const radio = Radius.circular(Radios.grande);
    const esquina = Radius.circular(Espacios.xs);
    // Mis mensajes en azul; los del otro en blanco. La esquina recortada
    // apunta hacia quien escribió.
    return Align(
      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: Espacios.xs - 1),
        padding: const EdgeInsets.fromLTRB(
          Espacios.m + 2,
          Espacios.s + 2,
          Espacios.m + 2,
          Espacios.s,
        ),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: esMio ? Colores.primario : Colores.tarjeta,
          boxShadow: esMio ? null : Sombras.suave,
          borderRadius: BorderRadius.only(
            topLeft: radio,
            topRight: radio,
            bottomLeft: esMio ? radio : esquina,
            bottomRight: esMio ? esquina : radio,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              mensaje.contenido,
              style: textos.bodyMedium?.copyWith(
                color: esMio ? blanco : Colores.tinta,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              Formatos.hora(mensaje.enviadoEn),
              style: textos.labelSmall?.copyWith(
                color: esMio
                    ? blanco.withValues(alpha: 0.85)
                    : Colores.tintaSuave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra blanca inferior: campo redondeado y botón azul de enviar. Si no
/// está [habilitada] (técnico antes de que el cliente escriba), muestra un
/// aviso y desactiva el campo.
class _BarraEnvio extends StatelessWidget {
  const _BarraEnvio({
    required this.controller,
    required this.enviando,
    required this.habilitada,
    required this.onEnviar,
    required this.anchoMaximo,
  });

  final TextEditingController controller;
  final bool enviando;
  final bool habilitada;
  final VoidCallback onEnviar;
  final double anchoMaximo;

  @override
  Widget build(BuildContext context) {
    final redondeado = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Radios.pildora),
      borderSide: BorderSide.none,
    );
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colores.tarjeta,
        border: Border(top: BorderSide(color: Colores.linea)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Espacios.s + 2),
          child: Align(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: anchoMaximo),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: habilitada,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => onEnviar(),
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: habilitada
                            ? 'Escribe un mensaje...'
                            : 'El cliente iniciará la conversación',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Espacios.l + 4,
                          vertical: Espacios.m,
                        ),
                        border: redondeado,
                        enabledBorder: redondeado,
                        focusedBorder: redondeado.copyWith(
                          borderSide: const BorderSide(
                            color: Colores.primario,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Espacios.s),
                  IconButton.filled(
                    tooltip: 'Enviar',
                    iconSize: 22,
                    style: IconButton.styleFrom(
                      minimumSize: const Size.square(48),
                    ),
                    onPressed: enviando || !habilitada ? null : onEnviar,
                    icon: const Icon(Icons.send_rounded),
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
