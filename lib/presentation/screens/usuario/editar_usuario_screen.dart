// lib/presentation/screens/usuario/editar_usuario_screen.dart
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/core/di/service_locator.dart';
import 'package:template_app/data/models/usuario/input/user_update_model.dart';
// Si tu repo.update requiere un modelo tipado de entrada, importa aquí:
// import 'package:template_app/data/models/usuario/input/user_update_model.dart';
// Y si usas un modelo de salida para el provider por id, impórtalo también.

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
  bool _loading = false;
  bool _hydrated = false; // evita rehidratar en cada rebuild

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
      // Ajusta según tu firma real:
      // await repo.update(widget.id, {'nombre': _nombre.text.trim(), 'email': _email.text.trim()});
      await repo.update(
        widget.id,
        UsuarioUpdateModel(
          nombre: _nombre.text.trim(),
          email: _email.text.trim(),
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuario actualizado')));
      context.pop(); // volver a la pantalla anterior
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
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final enableBlur = Platform.isIOS; // blur pesado solo en iOS

    final uAsync = ref.watch(usuarioByIdProvider(widget.id));

    return uAsync.when(
      loading:
          () => const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          ),
      error:
          (e, _) => Scaffold(
            appBar: AppBar(
              title: const Text('Editar usuario'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed:
                    () =>
                        context.canPop()
                            ? context.pop()
                            : context.go('/usuarios'),
              ),
            ),
            body: Center(child: Text('Error: $e')),
          ),
      data: (u) {
        // hidrata campos una sola vez
        if (!_hydrated && u != null) {
          _nombre.text = u.nombre ?? '';
          _email.text = u.email ?? '';
          _hydrated = true;
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
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
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      cs.primaryContainer.withOpacity(0.55),
                      cs.background,
                    ],
                  ),
                ),
              ),

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
                              'Actualiza los datos y guarda los cambios.',
                              style: text.bodyMedium?.copyWith(
                                color: cs.onBackground.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Card translúcida
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child:
                                  enableBlur
                                      ? BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 12,
                                          sigmaY: 12,
                                        ),
                                        child: _GlassCard(
                                          child: _buildForm(context),
                                        ),
                                      )
                                      : _GlassCard(child: _buildForm(context)),
                            ),

                            const SizedBox(height: 18),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: cs.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Los cambios serán visibles inmediatamente en la lista.',
                                    style: text.bodySmall?.copyWith(
                                      color: cs.onBackground.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

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

  Widget _buildForm(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nombre,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              hintText: 'Ej. Juan Pérez',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator:
                (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'ejemplo@correo.com',
              prefixIcon: Icon(Icons.alternate_email),
            ),
            validator: (v) {
              final val = v?.trim() ?? '';
              if (val.isEmpty) return 'Requerido';
              if (!val.contains('@')) return 'Email inválido';
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/usuarios');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
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

/// Card con estética “glass”
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 10,
      shadowColor: Colors.black12,
      color: Colors.white.withOpacity(0.85),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: Theme.of(
              context,
            ).inputDecorationTheme.copyWith(
              filled: true,
              fillColor: cs.surface.withOpacity(0.9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black12.withOpacity(0.06)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black12.withOpacity(0.06)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: cs.primary, width: 1.4),
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

