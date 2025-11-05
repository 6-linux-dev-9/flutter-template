import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:template_app/core/di/providers/product_provider.dart';
import 'package:template_app/data/models/producto/input/producto_create_model.dart';
import 'package:template_app/presentation/forms/form_card.dart';
import 'package:template_app/presentation/forms/form_section.dart';
import 'package:template_app/presentation/forms/inputs/boolean_switch.dart';
import 'package:template_app/presentation/forms/inputs/date_time_input.dart';
import 'package:template_app/presentation/forms/inputs/json_text_input.dart';
import 'package:template_app/presentation/forms/inputs/number_input.dart';

class CrearProductoScreen extends ConsumerStatefulWidget {
  const CrearProductoScreen({super.key});

  @override
  ConsumerState<CrearProductoScreen> createState() =>
      _CrearProductoScreenState();
}

class _CrearProductoScreenState extends ConsumerState<CrearProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombre = TextEditingController();
  final _precio = TextEditingController();
  final _diagrama = TextEditingController();

  bool _esCaro = false;
  bool _loading = false;
  DateTime? _fechaCreacion = DateTime.now();

  @override
  void dispose() {
    _nombre.dispose();
    _precio.dispose();
    _diagrama.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final repo = ref.read(productRepositoryProvider);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await repo.create(
        ProductoCreateModel(
          nombre: _nombre.text.trim(),
          precio: double.tryParse(_precio.text.trim()) ?? 0,
          esCaro: _esCaro,
          diagrama: _diagrama.text.trim(),
          fechaCreacion: _fechaCreacion ?? DateTime.now(),
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto creado con éxito')),
      );
      context.pop(true);
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
    final enableBlur = Platform.isIOS;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Volver',
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Nuevo producto'),
      ),
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primaryContainer.withOpacity(0.55), cs.background],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                        Text(
                          'Crear producto',
                          style: text.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Registra un nuevo producto con sus atributos.',
                          style: text.bodyMedium?.copyWith(
                            color: cs.onBackground.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child:
                              enableBlur
                                  ? BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 12,
                                      sigmaY: 12,
                                    ),
                                    child: _GlassCard(child: _form()),
                                  )
                                  : _GlassCard(child: _form()),
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
  }

  Widget _form() {
    final cs = Theme.of(context).colorScheme;
    // Si deseas, puedes iniciar en hoy: _fechaCreacion = DateTime.now();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormSection(
            title: 'Datos del producto',
            child: FormCard(
              child: Column(
                children: [
                  // Nombre
                  TextFormField(
                    controller: _nombre,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Requerido'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // Precio usando NumberInput
                  NumberInput(
                    controller: _precio,
                    label: 'Precio',
                    //prefixIcon: Icons.monetization_on_outlined,
                    validator: (v) {
                      final s = (v ?? '').trim();
                      if (s.isEmpty) return 'Requerido';
                      if (double.tryParse(s) == null)
                        return 'Debe ser numérico';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          FormSection(
            title: 'Disponibilidad / Estado',
            child: FormCard(
              child: BooleanSwitch(
                value: _esCaro,
                label: '¿Es caro?',
                onChanged: (v) => setState(() => _esCaro = v),
              ),
            ),
          ),

          const SizedBox(height: 16),

          FormSection(
            title: 'Fecha de creación',
            child: FormCard(
              child: DateTimeInput(
                value: _fechaCreacion,
                onChanged: (v) => setState(() => _fechaCreacion = v),
              ),
            ),
          ),

          const SizedBox(height: 16),

          FormSection(
            title: 'Diagrama (JSON)',
            child: FormCard(child: JsonTextInput(controller: _diagrama)),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _loading ? null : () => context.pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed:
                      _loading
                          ? null
                          : () {
                            if (_formKey.currentState!.validate()) {
                              if (_fechaCreacion == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Selecciona la fecha'),
                                  ),
                                );
                                return;
                              }
                              _submit();
                            }
                          },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Guardar'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
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

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 10,
      color: Colors.white.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
