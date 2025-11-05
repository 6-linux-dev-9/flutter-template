import 'package:flutter/material.dart';

typedef ItemToString<T> = String Function(T item);
typedef ItemEquals<T> = bool Function(T a, T b);

class SelectInput<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String label;
  final ItemToString<T> itemLabel;
  final ItemEquals<T>? equals;

  const SelectInput({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
    this.label = 'Selecciona',
    this.equals,
  });

  @override
  Widget build(BuildContext context) {
    bool _eq(T? a, T? b) {
      if (equals != null)
        return (a != null && b != null) ? equals!(a, b) : a == b;
      return a == b;
    }

    return DropdownButtonFormField<T>(
      value: items.where((e) => _eq(e, value)).isNotEmpty ? value : null,
      items:
          items
              .map((e) => DropdownMenuItem(value: e, child: Text(itemLabel(e))))
              .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}
