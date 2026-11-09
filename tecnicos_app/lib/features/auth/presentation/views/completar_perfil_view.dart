import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../../../../core/validators/codigo_dactilar_validator.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/campos.dart';
import '../../domain/entities/rol.dart';
import '../providers/completar_perfil_provider.dart';
import '../widgets/auth_layout.dart';
import '../widgets/opcion_rol.dart';

class CompletarPerfilView extends ConsumerStatefulWidget {
  const CompletarPerfilView({super.key, required this.onCerrarSesion});

  final Future<void> Function() onCerrarSesion;

  @override
  ConsumerState<CompletarPerfilView> createState() =>
      _CompletarPerfilViewState();
}

class _CompletarPerfilViewState extends ConsumerState<CompletarPerfilView> {
  final _formKey = GlobalKey<FormState>();
  final _cedula = TextEditingController();
  final _dactilar = TextEditingController();
  Rol _rol = Rol.cliente;

  @override
  void dispose() {
    _cedula.dispose();
    _dactilar.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(completarPerfilProvider.notifier).completar(
          cedula: _cedula.text,
          codigoDactilar: _dactilar.text,
          rol: _rol,
        );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(completarPerfilProvider);
    final cargando = estado.isLoading;
    final error = cargando || !estado.hasError
        ? null
        : AsyncValueView.mensajeDe(estado.error!);

    return AuthLayout(
      titulo: 'Completa tu perfil',
      subtitulo: 'Necesitamos tu identidad para activar tu cuenta.',
      tituloCentrado: true,
      anchoEscritorio: 440,
      panelDetallado: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error != null) ...[
              AvisoBanner(tipo: TipoAviso.error, mensaje: error),
              const SizedBox(height: Espacios.l),
            ],
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: OpcionRol(
                      icono: Icons.search,
                      titulo: 'Buscar un servicio',
                      descripcion: 'Quiero contratar técnicos',
                      elegida: _rol == Rol.cliente,
                      onTap: () => setState(() => _rol = Rol.cliente),
                    ),
                  ),
                  const SizedBox(width: Espacios.m),
                  Expanded(
                    child: OpcionRol(
                      icono: Icons.handyman_outlined,
                      titulo: 'Ofrecer mis servicios',
                      descripcion: 'Soy técnico profesional',
                      elegida: _rol == Rol.tecnico,
                      onTap: () => setState(() => _rol = Rol.tecnico),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Espacios.xl),
            CampoEtiquetado(
              etiqueta: 'Cédula',
              ayuda: '10 dígitos',
              child: TextFormField(
                controller: _cedula,
                decoration: const InputDecoration(
                  hintText: '17xxxxxxxx',
                  prefixIcon: Icon(Icons.badge_outlined),
                  errorMaxLines: 2,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                textInputAction: TextInputAction.next,
                validator: CedulaValidator.validate,
              ),
            ),
            const SizedBox(height: Espacios.l),
            CampoEtiquetado(
              etiqueta: 'Código dactilar',
              child: TextFormField(
                controller: _dactilar,
                decoration: const InputDecoration(
                  hintText: 'V1234V5678',
                  helperText: 'Está en el reverso de tu cédula',
                ),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: CodigoDactilarValidator.formatters,
                onFieldSubmitted: (_) => _enviar(),
                validator: CodigoDactilarValidator.validate,
              ),
            ),
            const SizedBox(height: Espacios.xl),
            BotonCarga(
              texto: 'Continuar',
              icono: Icons.arrow_forward,
              iconoAlFinal: true,
              cargando: cargando,
              onPressed: _enviar,
            ),
            Center(
              child: TextButton(
                onPressed: cargando ? null : widget.onCerrarSesion,
                child: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}