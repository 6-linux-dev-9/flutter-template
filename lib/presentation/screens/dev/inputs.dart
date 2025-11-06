

// lib/presentation/screens/inputs_catalog_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// helpers
import 'package:template_app/presentation/forms/form_card.dart';
import 'package:template_app/presentation/forms/form_section.dart';

// inputs
import 'package:template_app/presentation/forms/inputs/date_time_input.dart';
import 'package:template_app/presentation/forms/inputs/number_input.dart';
import 'package:template_app/presentation/forms/inputs/boolean_switch.dart';
import 'package:template_app/presentation/forms/inputs/json_text_input.dart';
import 'package:template_app/presentation/forms/inputs/select_input.dart';
import 'package:template_app/presentation/forms/inputs/multiselect_chips.dart';
import 'package:template_app/presentation/forms/inputs/autocomplete_input.dart';
import 'package:template_app/presentation/forms/inputs/input_image_picker.dart';

class InputsCatalogScreen extends StatefulWidget {
  const InputsCatalogScreen({super.key});
  @override
  State<InputsCatalogScreen> createState() => _InputsCatalogScreenState();
}

class _InputsCatalogScreenState extends State<InputsCatalogScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _createdAt;
  final _numberCtrl = TextEditingController();
  bool _isActive = true;

  final _jsonCtrl = TextEditingController(text: '{\n  "key": "value"\n}');

  final _roles = const ['Admin', 'Editor', 'Viewer'];
  String? _role = 'Admin';

  final _tags = const ['new', 'hot', 'promo', 'draft'];
  Set<String> _selectedTags = {'new'};

  final _cities = const [
    'Santa Cruz de la Sierra',
    'Cochabamba',
    'La Paz',
    'Tarija',
    'Potosí',
    'Oruro',
    'Sucre',
    'Beni',
    'Pando',
  ];
  String? _city;

  List<XFile> _images = const [];
  List<XFile> _avatar = const [];

  String? _validateNumber(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Requerido';
    final n = num.tryParse(s);
    if (n == null) return 'Debe ser numérico';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Revisa los campos')));
      return;
    }
    int? len(XFile x) =>
        null; // si quieres calcular bytes, haz await x.length()

    final payload = {
      'createdAt': (_createdAt ?? DateTime.now()).toIso8601String(),
      'amount': num.parse(_numberCtrl.text.trim()),
      'active': _isActive,
      'metadata': jsonDecode(_jsonCtrl.text.trim()),
      'role': _role,
      'tags': _selectedTags.toList(),
      'city': _city,
      'images':
          _images
              .map((x) => {'name': x.name, 'path': x.path, 'length': len(x)})
              .toList(),
      'avatar':
          _avatar.isEmpty
              ? null
              : {'name': _avatar.first.name, 'path': _avatar.first.path},
    };

    debugPrint(const JsonEncoder.withIndent('  ').convert(payload));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payload listo (ver consola)')),
    );
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _jsonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Inputs')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              FormSection(
                title: 'Fechas / LocalDateTime (ISO-8601)',
                child: FormCard(
                  child: DateTimeInput(
                    value: _createdAt,
                    onChanged: (v) => setState(() => _createdAt = v),
                  ),
                ),
              ),
              FormSection(
                title: 'Numérico',
                child: FormCard(
                  child: NumberInput(
                    controller: _numberCtrl,
                    validator: _validateNumber,
                  ),
                ),
              ),
              FormSection(
                title: 'Boolean',
                child: FormCard(
                  child: BooleanSwitch(
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                  ),
                ),
              ),
              FormSection(
                title: 'JSON (validación en vivo)',
                child: FormCard(child: JsonTextInput(controller: _jsonCtrl)),
              ),
              FormSection(
                title: 'ComboBox (genérico <T>)',
                child: FormCard(
                  child: SelectInput<String>(
                    items: _roles,
                    value: _role,
                    itemLabel: (s) => s,
                    onChanged: (v) => setState(() => _role = v),
                    label: 'Rol',
                  ),
                ),
              ),
              FormSection(
                title: 'MultiSelect (chips)',
                child: FormCard(
                  child: MultiSelectChips(
                    options: _tags,
                    selected: _selectedTags,
                    onChanged: (s) => setState(() => _selectedTags = s),
                  ),
                ),
              ),
              FormSection(
                title: 'Imagen única (avatar / portada)',
                child: FormCard(
                  child: InputImagePicker(
                    multiple: false,
                    label: 'Seleccionar avatar',
                    helper: '1 imagen máx. · Cámara o galería',
                    onChanged: (files) => setState(() => _avatar = files),
                    maxCount: 1,
                  ),
                ),
              ),
              FormSection(
                title: 'Imágenes múltiples (galería)',
                child: FormCard(
                  child: InputImagePicker(
                    multiple: true,
                    label: 'Galería',
                    helper: 'Hasta 10 imágenes',
                    onChanged: (files) => setState(() => _images = files),
                    maxCount: 10,
                  ),
                ),
              ),
              FormSection(
                title: 'Autocomplete',
                child: FormCard(
                  child: AutocompleteInput(
                    options: _cities,
                    value: _city,
                    onSelected: (v) => setState(() => _city = v),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Generar payload de ejemplo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
