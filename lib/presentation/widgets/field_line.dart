import 'package:flutter/material.dart';

class FieldLine extends StatelessWidget {
  final String label;
  final String value;
  const FieldLine({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final onBg = Theme.of(context).colorScheme.onSurface.withOpacity(0.75);
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.25),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value, style: TextStyle(color: onBg)),
        ],
      ),
    );
    // Si prefieres SelectableText:
    // return SelectableText.rich(...)
  }
}
