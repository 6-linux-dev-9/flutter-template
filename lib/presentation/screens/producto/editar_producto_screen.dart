
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:template_app/core/di/providers/product_provider.dart';
import 'package:template_app/data/models/producto/input/producto_update_model.dart';
import 'package:template_app/presentation/forms/form_card.dart';
import 'package:template_app/presentation/forms/form_section.dart';
import 'package:template_app/presentation/forms/inputs/boolean_switch.dart';
import 'package:template_app/presentation/forms/inputs/date_time_input.dart';
import 'package:template_app/presentation/forms/inputs/json_text_input.dart';
import 'package:template_app/presentation/forms/inputs/number_input.dart';
import 'package:template_app/presentation/forms/inputs/select_input.dart';
import 'package:template_app/presentation/widgets/glass_card.dart';

class EditarProductoScreen extends ConsumerStatefulWidget {
  final String id;
  const EditarProductoScreen({super.key, required this.id});

  @override
  ConsumerState<EditarProductoScreen> createState() =>
      _EditarProductoScreenState();
}

class _EditarProductoScreenState extends ConsumerState<EditarProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombre = TextEditingController();
  final _precio = TextEditingController();
  final _diagrama = TextEditingController();

  bool _esCaro = false;
  DateTime? _fechaCreacion = DateTime.now();
  bool _hydrated = false;
  bool _loading = false;
  String? _estadoSeleccionado;

  @override
  void dispose() {
    _nombre.dispose();
    _precio.dispose();
    _diagrama.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(productRepositoryProvider);

    setState(() => _loading = true);
    try {
      await repo.update(
        widget.id,
        ProductoUpdateModel(
          nombre: _nombre.text.trim(),
          precio: double.tryParse(_precio.text.trim()) ?? 0,
          esCaro: _esCaro,
          diagrama: _diagrama.text.trim(),
          fechaCreacion: _fechaCreacion ?? DateTime.now(),
           estado: _estadoSeleccionado ?? 'activo',
        ),
      );
      ref.invalidate(productosProvider);
      //ref.invalidate(productoByIdProvider(widget.id));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto actualizado con éxito')),
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
    final pAsync = ref.watch(productoByIdProvider(widget.id));
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final enableBlur = Platform.isIOS;

    return pAsync.when(
      loading:
          () => const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          ),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (p) {
        // Hidratar los datos solo una vez
        if (!_hydrated) {
          _nombre.text = p.nombre;
          _precio.text = p.precio.toString();
          _diagrama.text = p.diagrama;
          _esCaro = p.esCaro;
          _fechaCreacion = p.fechaCreacion ?? DateTime.now();
          _estadoSeleccionado = p.estado ?? 'activo';
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
                  context.go('/productos');
                }
              },
            ),
            title: const Text('Editar producto'),
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
                              'Editar producto',
                              style: text.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Modifica los datos del producto y guarda los cambios.',
                              style: text.bodyMedium?.copyWith(
                                color: cs.onBackground.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Formulario dentro del GlassCard
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

              // Loading overlay
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
          // Sección 1
          FormSection(
            title: 'Datos del producto',
            child: FormCard(
              child: Column(
                children: [
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

                  NumberInput(
                    controller: _precio,
                    label: 'Precio',
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

          // Sección 2
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
            title: 'Estado del producto',
            child: FormCard(
              child: Column(
                children: [
                  SelectInput<String>(
                    items: const ['activo', 'eliminado'],
                    value: _estadoSeleccionado,
                    onChanged: (v) => setState(() => _estadoSeleccionado = v),
                    itemLabel: (v) => v.toUpperCase(),
                    label: 'Estado',
                    equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Sección 3
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

          // Sección 4
          FormSection(
            title: 'Diagrama (JSON)',
            child: FormCard(child: JsonTextInput(controller: _diagrama)),
          ),

          const SizedBox(height: 30),

          // Botones
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
                              context.go('/productos');
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
