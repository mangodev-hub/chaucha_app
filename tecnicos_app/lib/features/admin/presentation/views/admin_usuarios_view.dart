// Pestaña "Usuarios" del panel: listar, buscar, crear, editar, suspender y
// eliminar clientes y técnicos. Los administradores se ven pero no se tocan.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/filtro_chips.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../auth/domain/entities/rol.dart';
import '../../domain/entities/usuario_admin.dart';
import '../providers/admin_providers.dart';
import '../widgets/admin_widgets.dart';
import '../widgets/usuario_formularios.dart';

class AdminUsuariosView extends ConsumerStatefulWidget {
  const AdminUsuariosView({super.key});

  @override
  ConsumerState<AdminUsuariosView> createState() => _AdminUsuariosViewState();
}

class _AdminUsuariosViewState extends ConsumerState<AdminUsuariosView> {
  String _busqueda = '';

  /// null = todos.
  Rol? _rol;

  @override
  Widget build(BuildContext context) {
    final usuarios = ref.watch(usuariosAdminProvider);
    return PantallaAdmin(
      titulo: 'Usuarios',
      subtitulo: 'Clientes, técnicos y administradores.',
      onRecargar: () =>
          esperarSinError(ref.refresh(usuariosAdminProvider.future)),
      accion: FilledButton.icon(
        onPressed: () => unawaited(mostrarNuevoUsuario(context)),
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Nuevo usuario'),
      ),
      filtros: [
        BuscadorAdmin(
          hint: 'Buscar por nombre, correo o cédula',
          onCambio: (texto) => setState(() => _busqueda = texto),
        ),
        FiltroChips<Rol?>(
          opciones: const [
            (null, 'Todos'),
            (Rol.cliente, 'Clientes'),
            (Rol.tecnico, 'Técnicos'),
            (Rol.admin, 'Administradores'),
          ],
          seleccionado: _rol,
          onCambio: (rol) => setState(() => _rol = rol),
        ),
      ],
      children: [
        AsyncValueView<List<UsuarioAdmin>>(
          value: usuarios,
          onRetry: () => ref.invalidate(usuariosAdminProvider),
          onData: (context, lista) {
            final visibles = [
              for (final u in lista)
                if ((_rol == null || u.rol == _rol) && u.coincide(_busqueda)) u,
            ];
            if (visibles.isEmpty) {
              return const EstadoMensaje(
                compacto: true,
                icono: Icons.person_search_outlined,
                mensaje: 'No hay usuarios con esos filtros.',
              );
            }
            return CuadriculaAdaptable(
              children: [for (final u in visibles) TarjetaUsuario(usuario: u)],
            );
          },
        ),
      ],
    );
  }
}

enum _Accion { editar, suspender, reactivar, eliminar }

/// Usuario en la lista: datos, estado y menú de acciones.
class TarjetaUsuario extends ConsumerWidget {
  const TarjetaUsuario({super.key, required this.usuario});

  final UsuarioAdmin usuario;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    // Observarlo lo mantiene vivo mientras corre una acción.
    final procesando = ref.watch(accionesUsuarioProvider(usuario.id)).isLoading;
    final inicial = usuario.nombres.isEmpty
        ? '?'
        : usuario.nombres.characters.first.toUpperCase();

    return TarjetaApp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: usuario.suspendido
                    ? Colores.superficieFuerte
                    : Colores.primarioSuave,
                foregroundColor: usuario.suspendido
                    ? Colores.tintaSuave
                    : Colores.primarioOscuro,
                child: Text(inicial),
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario.nombreCompleto,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.titleSmall,
                    ),
                    Text(
                      usuario.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
              if (procesando)
                const Padding(
                  padding: EdgeInsets.all(Espacios.m),
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else if (!usuario.esAdmin)
                PopupMenuButton<_Accion>(
                  tooltip: 'Acciones',
                  onSelected: (accion) =>
                      unawaited(_ejecutar(context, ref, accion)),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: _Accion.editar,
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Editar'),
                      ),
                    ),
                    if (usuario.suspendido)
                      const PopupMenuItem(
                        value: _Accion.reactivar,
                        child: ListTile(
                          leading: Icon(Icons.lock_open_outlined),
                          title: Text('Reactivar acceso'),
                        ),
                      )
                    else
                      const PopupMenuItem(
                        value: _Accion.suspender,
                        child: ListTile(
                          leading: Icon(Icons.block_outlined),
                          title: Text('Suspender acceso'),
                        ),
                      ),
                    const PopupMenuItem(
                      value: _Accion.eliminar,
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: Colores.error,
                        ),
                        title: Text('Eliminar'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: Espacios.m),
          Wrap(
            spacing: Espacios.s,
            runSpacing: Espacios.s,
            children: [
              Pildora(
                texto: switch (usuario.rol) {
                  Rol.cliente => 'Cliente',
                  Rol.tecnico => 'Técnico',
                  Rol.admin => 'Administrador',
                },
                color: usuario.esAdmin
                    ? Colores.primarioProfundo
                    : Colores.primario,
              ),
              if (usuario.verificado case final verificado?)
                Pildora(
                  texto: verificado ? 'Verificado' : 'Sin verificar',
                  icono: verificado
                      ? Icons.verified_outlined
                      : Icons.hourglass_empty,
                  color: verificado ? Colores.acento : Colores.aviso,
                ),
              if (usuario.suspendido)
                const Pildora(
                  texto: 'Suspendido',
                  icono: Icons.block,
                  color: Colores.error,
                ),
            ],
          ),
          const SizedBox(height: Espacios.s),
          Text(
            [
              if (usuario.cedula case final cedula?) 'C.I. $cedula',
              usuario.ciudad,
              'Desde ${Formatos.fechaCorta(usuario.creadoEn)}',
            ].join(' · '),
            style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }

  Future<void> _ejecutar(
    BuildContext context,
    WidgetRef ref,
    _Accion accion,
  ) async {
    if (accion == _Accion.editar) {
      // La hoja muestra su propio aviso.
      await mostrarEditarUsuario(context, usuario);
      return;
    }
    final acciones = ref.read(accionesUsuarioProvider(usuario.id).notifier);
    final nombre = usuario.nombreCompleto;
    final bool ok;
    final String exito;
    switch (accion) {
      case _Accion.editar:
        return;
      case _Accion.reactivar:
        ok = await acciones.suspender(suspendido: false);
        exito = 'Acceso reactivado.';
      case _Accion.suspender:
        final seguir = await context.confirmar(
          'Suspender a $nombre',
          'No podrá iniciar sesión hasta que lo reactives. Sus datos se '
              'conservan.',
          textoConfirmar: 'Sí, suspender',
          destructivo: true,
          icono: Icons.block_outlined,
        );
        if (!seguir) return;
        ok = await acciones.suspender(suspendido: true);
        exito = 'Acceso suspendido.';
      case _Accion.eliminar:
        final seguir = await context.confirmar(
          'Eliminar a $nombre',
          'Se borra su cuenta y no se puede deshacer. Si tiene solicitudes '
              'u ofertas, suspéndelo en su lugar.',
          textoConfirmar: 'Sí, eliminar',
          destructivo: true,
          icono: Icons.delete_outline,
        );
        if (!seguir) return;
        ok = await acciones.eliminar();
        exito = 'Usuario eliminado.';
    }
    if (!context.mounted) return;
    if (ok) {
      context.mostrarMensaje(exito, tipo: TipoMensaje.exito);
    } else if (ref.read(accionesUsuarioProvider(usuario.id)) case AsyncError(
      :final error,
    )) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }
}
