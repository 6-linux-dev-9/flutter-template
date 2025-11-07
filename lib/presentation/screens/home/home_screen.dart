// // lib/presentation/screens/home/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../../../core/constants/sizes.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Inicio'),
//         actions: [
//           IconButton(
//             tooltip: 'Ir a Usuarios',
//             onPressed: () => context.pushNamed('usuarios'),
//             icon: const Icon(Icons.group),
//           ),
//           IconButton(
//             tooltip: 'Ir a Productos',
//             onPressed: () {
//               context.pushNamed('productos'); // cuando exista la ruta
//             },
//             icon: const Icon(Icons.inventory_2),
//           ),
//           IconButton(
//             tooltip: 'Ir a Objeto',
//             onPressed: () {
//               context.pushNamed('objeto'); // cuando exista la ruta
//             },
//             icon: const Icon(Icons.category),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(Sizes.p16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header + buscador
//               Text(
//                 'Panel principal',
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: Sizes.p16),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Buscar (usuarios, productos)…',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onSubmitted: (q) {
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text('Buscar: $q')));
//                 },
//               ),
//               const SizedBox(height: Sizes.p24),

//               // // Acciones rápidas
//               // Wrap(
//               //   spacing: Sizes.p16,
//               //   runSpacing: Sizes.p16,
//               //   children: [
//               //     _QuickAction(
//               //       label: 'Nuevo usuario',
//               //       icon: Icons.person_add,
//               //       onTap: () => context.pushNamed('usuarioNew'),
//               //     ),
//               //     _QuickAction(
//               //       label: 'Nuevo producto',
//               //       icon: Icons.add_box,
//               //       onTap: () {
//               //         context.pushNamed('productoNew'); // cuando exista
//               //       },
//               //     ),
//               //     _QuickAction(
//               //       label: 'Nuevo Objeto',
//               //       icon: Icons.abc_sharp,
//               //       onTap: () {
//               //         context.pushNamed('objetoNew'); // cuando exista
//               //       },
//               //     ),
//               //   ],
//               // ),
//               // const SizedBox(height: Sizes.p24),

//               // Tarjetas de módulos
//               Expanded(
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     final isWide = constraints.maxWidth >= 700;
//                     final crossAxisCount = isWide ? 3 : 1;

//                     // ↓↓↓ más alto (menor ratio) para que no se desborde
//                     final ratio = isWide ? 1.15 : 0.85;

//                     return GridView.count(
//                       crossAxisCount: crossAxisCount,
//                       mainAxisSpacing: Sizes.p16,
//                       crossAxisSpacing: Sizes.p16,
//                       childAspectRatio: ratio,
//                       children: [
//                         _ModuleCard(
//                           title: 'Usuarios',
//                           subtitle:
//                               'Gestiona la lista, crea y edita usuarios del sistema.',
//                           icon: Icons.group,
//                           color: color.primaryContainer,
//                           fgColor: color.onPrimaryContainer,
//                           onOpenList: () => context.pushNamed('usuarios'),
//                           onCreate: () => context.pushNamed('usuarioNew'),
//                         ),
//                         _ModuleCard(
//                           title: 'Productos',
//                           subtitle:
//                               'Administra catálogo, precios y existencias.',
//                           icon: Icons.inventory_2,
//                           color: color.tertiaryContainer,
//                           fgColor: color.onTertiaryContainer,
//                           onOpenList: () => context.pushNamed('productos'),
//                           onCreate: () => context.pushNamed('productoNew'),
//                         ),
//                         _ModuleCard(
//                           title: 'Objeto',
//                           subtitle:
//                               'Administra creacion,eliminacion y edicion de objetos.',
//                           icon: Icons.category,
//                           color: color.tertiaryContainer,
//                           fgColor: color.onTertiaryContainer,
//                           onOpenList: () => context.pushNamed('objetos'),
//                           onCreate: () => context.pushNamed('objetoNew'),
//                         ),
//                         _ModuleCard(
//                           title: 'Reportes (próx.)',
//                           subtitle:
//                               'Indicadores y reportes descargables (en construcción).',
//                           icon: Icons.insert_chart_outlined,
//                           color: color.secondaryContainer,
//                           fgColor: color.onSecondaryContainer,
//                           onOpenList: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Módulo en construcción'),
//                               ),
//                             );
//                           },
//                           onCreate: null,
//                           disabled: true,
//                         ),
//                         _ModuleCard(
//                           title: 'Herramientas',
//                           subtitle:
//                               'Revisa los input que posee el sistema.',
//                           icon: Icons.inventory_2,
//                           color: color.tertiaryContainer,
//                           fgColor: color.onTertiaryContainer,
//                           onOpenList: () => context.pushNamed('dev'),
//                           ///onCreate: () => context.pushNamed('productosNew'),
//                         ),
//                         //  _ModuleCard(
//                         //   title: 'Productos',
//                         //   subtitle:
//                         //       'Administra catálogo, precios y existencias.',
//                         //   icon: Icons.inventory_2,
//                         //   color: color.tertiaryContainer,
//                         //   fgColor: color.onTertiaryContainer,
//                         //   onOpenList: () => context.pushNamed('productos'),
//                         //   onCreate: () => context.pushNamed('productosNew'),
//                         // ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _QuickAction extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;

