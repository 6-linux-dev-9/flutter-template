import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:template_app/core/di/providers/objeto_provider.dart';
import 'package:template_app/data/models/objeto/input/objeto_create_model.dart';
import 'package:template_app/presentation/forms/form_card.dart';
import 'package:template_app/presentation/forms/form_section.dart';
import 'package:template_app/presentation/forms/inputs/boolean_switch.dart';
import 'package:template_app/presentation/forms/inputs/date_time_input.dart';
import 'package:template_app/presentation/forms/inputs/json_text_input.dart';
import 'package:template_app/presentation/forms/inputs/number_input.dart';
import 'package:template_app/presentation/widgets/glass_card.dart';

class CrearObjetoScreen extends ConsumerStatefulWidget {
  const CrearObjetoScreen({super.key});

  @override
  ConsumerState<CrearObjetoScreen> createState() => _CrearObjetoScreenState();
}

class _CrearObjetoScreenState extends ConsumerState<CrearObjetoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final _nombre = TextEditingController();
  final _valor_numerico = TextEditingController();
  final _diagrama = TextEditingController();
  final _campo = TextEditingController();
  final _valor_entero = TextEditingController();

  // Variables de tipo lógico y fecha
  bool _valor_de_verdad = false;
  DateTime? _fecha_reserva = DateTime.now();
  bool _loading = false;

  @override
  void dispose() {
    _nombre.dispose();
    _valor_numerico.dispose();
    _diagrama.dispose();
    _campo.dispose();
    _valor_entero.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(objetoRepositoryProvider);

    setState(() => _loading = true);
    try {
      await repo.create(
        ObjetoCreateModel(
          nombre: _nombre.text.trim(),
          valor_numerico: double.tryParse(_valor_numerico.text.trim()) ?? 0.0,
          diagrama: _diagrama.text.trim(),
          fecha_reserva: _fecha_reserva,
          valor_de_verdad: _valor_de_verdad,
          campo: _campo.text.trim(),
          valor_entero: int.tryParse(_valor_entero.text.trim()) ?? 0,
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Objeto creado con éxito')));
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
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: const Text('Nuevo objeto'),
      ),
      body: Stack(
        children: [
          // Fondo degradado
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
                        // Encabezado
                        Text(
                          'Crear objeto',
                          style: text.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Registra un nuevo objeto con sus atributos.',
                          style: text.bodyMedium?.copyWith(
                            color: cs.onBackground.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Card translúcida con efecto blur opcional
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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= DATOS PRINCIPALES =================
          FormSection(
            title: 'Datos del objeto',
            child: FormCard(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombre,
                    decoration: const InputDecoration(
                      labelText: 'nombre',
                      prefixIcon: Icon(Icons.text_fields),
                    ),
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Requerido'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _campo,
                    decoration: const InputDecoration(
                      labelText: 'campo',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Requerido'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  NumberInput(
                    controller: _valor_numerico,
                    label: 'valor_numerico',
                  ),
                  const SizedBox(height: 16),
                  NumberInput(controller: _valor_entero, label: 'valor_entero'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ================= OPCIONES Y FECHA =================
          FormSection(
            title: 'Opciones y fecha',
            child: FormCard(
              child: Column(
                children: [
                  BooleanSwitch(
                    value: _valor_de_verdad,
                    label: 'valor_de_verdad',
                    onChanged: (v) => setState(() => _valor_de_verdad = v),
                  ),
                  const SizedBox(height: 16),
                  DateTimeInput(
                    value: _fecha_reserva,
                    onChanged: (v) => setState(() => _fecha_reserva = v),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ================= DIAGRAMA =================
          FormSection(
            title: 'Diagrama (JSON)',
            child: FormCard(child: JsonTextInput(controller: _diagrama)),
          ),

          const SizedBox(height: 30),

          // ================= BOTONES =================
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
                              context.go('/objetos');
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
