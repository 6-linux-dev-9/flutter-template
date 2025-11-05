// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:template_app/presentation/forms/input_image_picker.dart';

// /// Pantalla catálogo de inputs genéricos.
// /// Muestra cómo capturar/validar:
// /// - LocalDateTime (Date + Time) en ISO-8601
// /// - Numérico (int/double)
// /// - Boolean (Switch)
// /// - JSON (validación en vivo)
// /// - ComboBox (Dropdown)
// /// - MultiSelect (ChoiceChips)
// /// - Autocomplete (búsqueda)
// class InputsCatalogScreen extends StatefulWidget {
//   const InputsCatalogScreen({super.key});

//   @override
//   State<InputsCatalogScreen> createState() => _InputsCatalogScreenState();
// }

// class _InputsCatalogScreenState extends State<InputsCatalogScreen> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers / states
//   DateTime? _createdAt;
//   final _numberCtrl = TextEditingController();
//   bool _isActive = true;

//   final _jsonCtrl = TextEditingController(text: '{\n  "key": "value"\n}');
//   String? _jsonError;

//   // Dropdown simple
//   final _options = const ['Admin', 'Editor', 'Viewer'];
//   String? _role;

//   // MultiSelect (chips)
//   final _tags = const ['new', 'hot', 'promo', 'draft'];
//   final Set<String> _selectedTags = {'new'};

//   List<XFile> _images = const [];
//   List<XFile> _avatar = const []; // imagen única
//   // Autocomplete
//   final _cities = const [
//     'Santa Cruz de la Sierra',
//     'Cochabamba',
//     'La Paz',
//     'Tarija',
//     'Potosí',
//     'Oruro',
//     'Sucre',
//     'Beni',
//     'Pando',
//   ];
//   String? _city;

//   @override
//   void initState() {
//     super.initState();
//     _role = _options.first;
//     _jsonCtrl.addListener(_validateJsonLive);
//   }

//   @override
//   void dispose() {
//     _numberCtrl.dispose();
//     _jsonCtrl.removeListener(_validateJsonLive);
//     _jsonCtrl.dispose();
//     super.dispose();
//   }

//   // ---- Helpers --------------------------------------------------------------

//   void _validateJsonLive() {
//     final txt = _jsonCtrl.text.trim();
//     if (txt.isEmpty) {
//       setState(() => _jsonError = 'Requerido');
//       return;
//     }
//     try {
//       jsonDecode(txt);
//       if (_jsonError != null) setState(() => _jsonError = null);
//     } catch (e) {
//       setState(
//         () =>
//             _jsonError =
//                 'JSON inválido: ${e is FormatException ? e.message : e.toString()}',
//       );
//     }
//   }

//   Future<void> _pickLocalDateTime(BuildContext context) async {
//     final now = DateTime.now();
//     final d = await showDatePicker(
//       context: context,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       initialDate: _createdAt ?? now,
//     );
//     if (d == null) return;

//     final t = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(_createdAt ?? now),
//     );
//     if (t == null) return;

//     final dt = DateTime(d.year, d.month, d.day, t.hour, t.minute);
//     setState(() => _createdAt = dt);
//   }

//   String _isoOrHint(DateTime? dt) =>
//       dt == null ? 'YYYY-MM-DDTHH:mm:ss' : dt.toIso8601String();

//   String? _validateNumber(String? v) {
//     final s = (v ?? '').trim();
//     if (s.isEmpty) return 'Requerido';
//     final n = num.tryParse(s);
//     if (n == null) return 'Debe ser numérico';
//     return null;
//   }

//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate() || _jsonError != null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Revisa los campos')));
//       return;
//     }

//      Future<Map<String, dynamic>> _fileSummary(XFile x) async {
//       int? len;
//       try {
//         len = await x.length(); // en web funciona también
//       } catch (_) {
//         len = null;
//       }
//       return {
//         'name': x.name,
//         'path': x.path, // en web puede venir vacío
//         'length': len, // bytes, si se pudo leer
//       };
//     }

//     final imagesSummary = await Future.wait(_images.map(_fileSummary));
//     final avatarSummary =
//         _avatar.isEmpty ? null : await _fileSummary(_avatar.first);

