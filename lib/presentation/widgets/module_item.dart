import 'package:flutter/material.dart';
import 'package:template_app/core/constants/sizes.dart';
class ModuleItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color Function(BuildContext) color;
  final Color Function(BuildContext) fg;
  final void Function(BuildContext)? onOpenList;
  final void Function(BuildContext)? onCreate;
  final bool disabled;
  final List<String> keywords;

  ModuleItem({
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

class ModuleCardFancy extends StatelessWidget {
  final ModuleItem item;
  const ModuleCardFancy({super.key, required this.item});

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