//   const _QuickAction({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Theme.of(context).colorScheme.surface,
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: Sizes.p16,
//             vertical: Sizes.p16,
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon),
//               const SizedBox(width: Sizes.p8),
//               Text(label),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ModuleCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final Color color;
//   final Color fgColor;
//   final VoidCallback? onOpenList;
//   final VoidCallback? onCreate;
//   final bool disabled;

//   const _ModuleCard({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.color,
//     required this.fgColor,
//     this.onOpenList,
//     this.onCreate,
//     this.disabled = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final border = RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(16),
//     );

//     return Card(
//       color: color,
//       shape: border,
//       elevation: 1.5,
//       child: Padding(
//         padding: const EdgeInsets.all(Sizes.p16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, size: 32, color: fgColor),
//             const SizedBox(height: Sizes.p16),
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 color: fgColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: Sizes.p8),

//             // ↓↓↓ que se adapte al alto disponible y no desborde
//             Flexible(
//               fit: FlexFit.loose,
//               child: Text(
//                 subtitle,
//                 maxLines: 3,
//                 overflow: TextOverflow.ellipsis,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: fgColor.withOpacity(0.9),
//                 ),
//               ),
//             ),

//             const SizedBox(height: Sizes.p8),
//             Row(
//               children: [
//                 FilledButton.tonalIcon(
//                   onPressed: disabled ? null : onOpenList,
//                   icon: const Icon(Icons.list),
//                   label: const Text('Ver lista'),
//                 ),
//                 const SizedBox(width: Sizes.p8),
//                 FilledButton.icon(
//                   onPressed: disabled ? null : onCreate,
//                   icon: const Icon(Icons.add),
//                   label: const Text('Crear'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//VERSION 2
//lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/sizes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController(); // ← controlador para el scroll total
  String _query = '';

  late final List<_ModuleItem> _items = [
    _ModuleItem(
      title: 'Usuarios',
      subtitle:
          'Gestiona la lista, crea y edita usuarios del sistema.ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss.Gestiona la lista, crea y edita usuarios del sistema.ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss.Gestiona la lista, crea y edita usuarios del sistema.ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss.Gestiona la lista, crea y edita usuarios del sistema.ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss.Gestiona la lista, crea y edita usuarios del sistema.ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss1111.',
      icon: Icons.group,
      color: (ctx) => Theme.of(ctx).colorScheme.primaryContainer,
      fg: (ctx) => Theme.of(ctx).colorScheme.onPrimaryContainer,
      onOpenList: (ctx) => ctx.pushNamed('usuarios'),
      onCreate: (ctx) => ctx.pushNamed('usuarioNew'),
      keywords: const ['usuario', 'usuarios', 'personas', 'gente'],
    ),
    _ModuleItem(
      title: 'Productos',
      subtitle: 'Administra catálogo, precios y existencias.',
      icon: Icons.inventory_2,
      color: (ctx) => Theme.of(ctx).colorScheme.tertiaryContainer,
      fg: (ctx) => Theme.of(ctx).colorScheme.onTertiaryContainer,
      onOpenList: (ctx) => ctx.pushNamed('productos'),
      onCreate: (ctx) => ctx.pushNamed('productoNew'),
      keywords: const ['producto', 'productos', 'stock', 'inventario'],
    ),
    _ModuleItem(
      title: 'Objeto',
      subtitle: 'Administra creación, eliminación y edición de objetos.',
      icon: Icons.category,
      color: (ctx) => Theme.of(ctx).colorScheme.secondaryContainer,
      fg: (ctx) => Theme.of(ctx).colorScheme.onSecondaryContainer,
      onOpenList: (ctx) => ctx.pushNamed('objetos'),
      onCreate: (ctx) => ctx.pushNamed('objetoNew'),
      keywords: const ['objeto', 'objetos', 'categoría'],
    ),
    _ModuleItem(
      title: 'Reportes (próx.)',
      subtitle: 'Indicadores y reportes descargables (en construcción).',
      icon: Icons.insert_chart_outlined,
      color: (ctx) => Theme.of(ctx).colorScheme.surfaceVariant,
      fg: (ctx) => Theme.of(ctx).colorScheme.onSurfaceVariant,
      onOpenList: (_) {},
      onCreate: null,
      disabled: true,
      keywords: const ['reporte', 'reportes', 'indicadores', 'estadísticas'],
    ),
    _ModuleItem(
      title: 'Herramientas',
      subtitle: 'Revisa los input que posee el sistema.',
      icon: Icons.build_circle_outlined,
      color: (ctx) => Theme.of(ctx).colorScheme.tertiaryContainer,
      fg: (ctx) => Theme.of(ctx).colorScheme.onTertiaryContainer,
      onOpenList: (ctx) => ctx.pushNamed('dev'),
      onCreate: null,
      keywords: const ['dev', 'herramientas', 'inputs'],
    ),
  ];

  List<_ModuleItem> get _filtered {
    if (_query.trim().isEmpty) return _items;
    final q = _query.toLowerCase();
    return _items.where((m) {
      final inTitle = m.title.toLowerCase().contains(q);
      final inSub = m.subtitle.toLowerCase().contains(q);
      final inKeys = m.keywords.any(
        (k) => k.toLowerCase().contains(q) || q.contains(k.toLowerCase()),
      );
      return inTitle || inSub || inKeys;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

    // @override
    // Widget build(BuildContext context) {
    //   final color = Theme.of(context).colorScheme;

    //   return Scaffold(
    //     appBar: null,
    //     body: SafeArea(
    //       child: Padding(
    //         padding: const EdgeInsets.all(Sizes.p16),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               'Panel principal',
    //               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //             const SizedBox(height: Sizes.p16),

    //             // Buscador con filtrado en vivo
    //             TextField(
    //               controller: _searchCtrl,
    //               decoration: InputDecoration(
    //                 hintText: 'Buscar (usuarios, productos, reportes)…',
    //                 prefixIcon: const Icon(Icons.search),
    //                 suffixIcon:
    //                     _query.isEmpty
    //                         ? null
    //                         : IconButton(
    //                           tooltip: 'Limpiar',
    //                           onPressed: () {
    //                             _searchCtrl.clear();
    //                             setState(() => _query = '');
    //                           },
    //                           icon: const Icon(Icons.close),
    //                         ),
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(12),
    //                 ),
    //               ),
    //               onChanged: (q) => setState(() => _query = q),
    //               onSubmitted: (q) {
    //                 // Si quieres feedback rápido:
    //                 ScaffoldMessenger.of(
    //                   context,
    //                 ).showSnackBar(SnackBar(content: Text('Buscar: $q')));
    //               },
    //             ),
    //             const SizedBox(height: Sizes.p8),
    //             Text(
    //               '${_filtered.length} resultado(s)',
    //               style: Theme.of(context).textTheme.labelMedium?.copyWith(
    //                 color: color.onSurfaceVariant,
    //               ),
    //             ),
    //             const SizedBox(height: Sizes.p16),

    //             // Tarjetas de módulos (grid responsive)
    //             Expanded(
    //               child: LayoutBuilder(
    //                 builder: (context, constraints) {
    //                   final isWide = constraints.maxWidth >= 700;
    //                   final crossAxisCount = isWide ? 3 : 1;
    //                   final ratio = isWide ? 0.95 : 0.85;

    //                   // return GridView.count(
    //                   //   crossAxisCount: crossAxisCount,
    //                   //   mainAxisSpacing: Sizes.p16,
    //                   //   crossAxisSpacing: Sizes.p16,
    //                   //   childAspectRatio: ratio,
    //                   //   children:
    //                   //       _filtered
    //                   //           .map((m) => _ModuleCardFancy(item: m))
    //                   //           .toList(),
    //                   // );
    //                   return GridView.builder(
    //                     itemCount: _filtered.length,
    //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                       crossAxisCount: isWide ? 3 : 1,
    //                       mainAxisSpacing: Sizes.p16,
    //                       crossAxisSpacing: Sizes.p16,
    //                       // ← controla la ALTURA del card
    //                       mainAxisExtent: isWide ? 300 : 260, // ajusta a gusto
    //                     ),
    //                     itemBuilder:
    //                         (context, i) => _ModuleCardFancy(item: _filtered[i]),
    //                   );
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }

    @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Buscador y texto de resultados
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panel principal',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: Sizes.p16),
                    TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Buscar (usuarios, productos, reportes)…',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            _query.isEmpty
                                ? null
                                : IconButton(
                                  tooltip: 'Limpiar',
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() => _query = '');
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (q) => setState(() => _query = q),
                    ),
                    const SizedBox(height: Sizes.p8),
                    Text(
                      '${_filtered.length} resultado(s)',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Sizes.p16),
                  ],
                ),
              ),
            ),

            // Grid de módulos
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width >= 700 ? 3 : 1,
                  mainAxisSpacing: Sizes.p16,
                  crossAxisSpacing: Sizes.p16,
                  mainAxisExtent:
                      MediaQuery.of(context).size.width >= 700 ? 300 : 260,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ModuleCardFancy(item: _filtered[i]),
                  childCount: _filtered.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 


