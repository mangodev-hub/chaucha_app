import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/check_animado.dart';
import '../../../../core/widgets/insignia_verificado.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../auth/data/repositories/supabase_usuario_repository.dart';
import '../../../auth/domain/entities/rol.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../domain/entities/documento_tecnico.dart';
import '../providers/verificacion_provider.dart';
import 'corregir_datos_dialog.dart';

/// Envuelve el inicio: si la cuenta quedó verificada y aún no lo celebró,
/// muestra la celebración (al entrar o en cuanto cambie).
class EscuchaVerificacion extends ConsumerStatefulWidget {
  const EscuchaVerificacion({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<EscuchaVerificacion> createState() =>
      _EscuchaVerificacionState();
}

class _EscuchaVerificacionState extends ConsumerState<EscuchaVerificacion> {
  /// Cuentas ya celebradas en esta ejecución (por si falla guardar la marca).
  final _celebradas = <String>{};

  /// Último pedido de corrección mostrado (campos + foto evaluada), para no
  /// repetirlo cada vez que se recarga el usuario.
  String? _correccionMostrada;
  bool _corrigiendo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quizasCelebrar(ref.read(usuarioActualProvider));
      unawaited(_quizasCorregir());
    });
  }

  /// Abre "Corrige tus datos" si la última validación encontró datos que no
  /// coinciden con la cédula.
  Future<void> _quizasCorregir({bool forzar = false}) async {
    final usuario = ref.read(usuarioActualProvider);
    if (_corrigiendo ||
        usuario == null ||
        usuario.verificado ||
        usuario.rol == Rol.admin ||
        !usuario.fotoVerificada) {
      return;
    }
    _corrigiendo = true;
    try {
      final v = await ref.read(verificacionProvider.future);
      final campos = v.camposNoCoinciden;
      if (campos.isEmpty || !mounted) return;
      final clave = [
        ...campos.map((c) => c.name),
        v.documentos[TipoDocumento.cedulaFrontal]?.ruta,
      ].join('|');
      if (clave == _correccionMostrada && !forzar) return;
      _correccionMostrada = clave;
      final guardado = await mostrarCorregirDatos(context, campos);
      if (guardado == true && mounted) {
        context.mostrarMensaje(
          'Datos guardados. Estamos revisando de nuevo tu identidad.',
          tipo: TipoMensaje.exito,
        );
      }
    } catch (_) {
      // Sin conexión: el aviso sigue en "Verifica tu identidad".
    } finally {
      _corrigiendo = false;
    }
  }

  void _quizasCelebrar(Usuario? usuario) {
    if (usuario == null ||
        !usuario.verificado ||
        usuario.verificacionVista ||
        usuario.rol == Rol.admin ||
        _celebradas.contains(usuario.id) ||
        !mounted) {
      return;
    }
    _celebradas.add(usuario.id);
    unawaited(_celebrar(usuario.rol));
  }

  Future<void> _celebrar(Rol rol) async {
    unawaited(
      ref
          .read(usuarioRepositoryProvider)
          .marcarVerificacionVista()
          .then((_) {}, onError: (_) {}),
    );
    await mostrarCelebracionVerificado(context, rol);
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(usuarioActualProvider, (_, usuario) {
        _quizasCelebrar(usuario);
        unawaited(_quizasCorregir());
      })
      // Terminó una validación (la que se lanza al subir las fotos).
      ..listen(validacionIdentidadProvider, (antes, ahora) {
        if (antes == true && !ahora) unawaited(_quizasCorregir(forzar: true));
      });
    return widget.child;
  }
}

Future<void> mostrarCelebracionVerificado(BuildContext context, Rol rol) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Identidad verificada',
    barrierColor: Colores.tinta.withValues(alpha: 0.55),
    transitionDuration: Movimiento.de(context, Movimiento.normal),
    pageBuilder: (context, _, _) => _Celebracion(rol: rol),
    transitionBuilder: (context, animacion, _, hijo) => FadeTransition(
      opacity: animacion,
      child: ScaleTransition(
        scale: Tween(begin: 0.92, end: 1.0).animate(
          CurvedAnimation(parent: animacion, curve: Movimiento.entrada),
        ),
        child: hijo,
      ),
    ),
  );
}

class _Celebracion extends StatelessWidget {
  const _Celebracion({required this.rol});

