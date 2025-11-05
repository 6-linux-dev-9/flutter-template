// lib/presentation/screens/usuario/crear_usuario_screen.dart
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/core/di/providers/user_provider.dart';
import 'package:template_app/data/models/usuario/input/user_create_model.dart';

class CrearUsuarioScreen extends ConsumerStatefulWidget {
  const CrearUsuarioScreen({super.key});

  @override
  ConsumerState<CrearUsuarioScreen> createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends ConsumerState<CrearUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final repo = ref.read(userRepositoryProvider);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await repo.create(
        UsuarioCreateModel(
          nombre: _nombre.text.trim(),
          email: _email.text.trim(),
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuario creado con éxito')));
      context.pop(true); // vuelve a la lista
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al crear: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final enableBlur =
        Platform.isIOS; // blur pesado solo en iOS para evitar jank

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
            if (context.canPop()) context.pop();
          },
        ),
        title: const Text('Nuevo usuario'),
      ),
      body: Stack(
        children: [
          // Fondo degradado suave
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [cs.primaryContainer.withOpacity(0.55), cs.background],
              ),
            ),
          ),

          // Contenido
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
                          'Crear usuario',
                          style: text.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Completa los datos básicos para registrar un nuevo usuario.',
                          style: text.bodyMedium?.copyWith(
                            color: cs.onBackground.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Card translúcida / simple
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

                        // Tip iOS-y
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
                                'Podrás editar estos datos más adelante desde la lista de usuarios.',
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
  }

  Widget _buildForm(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Nombre
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

          // Email
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

          // Botones
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _loading ? null : () {
                    if(context.canPop()){
                      context.pop();
                    }else{
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
                  label: const Text('Guardar'),
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

/// Card con estética “glass” amable para ambos SO.
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
