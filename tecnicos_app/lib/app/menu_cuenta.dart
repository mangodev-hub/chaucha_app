import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/errors/app_failure.dart';
import '../core/theme/tokens.dart';
import '../core/utils/formatos.dart';
import '../core/validators/form_validators.dart';
import '../core/widgets/async_value_view.dart';
import '../core/widgets/avatar_usuario.dart';
import '../core/widgets/campos.dart';
import '../core/widgets/mensajes.dart';
import '../features/auth/data/repositories/supabase_auth_repository.dart';
import '../features/auth/presentation/providers/cuenta_provider.dart';
import '../features/auth/presentation/providers/sesion_provider.dart';

enum _Op { perfil, agenda, configuracion, acerca, salir }

class MenuCuenta extends ConsumerWidget {
  const MenuCuenta({
    super.key,
    required this.onPerfil,
    required this.onCerrarSesion,
    this.onAgenda,
    this.compacto = false,
    this.sobreOscuro = false,
    this.hijo,
  });

  final VoidCallback onCerrarSesion;
  final bool compacto;

  /// Nombre y flecha en blanco (barra superior oscura de escritorio).
  final bool sobreOscuro;
  final VoidCallback? onPerfil;

  /// Lo que se toca para abrir el menú, en lugar del avatar por defecto
  /// (el encabezado del inicio pasa su propio avatar con aro).
  final Widget? hijo;

  /// "Mi agenda", solo cuando la agenda no es una pestaña (cliente).
  final VoidCallback? onAgenda;
  static PopupMenuItem<_Op> _item(
    _Op valor,
    IconData icono,
    String texto, {
    Color? color,
  }) => PopupMenuItem<_Op>(
    value: valor,
    child: Row(
      children: [
        Icon(icono, size: 20, color: color ?? Colores.tintaSuave),
        const SizedBox(width: Espacios.m),
        Text(texto, style: TextStyle(color: color ?? Colores.tinta)),
      ],
    ),
  );

  void _elegir(BuildContext context, _Op op) {
    switch (op) {
      case _Op.perfil:
        onPerfil?.call();
      case _Op.agenda:
        onAgenda?.call();
      case _Op.configuracion:
        showDialog<void>(
          context: context,
          builder: (_) => const _DialogoConfiguracion(),
        );
      case _Op.acerca:
        showAboutDialog(
          context: context,
          applicationName: 'ChauchaApp',
          applicationLegalese: 'EagleDev 2026',
        );
      case _Op.salir:
        onCerrarSesion();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    final correo = ref.watch(authRepositoryProvider).correoActual;
    final textos = Theme.of(context).textTheme;
    final nombre = usuario?.nombres ?? '';

    Widget avatar(double lado) => AvatarUsuario(
      nombre: usuario?.nombreCompleto ?? nombre,
      rutaFoto: usuario?.fotoPerfilRuta,
      radio: lado / 2,
    );

    return PopupMenuButton<_Op>(
      tooltip: 'Mi cuenta',
      offset: const Offset(0, 48),
      color: Colores.tarjeta,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radios.medio),
        side: const BorderSide(color: Colores.linea),
      ),
      onSelected: (op) => _elegir(context, op),
      itemBuilder: (_) => [
        PopupMenuItem<_Op>(
          enabled: false,
          child: Row(
            children: [
              avatar(40),
              const SizedBox(width: Espacios.m),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      usuario?.nombreCompleto ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: textos.titleSmall?.copyWith(color: Colores.tinta),
                    ),
                    if (correo != null)
                      Text(
                        correo,
                        overflow: TextOverflow.ellipsis,
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
        const PopupMenuDivider(),
        if (onPerfil != null)
          _item(_Op.perfil, Icons.person_outline, 'Mi perfil'),
        if (onAgenda != null)
          _item(_Op.agenda, Icons.event_outlined, 'Mi agenda'),
        _item(
          _Op.configuracion,
          Icons.settings_outlined,
          'Configuración de la cuenta',
        ),
        const PopupMenuDivider(),
        _item(_Op.acerca, Icons.info_outline, 'Acerca de ChauchaApp'),
        const PopupMenuDivider(),
        _item(_Op.salir, Icons.logout, 'Cerrar sesión', color: Colores.error),
      ],
      child: hijo != null
          ? hijo!
          : compacto
          ? Padding(
              padding: const EdgeInsets.all(Espacios.s),
              child: avatar(32),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Espacios.s,
                vertical: Espacios.xs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  avatar(32),
                  const SizedBox(width: Espacios.s + 2),
                  Text(
                    nombre,
                    style: textos.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: sobreOscuro ? Colores.sobreOscuro : null,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: sobreOscuro ? Colores.sobreOscuro : null,
                  ),
                ],
              ),
            ),
    );
  }
}

/// "Configuración de la cuenta": agrupa acceso (correo y contraseña),
/// seguridad e información de la cuenta. Sin datos personales.
class _DialogoConfiguracion extends ConsumerWidget {
  const _DialogoConfiguracion();

