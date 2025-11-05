// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            tooltip: 'Ir a Usuarios',
            onPressed: () => context.pushNamed('usuarios'),
            icon: const Icon(Icons.group),
          ),
          IconButton(
            tooltip: 'Ir a Productos',
            onPressed: () {
              // context.pushNamed('productos'); // cuando exista la ruta
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Módulo productos no disponible')),
              );
            },
            icon: const Icon(Icons.inventory_2),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + buscador
              Text(
                'Panel principal',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: Sizes.p16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar (usuarios, productos)…',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (q) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Buscar: $q')));
                },
              ),
              const SizedBox(height: Sizes.p24),

              // Acciones rápidas
              Wrap(
                spacing: Sizes.p16,
                runSpacing: Sizes.p16,
                children: [
                  _QuickAction(
                    label: 'Nuevo usuario',
                    icon: Icons.person_add,
                    onTap: () => context.pushNamed('usuarioNew'),
                  ),
                  _QuickAction(
                    label: 'Nuevo producto',
                    icon: Icons.add_box,
                    onTap: () {
                      // context.pushNamed('productoNew'); // cuando exista
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Crear producto no disponible'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: Sizes.p24),

              // Tarjetas de módulos
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 700;
                    final crossAxisCount = isWide ? 3 : 1;

                    // ↓↓↓ más alto (menor ratio) para que no se desborde
                    final ratio = isWide ? 1.15 : 0.85;

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: Sizes.p16,
                      crossAxisSpacing: Sizes.p16,
                      childAspectRatio: ratio,
                      children: [
                        _ModuleCard(
                          title: 'Usuarios',
                          subtitle:
                              'Gestiona la lista, crea y edita usuarios del sistema.',
                          icon: Icons.group,
                          color: color.primaryContainer,
                          fgColor: color.onPrimaryContainer,
                          onOpenList: () => context.pushNamed('usuarios'),
                          onCreate: () => context.pushNamed('usuarioNew'),
                        ),
                        _ModuleCard(
                          title: 'Productos',
                          subtitle:
                              'Administra catálogo, precios y existencias.',
                          icon: Icons.inventory_2,
                          color: color.tertiaryContainer,
                          fgColor: color.onTertiaryContainer,
                          onOpenList: () => context.pushNamed('productos'),
                          onCreate: () => context.pushNamed('productoNew'),
                        ),
                        _ModuleCard(
                          title: 'Reportes (próx.)',
                          subtitle:
                              'Indicadores y reportes descargables (en construcción).',
                          icon: Icons.insert_chart_outlined,
                          color: color.secondaryContainer,
                          fgColor: color.onSecondaryContainer,
                          onOpenList: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Módulo en construcción'),
                              ),
                            );
                          },
                          onCreate: null,
                          disabled: true,
                        ),
                        _ModuleCard(
                          title: 'Herramientas',
                          subtitle:
                              'Revisa los input que posee el sistema.',
                          icon: Icons.inventory_2,
                          color: color.tertiaryContainer,
                          fgColor: color.onTertiaryContainer,
                          onOpenList: () => context.pushNamed('dev'),
                          ///onCreate: () => context.pushNamed('productosNew'),
                        ),
                        //  _ModuleCard(
                        //   title: 'Productos',
                        //   subtitle:
                        //       'Administra catálogo, precios y existencias.',
                        //   icon: Icons.inventory_2,
                        //   color: color.tertiaryContainer,
                        //   fgColor: color.onTertiaryContainer,
                        //   onOpenList: () => context.pushNamed('productos'),
                        //   onCreate: () => context.pushNamed('productosNew'),
                        // ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p16,
            vertical: Sizes.p16,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              const SizedBox(width: Sizes.p8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color fgColor;
  final VoidCallback? onOpenList;
  final VoidCallback? onCreate;
  final bool disabled;

  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.fgColor,
    this.onOpenList,
    this.onCreate,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return Card(
      color: color,
      shape: border,
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: fgColor),
            const SizedBox(height: Sizes.p16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: fgColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Sizes.p8),

            // ↓↓↓ que se adapte al alto disponible y no desborde
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: fgColor.withOpacity(0.9),
                ),
              ),
            ),

            const SizedBox(height: Sizes.p8),
            Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: disabled ? null : onOpenList,
                  icon: const Icon(Icons.list),
                  label: const Text('Ver lista'),
                ),
                const SizedBox(width: Sizes.p8),
                FilledButton.icon(
                  onPressed: disabled ? null : onCreate,
                  icon: const Icon(Icons.add),
                  label: const Text('Crear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
