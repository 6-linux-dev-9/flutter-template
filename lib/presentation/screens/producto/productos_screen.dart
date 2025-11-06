import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/core/di/providers/product_provider.dart';
import 'package:template_app/core/utils/date_format.dart';

import 'package:template_app/data/models/producto/output/producto_model.dart';
import 'package:template_app/presentation/widgets/empty_state.dart';
import 'package:template_app/presentation/widgets/error_state.dart';
import 'package:template_app/presentation/widgets/field_line.dart';

class ProductosScreen extends ConsumerWidget {
  const ProductosScreen({super.key});

  Future<void> _deleteProducto(
    BuildContext context,
    WidgetRef ref,
    ProductoModel p,
  ) async {
    final repo = ref.read(productRepositoryProvider);

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Eliminar producto'),
            content: Text(
              '¿Seguro que deseas eliminar "${p.nombre}"?\nEsta acción no se puede deshacer.',
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
      await repo.delete(p.id.toString());
      ref.invalidate(productosProvider);
      messenger.showSnackBar(
        const SnackBar(content: Text('Producto eliminado')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productos = ref.watch(productosProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        centerTitle: Platform.isIOS,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/productos/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: productos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => ErrorState(
              message: 'Error al cargar productos',
              details: e.toString(),
              onRetry: () => ref.invalidate(productosProvider),
            ),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              title: 'Sin Productos aún',
              description: Text('Crea tu primer Producto para empezar.'),
              action: FilledButton.icon(
                onPressed: () => context.pushNamed('productoNew'),
                icon: const Icon(Icons.power_rounded),
                label: const Text('Crear Producto'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(productosProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final p = list[i];

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
                        // Header
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: cs.primaryContainer,
                              child: Icon(
                                Icons.inventory_2_outlined,
                                color: cs.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                p.nombre,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Campos
                        // Campos
                        FieldLine(label: 'Nombre', value: p.nombre),
                        const SizedBox(height: 4),

                        FieldLine(label: 'Precio', value: '${p.precio} Bs'),
                        const SizedBox(height: 4),

                        FieldLine(
                          label: '¿Es caro?',
                          value: p.esCaro ? 'Sí' : 'No',
                        ),
                        const SizedBox(height: 4),

                        FieldLine(
                          label: 'Diagrama',
                          value:
                              p.diagrama.length > 45
                                  ? p.diagrama.substring(0, 45) + '…'
                                  : p.diagrama,
                        ),
                        FieldLine(
                          label: 'Fecha de Creación',
                          value: p.fechaCreacion.toPretty(),
                        ),


                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed:
                                    () =>
                                        context.push('/productos/${p.id}/edit'),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Editar'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed:
                                    () => _deleteProducto(context, ref, p),
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Eliminar'),
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
//             Icon(Icons.inventory_2_outlined, size: 64, color: cs.outline),
//             const SizedBox(height: 12),
//             Text(
//               'Sin productos aún',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 6),
//             Text(
//               'Agrega tu primer producto.',
//               style: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
//             ),
//             const SizedBox(height: 16),
//             FilledButton.icon(
//               onPressed: onCreate,
//               icon: const Icon(Icons.add),
//               label: const Text('Crear producto'),
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
