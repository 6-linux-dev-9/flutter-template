import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/core/di/providers/objeto_provider.dart';
import 'package:template_app/core/utils/date_format.dart';

import 'package:template_app/data/models/objeto/output/objeto_model.dart';
import 'package:template_app/presentation/widgets/empty_state.dart';
import 'package:template_app/presentation/widgets/error_state.dart';
import 'package:template_app/presentation/widgets/field_line.dart';

class ObjetoScreen extends ConsumerWidget {
  const ObjetoScreen({super.key});

  Future<void> _deleteObjeto(
    BuildContext context,
    WidgetRef ref,
    ObjetoModel o,
  ) async {
    final repo = ref.read(objetoRepositoryProvider);

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Eliminar objeto'),
            content: Text(
              '¿Seguro que deseas eliminar "${o.nombre.isNotEmpty ? o.nombre : 'este objeto'}"?\nEsta acción no se puede deshacer.',
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
      await repo.delete(o.id.toString());
      ref.invalidate(objetoProvider);
      messenger.showSnackBar(const SnackBar(content: Text('Objeto eliminado')));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objetos = ref.watch(objetoProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Objetos'), centerTitle: Platform.isIOS),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/objetos/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: objetos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => ErrorState(
              message: 'Error al cargar objetos',
              details: e.toString(),
              onRetry: () => ref.invalidate(objetoProvider),
            ),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              title: 'Sin Objetos aún',
              description: Text('Crea tu primer objeto para empezar.'),
              action: FilledButton.icon(
                onPressed: () => context.pushNamed('objetoNew'),
                icon: const Icon(Icons.cable),
                label: const Text('Crear Objeto'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(objetoProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final o = list[i];

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
                        // Encabezado dinámico
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: cs.primaryContainer,
                              child: Icon(
                                Icons.widgets_outlined,
                                color: cs.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                o.nombre.isNotEmpty
                                    ? o.nombre
                                    : 'Objeto #${o.id}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Campos principales
                        FieldLine(label: 'ID', value: o.id.toString()),
                        const SizedBox(height: 4),

                        if (o.nombre.isNotEmpty)
                          FieldLine(label: 'nombre', value: o.nombre),
                        const SizedBox(height: 4),

                        FieldLine(
                          label: 'valor_numerico',
                          value: o.valor_numerico.toStringAsFixed(2),
                        ),
                        const SizedBox(height: 4),

                        FieldLine(label: 'campo', value: o.campo),
                        const SizedBox(height: 4),

                        FieldLine(
                          label: 'valor_de_verdad',
                          value: o.valor_de_verdad ? 'Sí' : 'No',
                        ),
                        const SizedBox(height: 4),

                        FieldLine(
                          label: 'valor_entero',
                          value: o.valor_entero.toString(),
                        ),
                        const SizedBox(height: 4),

                        FieldLine(
                          label: 'diagrama',
                          value:
                              o.diagrama.length > 45
                                  ? o.diagrama.substring(0, 45) + '…'
                                  : o.diagrama,
                        ),
                        const SizedBox(height: 4),

                        FieldLine(
                          label: 'fecha_reserva',
                          value:
                              o.fecha_reserva != null
                                  ? o.fecha_reserva!.toPretty()
                                  : 'N/A',
                        ),

                        const SizedBox(height: 12),

                        // Botones de acción
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed:
                                    () => context.push('/objetos/${o.id}/edit'),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Editar'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: () => _deleteObjeto(context, ref, o),
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
