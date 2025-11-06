// lib/presentation/screens/usuario/editar_usuario_screen.dart
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:template_app/core/di/providers/user_provider.dart';
import 'package:template_app/data/models/usuario/input/user_update_model.dart';
import 'package:template_app/presentation/forms/form_card.dart';
import 'package:template_app/presentation/forms/form_section.dart';
import 'package:template_app/presentation/widgets/glass_card.dart';

class EditarUsuarioScreen extends ConsumerStatefulWidget {
  final String id;
  const EditarUsuarioScreen({super.key, required this.id});

  @override
  ConsumerState<EditarUsuarioScreen> createState() =>
      _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends ConsumerState<EditarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _email = TextEditingController();

  bool _hydrated = false;
  bool _loading = false;

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(userRepositoryProvider);

    setState(() => _loading = true);
    try {
      await repo.update(
        widget.id,
        UsuarioUpdateModel(
          nombre: _nombre.text.trim(),
          email: _email.text.trim(),
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario actualizado con éxito')),
      );
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uAsync = ref.watch(usuarioByIdProvider(widget.id));
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final enableBlur = Platform.isIOS;

    return uAsync.when(
      loading:
          () => const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          ),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (u) {
        // Hidratar datos solo una vez
        if (!_hydrated && u != null) {
          _nombre.text = u.nombre ?? '';
          _email.text = u.email ?? '';
          _hydrated = true;
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              tooltip: 'Volver',
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/usuarios');
                }
              },
            ),
            title: const Text('Editar usuario'),
          ),
          body: Stack(
            children: [
              // Fondo degradado
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.primaryContainer.withOpacity(0.55),
                      cs.background,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Contenido principal
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Encabezado
                            Text(
                              'Editar usuario',
                              style: text.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Actualiza los datos del usuario y guarda los cambios.',
                              style: text.bodyMedium?.copyWith(
                                color: cs.onBackground.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // GlassCard con el formulario
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child:
                                  enableBlur
                                      ? BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 12,
                                          sigmaY: 12,
                                        ),
                                        child: GlassCard(child: _form()),
                                      )
                                      : GlassCard(child: _form()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Capa de loading
              if (_loading)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Colors.black.withOpacity(0.08),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _form() {
    final cs = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección principal
          FormSection(
            title: 'Datos del usuario',
            child: FormCard(
              child: Column(
                children: [
                  // Nombre
                  TextFormField(
                    controller: _nombre,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Requerido'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (v) {
                      final val = v?.trim() ?? '';
                      if (val.isEmpty) return 'Requerido';
                      if (!val.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Botones inferiores
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      _loading
                          ? null
                          : () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/usuarios');
                            }
                          },
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Guardar cambios'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: cs.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
