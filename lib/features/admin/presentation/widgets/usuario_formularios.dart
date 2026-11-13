// Hojas para crear y editar usuarios desde el panel de administrador.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../../../../core/validators/codigo_dactilar_validator.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/campos.dart';
import '../../../../core/widgets/encabezado_pantalla.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/sacudir.dart';
import '../../../auth/domain/entities/registro_datos.dart';
import '../../../auth/domain/entities/rol.dart';
import '../../domain/entities/usuario_admin.dart';
import '../providers/admin_providers.dart';

/// Abre la hoja para crear un cliente o técnico. Devuelve true si se creó.
Future<bool> mostrarNuevoUsuario(BuildContext context) async {
  final creado = await _mostrarHoja(context, const _NuevoUsuario());
  return creado ?? false;
}

/// Abre la hoja para editar los datos básicos. Devuelve true si se guardó.
Future<bool> mostrarEditarUsuario(BuildContext context, UsuarioAdmin usuario) {
  return _mostrarHoja(
    context,
    _EditarUsuario(usuario: usuario),
  ).then((guardado) => guardado ?? false);
}

Future<bool?> _mostrarHoja(BuildContext context, Widget contenido) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (hoja) => Padding(
      // Sube con el teclado.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(hoja).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Espacios.xl,
            0,
            Espacios.xl,
            Espacios.xl,
          ),
          child: contenido,
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Crear
// ---------------------------------------------------------------------------

class _NuevoUsuario extends ConsumerStatefulWidget {
  const _NuevoUsuario();

  @override
  ConsumerState<_NuevoUsuario> createState() => _NuevoUsuarioState();
}

