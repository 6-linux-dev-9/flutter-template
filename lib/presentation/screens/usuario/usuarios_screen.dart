// lib/presentation/screens/usuario/usuarios_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/core/di/providers/user_provider.dart';
import 'package:template_app/data/models/usuario/output/user_model.dart';
import 'package:template_app/presentation/widgets/empty_state.dart';
import 'package:template_app/presentation/widgets/error_state.dart';
import 'package:template_app/presentation/widgets/field_line.dart';

class UsuariosScreen extends ConsumerWidget {
  const UsuariosScreen({super.key});

  Future<void> _deleteUser(
    BuildContext context,
    WidgetRef ref,
    UsuarioModel u,
  ) async {
    final repo = ref.read(userRepositoryProvider);

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Eliminar usuario'),
            content: Text(
              '¿Seguro que deseas eliminar a "${u.nombre}"?\nEsta acción no se puede deshacer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await repo.delete(u.id.toString());
      // refrescar lista
      ref.invalidate(usuariosProvider);
      messenger.showSnackBar(
        const SnackBar(content: Text('Usuario eliminado')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuarios = ref.watch(usuariosProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        centerTitle: Platform.isIOS, // sutil toque iOS
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/usuarios/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: usuarios.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => ErrorState(
              message: 'Error al cargar usuarios',
              details: e.toString(),
              onRetry: () => ref.invalidate(usuariosProvider),
            ),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              title: 'Sin usuarios aún',
              description: Text('Crea tu primer usuario para empezar.'),
              action: FilledButton.icon(
                onPressed: () => context.pushNamed('usuarioNew'),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Crear usuario'),
              ),
            );
          }

          // Pull-to-refresh
          return RefreshIndicator(
            onRefresh: () => ref.refresh(usuariosProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final u = list[i] as UsuarioModel;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado con icono y nombre
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: cs.primaryContainer,
                              child: Icon(
                                Icons.person,
                                color: cs.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                u.nombre,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Campos “Nombre: … / Email: …”
                        FieldLine(label: 'Nombre', value: u.nombre),
                        const SizedBox(height: 4),
                        FieldLine(label: 'Email', value: u.email),

                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed:
                                    () =>
                                        context.push('/usuarios/${u.id}/edit'),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Editar'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: () => _deleteUser(context, ref, u),
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Eliminar'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// class _FieldLine extends StatelessWidget {
//   final String label;
//   final String value;
//   const _FieldLine({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     final onBg = Theme.of(context).colorScheme.onSurface.withOpacity(0.75);
//     return RichText(
//       text: TextSpan(
//         style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.25),
//         children: [
//           TextSpan(
//             text: '$label: ',
//             style: const TextStyle(fontWeight: FontWeight.w600),
//           ),
//           TextSpan(text: value, style: TextStyle(color: onBg)),
//         ],
//       ),
//     );
//     // Si prefieres SelectableText:
//     // return SelectableText.rich(...)
//   }
// }

// class _EmptyState extends StatelessWidget {
//   final VoidCallback onCreate;
//   const _EmptyState({required this.onCreate});

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

// class _ErrorState extends StatelessWidget {
//   final String message;
//   final String? details;
//   final VoidCallback onRetry;
//   const _ErrorState({
//     required this.message,
//     this.details,
//     required this.onRetry,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.error_outline, size: 64, color: cs.error),
//             const SizedBox(height: 12),
//             Text(message, style: Theme.of(context).textTheme.titleMedium),
//             if (details != null) ...[
//               const SizedBox(height: 6),
//               Text(
//                 details!,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
//               ),
//             ],
//             const SizedBox(height: 16),
//             OutlinedButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Reintentar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
