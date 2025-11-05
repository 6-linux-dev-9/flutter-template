import 'package:flutter/material.dart';

class AutocompleteInput extends StatelessWidget {
  final List<String> options;
  final String? value;
  final ValueChanged<String> onSelected;
  final String label;
  final String hint;

  const AutocompleteInput({
    super.key,
    required this.options,
    required this.onSelected,
    this.value,
    this.label = 'Ciudad',
    this.hint = 'Busca…',
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: value != null ? TextEditingValue(text: value!) : null,
      optionsBuilder: (TextEditingValue tev) {
        final q = tev.text.trim().toLowerCase();
        if (q.isEmpty) return const Iterable<String>.empty();
        return options.where((c) => c.toLowerCase().contains(q));
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
          onFieldSubmitted: (_) => onFieldSubmitted(),
        );
      },
      onSelected: onSelected,
      optionsViewBuilder: (context, onSel, opts) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240, maxWidth: 420),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: opts.length,
                itemBuilder: (_, i) {
                  final opt = opts.elementAt(i);
                  return ListTile(title: Text(opt), onTap: () => onSel(opt));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