class _NuevoUsuarioState extends ConsumerState<_NuevoUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _cedula = TextEditingController();
  final _dactilar = TextEditingController();
  Rol _rol = Rol.cliente;
  int _fallos = 0;

  @override
  void dispose() {
    for (final c in [
      _email,
      _password,
      _nombres,
      _apellidos,
      _cedula,
      _dactilar,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _crear() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _fallos++);
      return;
    }
    final ok = await ref
        .read(crearUsuarioProvider.notifier)
        .crear(
          RegistroDatos(
            email: _email.text,
            password: _password.text,
            nombres: _nombres.text,
            apellidos: _apellidos.text,
            cedula: _cedula.text,
            codigoDactilar: _dactilar.text,
            rol: _rol,
          ),
        );
    if (!mounted) return;
    if (ok) {
      context.mostrarMensaje(
        'Usuario creado. Le llegará un correo para confirmar su cuenta.',
        tipo: TipoMensaje.exito,
      );
      Navigator.of(context).pop(true);
    } else if (ref.read(crearUsuarioProvider) case AsyncError(:final error)) {
      setState(() => _fallos++);
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final creando = ref.watch(crearUsuarioProvider).isLoading;
    const separacion = SizedBox(height: Espacios.l);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const EncabezadoPantalla(
            titulo: 'Nuevo usuario',
            subtitulo: 'Recibirá un correo para confirmar su cuenta.',
          ),
          separacion,
          CampoEtiquetado(
            etiqueta: 'Tipo de cuenta',
            child: SegmentedButton<Rol>(
              segments: const [
                ButtonSegment(
                  value: Rol.cliente,
                  icon: Icon(Icons.person_outline),
                  label: Text('Cliente'),
                ),
                ButtonSegment(
                  value: Rol.tecnico,
                  icon: Icon(Icons.engineering_outlined),
                  label: Text('Técnico'),
                ),
              ],
              selected: {_rol},
              onSelectionChanged: (s) => setState(() => _rol = s.first),
            ),
          ),
          separacion,
          CampoEtiquetado(
            etiqueta: 'Nombres',
            child: TextFormField(
              controller: _nombres,
              textCapitalization: TextCapitalization.words,
              validator: (v) => FormValidators.nombre(v, campo: 'El nombre'),
            ),
          ),
          separacion,
          CampoEtiquetado(
            etiqueta: 'Apellidos',
            child: TextFormField(
              controller: _apellidos,
              textCapitalization: TextCapitalization.words,
              validator: (v) => FormValidators.nombre(v, campo: 'El apellido'),
            ),
          ),
          separacion,
          CampoEtiquetado(
            etiqueta: 'Cédula',
            ayuda: 'Ecuador (10 dígitos)',
            child: TextFormField(
              controller: _cedula,
              keyboardType: TextInputType.number,
              maxLength: 10,
              validator: CedulaValidator.validate,
            ),
          ),
          separacion,
          CampoEtiquetado(
            etiqueta: 'Código dactilar',
            ayuda: 'Opcional',
            child: TextFormField(
              controller: _dactilar,
              textCapitalization: TextCapitalization.characters,
              validator: (v) => (v ?? '').trim().isEmpty
                  ? null
                  : CodigoDactilarValidator.validate(v),
            ),
          ),
          separacion,
          CampoEtiquetado(
            etiqueta: 'Correo',
            child: TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: FormValidators.email,
            ),
          ),
          separacion,
          CampoEtiquetado(
            etiqueta: 'Contraseña temporal',
            ayuda: 'Pídele que la cambie',
            child: CampoContrasena(
              controller: _password,
              validator: FormValidators.password,
            ),
          ),
          const SizedBox(height: Espacios.xl),
          Sacudir(
            senal: _fallos,
            child: BotonCarga(
              texto: 'Crear usuario',
              icono: Icons.person_add_alt_1_outlined,
              cargando: creando,
              onPressed: _crear,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Editar
// ---------------------------------------------------------------------------

class _EditarUsuario extends ConsumerStatefulWidget {
  const _EditarUsuario({required this.usuario});

  final UsuarioAdmin usuario;

  @override
  ConsumerState<_EditarUsuario> createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends ConsumerState<_EditarUsuario> {
  final _formKey = GlobalKey<FormState>();
  late final _nombres = TextEditingController(text: widget.usuario.nombres);
  late final _apellidos = TextEditingController(text: widget.usuario.apellidos);
  late final _ciudad = TextEditingController(text: widget.usuario.ciudad);
  int _fallos = 0;

  @override
  void dispose() {
    _nombres.dispose();
    _apellidos.dispose();
    _ciudad.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _fallos++);
      return;
    }
    final acciones = accionesUsuarioProvider(widget.usuario.id);
    final ok = await ref
        .read(acciones.notifier)
        .actualizar(
          CambiosUsuario(
            nombres: _nombres.text.trim(),
            apellidos: _apellidos.text.trim(),
            ciudad: _ciudad.text.trim(),
          ),
        );
    if (!mounted) return;
    if (ok) {
      context.mostrarMensaje('Cambios guardados.', tipo: TipoMensaje.exito);
      Navigator.of(context).pop(true);
    } else if (ref.read(acciones) case AsyncError(:final error)) {
      setState(() => _fallos++);
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final guardando = ref
        .watch(accionesUsuarioProvider(widget.usuario.id))
        .isLoading;
    const separacion = SizedBox(height: Espacios.l);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EncabezadoPantalla(
            titulo: 'Editar usuario',
            subtitulo: widget.usuario.email,
          ),
          separacion,
          CampoEtiquetado(
            etiqueta: 'Nombres',
            child: TextFormField(
              controller: _nombres,
              textCapitalization: TextCapitalization.words,
              validator: (v) => FormValidators.nombre(v, campo: 'El nombre'),
            ),
          ),
          separacion,
          CampoEtiquetado(
            etiqueta: 'Apellidos',
            child: TextFormField(
              controller: _apellidos,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          separacion,
          CampoEtiquetado(
            etiqueta: 'Ciudad',
            child: TextFormField(
              controller: _ciudad,
              textCapitalization: TextCapitalization.words,
              validator: (v) => FormValidators.requerido(v, campo: 'La ciudad'),
            ),
          ),
          const SizedBox(height: Espacios.xl),
          Sacudir(
            senal: _fallos,
            child: BotonCarga(
              texto: 'Guardar cambios',
              icono: Icons.save_outlined,
              cargando: guardando,
              onPressed: _guardar,
            ),
          ),
        ],
      ),
    );
  }
}
