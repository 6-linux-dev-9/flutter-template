// import 'dart:convert';
// import 'package:flutter/material.dart';

// class JsonTextInput extends StatefulWidget {
//   final TextEditingController controller;
//   final String label;
//   const JsonTextInput({
//     super.key,
//     required this.controller,
//     this.label = 'Metadata (JSON)',
//   });

//   @override
//   State<JsonTextInput> createState() => _JsonTextInputState();
// }

// class _JsonTextInputState extends State<JsonTextInput> {
//   String? _error;

//   void _validateLive() {
//     final txt = widget.controller.text.trim();
//     if (txt.isEmpty) {
//       setState(() => _error = 'Requerido');
//       return;
//     }
//     try {
//       jsonDecode(txt);
//       if (_error != null) setState(() => _error = null);
//     } catch (e) {
//       setState(
//         () =>
//             _error =
//                 'JSON inválido: ${e is FormatException ? e.message : e.toString()}',
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(_validateLive);
//     _validateLive();
//   }

//   @override
//   void dispose() {
//     widget.controller.removeListener(_validateLive);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final isOk = _error == null;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: widget.controller,
//           minLines: 6,
//           maxLines: 16,
//           decoration: InputDecoration(
//             alignLabelWithHint: true,
//             hintText: '{ "key": "value" }',
//             prefixIcon: const Icon(Icons.data_object),
//             errorText: _error,
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: isOk ? Colors.transparent : cs.error,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 8,
//           children: [
//             OutlinedButton.icon(
//               icon: const Icon(Icons.format_align_left),
//               label: const Text('Formatear'),
//               onPressed: () {
//                 try {
//                   final obj = jsonDecode(widget.controller.text.trim());
//                   widget.controller.text = const JsonEncoder.withIndent(
//                     '  ',
//                   ).convert(obj);
//                 } catch (_) {}
//               },
//             ),
//             OutlinedButton.icon(
//               icon: const Icon(Icons.restore),
//               label: const Text('Ejemplo'),
//               onPressed: () {
//                 widget.controller.text = const JsonEncoder.withIndent(
//                   '  ',
//                 ).convert({
//                   "tags": ["new", "promo"],
//                   "meta": {"source": "catalog", "score": 0.98},
//                 });
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';

class JsonTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const JsonTextInput({
    super.key,
    required this.controller,
    this.label = 'Metadata (JSON)',
  });

  @override
  State<JsonTextInput> createState() => _JsonTextInputState();
}

class _JsonTextInputState extends State<JsonTextInput> {
  String? _error;

  void _validateLive() {
    final txt = widget.controller.text.trim();
    if (txt.isEmpty) {
      // Campo vacío: no marcar error (se considera válido)
      setState(() => _error = null);
      return;
    }
    try {
      jsonDecode(txt);
      if (_error != null) setState(() => _error = null);
    } catch (e) {
      setState(
        () =>
            _error =
                'JSON inválido: ${e is FormatException ? e.message : e.toString()}',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateLive);
    _validateLive();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateLive);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isOk = _error == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          minLines: 6,
          maxLines: 16,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            hintText: '{ "key": "value" }',
            prefixIcon: const Icon(Icons.data_object),
            errorText: _error,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isOk ? Colors.transparent : cs.error,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.format_align_left),
              label: const Text('Formatear'),
              onPressed: () {
                try {
                  final obj = jsonDecode(widget.controller.text.trim());
                  widget.controller.text = const JsonEncoder.withIndent(
                    '  ',
                  ).convert(obj);
                } catch (_) {}
              },
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.restore),
              label: const Text('Ejemplo'),
              onPressed: () {
                widget.controller.text = const JsonEncoder.withIndent(
                  '  ',
                ).convert({
                  "tags": ["new", "promo"],
                  "meta": {"source": "catalog", "score": 0.98},
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
