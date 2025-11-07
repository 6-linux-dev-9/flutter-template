//VERSION 2
//lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/presentation/widgets/module_item.dart';
import '../../../core/constants/sizes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  late final List<ModuleItem> _items = [
    ModuleItem(
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
    ModuleItem(
      title: 'Productos',
      subtitle: 'Administra catálogo, precios y existencias.',
      icon: Icons.inventory_2,
      color: (ctx) => Theme.of(ctx).colorScheme.tertiaryContainer,
      fg: (ctx) => Theme.of(ctx).colorScheme.onTertiaryContainer,
      onOpenList: (ctx) => ctx.pushNamed('productos'),
      onCreate: (ctx) => ctx.pushNamed('productoNew'),
      keywords: const ['producto', 'productos', 'stock', 'inventario'],
    ),
    ModuleItem(
      title: 'Objeto',
      subtitle: 'Administra creación, eliminación y edición de objetos.',
      icon: Icons.category,
      color: (ctx) => Theme.of(ctx).colorScheme.secondaryContainer,
      fg: (ctx) => Theme.of(ctx).colorScheme.onSecondaryContainer,
      onOpenList: (ctx) => ctx.pushNamed('objetos'),
      onCreate: (ctx) => ctx.pushNamed('objetoNew'),
      keywords: const ['objeto', 'objetos', 'categoría'],
    ),
    ModuleItem(
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
    ModuleItem(
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

  List<ModuleItem> get _filtered {
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
                  (context, i) => ModuleCardFancy(item: _filtered[i]),
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
 