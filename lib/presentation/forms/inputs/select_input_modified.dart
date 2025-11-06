import 'package:flutter/material.dart';

typedef ItemToString<T> = String Function(T item);
typedef ItemEquals<T> = bool Function(T a, T b);

class SelectInputModified<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String label;
  final ItemToString<T> itemLabel;
  final ItemEquals<T>? equals;
  final String? hintText;
  final bool allowNull;

  const SelectInputModified({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
    this.label = 'Selecciona',
    this.equals,
    this.hintText,
    this.allowNull = true,
  });

  @override
  Widget build(BuildContext context) {
    bool _eq(T? a, T? b) {
      if (equals != null)
        return (a != null && b != null) ? equals!(a, b) : a == b;
      return a == b;
    }

    final allItems = allowNull ? [null, ...items] : items;

    return DropdownButtonFormField<T>(
      isExpanded: true,
      value: items.where((e) => _eq(e, value)).isNotEmpty ? value : null,
      items:
          allItems
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    e == null ? (hintText ?? 'Ninguno') : itemLabel(e),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.person_outline),
      ),
    );
  }
}