//     final payload = <String, dynamic>{
//       // LocalDateTime estilo backend Java: ISO8601
//       'createdAt': (_createdAt ?? DateTime.now()).toIso8601String(),

//       // numérico (decide int/double según tu backend)
//       'amount': num.parse(_numberCtrl.text.trim()),

//       // boolean
//       'active': _isActive,

//       // json (ya validado)
//       'metadata': jsonDecode(_jsonCtrl.text.trim()),

//       // combo
//       'role': _role,

//       // multi-select
//       'tags': _selectedTags.toList(),

//       // autocomplete
//       'city': _city,
//     };

//     final pretty = const JsonEncoder.withIndent('  ').convert(payload);
//     debugPrint(pretty);


//     // --- arriba junto a los demás estad
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Payload listo (ver consola)')),
//     );
//   }

//   // ---- UI -------------------------------------------------------------------

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Catálogo de Inputs'),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//             children: [
//               _Section(
//                 title: 'Fechas / LocalDateTime (ISO-8601)',
//                 child: _dateCard(cs),
//               ),
//               _Section(title: 'Numérico', child: _numberCard()),
//               _Section(title: 'Boolean', child: _boolCard()),
//               _Section(
//                 title: 'JSON (validación en vivo)',
//                 child: _jsonCard(cs),
//               ),
//               _Section(title: 'ComboBox', child: _comboCard()),
//               _Section(title: 'MultiSelect (chips)', child: _chipsCard(cs)),
//               _Section(
//                 title: 'Imagen única (avatar / portada)',
//                 child: _Card(
//                   child: InputImagePicker(
//                     multiple: false,
//                     label: 'Seleccionar avatar',
//                     helper: '1 imagen máx. · Cámara o galería',
//                     onChanged: (files) => setState(() => _avatar = files),
//                     maxCount: 1,
//                   ),
//                 ),
//               ),

//               _Section(
//                 title: 'Imágenes múltiples (galería)',
//                 child: _Card(
//                   child: InputImagePicker(
//                     multiple: true,
//                     label: 'Galería',
//                     helper: 'Hasta 10 imágenes',
//                     onChanged: (files) => setState(() => _images = files),
//                     maxCount: 10,
//                   ),
//                 ),
//               ),

//               _Section(title: 'Autocomplete', child: _autocompleteCard()),
//               const SizedBox(height: 12),
//               FilledButton.icon(
//                 onPressed: _save,
//                 icon: const Icon(Icons.save_outlined),
//                 label: const Text('Generar payload de ejemplo'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _dateCard(ColorScheme cs) {
//     return _Card(
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               _isoOrHint(_createdAt),
//               style: TextStyle(
//                 color: _createdAt == null ? cs.onSurfaceVariant : cs.onSurface,
//               ),
//             ),
//           ),
//           OutlinedButton.icon(
//             icon: const Icon(Icons.event),
//             label: const Text('Elegir'),
//             onPressed: () => _pickLocalDateTime(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _numberCard() {
//     return _Card(
//       child: TextFormField(
//         controller: _numberCtrl,
//         keyboardType: const TextInputType.numberWithOptions(
//           decimal: true,
//           signed: false,
//         ),
//         inputFormatters: [
//           FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')),
//           TextInputFormatter.withFunction((oldValue, newValue) {
//             // Normaliza coma a punto
//             final t = newValue.text.replaceAll(',', '.');
//             return newValue.copyWith(
//               text: t,
//               selection: TextSelection.collapsed(offset: t.length),
//             );
//           }),
//         ],
//         decoration: const InputDecoration(
//           labelText: 'Amount',
//           hintText: 'Ej. 123.45',
//           prefixIcon: Icon(Icons.pin_outlined),
//         ),
//         validator: _validateNumber,
//       ),
//     );
//   }

//   Widget _boolCard() {
//     return _Card(
//       child: SwitchListTile(
//         title: const Text('Activo'),
//         value: _isActive,
//         onChanged: (v) => setState(() => _isActive = v),
//       ),
//     );
//   }