  Future<void> _cerrarEnTodos(BuildContext context, WidgetRef ref) async {
    final ok = await context.confirmar(
      'Cerrar sesión en todos los dispositivos',
      'Tendrás que iniciar sesión de nuevo en cada uno, incluido este.',
      textoConfirmar: 'Sí, cerrar todo',
      textoCancelar: 'Volver',
      destructivo: true,
      icono: Icons.devices_other_outlined,
    );
    if (!ok) return;
    try {
      await ref.read(authRepositoryProvider).cerrarSesionEnTodos();
    } on AppFailure catch (e) {
      if (context.mounted) {
        context.mostrarMensaje(e.message, tipo: TipoMensaje.error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authRepositoryProvider);
    final usuario = ref.watch(usuarioActualProvider);
    final textos = Theme.of(context).textTheme;

    Widget titulo(String t) => Padding(
      padding: const EdgeInsets.only(top: Espacios.l, bottom: Espacios.xs),
      child: Text(
        t.toUpperCase(),
        style: textos.labelSmall?.copyWith(
          color: Colores.tintaSuave,
          letterSpacing: 0.8,
        ),
      ),
    );

    Widget fila({
      required IconData icono,
      required String texto,
      String? detalle,
      String? accion,
      VoidCallback? onTap,
      Color? color,
    }) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icono, color: color ?? Colores.tintaSuave),
      title: Text(texto, style: TextStyle(color: color ?? Colores.tinta)),
      subtitle: detalle == null ? null : Text(detalle),
      trailing: accion == null
          ? null
          : Text(
              accion,
              style: textos.labelLarge?.copyWith(color: Colores.primario),
            ),
      onTap: onTap,
    );

    return AlertDialog(
      title: const Text('Configuración de la cuenta'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titulo('Acceso'),
              if (auth.usaContrasena) ...[
                fila(
                  icono: Icons.mail_outline,
                  texto: 'Correo electrónico',
                  detalle: auth.correoActual,
                  accion: 'Cambiar',
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (_) => const _DialogoCuenta(correo: true),
                  ),
                ),
                fila(
                  icono: Icons.lock_outline,
                  texto: 'Contraseña',
                  detalle: '••••••••',
                  accion: 'Cambiar',
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (_) => const _DialogoCuenta(correo: false),
                  ),
                ),
              ] else
                fila(
                  icono: Icons.mail_outline,
                  texto: 'Correo electrónico',
                  detalle:
                      '${auth.correoActual ?? ''}\nTu cuenta usa Google, por '
                      'eso el correo y la contraseña se gestionan allá.',
                ),
              titulo('Seguridad'),
              fila(
                icono: Icons.devices_other_outlined,
                texto: 'Cerrar sesión en todos los dispositivos',
                detalle: 'Útil si olvidaste cerrar sesión en otro equipo.',
                onTap: () => _cerrarEnTodos(context, ref),
              ),
              if (usuario != null) ...[
                titulo('Información'),
                fila(
                  icono: Icons.calendar_month_outlined,
                  texto: 'Cuenta creada',
                  detalle: Formatos.fecha(usuario.creadoEn),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

class _DialogoCuenta extends ConsumerStatefulWidget {
  const _DialogoCuenta({required this.correo});

  final bool correo;

  @override
  ConsumerState<_DialogoCuenta> createState() => _DialogoCuentaState();
}

class _DialogoCuentaState extends ConsumerState<_DialogoCuenta> {
  final _form = GlobalKey<FormState>();
  final _actual = TextEditingController();
  final _nuevo = TextEditingController();
  final _confirmar = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _actual.dispose();
    _nuevo.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    final cuenta = ref.read(cuentaProvider.notifier);
    final ok = widget.correo
        ? await cuenta.cambiarCorreo(
            contrasena: _actual.text,
            nuevo: _nuevo.text,
          )
        : await cuenta.cambiarContrasena(
            actual: _actual.text,
            nueva: _nuevo.text,
          );
    if (!mounted) return;
    if (ok) {
      context.mostrarMensaje(
        widget.correo
            ? 'Te enviamos un enlace de confirmación al nuevo correo.'
            : 'Contraseña actualizada.',
        tipo: TipoMensaje.exito,
      );
      Navigator.pop(context);
    } else if (ref.read(cuentaProvider) case AsyncError(:final error)) {
      setState(() => _error = AsyncValueView.mensajeDe(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cargando = ref.watch(cuentaProvider).isLoading;
    return AlertDialog(
      title: Text(widget.correo ? 'Cambiar correo' : 'Cambiar contraseña'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CampoEtiquetado(
                  etiqueta: 'Contraseña actual',
                  child: CampoContrasena(
                    controller: _actual,
                    validator: (v) => FormValidators.requerido(
                      v,
                      campo: 'La contraseña actual',
                    ),
                  ),
                ),
                const SizedBox(height: Espacios.l),
                if (widget.correo)
                  CampoEtiquetado(
                    etiqueta: 'Nuevo correo',
                    child: TextFormField(
                      controller: _nuevo,
                      keyboardType: TextInputType.emailAddress,
                      validator: FormValidators.email,
                    ),
                  )
                else ...[
                  CampoEtiquetado(
                    etiqueta: 'Nueva contraseña',
                    child: CampoContrasena(
                      controller: _nuevo,
                      validator: FormValidators.password,
                    ),
                  ),
                  const SizedBox(height: Espacios.l),
                  CampoEtiquetado(
                    etiqueta: 'Confirmar contraseña',
                    child: CampoContrasena(
                      controller: _confirmar,
                      validator: (v) => v != _nuevo.text
                          ? 'Las contraseñas no coinciden.'
                          : null,
                    ),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: Espacios.m),
                  Text(_error!, style: const TextStyle(color: Colores.error)),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: cargando ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: cargando ? null : _guardar,
          child: Text(cargando ? 'Guardando...' : 'Guardar'),
        ),
      ],
    );
  }
}
