// import 'package:flutter/material.dart';

// class EmptyState extends StatelessWidget {
//   final VoidCallback onCreate;
//   const EmptyState({super.key, required this.onCreate});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.group_outlined, size: 64, color: cs.outline),
//             const SizedBox(height: 12),
//             Text(
//               'Sin usuarios aún',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 6),
//             Text(
//               'Crea tu primer usuario para empezar.',
//               style: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
//             ),
//             const SizedBox(height: 16),
//             FilledButton.icon(
//               onPressed: onCreate,
//               icon: const Icon(Icons.person_add_alt_1),
//               label: const Text('Crear usuario'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title; // Ej: "Sin usuarios aún"
  final Widget? description; // Texto explicativo personalizado
  final Widget? action; // Botón personalizado
  final IconData? icon; // Ícono principal (por defecto uno genérico)

  const EmptyState({
    super.key,
    required this.title,
    this.description,
    this.action,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.inbox_outlined, size: 64, color: cs.outline),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 6),
              DefaultTextStyle.merge(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                child: description!,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