//   Widget _jsonCard(ColorScheme cs) {
//     final isOk = _jsonError == null;
//     return _Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Metadata (JSON)',
//             style: Theme.of(context).textTheme.labelLarge,
//           ),
//           const SizedBox(height: 8),
//           TextFormField(
//             controller: _jsonCtrl,
//             minLines: 6,
//             maxLines: 16,
//             decoration: InputDecoration(
//               alignLabelWithHint: true,
//               hintText: '{ "key": "value" }',
//               prefixIcon: const Icon(Icons.data_object),
//               errorText: _jsonError,
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: isOk ? Colors.transparent : cs.error,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 8,
//             children: [
//               OutlinedButton.icon(
//                 icon: const Icon(Icons.format_align_left),
//                 label: const Text('Formatear'),
//                 onPressed: () {
//                   try {
//                     final obj = jsonDecode(_jsonCtrl.text.trim());
//                     _jsonCtrl.text = const JsonEncoder.withIndent(
//                       '  ',
//                     ).convert(obj);
//                   } catch (_) {
//                     /* ya se muestra el error en vivo */
//                   }
//                 },
//               ),
//               OutlinedButton.icon(
//                 icon: const Icon(Icons.restore),
//                 label: const Text('Ejemplo'),
//                 onPressed: () {
//                   _jsonCtrl.text = const JsonEncoder.withIndent('  ').convert({
//                     "tags": ["new", "promo"],
//                     "meta": {"source": "catalog", "score": 0.98},
//                   });
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _comboCard() {
//     return _Card(
//       child: DropdownButtonFormField<String>(
//         value: _role,
//         items:
//             _options
//                 .map((o) => DropdownMenuItem(value: o, child: Text(o)))
//                 .toList(),
//         onChanged: (v) => setState(() => _role = v),
//         decoration: const InputDecoration(
//           labelText: 'Rol',
//           prefixIcon: Icon(Icons.security_outlined),
//         ),
//       ),
//     );
//   }

//   Widget _chipsCard(ColorScheme cs) {
//     return _Card(
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 4,
//         children:
//             _tags.map((t) {
//               final selected = _selectedTags.contains(t);
//               return ChoiceChip(
//                 label: Text(t),
//                 selected: selected,
//                 avatar: selected ? const Icon(Icons.check, size: 16) : null,
//                 onSelected: (_) {
//                   setState(() {
//                     if (selected) {
//                       _selectedTags.remove(t);
//                     } else {
//                       _selectedTags.add(t);
//                     }
//                   });
//                 },
//               );
//             }).toList(),
//       ),
//     );
//   }

//   Widget _autocompleteCard() {
//     return _Card(
//       child: Autocomplete<String>(
//         initialValue: _city != null ? TextEditingValue(text: _city!) : null,
//         optionsBuilder: (TextEditingValue textEditingValue) {
//           final q = textEditingValue.text.trim().toLowerCase();
//           if (q.isEmpty) return const Iterable<String>.empty();
//           return _cities.where((c) => c.toLowerCase().contains(q));
//         },
//         fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
//           return TextFormField(
//             controller: controller,
//             focusNode: focusNode,
//             decoration: const InputDecoration(
//               labelText: 'Ciudad',
//               hintText: 'Busca…',
//               prefixIcon: Icon(Icons.location_on_outlined),
//             ),
//             onFieldSubmitted: (_) => onFieldSubmitted(),
//           );
//         },
//         onSelected: (value) => setState(() => _city = value),
//         optionsViewBuilder: (context, onSelected, options) {
//           return Align(
//             alignment: Alignment.topLeft,
//             child: Material(
//               elevation: 4,
//               borderRadius: BorderRadius.circular(12),
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(
//                   maxHeight: 240,
//                   maxWidth: 420,
//                 ),
//                 child: ListView.builder(
//                   padding: EdgeInsets.zero,
//                   itemCount: options.length,
//                   itemBuilder: (_, i) {
//                     final opt = options.elementAt(i);
//                     return ListTile(
//                       title: Text(opt),
//                       onTap: () => onSelected(opt),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ----- UI helpers -----

// class _Section extends StatelessWidget {
//   final String title;
//   final Widget child;
//   const _Section({required this.title, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     final text = Theme.of(context).textTheme;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
//           ),
//           const SizedBox(height: 8),
//           child,
//         ],
//       ),
//     );
//   }
// }

// class _Card extends StatelessWidget {
//   final Widget child;
//   const _Card({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 1.5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: Padding(padding: const EdgeInsets.all(12), child: child),
//     );
//   }
// }


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
