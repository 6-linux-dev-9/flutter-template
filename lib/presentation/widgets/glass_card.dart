import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 10,
      shadowColor: Colors.black12,
      color: Colors.white.withOpacity(0.85),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: Theme.of(
              context,
            ).inputDecorationTheme.copyWith(
              filled: true,
              fillColor: cs.surface.withOpacity(0.9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black12.withOpacity(0.06)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black12.withOpacity(0.06)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: cs.primary, width: 1.4),
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
