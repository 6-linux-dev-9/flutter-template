import 'package:flutter/material.dart';

class DateTimeInput extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String label;

  const DateTimeInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Fecha y hora',
  });

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: value ?? now,
    );
    if (d == null) return;

    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value ?? now),
    );
    if (t == null) return;

    onChanged(DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text =
        value == null ? 'YYYY-MM-DDTHH:mm:ss' : value!.toIso8601String();

    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: value == null ? cs.onSurfaceVariant : cs.onSurface,
            ),
          ),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.event),
          label: Text(
            'Elegir${value != null ? ' ('
                    '${TimeOfDay.fromDateTime(value!).format(context)})' : ''}',
          ),
          onPressed: () => _pick(context),
        ),
      ],
    );
  }
}
