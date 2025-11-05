import 'package:flutter/material.dart';

class MultiSelectChips extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  const MultiSelectChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children:
          options.map((t) {
            final isSel = selected.contains(t);
            return ChoiceChip(
              label: Text(t),
              selected: isSel,
              avatar: isSel ? const Icon(Icons.check, size: 16) : null,
              onSelected: (_) {
                final next = Set<String>.from(selected);
                isSel ? next.remove(t) : next.add(t);
                onChanged(next);
              },
            );
          }).toList(),
    );
  }
}