class _ModuleItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color Function(BuildContext) color;
  final Color Function(BuildContext) fg;
  final void Function(BuildContext)? onOpenList;
  final void Function(BuildContext)? onCreate;
  final bool disabled;
  final List<String> keywords;

  _ModuleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.fg,
    this.onOpenList,
    this.onCreate,
    this.disabled = false,
    this.keywords = const [],
  });
}

class _ModuleCardFancy extends StatelessWidget {
  final _ModuleItem item;
  const _ModuleCardFancy({required this.item});

  @override
  Widget build(BuildContext context) {
    final bg = item.color(context);
    final fg = item.fg(context);

    return InkWell(
      onTap: item.disabled ? null : () => item.onOpenList?.call(context),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Gradiente suave
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bg, Color.alphaBlend(Colors.black.withOpacity(0.06), bg)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cinta “Próx.” si está deshabilitado
            if (item.disabled)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: fg.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: fg.withOpacity(0.25)),
                  ),
                  child: Text(
                    'Próx.',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: fg),
                  ),
                ),
              ),

            // Icono dentro de un “pill”
            Container(
              decoration: BoxDecoration(
                color: fg.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(item.icon, size: 28, color: fg),
            ),
            const SizedBox(height: Sizes.p16),

            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: fg,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: Sizes.p8),

            Text(
              item.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: fg.withOpacity(0.92),
                height: 1.1,
              ),
            ),
            // Espaciado mínimo antes de los botones
            //const SizedBox(height: Sizes.p24),
            const Spacer(), // botones al fondo
            // const SizedBox(height: Sizes.p12),

            // Botones
            // Row(
            //   children: [
            //     FilledButton.tonalIcon(
            //       onPressed:
            //           item.disabled
            //               ? null
            //               : () => item.onOpenList?.call(context),
            //       icon: const Icon(Icons.list),
            //       label: const Text('Ver lista'),
            //     ),
            //     const SizedBox(width: Sizes.p8),
            //     FilledButton.icon(
            //       onPressed:
            //           item.disabled ? null : () => item.onCreate?.call(context),
            //       icon: const Icon(Icons.add),
            //       label: const Text('Crear'),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed:
                      item.disabled
                          ? null
                          : () => item.onOpenList?.call(context),
                  icon: const Icon(Icons.list, size: 18),
                  label: const Text('Ver lista'),
                ),
                const SizedBox(width: Sizes.p8),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed:
                      item.disabled ? null : () => item.onCreate?.call(context),
                  icon: const Icon(Icons.add, size: 18),
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
//FIN VERSION 2