  final Rol rol;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final mensaje = rol == Rol.tecnico
        ? 'Ya puedes recibir solicitudes de tu zona y enviar tus precios.'
        : 'Ya puedes pedir servicios a técnicos verificados de tu zona.';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Espacios.l),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Material(
            color: Colores.tarjeta,
            borderRadius: BorderRadius.circular(Radios.muyGrande),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Espacios.xl,
                Espacios.l,
                Espacios.xl,
                Espacios.xl,
              ),
              child: Semantics(
                liveRegion: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _Festejo(tamano: 200),
                    Text(
                      '¡Identidad verificada!',
                      textAlign: TextAlign.center,
                      style: textos.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: Espacios.s),
                    Text(
                      mensaje,
                      textAlign: TextAlign.center,
                      style: textos.bodyLarge?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                    const SizedBox(height: Espacios.l),
                    const InsigniaVerificado(),
                    const SizedBox(height: Espacios.xs),
                    Text(
                      'Esta insignia aparecerá en tu perfil.',
                      textAlign: TextAlign.center,
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                    const SizedBox(height: Espacios.xl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Continuar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// El check grande en el centro, dos anillos que se expanden y chispas que
/// salen hacia afuera. Con "reducir animaciones" se ve solo el check.
class _Festejo extends StatefulWidget {
  const _Festejo({required this.tamano});

  final double tamano;

  @override
  State<_Festejo> createState() => _FestejoState();
}

class _FestejoState extends State<_Festejo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador = AnimationController(
    vsync: this,
  );
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iniciado) {
      _iniciado = true;
      _controlador.duration = Movimiento.de(
        context,
        const Duration(milliseconds: 1600),
      );
      unawaited(_controlador.forward());
    }
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: widget.tamano,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _PintorFestejo(_controlador)),
            ),
            CheckAnimado(tamano: widget.tamano * 0.42),
          ],
        ),
      ),
    );
  }
}

class _PintorFestejo extends CustomPainter {
  _PintorFestejo(this.progreso) : super(repaint: progreso);

  final Animation<double> progreso;

  static const _colores = [
    Colores.primarioClaro,
    Colores.cielo,
    Colores.primarioVivo,
    Colores.cieloClaro,
  ];
  static const _chispas = 12;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progreso.value;
    // Sin animación (duración cero) termina en 1: no se dibuja nada extra.
    if (t <= 0 || t >= 1) return;
    final centro = size.center(Offset.zero);
    final radio = size.shortestSide / 2;

    // Dos anillos, el segundo con retraso.
    for (final (retraso, color) in [
      (0.0, Colores.primarioClaro),
      (0.18, Colores.cielo),
    ]) {
      final f = ((t - retraso) / 0.7).clamp(0.0, 1.0);
      if (f <= 0 || f >= 1) continue;
      final curva = Curves.easeOutCubic.transform(f);
      canvas.drawCircle(
        centro,
        radio * (0.3 + 0.65 * curva),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * (1 - f) + 1
          ..color = color.withValues(alpha: 0.55 * (1 - f)),
      );
    }

    // Chispas: salen del centro, giran un poco y se desvanecen.
    final f = ((t - 0.15) / 0.85).clamp(0.0, 1.0);
    if (f <= 0) return;
    final curva = Curves.easeOutQuart.transform(f);
    final opacidad = (1 - f) * (f < 0.15 ? f / 0.15 : 1);
    for (var i = 0; i < _chispas; i++) {
      final angulo = (2 * math.pi / _chispas) * i + curva * 0.35;
      final distancia = radio * (0.3 + (i.isEven ? 0.62 : 0.5) * curva);
      final punto =
          centro + Offset(math.cos(angulo), math.sin(angulo)) * distancia;
      final pintura = Paint()
        ..color = _colores[i % _colores.length].withValues(alpha: opacidad);
      final lado = (i.isEven ? 7.0 : 5.0) * (1 - 0.4 * f);
      if (i % 3 == 0) {
        // Rombo.
        canvas
          ..save()
          ..translate(punto.dx, punto.dy)
          ..rotate(math.pi / 4 + curva)
          ..drawRect(
            Rect.fromCenter(center: Offset.zero, width: lado, height: lado),
            pintura,
          )
          ..restore();
      } else {
        canvas.drawCircle(punto, lado / 2, pintura);
      }
    }
  }

  @override
  bool shouldRepaint(_PintorFestejo old) => false;
}
