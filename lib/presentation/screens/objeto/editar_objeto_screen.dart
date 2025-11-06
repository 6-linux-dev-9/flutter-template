import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:template_app/core/di/providers/objeto_provider.dart';
import 'package:template_app/core/di/providers/user_provider.dart';
import 'package:template_app/data/models/objeto/input/objeto_update_model.dart';
import 'package:template_app/data/models/usuario/output/user_model.dart';
import 'package:template_app/presentation/forms/form_card.dart';
import 'package:template_app/presentation/forms/form_section.dart';
import 'package:template_app/presentation/forms/inputs/boolean_switch.dart';
import 'package:template_app/presentation/forms/inputs/date_time_input.dart';
import 'package:template_app/presentation/forms/inputs/json_text_input.dart';
import 'package:template_app/presentation/forms/inputs/number_input.dart';
import 'package:template_app/presentation/forms/inputs/select_input.dart';
import 'package:template_app/presentation/forms/inputs/select_input_modified.dart';
import 'package:template_app/presentation/widgets/glass_card.dart';

class EditarObjetoScreen extends ConsumerStatefulWidget {
  final String id;
  const EditarObjetoScreen({super.key, required this.id});

  @override
  ConsumerState<EditarObjetoScreen> createState() => _EditarObjetoScreenState();
}

class _EditarObjetoScreenState extends ConsumerState<EditarObjetoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nombre = TextEditingController();
  final _valor_numerico = TextEditingController();
  final _diagrama = TextEditingController();
  final _campo = TextEditingController();
  final _valor_entero = TextEditingController();

  bool _valor_de_verdad = false;
  DateTime? _fecha_reserva = DateTime.now();
  bool _hydrated = false;
  bool _loading = false;
  String? _estadoSeleccionado;
  dynamic _usuarioSeleccionado;
  
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
      await repo.update(
        widget.id,
        ObjetoUpdateModel(
          nombre: _nombre.text.trim(),
          valor_numerico: double.tryParse(_valor_numerico.text.trim()) ?? 0.0,
          diagrama: _diagrama.text.trim(),
          fecha_reserva: _fecha_reserva,
          valor_de_verdad: _valor_de_verdad,
          campo: _campo.text.trim(),
          valor_entero: int.tryParse(_valor_entero.text.trim()) ?? 0,
         usuario_id: _usuarioSeleccionado?.id,
         estado: _estadoSeleccionado ?? 'activo'
        ),
      );
      ref.invalidate(objetoProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Objeto actualizado con éxito')),
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
    final objetoAsync = ref.watch(objetoByIdProvider(widget.id));
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final enableBlur = Platform.isIOS;

    return objetoAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (o) {
        // Precargar datos una sola vez
        if (!_hydrated) {
          _nombre.text = o.nombre;
          _valor_numerico.text = o.valor_numerico.toString();
          _diagrama.text = o.diagrama;
          _campo.text = o.campo;
          _valor_entero.text = o.valor_entero.toString();
          _valor_de_verdad = o.valor_de_verdad;
          _fecha_reserva = o.fecha_reserva ?? DateTime.now();
           if (o.usuario_id != null) {
            final usuariosAsync = ref.read(usuariosProvider);
            usuariosAsync.whenData((usuarios) {
              final seleccionado = usuarios.firstWhere(
                (u) => u.id == o.usuario_id,
               // orElse: () => null,
              );
              if (mounted) setState(() => _usuarioSeleccionado = seleccionado);
            });
          }
          _estadoSeleccionado = o.estado ?? 'activo';
          _hydrated = true;
          

        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text('Editar objeto'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
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
                              'Editar objeto',
                              style: text.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Modifica los atributos del objeto seleccionado.',
                              style: text.bodyMedium?.copyWith(
                                color: cs.onBackground.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // GlassCard principal
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
      },
    );
  }

  Widget _form() {
    final cs = Theme.of(context).colorScheme;
    final usuariosAsync = ref.watch(usuariosProvider);


    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =============== DATOS PRINCIPALES ===============
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

          // =============== OPCIONES Y FECHA ===============
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
                  ),
                  
                ],
              ),
            ),
          ),

          FormSection(
            title: 'Usuario asociado',
            child: FormCard(
              child: usuariosAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error al cargar usuarios: $e'),
                data:
                    (usuarios) => SelectInputModified<UsuarioModel>(
                      items: usuarios,
                      value: _usuarioSeleccionado,
                      onChanged:
                          (u) => setState(() => _usuarioSeleccionado = u),
                      itemLabel: (u) => u.toStringModified(),
                      label: 'Selecciona un usuario',
                    ),
              ),
            ),
          ),


          const SizedBox(height: 16),

          // =============== DIAGRAMA JSON ===============
          FormSection(
            title: 'Diagrama (JSON)',
            child: FormCard(child: JsonTextInput(controller: _diagrama)),
          ),

          const SizedBox(height: 30),

          // =============== BOTONES ===============
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
